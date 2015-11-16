//
//  BoutiqueModel.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "BoutiqueModel.h"

@implementation BoutiqueModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(NSArray *)addgetDataArray:(NSDictionary *)dic{
    
    NSArray * array = nil;
    
    array = [dic[@"list"][0] objectForKey:@"books"];
    
    
    return array;
    
}
-(void)addWithDictionary:(NSDictionary *) dic{
    
    self.author_penname = [dic[@"book"] objectForKey:@"author_penname"];
    
    self.book_name = [dic[@"book"] objectForKey:@"book_name"];
    self.img_url = [dic[@"book"] objectForKey:@"img_url"];
    self.bookId = [dic[@"bookId"] intValue];
    self.shortIntroduction = dic[@"shortIntroduction"];
    self.name = [dic[@"bookCategory"] objectForKey:@"name"];
}


@end
