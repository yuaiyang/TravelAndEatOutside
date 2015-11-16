//
//  TravelCommentSecondCell.h
//  TravelAndEatOutside
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelActDetailModel.h"

@interface TravelCommentSecondCell : UITableViewCell

@property (nonatomic, strong)TravelActDetailModel * model;
@property (weak, nonatomic) IBOutlet UILabel *commentName;
@property (weak, nonatomic) IBOutlet UILabel *commentRate;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;

@end
