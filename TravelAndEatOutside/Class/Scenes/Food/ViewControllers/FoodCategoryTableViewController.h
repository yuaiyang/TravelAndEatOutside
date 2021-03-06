//
//  FoodCityTableViewController.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>

// 创建代理协议
@protocol  FoodCategoryTableViewControllerDelegate<NSObject>

- (void)sendValue:(NSString *)categoryStr;// 代理方法传递分类名


@end


@interface FoodCategoryTableViewController : UITableViewController

@property (nonatomic, assign)id<FoodCategoryTableViewControllerDelegate> delegate;

@end
