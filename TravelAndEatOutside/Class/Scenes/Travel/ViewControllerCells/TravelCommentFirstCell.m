//
//  TravelCommentFirstCell.m
//  TravelAndEatOutside
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "TravelCommentFirstCell.h"

@implementation TravelCommentFirstCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(TravelActDetailModel *)model
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%.f", model.averageRate];
    self.commentCount.text = [[NSString stringWithFormat:@"%ld", model.count] stringByAppendingString:@"人评价"];
    
}

@end
