//
//  HomePageViewController.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageMOdel.h"

@interface HomePageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *img_urlImageView;
@property (weak, nonatomic) IBOutlet UILabel *book_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *author_pennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)collectButton:(UIButton *)sender;

- (IBAction)readButton:(UIButton *)sender;
- (IBAction)downLoadButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property(nonatomic,assign)long bookId; //图书的id
@property(nonatomic,assign)long chapterId;

@property(nonatomic,copy)NSString *img_url;  //图片网址
@property(nonatomic,copy)NSString *shortIntroduction;

@property(nonatomic,strong)UIView *aView;
@property(nonatomic,strong)UIButton *openButton;

//-(void)handleOpenButton:(HomePageMOdel *)model;

@end
