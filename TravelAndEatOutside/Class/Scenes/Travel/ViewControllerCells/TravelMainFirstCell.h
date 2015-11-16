//
//  TravelMainFirstCell.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelRootCellModel.h"



@interface TravelMainFirstCell : UICollectionViewCell

@property (nonatomic, strong)TravelRootCellModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel; // 分类名

@end
