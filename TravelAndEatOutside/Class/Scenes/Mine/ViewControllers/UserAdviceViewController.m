//
//  UserAdviceViewController.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/22.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "UserAdviceViewController.h"
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface UserAdviceViewController ()<UITextFieldDelegate,MFMailComposeViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextView *userAdviceTextView;// 用户建议
@property (weak, nonatomic) IBOutlet UITextField *userContactTextField;// 用户联系方式

@end

@implementation UserAdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置textField的代理
    self.userContactTextField.delegate = self;
}

//将要编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y+textField.frame.size.height+260+50);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

//编辑结束
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

// 用户点击返回按钮
- (IBAction)didClickBackButtonItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 用户点击反馈提交按钮
- (IBAction)userSubmitAdviceButton:(UIButton *)sender {
    
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    if(mailCompose)
    {
        //设置代理
        [mailCompose setMailComposeDelegate:self];
        
        NSArray *toAddress = [NSArray arrayWithObject:@"510126362@qq.com"];
        
        NSString *emailBody = self.userAdviceTextView.text;
        
        //设置收件人
        [mailCompose setToRecipients:toAddress];
        //设置抄送人
        
        //设置邮件内容 (当有标签的时候设置为yes)
        [mailCompose setMessageBody:emailBody isHTML:NO];
        
        
        
        //设置邮件主题
        [mailCompose setSubject:@"用户建议"];
        
        //设置邮件视图在当前视图上显示方式
        [self presentModalViewController:mailCompose animated:YES];
    }
    
    
}

// 执行代理方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            CLog(@"%@",msg);
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            CLog(@"%@",msg);
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            CLog(@"%@",msg);
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            CLog(@"%@",msg);
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

// 点击空白区域回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

// 输入完毕点击return回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
