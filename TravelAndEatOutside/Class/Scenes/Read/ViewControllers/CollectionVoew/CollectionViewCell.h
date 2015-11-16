//
//  CollectionViewCell.h
//  我的小说
//
//  Created by 雨爱阳 on 15/7/3.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectModel;

@interface CollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *img_urlImageView;
@property(nonatomic,strong)UILabel *isDownloadLabel;

-(void)configCell:(CollectModel *)model;

@end
