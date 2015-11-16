//
//  AboutAppViewController.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/22.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "AboutAppViewController.h"

@interface AboutAppViewController ()


// 软件介绍label
@property (weak, nonatomic) IBOutlet UILabel *appIntroducedLabel;
// 软件版本号
@property (weak, nonatomic) IBOutlet UILabel *appVersionNumberLabel;


@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 用户点击返回按钮
- (IBAction)didClickBackButtonItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
