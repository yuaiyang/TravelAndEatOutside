//
//  HomePageViewController.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "HomePageViewController.h"
#import "CatalogTableViewController.h"
#import "CollectModel.h"
#import "ReadDataBaseManager.h"
#import "CatalogModel.h"
#import "MBProgressHUD.h"

#define kNotificationNameGetdatabaseSource @"getDatabaseSource"
@interface HomePageViewController ()

@property(nonatomic, strong)MBProgressHUD * HUD;
@property(nonatomic, strong)CatalogTableViewController * catalogVC;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self requestNetwork];
    [self requestNetwork1];
    
    //为了不让点击阅读变卡，在这里创建数据
    
    _catalogVC = [[CatalogTableViewController alloc]init];
    _catalogVC.bookId = _bookId;
    

        [_catalogVC view];

    
    // Do any additional setup after loading the view.
}

-(void)requestNetwork{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    __weak HomePageViewController * homePVC = self;
    [manager GET:[NSString stringWithFormat:ReadHomePage,homePVC.bookId] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * dictionary = responseObject;
        
        HomePageMOdel * model = [[HomePageMOdel alloc]init];
        
        [model initWithDictionary:dictionary];
        
        self.book_nameLabel.text = model.book_name;
        
        NSString * str = [NSString stringWithFormat:@"http://cdn.ikanshu.cn/211/images/%@",model.img_url];
        
        //赋值给收藏
        _img_url = str;
        
        NSString * str1 = [NSString stringWithFormat:@"作者:%@",model.author_penname];
        NSString * str2 = [NSString stringWithFormat:@"分类:%@",model.name];
        
        homePVC.author_pennameLabel.text = str1;  //作者
        homePVC.nameLabel.text = str2;  //分类
        [homePVC.img_urlImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"ReadPlaceHoder"]];  //图片
        
        
        homePVC.contentLabel.text = [dictionary[@"types"] objectForKey:@"newIntroduction"];
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        CLog(@"请求错误");
    }];
    

    
}


//下载数据二需要拼接bookId
- (void)requestNetwork1
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[NSString stringWithFormat:Readcatalog,self.bookId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dictionary = responseObject;
        NSArray *arrays = dictionary[@"list"];
        
        
        ReadDataBaseManager *manager = [ReadDataBaseManager  shareDataManager];
        [manager creatDatabase];
        [manager creatCatalogInfo];
        
        for (int i = 0; i < arrays.count; i++) {
            NSArray *array = [arrays[i] objectForKey:@"chapters"];
            
            for (int j = 0; j < array.count; j++) {
                
                CatalogModel *model = [[CatalogModel alloc]init];
                model.chapterName = [array[j] objectForKey:@"n"];
                model.chaperId = [[array[j]objectForKey:@"i"] longValue];
                model.chaper_label = 0;
                model.book_id = self.bookId;
                self.chapterId = [[array[0]objectForKey:@"i"] longValue];
                [manager insertCatalogInfo:model];
                
            }
            
        }
        
        [manager closeDatabase];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"请求错误");
    }];
    
    //调用数据库，但没有存储数据
    ReadDataBaseManager *man = [ReadDataBaseManager shareDataManager];
    [man creatDatabase];
    [man creatCatalogInfo];
    NSMutableArray *array = [man selectCatalogInfoWithBookId:self.bookId];
    CLog(@"%ld",array.count);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//收藏按钮
- (IBAction)collectButton:(UIButton *)sender {
    
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [alert show];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    __block HomePageViewController * homeVC = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        

    
    CollectModel *model = [[CollectModel alloc]init];
    
    model.bookId = self.bookId;

    model.book_name = self.book_nameLabel.text;

    model.img_url = self.img_url;
    model.isDownLoad = 0;
    
    ReadDataBaseManager *manager = [ReadDataBaseManager shareDataManager];
    [manager creatDatabase];
    NSArray *arrays = [manager selectContentInfoWithBookId:self.bookId];
    
    if (arrays.count != 0) {
        
        model.isDownLoad = 1;
    }
    
    [manager insertCollectInfoWith:model];
    
    
    
    NSMutableArray *array = [manager selectInfo];
    [manager closeDatabase];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameGetdatabaseSource object:self userInfo:@{@"array":array}];
        });
}

//阅读
- (IBAction)readButton:(UIButton *)sender {
   
    //只显示文字
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在加载用...";
    // HUD各元素与HUD边缘的间距
    hud.margin = 10.f;
    // HUD相对于父视图中心点的x轴偏移量和y轴偏移量
    hud.yOffset = 150.f;
    // 隐藏时是否将HUD从父视图中移除，默认是NO。
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];

    
    [self.navigationController pushViewController:_catalogVC animated:YES];
}


//下载按钮
- (IBAction)downLoadButton:(UIButton *)sender {
    
    
    //用了UIAlertViewController 不知道怎么自动消失，所以就使用了UIAlertViewController
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"因版权问题，暂无法下载" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    
    [self performSelector:@selector(performDismiss:) withObject:alertView afterDelay:0.7f];
    
    
}

-(void)performDismiss:(UIAlertView *)alert{

    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
