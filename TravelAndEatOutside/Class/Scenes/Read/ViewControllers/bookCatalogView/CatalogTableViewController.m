//
//  CatalogTableViewController.m
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "CatalogTableViewController.h"
#import "CatalogModel.h"
#import "ContentViewController.h"

@interface CatalogTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)NSMutableArray * datasource;

@end

@implementation CatalogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarItem.title = @"目录";
    
    //下载数据
    [self requestNet];
    
}

-(void)requestNet{
    //初始化数组
    self.datasource = [NSMutableArray array];
    //利用第三方下载数据
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    __weak CatalogTableViewController * catalogTVC = self;
    [manager GET:[NSString stringWithFormat:Readcatalog,_bookId] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //得到第一层字典
        NSDictionary * dictionary = responseObject;
        //得到第二层数组
        NSArray * array = dictionary[@"list"];
        //遍历数组，取值
        for (NSDictionary * dict in array) {
            
            NSMutableArray * mutArray = [NSMutableArray array];
            
            
            NSArray * arr = dict[@"chapters"];
            
            for (NSDictionary * dic in arr) {
                //创建model
                CatalogModel * model = [[CatalogModel alloc]init];
                //为model类取值
                model.chapterName = [dic objectForKey:@"n"];
                model.chaperId = [[dic objectForKey:@"i"]longValue];
                [mutArray addObject:model];
                
            }
            //添加的数组内
            [catalogTVC.datasource addObject:mutArray];
            
        }
        //刷新数据
        [catalogTVC.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        CLog(@"%@",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//返回区的数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datasource.count;
}
//返回每个区行的数目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datasource[section] count];
}
//返回每个区标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [NSString stringWithFormat:@"第%d卷",section +1];
}
//右边栏，索引的数目
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i<_datasource.count; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i + 1]];
    }
    return array;
}

//显示每个cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    //从数组中取出内容
    NSArray * array = _datasource[indexPath.section];
    CatalogModel * model  = array[indexPath.row];
    
    cell.textLabel.text = model.chapterName;

    
    return cell;
}
//点击每个cell，进入阅读页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentViewController *contentVC = [[ContentViewController alloc]init];
    
    
    NSArray * array = _datasource[indexPath.section];
    CatalogModel * model  = array[indexPath.row];
    
    contentVC.chapterId = model.chaperId; 
    
    self.navigationController.navigationBarHidden = YES;
    
    
    contentVC.bookId = self.bookId;
    
    [self.navigationController pushViewController:contentVC animated:YES];
    
    
    
}


@end
