//
//  TravelHeaderViewCell.h
//  TravelAndEatOutside
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelHeaderViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *locationLabel; //定位中
@property (weak, nonatomic) IBOutlet UICollectionView *hotCityCollectionView; // 热门城市集合

@end
