//
//  ContentViewController.m
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "ContentViewController.h"
#import "MenuModel.h"
#import "ContentModel.h"
#import "DownViewMenu.h"
#import "ReadDataBaseManager.h"
#import "CatalogTableViewController.h"
#import "CatalogModel.h"
#import "CatalogModel.h"

@interface ContentViewController ()<UIScrollViewDelegate,UITextFieldDelegate,downViewDelegate>


{
    NSInteger number;
    NSInteger counts;
    NSInteger number1;
    BOOL switchStatu;
    
}

@property(nonatomic,assign)int font_size;
@property(nonatomic,assign)int day_night;

@property(nonatomic,assign)BOOL isopen;

-(NSInteger)calculateWords:(NSString *)contentStr;

-(void)readContentFromDatasource;

@end

@implementation ContentViewController
//懒加载
-(UITextField *)menuTextField
{
    if (!_menuTextField) {
        self.menuTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        _menuTextField.backgroundColor =[UIColor blackColor];
        
        
    }
    return _menuTextField;
}
//懒加载
-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        
        self.contentLabel = [[UILabel alloc]initWithFrame:self.view.frame];
        
        _contentLabel.font = [UIFont systemFontOfSize:25];
        
    }
    return _contentLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //进入阅读界面，TabBar隐藏
    self.tabBarController.tabBar.hidden = YES;
    
    _font_size = 15;
    
   
    //配置菜单显示
    [self configMenu];
    [self judgeContentSource];
    
}

-(void)configMenu
{
    number = 1;
    
    self.isopen = YES;
    //设置背景色
    self.view.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:235 / 255.0 blue:201 / 255.0 alpha:1];
    //打开数据库，并创建数据库
    ReadDataBaseManager *manager = [ReadDataBaseManager shareDataManager];
    [manager creatDatabase];
    
//    从数据库中获取MenuModel，获取以前读者的
    MenuModel *model = [manager selectMenuTableInfo];
    [manager closeDatabase];
    //获取字体的大小
    self.font_size = model.font_size;
    //获取白天还是黑夜
    self.day_night = model.day_night;
    

    
}

-(void)judgeContentSource
{
      //打开数据库，并创建数据库
    ReadDataBaseManager *manager = [ReadDataBaseManager shareDataManager];
    [manager creatDatabase];
    
    ContentModel *model = [[ContentModel alloc]init];
    model.book_id = self.bookId;
    
    [manager creatContenInfoWith:model];
    
    //从数据库中读取书的内容
    NSArray *array = [manager selectContentInfoWithBookId:self.bookId];
    
    [manager closeDatabase];
    
    
    if (array.count == 0) {
        //如果数据库中没有内容，从网络下载
        [self requestNetwork];
    }else
    {
        ////如果数据库中有内容，从数据库中读取
        [self readContentFromDatasource];
        
    }
    //读取数据库
    [manager closeDatabase];
}

-(void)readContentFromDatasource
{
    
     //打开数据库
    ReadDataBaseManager *manager = [ReadDataBaseManager shareDataManager];
    //从数据库中读取内容
    NSMutableArray *array = [manager selectContentInfoWithBookId:self.bookId];
    
    
    for (int i = 0; i < array.count; i++) {
        ContentModel *model = array[i];
        if (model.chapter_id == self.chapterId) {
            
            NSString *str = model.content;
            
            NSInteger pageWords = [self calculateWords:str];
            NSInteger count = str.length / pageWords + 1;
            counts = count;
#warning mark------------这句话什么意思我也不知道😢
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            //设置ScrollView的属性
            UIScrollView *contentScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
            contentScrollView.pagingEnabled = YES;    //翻页
            contentScrollView.showsHorizontalScrollIndicator = NO; //取消指示条
            contentScrollView.bounces = YES;  //弹性
            contentScrollView.directionalLockEnabled = YES;
            contentScrollView.delegate = self;  //代理
            
            
            //设置ScrollView的ContentSize的大小
            contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width * count + 1, self.view.frame.size.height);
            
            //ScrollView上有个标签，标签里面显示的是内容，下面是创建标签，并设置大小
            for (int i = 0; i < count; i++) {
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 +i * self.view.frame.size.width , 50, self.view.frame.size.width - 20, self.view.frame.size.height - 100)];
                
                
                label.lineBreakMode = NSLineBreakByCharWrapping;  //换行模式
                label.numberOfLines = 0;   //自动换行
                label.font = [UIFont systemFontOfSize:self.font_size];  //字体大小
                //设置一个手势，点击屏幕，即阅读界面的label，会相应手势，出现设置的View
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAction:)];
                label.userInteractionEnabled =YES;
                [label addGestureRecognizer:tapGesture];
                
                //这下面是最难的部分，说实话，我不太懂，参考的别人的代码写的。为label赋值
#warning mark     ----------注释从写
                if (i == count - 1) {
                    label.text = [str substringWithRange:NSMakeRange(pageWords * i, pageWords - pageWords * count + str.length)];
                    for (int i = 0; i < pageWords * count + str.length; i++) {
                        label.text = [label.text stringByAppendingString:@" "];
                        
                    }
                    
                }else
                {
                    label.text = [str substringWithRange:NSMakeRange(pageWords * i, pageWords)];
                    
                }
                
                [contentScrollView addSubview:label];
                [self.view addSubview:contentScrollView];
            }
            
            self.chapterId++;
            number = 1;
            
        }
        
    }
    

    
}

//下载数据
-(void)requestNetwork
{
    
    //利用AFN下载数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[NSString stringWithFormat:ReadContent,self.chapterId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        下载后章节id自动加一
        self.chapterId++;
        //第一层字典
        NSDictionary *dict = responseObject;
        //第二层字典
        NSString *str = dict[@"content"];
        //计算字数
        NSInteger pageWords = [self calculateWords:str];
        
        //计算有多少页
        NSInteger count = str.length / pageWords + 1;
        counts = count;
        
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        //设置滑动view
        UIScrollView *contentScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        contentScrollView.pagingEnabled = YES;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.bounces = YES;
        contentScrollView.directionalLockEnabled = YES;
        contentScrollView.delegate = self;
        
        contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width * count + 1, self.view.frame.size.height);
        ReadDataBaseManager *manager = [ReadDataBaseManager shareDataManager
                                        ];
        [manager creatCatalogInfo];

        CatalogModel *model = [manager selectCatalogInfoWithChapterId:self.chapterId];
        
        for (int i = 0; i < count; i++) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 +i * self.view.frame.size.width, 10, self.view.frame.size.width
                                                                           , 30)];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = model.chapterName;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 +i * self.view.frame.size.width , 50, self.view.frame.size.width - 20, self.view.frame.size.height - 100)];
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:_font_size];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAction:)];
            label.userInteractionEnabled =YES;
            [label addGestureRecognizer:tapGesture];
            
            if (i == count - 1) {
                label.text = [str substringWithRange:NSMakeRange(pageWords * i, pageWords - pageWords * count + str.length)];
                for (int i = 0; i < pageWords * count + str.length; i++) {
                    label.text = [label.text stringByAppendingString:@" "];
                    
                }
                
            }else
            {
                label.text = [str substringWithRange:NSMakeRange(pageWords * i, pageWords)];
                
            }
            
            
            [contentScrollView addSubview:titleLabel];
            [contentScrollView addSubview:label];
            [self.view addSubview:contentScrollView];
        }
        
        number = 1;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        CLog(@"%@",error);
    }];
    
}

//
-(void)getfontsize
{
    self.chapterId--;
    [self requestNetwork];
    
}


-(NSInteger)calculateWords:(NSString *)contentStr
{
//    每个行数的大小
    CGFloat height = self.contentLabel.font.lineHeight;
    //根据字数计算CGRect
    CGRect Rect = [contentStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 20000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.font_size]} context:nil];
    
    //计算出页数，后面为什么要加一
    long pageTotal = (self.view.frame.size.height - 100) / height + 1;
    
    long total  = Rect.size.height / height + 1;
    
    float wordWidth = self.view.frame.size.width * total / contentStr.length;
    
    long pageWords = (self.view.frame.size.width - 20) * pageTotal / wordWidth + 1;
    
    return pageWords - 20;
}


-(void)TapAction:(UIGestureRecognizer *)sender
{
    //下面弹出来的View
    self.menuTextField.userInteractionEnabled = YES;
    
    DownViewMenu *downView = [[DownViewMenu alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    //设置代理
    downView.delegate = self;
    downView.backgroundColor = [UIColor blackColor];
    self.menuTextField.font = [UIFont systemFontOfSize:0.01];
    self.menuTextField.inputView = downView;
    
    if (self.isopen) {
        
        self.menuTextField.hidden = NO;
        
        [self.view addSubview:self.menuTextField];
        [self.menuTextField becomeFirstResponder];
        
        self.isopen = NO;
    }else
    {
        
        self.menuTextField.hidden = YES;
        
        [self.menuTextField resignFirstResponder];
        self.isopen = YES;
    }
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollViewWidth = self.view.frame.size.width * (counts - 1);
    
    
    if (scrollView.contentOffset.x < 0) {
        if (number1 == 1) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                
//                [self requestNetwork1];
            }];
            
        }
        number1++;
        
    }
    
    
    if (scrollViewWidth < scrollView.contentOffset.x ) {

        if (number == 1) {

            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                
                [self judgeContentSource];
            }];
        }
        number ++;
    }
}

-(void)requestNetwork1
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:ReadContent,self.chapterId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.chapterId--;
        NSDictionary *dict = responseObject;
        NSString *str = dict[@"content"];
        NSInteger pageWords = [self calculateWords:str];

        NSInteger count = str.length / pageWords + 1;
        counts = count;
        
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        
        UIScrollView *contentScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        contentScrollView.pagingEnabled = YES;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.bounces = YES;
        contentScrollView.directionalLockEnabled = YES;
        contentScrollView.delegate = self;
        
        contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width * count + 1, self.view.frame.size.height);
        
        for (int i = 0; i < count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 +i * self.view.frame.size.width , 50, self.view.frame.size.width - 20, self.view.frame.size.height - 100)];
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.numberOfLines = 0;
            
            label.font = [UIFont systemFontOfSize:25];
            if (i == count - 1) {
                label.text = [str substringWithRange:NSMakeRange(pageWords * i, pageWords - pageWords * count + str.length)];
                for (int i = 0; i < pageWords * count + str.length; i++) {
                    label.text = [label.text stringByAppendingString:@" "];
                }

            }else
            {
                label.text = [str substringWithRange:NSMakeRange(pageWords * i, pageWords)];

            }
            
            
            [contentScrollView addSubview:label];
            [self.view addSubview:contentScrollView];
        }
        self.chapterId--;
        number1 = 1;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        CLog(@"%@",error);
    }];
    
}


#pragma mark - 点击下边视图的所有方法
-(void)handleButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
            
            
        case 0:
        {
            //更改字体
            [self.menuTextField resignFirstResponder];
            UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
            aView.backgroundColor = [UIColor blackColor];
            self.fontLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 40)];
            self.fontLabel.text = [NSString stringWithFormat:@"当前字号 ：%d",self.font_size];
            self.fontLabel.textColor = [UIColor whiteColor];
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [addButton setTitle:@"加大" forState:UIControlStateNormal];
            [addButton addTarget:self action:@selector(handleAddButton:) forControlEvents:UIControlEventTouchDown];
            
            UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [minusButton setTitle:@"减小" forState:UIControlStateNormal];
            [minusButton addTarget:self action:@selector(handleMinusButton:) forControlEvents:UIControlEventTouchDown];
            
            addButton.frame = CGRectMake(self.view.frame.size.width / 2 - 100, 60, 100, 40);
            minusButton.frame = CGRectMake(self.view.frame.size.width / 2 , 60, 100, 40);
            
            [aView addSubview:self.fontLabel];
            [aView addSubview:addButton];
            [aView addSubview:minusButton];
            
            
            self.menuTextField.inputView = aView;
            [self.menuTextField becomeFirstResponder];
        }
            break;
        case 1:
        {
            //设置背景颜色
            [self.menuTextField resignFirstResponder];
            UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
            aView.backgroundColor = [UIColor blackColor];
            
            for (int i = 0; i < 5; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.layer.cornerRadius = 10;
                button.layer.masksToBounds = YES;
                button.frame = CGRectMake(30+ 10*i + i * (self.view.frame.size.width - 100) / 5, 10, (self.view.frame.size.width - 100) / 5, 40);
                
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i + 1]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(handleColorButton:) forControlEvents:UIControlEventTouchDown];
                button.tag = 20 + i;
                [aView addSubview:button];
            }
            
            self.menuTextField.inputView = aView;
            [self.menuTextField becomeFirstResponder];
            
        }
            
            break;
        case 2:
            
        {
            //设置白天黑夜模式
            [self.menuTextField resignFirstResponder];
            UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
            aView.backgroundColor = [UIColor blackColor];
            UISwitch *aSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, 20, 100, 30)];
            aSwitch.tintColor = [UIColor darkGrayColor];
            
            [aSwitch addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventValueChanged];
            
            [aView addSubview:aSwitch];
            self.menuTextField.inputView = aView;
            [self.menuTextField becomeFirstResponder];
            
            
        }
            
            break;
            
        case 3:
            
        {
            //返回
            self.navigationController.navigationBarHidden = NO;
            // 保证返回时tabBar还在
            self.tabBarController.tabBar.hidden = NO;
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
            
            
            break;
        case 4:
        {
            //进入目录
            [self.menuTextField resignFirstResponder];
            self.navigationController.navigationBarHidden = NO;
            CatalogTableViewController *catalogVC = [[CatalogTableViewController alloc]init];
            catalogVC.bookId = self.bookId;
            [self.navigationController pushViewController:catalogVC animated:YES];
            
        }
            
            break;
        case 5:
        {
            //进度
            [self.menuTextField resignFirstResponder];
            UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
            aView.backgroundColor = [UIColor blackColor];
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake(self.view.frame.size.width / 2 - 150, 50, 100, 40);
            [backButton setTitle:@"上一章" forState:UIControlStateNormal];
            backButton.backgroundColor = [UIColor lightGrayColor];
            backButton.layer.cornerRadius = 10;
            backButton.layer.masksToBounds = YES;
            [backButton addTarget:self action:@selector(handleBackButton:) forControlEvents:UIControlEventTouchDown];
            
            
            UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
            nextButton.frame = CGRectMake(self.view.frame.size.width / 2 + 50, 50, 100, 40);
            [nextButton setTitle:@"下一章" forState:UIControlStateNormal];
            nextButton.backgroundColor = [UIColor lightGrayColor];
            nextButton.layer.cornerRadius = 10;
            nextButton.layer.masksToBounds = YES;
            [nextButton addTarget:self action:@selector(handleNextButton:) forControlEvents:UIControlEventTouchDown];
            
            [aView addSubview:nextButton];
            [aView addSubview:backButton];
            
            [self.menuTextField resignFirstResponder];
            self.menuTextField.inputView = aView;
            [self.menuTextField becomeFirstResponder];
            
        }
            
            break;
            
            
        default:
            break;
    }
    
}


#pragma mark - 点击下菜单上的按钮

//增大字体
-(void)handleAddButton:(UIButton *)sender
{
    ++self.font_size;
    
    self.chapterId--;
    
   [self requestNetwork];
}



//减小字体
-(void)handleMinusButton:(UIButton *)sender
{
    --self.font_size;
    self.chapterId--;
    [self requestNetwork];
    
}

//点击Switch开关

-(void)handleSwitch:(UISwitch *)sender
{
    
    if (sender.on) {
        
        self.view.backgroundColor = [UIColor darkGrayColor];
        
    }else
    {
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
}

//点击风格按钮
-(void)handleColorButton:(UIButton *)button
{
    ReadDataBaseManager *manager = [ReadDataBaseManager shareDataManager];
    [manager creatDatabase];
    MenuModel *model = [manager selectMenuTableInfo];
    
    switch (button.tag) {
        case 20:
            
            self.view.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:235 / 255.0 blue:201 / 255.0 alpha:1];
            break;
        case 21:
            self.view.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:245 / 255.0 blue:230 / 255.0 alpha:1];
            break;
        case 22:
            self.view.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:255 / 255.0 alpha:1];
            break;
        case 23:
            self.view.backgroundColor = [UIColor colorWithRed:142 / 255.0 green:229 / 255.0 blue:238 / 255.0 alpha:1];
            break;
        case 24:
            self.view.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:192 / 255.0 blue:203 / 255.0 alpha:1];
            break;
            
        default:
            break;
    }
    
    
    model.font_color = button.tag;
    
    [manager updataMenuTableInfo:model];
    
}

//上一章
-(void)handleBackButton:(UIButton *)sender
{
    self.chapterId--;
    [self.menuTextField resignFirstResponder];
    [self requestNetwork];
    //
}
//下一张
-(void)handleNextButton:(UIButton *)sender
{
    self.chapterId++;
    [self.menuTextField resignFirstResponder];
    [self requestNetwork];
    
    
}


@end
