//
//  TravelActDetailModel.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/28.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelActDetailModel : NSObject

// 上部分
@property (nonatomic, strong)NSString * appMainTitle;// 主题

@property (nonatomic, strong)NSString * appSubTitle; //摘要

@property (nonatomic, assign)NSInteger saledCount; // 已售

@property (nonatomic, assign)NSInteger commentCount;// 评论数

@property (nonatomic, strong)NSString * address; // 地址

@property (nonatomic, strong)NSString * packageDetial;//购买须知

@property (nonatomic, strong)NSString * productIntroduction; //详情介绍

@property (nonatomic, assign)NSInteger productId;

@property (nonatomic, strong)NSString * url;//图片网址

//门票部分
@property (nonatomic, assign)NSInteger miniPrice;//价格

@property (nonatomic, strong)NSString * packageName;//标题

@property (nonatomic, strong)NSString * outerDescription;//简介

//评价页面
@property (nonatomic, assign)float averageRate;//平均分
@property (nonatomic, assign)NSInteger count; //评价人数

@property (nonatomic, assign)NSInteger goodRateCount; // 好评
@property (nonatomic, assign)NSInteger middleRateCount;
@property (nonatomic, assign)NSInteger badRateCount;

@property (nonatomic, strong)NSString * userName;//评论人
@property (nonatomic, strong)NSString * content; //评论内容
@property (nonatomic, strong)NSString * createdDate;//时间
@property (nonatomic, assign)NSInteger rate; //评分


@end
