//
//  ActivityDetailViewController.m
//  TravelPart
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "TravelActDetailModel.h"
#import "ActivityDetailCell.h"
#import "ActivitySecondCell.h"
#import "ActivityWeatherCell.h"
#import "SDCycleScrollView.h"
#import <MapKit/MapKit.h>




@interface ActivityDetailViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong)NSMutableArray * picArray; //存放轮播图片

@property (nonatomic, strong)NSMutableArray * modelArray; // 存放 model

@property (nonatomic, strong)TravelActDetailModel * model; //活动 model

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;//轮播视图

@property (nonatomic, strong)CLGeocoder * geocoder;
@property (nonatomic, copy)NSString * mapTitle;//接收到达位置




@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    self.view.backgroundColor = [UIColor  whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 请求数据
    [self requestData];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;

    // 注册 cell
    [self registerCell];
    
    
}


// 注册 cell
- (void)registerCell
{
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ActivityDetailCell" bundle:nil] forCellReuseIdentifier:@"acticity_id"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ActivitySecondCell" bundle:nil] forCellReuseIdentifier:@"comment_id"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ActivityWeatherCell" bundle:nil] forCellReuseIdentifier:@"address_id"];
}


//请求数据
- (void)requestData
{
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        __weak ActivityDetailViewController * weakSelf = self;
        [manager GET:kActivityDetailOne(_productId) parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSDictionary * dic = responseObject[@"data"];
            for (NSDictionary * xdic in dic[@"imageList"]) {
                TravelActDetailModel * model = [TravelActDetailModel new];
                [model setValuesForKeysWithDictionary:xdic];
                NSString * url = [@"http://cdn5.jinxidao.com/" stringByAppendingString:model.url];
                [weakSelf.picArray addObject:url];
            }
            
            _model = [TravelActDetailModel new];
            [_model setValuesForKeysWithDictionary:dic];
            // 设置轮播图
            [self createShufflingFigure];
            
            [weakSelf.myTableView reloadData];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            CLog(@"error:%@", error);
            
        }];
        
        [self.myTableView reloadData];
}

// 设置轮播图
- (void)createShufflingFigure {
    //网络加载 --- 创建带标题的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180) imageURLStringsGroup:nil]; // 模拟网络延时情景
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.delegate = self;
    
    _cycleScrollView.dotColor = [UIColor clearColor]; // 自定义分页控件小圆标颜色
    
    _cycleScrollView.autoScrollTimeInterval = 10.0;
    
    _cycleScrollView.imageURLStringsGroup = self.picArray;
    
    self.myTableView.tableHeaderView = _cycleScrollView;

}


#pragma mark-----实现SDCycleScrollViewDelegate 方法
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}



#pragma mark-----实现 tableView 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// 设置 cell 内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            self.mapTitle = model.address;
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
            break;
    }
    
    
    return nil;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

// 设置 cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    return 50;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有东西" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.f];
    }else if (indexPath.section == 2) {
        [self turnByTurn];
    }
}

- (void)dismiss:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}


// 查看路线
- (void)turnByTurn{
    //根据“北京市”进行地理编码
    [self.geocoder geocodeAddressString:@"北京市" completionHandler:^(NSArray *placemarks, NSError *error) {
        //注意地理编码一次只能定位到一个位置，不能同时定位，所在放到第一个位置定位完成回调函数中再次定位
        [self.geocoder geocodeAddressString:self.mapTitle completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *clPlacemark2=[placemarks firstObject];//获取第一个地标
            MKPlacemark *mkPlacemark2=[[MKPlacemark alloc]initWithPlacemark:clPlacemark2];
            NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
            MKMapItem *mapItem1=[MKMapItem mapItemForCurrentLocation];//当前位置
            MKMapItem *mapItem2=[[MKMapItem alloc]initWithPlacemark:mkPlacemark2];
            [MKMapItem openMapsWithItems:@[mapItem1,mapItem2] launchOptions:options];
            
        }];
        
    }];
}


// 点击返回上一级页面
- (IBAction)backButton:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

// 懒加载
-(NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

-(NSMutableArray *)picArray
{
    if (!_picArray) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}

@end
