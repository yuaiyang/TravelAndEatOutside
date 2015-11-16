//
//  CollectModel.h
//  我的小说
//
//  Created by 雨爱阳 on 15/7/4.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject

@property(nonatomic,copy)NSString *img_url;
@property(nonatomic,copy)NSString *book_name;
@property(nonatomic,assign)long bookId;
@property(nonatomic,assign)int isDownLoad;

@end
