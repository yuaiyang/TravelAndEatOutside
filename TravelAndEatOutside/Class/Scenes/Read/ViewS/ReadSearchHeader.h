//
//  ReadSearchHeader.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/26.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReadSearchHeaderDelegate <NSObject>

-(void)toResultView:(NSString *)name;

@end

@interface ReadSearchHeader : UIView<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)click:(UIButton *)sender;

@property(nonatomic, assign)id delegate;


@end
