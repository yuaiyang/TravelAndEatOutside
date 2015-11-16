//
//  ContentModel.h
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject

@property(nonatomic,copy)NSString *content; //内容
@property(nonatomic,assign)long book_id;  //书的id
@property(nonatomic,assign)long chapter_id;  //章节id

@end
