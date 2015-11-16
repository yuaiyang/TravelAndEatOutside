//
//  FoodUrls.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#ifndef FoodUrls_h
#define FoodUrls_h

// 美食列表链接
#define KURL @"http://api.dianping.com/v1/deal/find_deals?appkey=42960815&sign=%@&city=%@&category=%@&limit=30&page=1"

// 城市链接
#define KCITYURL @"http://api.dianping.com/v1/metadata/get_cities_with_deals?appkey=42960815&sign=6AFD15FED56B37F265210060C38B776D55EF8148"

#define KFoodCategoryUrl @"http://api.dianping.com/v1/metadata/get_categories_with_deals?appkey=42960815&sign=6AFD15FED56B37F265210060C38B776D55EF8148"

#endif /* FoodUrls_h */
