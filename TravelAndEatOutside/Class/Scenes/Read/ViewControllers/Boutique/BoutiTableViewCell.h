//
//  BoutiTableViewCell.h
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoutiqueModel.h"
@interface BoutiTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_urlImageView;
@property (weak, nonatomic) IBOutlet UILabel *book_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *author_pennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortIntroductionLabel;

-(void)configCell:(BoutiqueModel *)model;

@end
