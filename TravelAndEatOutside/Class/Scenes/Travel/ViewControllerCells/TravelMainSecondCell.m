//
//  TravelMainSecondCell.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "TravelMainSecondCell.h"
#import "UIImage+AFNetworking.h"

@implementation TravelMainSecondCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setModel:(TravelRootCellModel *)model
{
    [self.imgView setImageWithURL:[NSURL URLWithString:model.tupian_url]];
    self.bigNameLabel.text = model.adTitle;
    self.digestLabel.text = model.adSubTitle;
}

@end
