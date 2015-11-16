//
//  ActivityForthCell.m
//  TravelAndEatOutside
//
//  Created by lanou3g on 15/10/28.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "ActivityForthCell.h"

@implementation ActivityForthCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(TravelActDetailModel *)model
{
    self.activityLabel.text = model.packageDetial;
}

@end
