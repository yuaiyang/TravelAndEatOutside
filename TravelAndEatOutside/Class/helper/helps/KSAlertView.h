//
//  KSAlertView.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/22.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewBlock)();

@interface KSAlertView : UIAlertView

/**
 *  设置alert
 *
 *  @param tittle       标题
 *  @param name         确定按钮名字
 *  @param content      内容
 *  @param name         取消按钮名字
 *  @param confirmBlock 确定按钮点击
 *  @param cancelBlock  取消按钮点击
 *
 *  @return SJAlertView
 */
+(KSAlertView *)alertWithTittle:(NSString *)tittle Content:(NSString *)content ConfirmButton:(NSString *) confirmName CancelButton:(NSString *)cancelName ConfirmButtonClicked:(AlertViewBlock)confirmBlock CancelButtonClicked:(AlertViewBlock)cancelBlock;



@end
