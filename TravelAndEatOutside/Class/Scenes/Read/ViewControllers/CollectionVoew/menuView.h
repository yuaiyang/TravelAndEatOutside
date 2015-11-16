//
//  menuView.h
//  我的小说
//
//  Created by 雨爱阳 on 15/7/4.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol menuDelegate <NSObject>

-(void)handleDetailButton:(UIButton *)sender;

@end

@interface menuView : UIView

@property(nonatomic,strong)UIView *aView;
@property(nonatomic,strong)UIButton *detailButton;
@property(nonatomic,strong)UIButton *deleteButton;
@property(nonatomic,strong)UIButton *destroyButton;
@property(nonatomic,strong)UILabel *book_nameLabel;

@property(nonatomic,assign)long bookId;

@property(nonatomic,assign)id<menuDelegate>delegate;

@end
