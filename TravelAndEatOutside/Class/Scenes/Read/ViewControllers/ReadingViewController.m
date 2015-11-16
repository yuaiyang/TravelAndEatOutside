//
//  ReadingViewController.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "ReadingViewController.h"

#define kWidth self.view.frame.size.width

@interface ReadingViewController ()<UIScrollViewDelegate>
- (IBAction)GoodReading:(UIButton *)sender;
- (IBAction)searchButton:(UIButton *)sender;
- (IBAction)rankButton:(UIButton *)sender;
- (IBAction)collectButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;

@end

@implementation ReadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //给ScrollView设置代理
    self.rootScrollView.delegate =self;
    
    //弹性自适应设置为NO
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置为page翻页
    self.rootScrollView.pagingEnabled = YES;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击第一个按钮
- (IBAction)GoodReading:(UIButton *)sender {
    
    self.rootScrollView.contentOffset = CGPointMake(kWidth * 0, 0);
    
    self.lineLabel.frame  = CGRectMake((kWidth/4) * 0, self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
}
//点击第二个按钮
- (IBAction)searchButton:(UIButton *)sender {
    
    self.rootScrollView.contentOffset = CGPointMake(self.view.frame.size.width * 1, 0);
    
    self.lineLabel.frame  = CGRectMake((kWidth/4) * 1, self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
}
//点击第三个按钮
- (IBAction)rankButton:(UIButton *)sender {
    
    self.rootScrollView.contentOffset = CGPointMake(self.view.frame.size.width * 2, 0);
    
    self.lineLabel.frame  = CGRectMake((kWidth/4) * 2, self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
}
//点击第四个按钮
- (IBAction)collectButton:(UIButton *)sender {
    
    self.rootScrollView.contentOffset = CGPointMake(self.view.frame.size.width * 3, 0);
    
    self.lineLabel.frame  = CGRectMake((kWidth/4) * 3, self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
}

#warning mark --------------scrollView代理执行的方法
//这个是实现在下面拖动的时候，那个显示标签能跟着移动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.lineLabel.frame  = CGRectMake(scrollView.contentOffset.x/4, self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
    
}


@end
