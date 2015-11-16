//
//  DownViewMenu.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "DownViewMenu.h"

@implementation DownViewMenu


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    NSArray *array = @[@"字体",@"风格",@"白夜",@"返回",@"目录",@"进度"];
    if (self) {
        for (int i = 0; i < 6; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchDown];
            button.tag = i;
            
            if (i < 3) {
                
                button.frame = CGRectMake(10 * (i+1) + ((self.frame.size.width - 50) / 3) * i, 10, (self.frame.size.width - 50) / 3, 40);
                
            }else if(i > 2)
            {
                
                button.frame = CGRectMake(10 * (i-2) + ((self.frame.size.width - 50) / 3) * (i - 3), 60, (self.frame.size.width - 50) / 3, 40);
                
            }
            
            [self addSubview:button];
            
        }
        
        
    }
    self.userInteractionEnabled = YES;
    return self;
}






-(void)handleButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleButtonAction:)]) {
        
        [self.delegate handleButtonAction:sender];
    }
    
    
}

@end
