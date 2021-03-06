//
//  TravelRootCollectionViewController.m
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#import "TravelRootCollectionViewController.h"
#import "TravelMainFirstCell.h"
#import "TravelRootCellModel.h"
#import "TravelMainSecondCell.h"
#import "TravelListCell.h"
#import "TravelActivityModel.h"
#import "TravelWebViewController.h"
#import "UIImage+AFNetworking.h"
#import "SDCycleScrollView.h"
#import "TravelCityListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HelpMethod.h"
#import "TravelSmallDetailViewController.h"
#import "SmallDetailTableViewController.h"
#import "ActivityDetailViewController.h"
#import "MJRefresh.h"


@interface TravelRootCollectionViewController ()<UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate, UICollectionViewDataSource,TravelCityListViewControllerDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong)NSMutableArray * circleArray; // 存储轮播图

@property (nonatomic, strong)NSMutableArray * cirModelArray;//存 储轮播modelarray
@property (nonatomic, strong)NSMutableArray * nameArray; // 存放轮播name

@property (nonatomic, strong)NSMutableArray * modelArray; // 存放 model 对象

@property (nonatomic, strong)NSMutableArray * smodelArray; //第二个 model 数组

@property (nonatomic, strong)NSMutableArray * activityModelArray; //存放活动 model

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong)TravelCityListViewController * travelCLVC;

@property (nonatomic, strong)CLLocationManager * locationManager;//  位置管理者
@property (nonatomic, strong)UILabel * displayLocation;// 显示当前地理位置
@property (nonatomic, copy)NSString * cityName;// 接收定位的城市名字
@property (nonatomic, copy)NSString * leftItemTitle;// 设置左ItemTitle的值

@property (nonatomic, assign)NSInteger pageCount; // 存放解析数据的页数

@property (nonatomic, strong)UIActivityIndicatorView * indicatorView; //

@end

@implementation TravelRootCollectionViewController

//static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 开启定位
    [self openPosition];

    // 注册 cell
    [self registerCell];
    
    // 推出城市页面传值
    self.travelCLVC = [[UIStoryboard storyboardWithName:@"Travel" bundle:nil] instantiateViewControllerWithIdentifier:@"TravelCity_id"];
    self.travelCLVC.delegate = self;
    
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(bookHeaderRefresh)];
    // 马上进入刷新状态
            [self.collectionView.header beginRefreshing];
    // 上拉加载
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(bookFooterLoadData)];
}

// 下拉刷新
- (void)bookHeaderRefresh
{
    // 刷新列表
    [self.collectionView reloadData];
    
    // 拿到当前下拉刷新控件，结束刷新
    [self.collectionView.header endRefreshing];
}

// 上拉加载
- (void)bookFooterLoadData
{
    // 判断加载自己的数据
    if (self.pageCount < self.activityModelArray.count) {
        if (self.activityModelArray.count - self.pageCount >= 11) {
            self.pageCount += 11;
            // 结束刷新
            [self.collectionView.footer endRefreshing];
            CLog(@"self.pageCount1 = %ld",self.pageCount);
        } else {
            self.pageCount += self.activityModelArray.count - self.pageCount;
            // 结束刷新
            [self.collectionView.footer endRefreshing];
            CLog(@"self.pageCount2 = %ld",self.pageCount);
        }
        
    } else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据已全部加载完毕" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        [self.collectionView.footer endRefreshing];
    }
    // 隐藏当前的上拉刷新控件
    self.collectionView.footer.hidden = YES;
    // 刷新列表
    [self.collectionView reloadData];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}
//注册 cell
- (void)registerCell
{
    // 小运营位
    [self.collectionView registerNib:[UINib nibWithNibName:@"TravelMainFirstCell" bundle:nil] forCellWithReuseIdentifier:@"Tfirst_id"];
    // 大运营位
    [self.collectionView registerNib:[UINib nibWithNibName:@"TravelMainSecondCell" bundle:nil] forCellWithReuseIdentifier:@"Tsecond_id"];
    // 活动列表
    [self.collectionView registerNib:[UINib nibWithNibName:@"TravelListCell" bundle:nil] forCellWithReuseIdentifier:@"Tlistcell_id"];
    // 轮播图
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

 // 开启定位
- (void)openPosition {
    // 初始化管理者
    self.locationManager = [[CLLocationManager alloc] init];
    // 开启定位
    [self.locationManager startUpdatingLocation];
    // iOS8之后 必须请求
    [self.locationManager requestWhenInUseAuthorization];
    // 绑定定位代理
    self.locationManager.delegate = self;
}

#pragma mark---- 实现位置管理者代理代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation * location = locations.firstObject;
    // 地理编码 反地理编码
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    // 反地理编码 (把经纬度转化为位置信息)
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //        NSLog(@"%@",placemarks);// 不一定会显示(不显示换模拟器)
        CLPlacemark * mark = placemarks.firstObject;
        self.cityName = mark.locality;
        // 判断是否已经赋值
        if ([[HelpMethod sharedManager].cityName_prepar isEqualToString:@""]) {
            // 单例传值
            [HelpMethod sharedManager].cityName_prepar = self.cityName;
        }
        // 判断 如果cityName有没有值,没有就默认为定位的值
        if (self.cityName == nil || [self.cityName isEqualToString:@""]) {
            self.cityName = @"北京市";
        }
        if (self.leftItemTitle == nil) {
            self.navigationItem.leftBarButtonItem.title = [@"我在" stringByAppendingString:self.cityName];
        }

        CLog(@"显示城市名:%@",mark.locality);
            // 定位完成后关闭定位服务(防止一直定位过于耗电)
        [_locationManager stopUpdatingLocation];
    }];

}

#pragma mark ---实现TravelCityListViewControllerDelegate代理方法
-(void)sendValueCity:(NSString *)cityText cityCode:(NSString *)cityCode {
    self.navigationItem.leftBarButtonItem.title = [@"我在" stringByAppendingString:cityText];
    self.leftItemTitle = cityText;
    self.cityCode = cityCode;
}

// 请求数据
- (void)requestData
{
    if (self.cityCode == nil) {
        self.cityCode = @"110100";
    }
    // 轮播图,小运营位,大运营位数据
    NSString * string = @"bannerRound%2CbannerScroll%2CbannerSquare&area_code";
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kRootDataUrl(string, self.cityCode)]];

    if(data) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self.circleArray removeAllObjects];
        [self.modelArray removeAllObjects];
        [self.smodelArray removeAllObjects];
        [self.cirModelArray removeAllObjects];
        
        NSArray * resArray = dic[@"content"];
        
        for (NSDictionary * resDic in resArray) {
            
            NSString * tag = resDic[@"operateId"];
            if ([tag isEqualToString:@"5"]) {
                
                NSArray * xArr = resDic[@"ad"];
                for (NSDictionary * ctDic in xArr) {
                    NSDictionary * xdic = ctDic[@"ct"];
                    TravelRootCellModel * model = [TravelRootCellModel new];
                    [model setValuesForKeysWithDictionary:xdic];
                    NSString * cirUrl = model.app_picpath;
                    NSString * cirName = model.title;
                    
                    [self.nameArray addObject:cirName];
                    
                    [self.circleArray addObject:cirUrl];
                    [self.cirModelArray addObject:model];

                }
         
            }else if ([tag isEqualToString:@"11"]) {
                
                NSArray * xArr = resDic[@"ad"];
                for (NSDictionary * ctDic in xArr) {
                    NSDictionary * xdic = ctDic[@"ct"];
                    
                    TravelRootCellModel * model = [TravelRootCellModel new];
                    [model setValuesForKeysWithDictionary:xdic];
                    
                    [self.modelArray addObject:model];
                    
                }
            }else if ([tag isEqualToString:@"12"]) {
                
                NSArray * xArr = resDic[@"ad"];
                for (NSDictionary * ctDic in xArr) {
                    NSDictionary * xdic = ctDic[@"ct"];
                    
                    TravelRootCellModel * model1 = [TravelRootCellModel new];
                    [model1 setValuesForKeysWithDictionary:xdic];
                    [self.smodelArray addObject:model1];
            }
        }
    }
  }
    // 活动列表数据
    NSData * data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:kRootCellUrl(self.cityCode)]];
    
//    CLog(@"+++++%@", kRootCellUrl(self.cityCode));

    if (data1) {
        NSDictionary * resDic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        [self.activityModelArray removeAllObjects];
        for (NSDictionary * dic in resDic[@"content"]) {
            TravelActivityModel * model = [TravelActivityModel new];
            [model setValuesForKeysWithDictionary:dic];
            
           
            [self.activityModelArray addObject:model];

        }
    }
    if (self.activityModelArray.count >= 11) {
        // 设置每次加载多少个值
        self.pageCount = 11;
        // 停止加载
        [self.indicatorView stopAnimating];
    } else {
        self.pageCount = self.activityModelArray.count;
        // 停止加载
        [self.indicatorView stopAnimating];
    }

    // 停止加载
    [self.indicatorView stopAnimating];

    // 加载轮播图
    [self creatCirPic];
    
    [self.collectionView reloadData];
}


//创建轮播图
- (void)creatCirPic
{
    //网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.width-20)/2) imageURLStringsGroup:nil]; // 模拟网络延时情景
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.delegate = self;
//    _cycleScrollView.titlesGroup = self.nameArray;
    
    _cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cycleScrollView.imageURLStringsGroup = self.circleArray;
    });
    
    _cycleScrollView.autoScrollTimeInterval = 3.0;
    
}

#pragma mark----实现SDCycleScrollViewDelegate方法
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    TravelRootCellModel * model = self.cirModelArray[index];
    if (model.app_url_site == 1) {
        // 推出 webView
        TravelWebViewController * WC = [[TravelWebViewController alloc] init];
        WC.webUrl = model.app_url;
        WC.title = model.title;
        [self.navigationController pushViewController:WC animated:YES];
    }else if (model.app_url_site == 3) {
        
        SmallDetailTableViewController * sdtVC = [[UIStoryboard storyboardWithName:@"Travel" bundle:nil] instantiateViewControllerWithIdentifier:@"smallDetail_id"];
        sdtVC.title = model.title;
        NSString * str = model.app_url;
        NSString * proStr = [str substringToIndex:5];
        sdtVC.productId = proStr;
        [self.navigationController pushViewController:sdtVC animated:YES];
    }
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 4;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.circleArray.count == 0 && self.modelArray.count == 0 && self.smodelArray.count == 0 && self.activityModelArray.count == 0) {
        [self creatAlert];
        return 0;
    }
    
    if (section == 0) {
        
        return 1;
    }else if (section == 1) {
        if (self.modelArray.count <4) {
            return self.modelArray.count;
        }
        return 4;
    }else if (section == 2) {
        return self.smodelArray.count;
    }
    if (self.activityModelArray.count == 0) {
        [self creatAlert];
        return 0;

    }
    return _pageCount;
//    return self.activityModelArray.count;
}

//设置 cell 内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        [cell.viewForLastBaselineLayout addSubview:_cycleScrollView];
        return cell;
    }else if (indexPath.section == 1) {
        TravelMainFirstCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Tfirst_id" forIndexPath:indexPath];

            TravelRootCellModel * model = self.modelArray[indexPath.row];
            cell.model = model;
            return cell;

    } else if (indexPath.section == 2) {
        
        TravelMainSecondCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Tsecond_id" forIndexPath:indexPath];

            TravelRootCellModel * model = self.smodelArray[indexPath.row];
            cell.model = model;
            return cell;
        
    }else {
//        if (self.activityModelArray.count == 0) {
//            UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 90)];
//            label.text = @"=================================\n我们正在这里努力开拓产品...\n>_<";
//            label.numberOfLines = 0;
//            label.textAlignment = NSTextAlignmentCenter;
//            [cell.viewForLastBaselineLayout addSubview:label];
//            
//            return cell;
//        }
        TravelListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Tlistcell_id" forIndexPath:indexPath];
        
            TravelActivityModel * model = self.activityModelArray[indexPath.row];
            cell.model = model;
            return cell;

    }
    return nil;
}

#pragma mark <UICollectionViewDelegate>

// 设置 cell 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(self.collectionView.frame.size.width, CGRectGetWidth(self.view.frame)/2);
    }
    if (indexPath.section == 1) {
        return CGSizeMake(CGRectGetWidth(self.view.frame)*4/25, CGRectGetWidth(self.view.frame)*1/5);
    }else if (indexPath.section == 2) {
        return CGSizeMake((CGRectGetWidth(self.view.frame)-20)/2, (CGRectGetWidth(self.view.frame)-10)/5);
    }else {
        return CGSizeMake(CGRectGetWidth(self.view.frame)-20, 250);
    }
    
    
}


//点击 cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        // 点击推出分类列表
        TravelRootCellModel * model = self.modelArray[indexPath.row];
        if (model.app_url_site != 1) {
            TravelSmallDetailViewController * tsdVC = [[UIStoryboard storyboardWithName:@"Travel" bundle:nil] instantiateViewControllerWithIdentifier:@"Tlist_id"];
            if (model.app_url_site == 4) {
                tsdVC.propertyId = model.app_url;
                tsdVC.tagId = @"0";
            }else if (model.app_url_site == 5) {
                tsdVC.tagId = model.app_url;
                tsdVC.propertyId = @"0";
            }
            tsdVC.title = model.title;
            [self.navigationController pushViewController:tsdVC animated:YES];
        }else if (model.app_url_site == 1) {
            TravelWebViewController * WC = [[TravelWebViewController alloc] init];
            TravelRootCellModel * model = self.smodelArray[indexPath.row];
            WC.webUrl = model.app_url;
            WC.title = model.title;
            [self.navigationController pushViewController:WC animated:YES];
        }
        
        
    }else if (indexPath.section == 2) {
        
        TravelRootCellModel * model = self.smodelArray[indexPath.row];

        if (model.app_url_site == 1) {
            // 推出 webView
            TravelWebViewController * WC = [[TravelWebViewController alloc] init];
            WC.webUrl = model.app_url;
            WC.title = model.title;
            [self.navigationController pushViewController:WC animated:YES];
        }else if (model.app_url_site == 3) {
            
            SmallDetailTableViewController * sdtVC = [[UIStoryboard storyboardWithName:@"Travel" bundle:nil] instantiateViewControllerWithIdentifier:@"smallDetail_id"];
            sdtVC.title = model.title;
            NSString * str = model.app_url;
            NSString * proStr = [str substringToIndex:5];
            sdtVC.productId = proStr;
            [self.navigationController pushViewController:sdtVC animated:YES];
        }
        
    }else {

        // 推出活动详情
        ActivityDetailViewController * adVC = [[UIStoryboard storyboardWithName:@"Travel" bundle:nil] instantiateViewControllerWithIdentifier:@"Tactivity_id"];
        TravelActivityModel * model = self.activityModelArray[indexPath.row];
        NSString * str = [NSString stringWithFormat:@"%ld", (long)model.productId];
        adVC.productId = str;
        [self.navigationController pushViewController:adVC animated:YES];
    }
}



// 列之间最小距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
// 距离上下左右
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else if (section == 1) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
// 点击城市推出城市列表
- (IBAction)ModalCityList:(UIBarButtonItem *)sender {
    self.travelCLVC.positionCityName = self.cityName;
    [self.navigationController pushViewController:self.travelCLVC animated:YES];
}
// 点击刷新页面
- (IBAction)refreshButton:(UIBarButtonItem *)sender {
    
    [self.circleArray removeAllObjects];
    [self.nameArray removeAllObjects];
    [self.smodelArray removeAllObjects];
    [self.modelArray removeAllObjects];
    [self.activityModelArray removeAllObjects];
    // 开启定位
    [self openPosition];
    [self requestData];
}




- (void)creatAlert
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:@"我们正在这里努力开拓产品..." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"返回城市列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:self.travelCLVC animated:YES];
    }];
    [alertC addAction:action];
    
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
    
}

// 懒加载
-(NSMutableArray *)circleArray
{
    if (!_circleArray) {
        _circleArray = [NSMutableArray array];
    }
    
    return _circleArray;
}

-(NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

-(NSMutableArray *)smodelArray
{
    if (!_smodelArray) {
        _smodelArray = [NSMutableArray array];
    }
    return _smodelArray;
}

-(NSMutableArray *)activityModelArray
{
    if (!_activityModelArray) {
        _activityModelArray = [NSMutableArray array];
    }
    
    return _activityModelArray;
}

-(NSMutableArray *)nameArray
{
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}



-(NSMutableArray *)cirModelArray
{
    if (!_cirModelArray) {
        _cirModelArray = [NSMutableArray array];
    }
    return _cirModelArray;
}



@end
