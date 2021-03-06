//
//  NSString+Characters.h
//  AddressBook
//
//  Created by y_小易 on 14-6-10.
//  Copyright (c) 2014年 www.雨爱阳.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Characters)

//将汉字转换为拼音(无音标)
- (NSString *)pinyinOfString;

//汉字转换为拼音后，返回大写的首字母
- (NSString *)firstCharacterOfString;

@end
