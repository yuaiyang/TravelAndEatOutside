//
//  ReadSearchResultModel.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "ReadSearchResultModel.h"

@implementation ReadSearchResultModel

-(NSArray *)getDataArray:(NSDictionary *)dic{
    
    NSArray * array = dic[@"books"];
    
    return  array;
    
}

-(void)initWithDictionary:(NSDictionary *) dic{
    
    self.author_penname = [dic[@"book"] objectForKey:@"author_penname"];
    
    self.book_name = [dic[@"book"] objectForKey:@"book_name"];
    self.img_url = [dic[@"book"] objectForKey:@"img_url"];
    
    self.bookId = [dic[@"bookId"] intValue];
    self.shortIntroduction = dic[@"shortIntroduction"];
    
}

@end
