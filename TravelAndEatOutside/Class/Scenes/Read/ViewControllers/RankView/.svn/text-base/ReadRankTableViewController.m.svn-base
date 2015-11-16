//
//  ReadRankTableViewController.m
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/24.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "ReadRankTableViewController.h"

#import "HomePageViewController.h"
#import "BoutiTableViewCell.h"
#import "BoutiqueModel.h"

@interface ReadRankTableViewController ()
@property(nonatomic, strong)NSMutableArray * rankingArray;
@end

@implementation ReadRankTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数组
    self.rankingArray = [NSMutableArray array];
    
    //注册Cell
    UINib * nib = [UINib nibWithNibName:@"BoutiTableViewCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"boutiqueCell"];
    
    //现在数据
    [self getDataFormNet];
    
    
}

-(void)getDataFormNet{
    
    //用AFH第三方下载数据，并添加到数组中
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    __weak ReadRankTableViewController * readRTVC = self;
    [manager GET:ReadRanking parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * dict = responseObject;
        
        BoutiqueModel * model = [[BoutiqueModel alloc]init];
        
        NSArray * array1 = [model addgetDataArray:dict];
        
        for (NSDictionary * dic in array1) {
            
            BoutiqueModel * aModel = [[BoutiqueModel alloc]init];
            [aModel addWithDictionary:dic];
            
            [_rankingArray addObject:aModel];
        }
        
        [readRTVC.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        CLog(@"%@",error);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _rankingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoutiTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"boutiqueCell"];
    
        BoutiqueModel *model = nil;
    
        model = _rankingArray[indexPath.row];
    
        [cell configCell:model];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomePageViewController * homePageVC = [[UIStoryboard storyboardWithName:@"Read" bundle:nil]instantiateViewControllerWithIdentifier:@"Read_view"];
    
    BoutiqueModel * model = _rankingArray[indexPath.row];
    
    homePageVC.bookId = model.bookId;
    
    [self.navigationController pushViewController:homePageVC animated:YES];
}


@end
