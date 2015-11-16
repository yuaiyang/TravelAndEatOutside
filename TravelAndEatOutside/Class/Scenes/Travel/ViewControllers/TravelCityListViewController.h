//
//  CityListViewController.h
//  TravelPart
//
//  Created by 雨爱阳 on 15/10/20.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TravelCityListViewController;

@protocol TravelCityListViewControllerDelegate <NSObject>

- (void)sendValueCity:(NSString *)cityText cityCode:(NSString *)cityCode;

@end

@interface TravelCityListViewController : UIViewController

@property (nonatomic, assign)id<TravelCityListViewControllerDelegate> delegate;
@property (nonatomic, copy)NSString * positionCityName;// 存储定位后传值下来的城市名字

@end
