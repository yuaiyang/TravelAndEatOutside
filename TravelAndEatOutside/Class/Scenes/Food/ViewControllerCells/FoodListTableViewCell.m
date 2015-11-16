//
//  FoodListTableViewCell.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "FoodListTableViewCell.h"
#import "FoodListModel.h"
#import "UIImageView+AFNetworking.h"

@interface FoodListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *fodImagView;
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *cityOfFood;
@property (weak, nonatomic) IBOutlet UILabel *priceOfFood;

@end

@implementation FoodListTableViewCell

// 重写setter方法给cell赋值
-(void)setFoodModel:(FoodListModel *)foodModel {
    _foodModel = foodModel;
    [self.fodImagView setImageWithURL:[NSURL URLWithString:self.foodModel.image_url]];
    self.foodName.text = self.foodModel.title;
    self.cityOfFood.text = self.foodModel.city;
    self.priceOfFood.text = [@"参考价:" stringByAppendingString:[[NSString stringWithFormat:@"%ld",self.foodModel.current_price] stringByAppendingString:@".00 元"]];
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
