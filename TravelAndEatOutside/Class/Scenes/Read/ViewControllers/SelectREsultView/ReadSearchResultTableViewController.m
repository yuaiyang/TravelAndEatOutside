//
//  ReadSearchResultTableViewController.m
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/24.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "ReadSearchResultTableViewController.h"


#import "BoutiqueModel.h"
#import "BoutiTableViewCell.h"
#import "HomePageViewController.h"
#import "ReadSearchResultModel.h"


@interface ReadSearchResultTableViewController ()

@property(nonatomic, strong)NSMutableArray * searchResultArray;

@end

@implementation ReadSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _searchName;
    
    //初始化数组
    self.searchResultArray = [NSMutableArray array];
    
    //注册cell
    UINib * nib = [UINib nibWithNibName:@"BoutiTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"boutiqueCell"];
    
    //下载数据
    [self addDataFormNet];
    
    //在navigationController上添加一个搜索框
    
    UISearchBar * search = [[UISearchBar alloc]init];
    
    [self.navigationItem.titleView addSubview:search];
    
    
}

-(void)addDataFormNet{
    
    //用AFH第三方下载数据，并添加到数组中
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    NSString * string = [_searchName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:_searchName]];
    
    NSString * asdf = [NSString stringWithFormat:ReadSearchResult,string];
    __weak ReadSearchResultTableViewController * readSRTVC = self;
    [manager GET:asdf parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * dict = responseObject;
        
        ReadSearchResultModel * model = [[ReadSearchResultModel alloc]init];
        
        NSArray * array1 = [model getDataArray:dict];
        
        for (NSDictionary * dic in array1) {
            
            BoutiqueModel * aModel = [[BoutiqueModel alloc]init];
            
            [aModel addWithDictionary:dic];
            
            [_searchResultArray addObject:aModel];
        }
        
        [readSRTVC.tableView reloadData];

        if (_searchResultArray.count ==0) {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"找不到内容" delegate:readSRTVC cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            [readSRTVC.navigationController popViewControllerAnimated:YES];
        }
        
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

    return _searchResultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BoutiTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"boutiqueCell"];
    
    BoutiqueModel *model = nil;
    
    model =_searchResultArray[indexPath.row];
    
    [cell configCell:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomePageViewController * homePageVC = [[UIStoryboard storyboardWithName:@"Read" bundle:nil]instantiateViewControllerWithIdentifier:@"Read_view"];
    
    BoutiqueModel * model = _searchResultArray[indexPath.row];;
    
    homePageVC.bookId = model.bookId;
    
    [self.navigationController pushViewController:homePageVC animated:YES];
}


@end
