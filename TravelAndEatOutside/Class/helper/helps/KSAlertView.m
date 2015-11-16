//
//  KSAlertView.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/22.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "KSAlertView.h"

@implementation KSAlertView

{
    AlertViewBlock _confirmBlock;
    AlertViewBlock _cancelBlock;
}

+(KSAlertView *)alertWithTittle:(NSString *)tittle Content:(NSString *)content ConfirmButton:(NSString *) confirmName CancelButton:(NSString *)cancelName ConfirmButtonClicked:(AlertViewBlock)confirmBlock CancelButtonClicked:(AlertViewBlock)cancelBlock
{
    KSAlertView * alertView = [[KSAlertView alloc]init];
    [alertView alertWithTittle:tittle Content:content ConfirmButton:confirmName CancelButton:cancelName ConfirmButtonClicked:confirmBlock CancelButtonClicked:cancelBlock];
    
    return alertView;
    
}


-(void)alertWithTittle:(NSString *)tittle Content:(NSString *)content ConfirmButton:(NSString *)confirmName CancelButton:(NSString *)cancelName ConfirmButtonClicked:(AlertViewBlock)confirmBlock CancelButtonClicked:(AlertViewBlock)cancelBlock
{
    self.title = tittle;
    self.message = content;
    _confirmBlock = confirmBlock;
    _cancelBlock = cancelBlock;
    if (cancelName) {
        [self addButtonWithTitle:cancelName];
    }
    else
    {
        
        _cancelBlock = confirmBlock;
    }
    if (confirmName) {
        [self addButtonWithTitle:confirmName];
    }
    self.delegate = self;
}

//代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        _cancelBlock();
    }
    else if (buttonIndex == 1)
    {
        _confirmBlock();
    }
}


@end
