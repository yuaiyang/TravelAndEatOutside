//
//  DownViewMenu.h
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol downViewDelegate <NSObject>

-(void)handleButtonAction:(UIButton *)sender;

@end

@interface DownViewMenu : UIView

@property(nonatomic,strong)UIButton *fontSizeButton;    //设置字体大小按钮
@property(nonatomic,strong)UIButton *backColorButton;//设置背景按钮
@property(nonatomic,strong)UIButton *nightButton;//设置白天黑夜按钮
@property(nonatomic,strong)UIButton *pageTurnStyleButton; //设置翻页按钮
@property(nonatomic,strong)UIButton *catalogButton;//设置目录按钮
@property(nonatomic,strong)UIButton *progressButton; //设置进度按钮
@property(nonatomic,strong)UIButton *crossScreenButton;
@property(nonatomic,strong)UIButton *settingButton;  


@property(nonatomic,assign)id<downViewDelegate>delegate;
@end
