//
//  ActivityDetailCell.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/28.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelActDetailModel.h"

@interface ActivityDetailCell : UITableViewCell

@property (nonatomic, strong)TravelActDetailModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *digestLabel;

@end
