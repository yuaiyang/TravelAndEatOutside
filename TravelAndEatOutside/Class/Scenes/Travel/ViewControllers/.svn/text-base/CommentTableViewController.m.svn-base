//
//  CommentTableViewController.m
//  TravelAndEatOutside
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "CommentTableViewController.h"
#import "TravelCommentFirstCell.h"
#import "TravelCommentSecondCell.h"
#import "TravelActDetailModel.h"

@interface CommentTableViewController ()

@property (nonatomic, strong)NSMutableArray * secondModelArray;//第二区 model

@property (nonatomic, strong)TravelActDetailModel * model;//第一区


@end

@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据
    [self getData];
    //注册 cell
    [self registerCell];
}

// 注册 cell
- (void)registerCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"TravelCommentFirstCell" bundle:nil] forCellReuseIdentifier:@"cfirst_id"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TravelCommentSecondCell" bundle:nil] forCellReuseIdentifier:@"csecond_id"];
}

//数据
- (void)getData
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kPingjiaUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        //第一区
        NSDictionary * dic = responseObject[@"data"];
        _model = [TravelActDetailModel new];
        [_model setValuesForKeysWithDictionary:dic];
        
        //第二区
        for (NSDictionary * xdic in dic[@"comments"]) {
            TravelActDetailModel * model1 = [TravelActDetailModel new];
            [model1 setValuesForKeysWithDictionary:xdic];
            [self.secondModelArray addObject:model1];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        CLog(@"Error:%@", error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section != 0) {
        return self.secondModelArray.count;
    }
    
    return 1;
}

// 设置 cell 内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        TravelCommentFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cfirst_id" forIndexPath:indexPath];
        cell.model = _model;
        return cell;
    }
    TravelCommentSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:@"csecond_id" forIndexPath:indexPath];
    TravelActDetailModel * model = self.secondModelArray[indexPath.row];
    cell.model = model;
    return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        return 70;
    }
    return 130;
}


-(NSMutableArray *)secondModelArray
{
    if (!_secondModelArray) {
        _secondModelArray = [NSMutableArray array];
    }
    return _secondModelArray;
}



@end
