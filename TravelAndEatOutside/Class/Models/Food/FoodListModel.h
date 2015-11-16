//
//  FoodListModel.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodListModel : NSObject

@property (nonatomic,retain)NSString * city;// 城市
@property (nonatomic,retain)NSString * image_url;// 图片
@property (nonatomic,retain)NSString * title;// 饭店标题
@property (nonatomic,assign)NSInteger current_price;// 价格




@end
