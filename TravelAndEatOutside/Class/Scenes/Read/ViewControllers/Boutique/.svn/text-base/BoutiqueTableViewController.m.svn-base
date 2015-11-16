//
//  BoutiqueTableViewController.m
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "BoutiqueTableViewController.h"
#import "BoutiqueModel.h"
#import "BoutiTableViewCell.h"
#import "HomePageViewController.h"



@interface BoutiqueTableViewController ()

@property(nonatomic,assign)int pageNumber;

@property(nonatomic,strong)NSMutableArray *datasource;

@property(nonatomic,strong)NSMutableArray *datasource0;
@property(nonatomic,strong)NSMutableArray *datasource1;
@property(nonatomic,strong)NSMutableArray *datasource2;
@property(nonatomic,strong)NSMutableArray *datasource3;
@property(nonatomic,strong)NSMutableArray *datasource4;



@end

@implementation BoutiqueTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNumber = 0;
    
    //注册cell
    UINib * nib = [UINib nibWithNibName:@"BoutiTableViewCell" bundle:nil];

    [self.tableView registerNib:nib forCellReuseIdentifier:@"boutiqueCell"];
    
    //下载数据，并保存到几个数组中
    [self createMutableArray];
    


}




//下载数据，并保存到几个数组中
- (void)createMutableArray {
    self.datasource0 = [NSMutableArray array];
    self.datasource1 = [NSMutableArray array];
    self.datasource2 = [NSMutableArray array];
    self.datasource3 = [NSMutableArray array];
    self.datasource4 = [NSMutableArray array];
    
    //通过下面的方法来为五个数组下载
    [self requestNetworkWithUrl:Boutique0 andArray:_datasource0];
    [self requestNetworkWithUrl:Boutique1 andArray:_datasource1];
    [self requestNetworkWithUrl:Boutique2 andArray:_datasource2];
    [self requestNetworkWithUrl:Boutique3 andArray:_datasource3];
    [self requestNetworkWithUrl:Boutique4 andArray:_datasource4];
    
    self.datasource = [NSMutableArray arrayWithObjects:_datasource0,_datasource1,_datasource2,_datasource3,_datasource4, nil];
}

-(void)requestNetworkWithUrl:(NSString *)url andArray:(NSMutableArray *)array{
    
    
    //用AFH第三方下载数据，并添加到数组中
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    __weak BoutiqueTableViewController * boutiqueTVC = self;
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary * dict = responseObject;
        
        BoutiqueModel * model = [[BoutiqueModel alloc]init];
        
        NSArray * array1 = [model addgetDataArray:dict];
        
        for (NSDictionary * dic in array1) {
            
            BoutiqueModel * aModel = [[BoutiqueModel alloc]init];
            [aModel addWithDictionary:dic];
            
            [array addObject:aModel];
        }
        
        [boutiqueTVC.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        CLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}


//返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _datasource.count;
}
//返回每个区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    NSArray * array = _datasource[section];
    
    return array.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BoutiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"boutiqueCell"];
    

    
    NSArray *array = _datasource[indexPath.section];
    
   BoutiqueModel *model = array[indexPath.row];
    
    [cell configCell:model];
    

    
    return cell;
}

//分区的题标
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray * array =@[@"重磅推荐",@"古装言情",@"玄幻仙侠",@"历史游戏",@"最新上架"];

    return array[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HomePageViewController * homePageVC = [[UIStoryboard storyboardWithName:@"Read" bundle:nil]instantiateViewControllerWithIdentifier:@"Read_view"];
    
    NSArray * array = _datasource[indexPath.section];
    
    BoutiqueModel * model = array[indexPath.row];
    
    homePageVC.bookId = model.bookId;
    
    [self.navigationController pushViewController:homePageVC animated:YES];
    
}




@end
