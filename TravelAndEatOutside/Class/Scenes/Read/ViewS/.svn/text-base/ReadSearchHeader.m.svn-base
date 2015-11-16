//
//  ReadSearchHeader.m
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/26.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "ReadSearchHeader.h"

@implementation ReadSearchHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        
    }
    return self;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (IBAction)click:(UIButton *)sender {
    
//    CLog(@"%@",sender.titleLabel.text);
    
    if ([_delegate respondsToSelector:@selector(toResultView:)]) {
        
        [_delegate toResultView:sender.titleLabel.text];
    }
    
}







@end
