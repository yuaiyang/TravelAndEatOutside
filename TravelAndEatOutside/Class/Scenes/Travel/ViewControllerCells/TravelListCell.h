//
//  TravelListCell.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelActivityModel.h"

@interface TravelListCell : UICollectionViewCell

@property (nonatomic, strong)TravelActivityModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *comboLabel; // 套餐类型
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;  // 城市
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 标题
@property (weak, nonatomic) IBOutlet UILabel *digestLabel; // 摘要
@property (weak, nonatomic) IBOutlet UILabel *curPriceLabel; // 现价
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel; // 原价
@property (weak, nonatomic) IBOutlet UILabel *reserveLabel; // 今日可定
@property (weak, nonatomic) IBOutlet UILabel *saleLabel; // 已售

@end
