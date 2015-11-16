//
//  CollectionViewCell.m
//  我的小说
//
//  Created by 雨爱阳 on 15/7/3.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "CollectionViewCell.h"
#import "CollectModel.h"


@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    
    self.img_urlImageView.layer.shadowOffset = CGSizeMake(10, 10);
    self.img_urlImageView.layer.shadowOpacity = 0.5;
    self.img_urlImageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    [self.contentView addSubview:self.img_urlImageView];
    [self.contentView addSubview:self.isDownloadLabel];
    return self;
    
}


-(UIImageView *)img_urlImageView
{
    if (!_img_urlImageView) {
        CGRect rect = self.contentView.frame;
        rect.size.height = self.contentView.frame.size.height - 20;
        self.img_urlImageView = [[UIImageView alloc]initWithFrame:rect];
    }
    return _img_urlImageView;
}

-(UILabel *)isDownloadLabel
{
    if (!_isDownloadLabel) {
        self.isDownloadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.img_urlImageView.frame.size.height, self.frame.size.width, 20)];
        _isDownloadLabel.font = [UIFont systemFontOfSize:15];
        _isDownloadLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _isDownloadLabel;
}

-(void)configCell:(CollectModel *)model
{
//    [self.img_urlImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil];
    
    [self.img_urlImageView setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil];
    
    if (model.isDownLoad == 1) {
        self.isDownloadLabel.text = @"";
    }else
    {
        self.isDownloadLabel.text = @"";
    }
    
}




@end
