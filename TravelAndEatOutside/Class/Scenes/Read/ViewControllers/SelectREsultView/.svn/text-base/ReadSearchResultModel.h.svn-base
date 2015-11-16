//
//  ReadSearchResultModel.h
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/24.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadSearchResultModel : NSObject


@property(nonatomic, copy)NSString * author_penname; //作者
@property(nonatomic, copy)NSString * book_name;   //书名
@property(nonatomic, copy)NSString * img_url; //书图片的网址

@property(nonatomic,assign)long bookId;
@property(nonatomic, copy)NSString * shortIntroduction;
@property(nonatomic, strong)NSMutableArray * array;
@property(nonatomic, copy)NSString * name;  //分类
@property(nonatomic, copy)NSString * phName;

-(NSArray *)getDataArray:(NSDictionary *)dic;

-(void)initWithDictionary:(NSDictionary *) dic;

@end
