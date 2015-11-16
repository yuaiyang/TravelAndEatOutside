//
//  HomePageMOdel.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "HomePageMOdel.h"

@implementation HomePageMOdel

-(void)initWithDictionary:(NSDictionary *)dic{
    
    self.author_penname = [[dic[@"types"] objectForKey:@"book"] objectForKey:@"author_penname"];
    self.book_name = [[dic[@"types"] objectForKey:@"book"] objectForKey:@"book_name"];
    self.img_url = [[dic[@"types"] objectForKey:@"book"] objectForKey:@"img_url"];
    self.Introduction = [[dic[@"types"] objectForKey:@"book"] objectForKey:@"Introduction"];
    self.name =  [[dic[@"types"] objectForKey:@"bookCategory"] objectForKey:@"name"];
    
    
}


@end
