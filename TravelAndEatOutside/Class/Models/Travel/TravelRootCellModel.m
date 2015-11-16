//
//  RootCellModel.m
//  TravelPart
//
//  Created by 雨爱阳 on 15/10/20.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "TravelRootCellModel.h"

@implementation TravelRootCellModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"new_app_picpath"]) {
        self.tupian_url = value;
    }
}

@end
