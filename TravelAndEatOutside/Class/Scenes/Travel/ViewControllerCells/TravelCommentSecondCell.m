//
//  TravelCommentSecondCell.m
//  TravelAndEatOutside
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "TravelCommentSecondCell.h"

@implementation TravelCommentSecondCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(TravelActDetailModel *)model
{
    self.commentName.text = model.userName;
    self.commentRate.text = [[NSString stringWithFormat:@"%ld", model.rate] stringByAppendingString:@"分"];
    self.dataLabel.text = model.createdDate;
    self.commentContent.text = model.content;
}

@end
