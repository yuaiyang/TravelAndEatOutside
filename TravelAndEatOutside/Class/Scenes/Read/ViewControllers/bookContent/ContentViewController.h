//
//  ContentViewController.h
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,assign)long chapterId;
@property(nonatomic,assign)long bookId;
//@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UILabel *titleLable;

@property(nonatomic,strong)UIView *upView;
@property(nonatomic,strong)UIView *downView;
@property(nonatomic,strong)UITextField *menuTextField;
@property(nonatomic,strong)UILabel *fontLabel;

@end
