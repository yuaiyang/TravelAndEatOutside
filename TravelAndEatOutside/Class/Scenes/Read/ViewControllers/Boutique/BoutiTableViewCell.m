//
//  BoutiTableViewCell.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "BoutiTableViewCell.h"

@implementation BoutiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCell:(BoutiqueModel *)model
{
    NSString *str = [NSString stringWithFormat:@"http://cdn.ikanshu.cn/211/images/%@",model.img_url];
    NSString *str1 = [NSString stringWithFormat:@"作者: %@",model.author_penname];
    
    [self.img_urlImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
    self.book_nameLabel.text = model.book_name;
    
    self.author_pennameLabel.text = str1;
    self.shortIntroductionLabel.numberOfLines  = 0;
    self.shortIntroductionLabel.text = model.shortIntroduction;
}

@end
