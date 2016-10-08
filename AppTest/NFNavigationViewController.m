//
//  NFNavigationViewController.m
//  NanFang-Hospital
//
//  Created by 梁育杰 on 16/8/23.
//  Copyright © 2016年 kaka. All rights reserved.
//

#import "NFNavigationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MKMapView.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "OpenURLManager.h"
#import <AMapLocationKit/AMapLocationKit.h>
#define SCREEN_WIDTH self.view.bounds.size.width
#define  SCREEN_HEIGHT self.view.bounds.size.height
// 5.适配px


@interface NFNavigationViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>

@property (retain, nonatomic) UIView * backButtonView;
@property (retain, nonatomic) UIButton * backButton;

@property (retain, nonatomic) MAPointAnnotation * pointAnnotation;
@property (assign, nonatomic) CLLocationCoordinate2D locationCoordinate2D;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAMapView * mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (assign, nonatomic) CLLocationCoordinate2D userLocation;

@property (retain, nonatomic) UIView * bgView;
@property (retain, nonatomic) UILabel * titleLabel;
@property (retain, nonatomic) UILabel * addrLabel;
@property (retain, nonatomic) UIView * lineView;
@property (retain, nonatomic) UIImageView * iconImageView;
@property (retain, nonatomic) UILabel * searchLabel;
@property (retain, nonatomic) UIButton * searchButton;
@property (retain, nonatomic) UIButton * myPositionButton;
@property (retain, nonatomic) UIButton * hospitalPositionButton;
@property (retain, nonatomic) UIImageView * annotationImageView;

@end

@implementation NFNavigationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.locationManager startUpdatingLocation];
    [self.navigationController.navigationBar addSubview:self.backButtonView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.backButtonView removeFromSuperview];
    [self.locationManager stopUpdatingLocation];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医院导航";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    [self.backButtonView addSubview:self.backButton];
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.annotationImageView];
    [self.mapView addAnnotation:self.pointAnnotation];
    
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = @"南方医院 广州大道北1838号";
    //发起正向地理编码
    [self.search AMapGeocodeSearch: geo];
    
    [self.locationManager startUpdatingLocation];
    
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.addrLabel];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.iconImageView];
    [self.bgView addSubview:self.searchLabel];
    [self.bgView addSubview:self.searchButton];
    [self.view addSubview:self.myPositionButton];
    [self.view addSubview:self.hospitalPositionButton];

}

// 当地图滑动的时候执行的方法
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    self.annotationImageView.hidden = NO;
    [self.mapView removeAnnotation:self.pointAnnotation];
}

// 当地图滑动停止的时候执行的方法
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    self.annotationImageView.hidden = YES;
    [self.mapView addAnnotation:self.pointAnnotation];
    NSLog(@"%f  %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
    self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
    
    regeoRequest.location =[AMapGeoPoint locationWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [self.search AMapReGoecodeSearch: regeoRequest];
}
//实现逆向地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
//    *province; //!< 省/直辖市
//    *city; //!< 市
//    *citycode; //!< 城市编码
//    *district; //!< 区
//    *adcode; //!< 区域编码
//    *township; //!< 乡镇街道
//    *towncode; //!< 乡镇街道编码
//    *neighborhood; //!< 社区
//    *building; //!< 建筑
//    *streetNumber; //!< 门牌信息
    if(response.regeocode != nil)
    {
        
        self.pointAnnotation.title = [NSString stringWithFormat:@"%@",response.regeocode.addressComponent.streetNumber.street];
        self.pointAnnotation.subtitle = [NSString stringWithFormat:@"%@%@%@%@",response.regeocode.addressComponent.city,response.regeocode.addressComponent.township,response.regeocode.addressComponent.streetNumber.street,response.regeocode.addressComponent.streetNumber.number];
        NSLog(@"response.regeocode.formattedAddress ============== %@",response.regeocode.formattedAddress);
        
    }

}

//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if(response.geocodes.count == 0)
    {
        return;
    }
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    for (AMapTip *p in response.geocodes) {
         self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        self.locationCoordinate2D = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        NSLog(@"responseObject: %f   %f", p.location.latitude, p.location.longitude);
    }
}


- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.userLocation = location.coordinate;
//    if (self.pointAnnotaiton == nil)
//    {
//        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
//        [self.pointAnnotaiton setCoordinate:location.coordinate];
//        
//        [self.mapView addAnnotation:self.pointAnnotaiton];
//    }
//    
//    [self.pointAnnotaiton setCoordinate:location.coordinate];
//    
//    [self.mapView setCenterCoordinate:location.coordinate];
//    [self.mapView setZoomLevel:15.1 animated:NO];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"circle"];
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}


//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        MAPinAnnotationView * annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        annotationView.image = [UIImage imageNamed:@"19.1"];
//        annotationView.centerOffset = CGPointMake(0, -18);
//        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
////        annotationView.pinColor = MAPinAnnotationColorPurple;
//        return annotationView;
//    }
//    return nil;
//}



#pragma mark - 懒加载
- (UIView *)backButtonView {
    if (!_backButtonView) {
        _backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, MATCHSIZE(0), MATCHSIZE(88), MATCHSIZE(88))];
//        _backButtonView.centerY = self.navigationController.navigationBar.bounds.size.height/2;
    }
    return _backButtonView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(MATCHSIZE(0), 0, MATCHSIZE(88), MATCHSIZE(88));
        [_backButton setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
//        [[_backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
    }
    return _backButton;
}

- (MAPointAnnotation *)pointAnnotation {
    if (!_pointAnnotation) {
        _pointAnnotation = [[MAPointAnnotation alloc] init];
        _pointAnnotation.title = @"南方医院";
        _pointAnnotation.subtitle = @"白云区广州大道北1838号";
    }
    return _pointAnnotation;
}

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _mapView.delegate = self;
        
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(23.188692, 113.329608);
//        _mapView.centerCoordinate = CLLocationCoordinate2DMake(23.188692, 113.329608);
        MACoordinateSpan span = MACoordinateSpanMake(0.000000, 0.020680);
        MACoordinateRegion region = MACoordinateRegionMake(_mapView.centerCoordinate, span);
        _mapView.region = region;
//        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
//        _mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
//        _mapView.userTrackingMode = MAUserTrackingModeFollow;

    }
    return _mapView;
}

- (AMapSearchAPI *)search {
    if (!_search) {
        //初始化检索对象
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
        
    }
    return _locationManager;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-MATCHSIZE(228)-64, SCREEN_WIDTH, MATCHSIZE(228))];
        _bgView.userInteractionEnabled = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MATCHSIZE(30), MATCHSIZE(40), MATCHSIZE(200), MATCHSIZE(32))];
        _titleLabel.text = @"南方医院";
        _titleLabel.font = [UIFont systemFontOfSize:MATCHSIZE(32)];
//        _titleLabel.textColor = RGB(51, 51, 51);
    }
    return _titleLabel;
}

- (UILabel *)addrLabel {
    if (!_addrLabel) {
        _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(MATCHSIZE(20), MATCHSIZE(92), MATCHSIZE(500), MATCHSIZE(26))];
        _addrLabel.text = @"广州市白云区广州大道北1838号";
        _addrLabel.font = [UIFont systemFontOfSize:MATCHSIZE(26)];
//        _addrLabel.textColor = RGB(153, 153, 153);
    }
    return _addrLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, MATCHSIZE(156), SCREEN_WIDTH, MATCHSIZE(1))];
//        _lineView.backgroundColor = RGB(220, 220, 220);
    }
    return _lineView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MATCHSIZE(230), MATCHSIZE(178), MATCHSIZE(24), MATCHSIZE(28))];
        _iconImageView.image = [UIImage imageNamed:@"19.1"];
    }
    return _iconImageView;
}

- (UILabel *)searchLabel {
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(MATCHSIZE(270), MATCHSIZE(178), MATCHSIZE(210), MATCHSIZE(28))];
        _searchLabel.text = @"查看路线及周边";
        _searchLabel.textAlignment = 1;
        _searchLabel.font = [UIFont systemFontOfSize:MATCHSIZE(28)];
//        _searchLabel.textColor = RGB(102, 102, 102);
        _searchLabel.userInteractionEnabled = YES;
    }
    return _searchLabel;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(0, MATCHSIZE(156), SCREEN_WIDTH, MATCHSIZE(72));
        _searchButton.backgroundColor = [UIColor clearColor];
//        [[_searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            [OpenURLManager callMapShowPathFromCurrentLocationTo:self.locationCoordinate2D andDesName:@"南方医院 广州大道北1838号"];
//        }];
    }
    return _searchButton;
}

- (UIButton *)myPositionButton {
    if (!_myPositionButton) {
        _myPositionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _myPositionButton.frame = CGRectMake(MATCHSIZE(20), SCREEN_HEIGHT-64-MATCHSIZE(305), MATCHSIZE(70), MATCHSIZE(70));
        [_myPositionButton setBackgroundImage:[UIImage imageNamed:@"定位-2"] forState:UIControlStateNormal];
//        [[_myPositionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            self.mapView.centerCoordinate = self.userLocation;
//        }];
    }
    return _myPositionButton;
}

- (UIButton *)hospitalPositionButton {
    if (!_hospitalPositionButton) {
        _hospitalPositionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hospitalPositionButton.frame = CGRectMake(MATCHSIZE(110), SCREEN_HEIGHT-64-MATCHSIZE(300), MATCHSIZE(60), MATCHSIZE(60));
        [_hospitalPositionButton setBackgroundImage:[UIImage imageNamed:@"导航"] forState:UIControlStateNormal];
//        [[_hospitalPositionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            self.mapView.centerCoordinate = CLLocationCoordinate2DMake(23.188692, 113.329608);
//        }];
    }
    return _hospitalPositionButton;
}

- (UIImageView *)annotationImageView {
    if (!_annotationImageView) {
        _annotationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-MATCHSIZE(35)/2.0, SCREEN_HEIGHT/2-MATCHSIZE(54)/2.0-64, MATCHSIZE(35), MATCHSIZE(54))];
        _annotationImageView.image = [UIImage imageNamed:@"circle"];
    }
    return _annotationImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
