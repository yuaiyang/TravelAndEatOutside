//
//  ActivitySecondCell.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/28.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "ActivitySecondCell.h"

@implementation ActivitySecondCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(TravelActDetailModel *)model
{
    self.saleCountLabel.text = [@"已售" stringByAppendingString:[NSString stringWithFormat:@"%ld", model.saledCount]];
    if (model.commentCount == 0) {
        self.pingjiaLabel.text = @"暂无评论";
    }else {
        self.pingjiaLabel.text = [[NSString stringWithFormat:@"%ld", model.commentCount] stringByAppendingString:@"人评价"];
    }
    
}

@end
