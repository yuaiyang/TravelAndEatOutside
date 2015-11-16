//
//  ReadsearchTableViewController.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/24.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "ReadsearchTableViewController.h"

#import "BoutiqueModel.h"
#import "BoutiTableViewCell.h"
#import "HomePageViewController.h"
#import "ReadSearchHeader.h"

#import "ReadSearchResultTableViewController.h"

@interface ReadsearchTableViewController ()

@property(nonatomic, strong)NSMutableArray * searchArray;

@end

@implementation ReadsearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数组
    self.searchArray = [NSMutableArray array];
    
    //注册cell
    UINib * nib = [UINib nibWithNibName:@"BoutiTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"boutiqueCell"];
    
    //下载数据
    [self getDataFormNet];
    
    //tableHeader
    
    [self buildHeader];
    
}


-(void)buildHeader{
    
    ReadSearchHeader * header = [[NSBundle mainBundle]loadNibNamed:@"ReadSearchHeader" owner:self.tableView options:nil].firstObject;
    
    header.delegate = self;
    
    header.searchBar.delegate = self;
    
    CGRect rect = header.frame;
    
    rect.size.height = 180;
    
    header.frame = rect;
    
    [self.tableView setTableHeaderView:header];
    
    UIView *view=self.tableView.tableHeaderView;
    view.frame=rect;
    self.tableView.tableHeaderView =view;
    
    
}

-(void)getDataFormNet{
    
    //用AFH第三方下载数据，并添加到数组中
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    __weak ReadsearchTableViewController * readTVC = self;
    [manager GET:ReadSearch parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * dict = responseObject;
        
        BoutiqueModel * model = [[BoutiqueModel alloc]init];
        
        NSArray * array1 = [model addgetDataArray:dict];
        
        for (NSDictionary * dic in array1) {
            
            BoutiqueModel * aModel = [[BoutiqueModel alloc]init];
            [aModel addWithDictionary:dic];
            
            [_searchArray addObject:aModel];
        }
        
        [readTVC.tableView reloadData];
        [self buildHeader];
        
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
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _searchArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BoutiTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"boutiqueCell"];
    
    
    
    BoutiqueModel *model = _searchArray[indexPath.row];
    
    [cell configCell:model];
    
    return cell;
}


//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomePageViewController * homePageVC = [[UIStoryboard storyboardWithName:@"Read" bundle:nil]instantiateViewControllerWithIdentifier:@"Read_view"];
    
    BoutiqueModel * model = _searchArray[indexPath.row];
    
    homePageVC.bookId = model.bookId;
    
    [self.navigationController pushViewController:homePageVC animated:YES];
    
    //让搜索框叫出来的键盘回收
    [self.view endEditing:YES];
    
}

//执行Header代理的方法
-(void)toResultView:(NSString *)name{
    
    ReadSearchResultTableViewController * resultVC = [[ReadSearchResultTableViewController alloc]init];
    
    resultVC.searchName = name;
    
    [self.navigationController pushViewController:resultVC animated:YES];
    
}


//search代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    ReadSearchResultTableViewController * resultVC = [[ReadSearchResultTableViewController alloc]init];
    
    resultVC.searchName = searchBar.text;
    
    [self.navigationController pushViewController:resultVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //让搜索框叫出来的键盘回收
    [self.view endEditing:YES];
}

@end
