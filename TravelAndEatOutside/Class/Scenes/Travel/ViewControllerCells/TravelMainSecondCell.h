//
//  TravelMainSecondCell.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelRootCellModel.h"


@interface TravelMainSecondCell : UICollectionViewCell

@property (nonatomic, strong)TravelRootCellModel * model;

@property (weak, nonatomic) IBOutlet UILabel *bigNameLabel;//大标题
@property (weak, nonatomic) IBOutlet UILabel *digestLabel; // 摘要
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
