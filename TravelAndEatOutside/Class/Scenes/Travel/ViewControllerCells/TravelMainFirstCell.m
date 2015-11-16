//
//  TravelMainFirstCell.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "TravelMainFirstCell.h"
#import "UIImage+AFNetworking.h"

@implementation TravelMainFirstCell

- (void)awakeFromNib {
    // Initialization code
}



-(void)setModel:(TravelRootCellModel *)model
{
    [self.imgView setImageWithURL:[NSURL URLWithString:model.app_picpath]];
    
    self.classNameLabel.text = model.title;
}

@end
