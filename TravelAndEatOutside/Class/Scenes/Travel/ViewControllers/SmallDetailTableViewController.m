//
//  SmallDetailTableViewController.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/26.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "SmallDetailTableViewController.h"
#import "TravelActDetailModel.h"
#import "ActivityDetailCell.h"
#import "ActivitySecondCell.h"
#import "ActivityWeatherCell.h"
#import "SDCycleScrollView.h"

@interface SmallDetailTableViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong)TravelActDetailModel * model;

@property (nonatomic, strong)NSMutableArray * picArray;//存储图片

@end

@implementation SmallDetailTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 请求数据
    [self requestData];

    // 注册 cell
    [self registerCell];

}


// 注册 cell
- (void)registerCell
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityDetailCell" bundle:nil] forCellReuseIdentifier:@"acticity_id"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivitySecondCell" bundle:nil] forCellReuseIdentifier:@"comment_id"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityWeatherCell" bundle:nil] forCellReuseIdentifier:@"address_id"];
}


- (void)requestData
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        __weak SmallDetailTableViewController * weakSelf = self;
        [manager GET:kSmallDetail(self.productId) parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary * dic = responseObject[@"data"];
            _model = [TravelActDetailModel new];
            [_model setValuesForKeysWithDictionary:dic];
            
            for (NSDictionary * xdic in dic[@"imageList"]) {
                TravelActDetailModel * model = [TravelActDetailModel new];
                [model setValuesForKeysWithDictionary:xdic];
                NSString * url = [@"http://cdn5.jinxidao.com/" stringByAppendingString:model.url];
                [weakSelf.picArray addObject:url];
            }
            // 设置轮播图
            [self createShufflingFigure];
            
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            CLog(@"%@", error);
        }];
 
        
    
}

// 设置轮播图
- (void)createShufflingFigure {
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.delegate = self;
    
    cycleScrollView.dotColor = [UIColor clearColor]; // 自定义分页控件小圆标颜色
    
    cycleScrollView.autoScrollTimeInterval = 6.0;

    cycleScrollView.imageURLStringsGroup = self.picArray;


    

    self.tableView.tableHeaderView = cycleScrollView;
    [self.tableView reloadData];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            //第一个 cell
            ActivityDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"acticity_id" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ActivityDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"acticity_id"];
            }
            TravelActDetailModel * model = _model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            return cell;
        }
            
            break;
        case 1:{
            ActivitySecondCell * cell = [tableView dequeueReusableCellWithIdentifier:@"comment_id" forIndexPath:indexPath];
            
            TravelActDetailModel * model = _model;
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            
            break;
        case 2:{
            ActivityWeatherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"address_id" forIndexPath:indexPath];
            TravelActDetailModel * model = _model;
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            
            break;

        case 3:{
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.textLabel.text = @"详情请到店了解";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            
            break;
            
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 30;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(view.frame), 30)];
    lable.text = @"购买须知";
    [view addSubview:lable];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有东西" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.f];
    }else if (indexPath.section == 2) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"调用地图" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.f];
    }
}

- (void)dismiss:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}


-(NSMutableArray *)picArray
{
    if (!_picArray) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}


@end
