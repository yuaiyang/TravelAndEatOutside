//
//  TravelWebViewController.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "TravelWebViewController.h"

@interface TravelWebViewController ()

@end

@implementation TravelWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建 webView
    [self creatWebView];
}

- (void)creatWebView
{
    UIWebView * wView = [[UIWebView alloc] initWithFrame:self.view.frame];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
    
    [wView loadRequest:request];
    
    
    [self.view addSubview:wView];
}





@end
