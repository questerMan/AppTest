//
//  MainController.m
//  LiXinTestAPP
//
//  Created by luyikun on 16/9/19.
//  Copyright © 2016年 luyikun. All rights reserved.
//

#import "MainController.h"


@interface MainController ()<AMapLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong)AMapLocationManager * locationManager; //位置管理类
@property (nonatomic, strong) AMapSearchAPI *search;
@property (retain, nonatomic) MAPointAnnotation * pointAnnotation;
@property (nonatomic ,strong) UIImageView *locationCenter;
@property (nonatomic,strong) BottomView * bottomView;
@end

@implementation MainController

-(void)viewWillAppear:(BOOL)animated{
    [self creatNAC];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self creatUI];
    
    [self creatMap];
    
    [self creatLocationSend];
    

}

/**
 *  创建导航栏
 */
-(void)creatNAC{
    
    self.title = @"广汽丽新";

    self.navigationController.navigationBar.translucent = YES;
    
    [self setNavigationBarItem];
    
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];

}


- (AMapSearchAPI *)search {
    if (!_search) {
        //初始化检索对象
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}
- (MAPointAnnotation *)pointAnnotation {
    if (!_pointAnnotation) {
        _pointAnnotation = [[MAPointAnnotation alloc] init];
    }
    return _pointAnnotation;
}


/**
 *  创建UI
 */
-(void)creatUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.height.offset(60);
    }];
    
    
    
    UIButton *leftBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBottomBtn.layer.cornerRadius = 5;
    leftBottomBtn.layer.masksToBounds = YES;
    leftBottomBtn.backgroundColor = [UIColor colorWithRed:0/256.0 green:139/256.0 blue:69/256.0 alpha:1];
    [leftBottomBtn setTitle:@"现在用车" forState:UIControlStateNormal];
    [leftBottomBtn addTarget:self action:@selector(leftBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:leftBottomBtn];
    
    UIButton *rightBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBottomBtn.layer.cornerRadius = 5;
    rightBottomBtn.layer.masksToBounds = YES;
    rightBottomBtn.backgroundColor = [UIColor colorWithRed:255/256.0 green:127/256.0 blue:0 alpha:1];
    [rightBottomBtn setTitle:@"预约" forState:UIControlStateNormal];
    [rightBottomBtn addTarget:self action:@selector(rightBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rightBottomBtn];
    
    [leftBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(10);
        make.bottom.equalTo(bottomView).offset(-10);
        make.top.equalTo(bottomView).offset(10);
        
        make.right.equalTo(rightBottomBtn.mas_left).offset(-10);
        make.width.equalTo(rightBottomBtn).multipliedBy(3);

    }];
    
    [rightBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView).offset(-10);
        make.bottom.equalTo(bottomView).offset(-10);
        make.top.equalTo(bottomView).offset(10);
        
        make.left.equalTo(leftBottomBtn.mas_right).offset(10);
    }];
    
    
}
-(void)leftBottomBtn:(UIButton *)send{
    NSLog(@"马上用车");
    if (!_bottomView) {
        _bottomView = [[BottomView alloc] init];
        _bottomView.tag = 1001;
    }

    [self.view addSubview: _bottomView];

    [UIView animateWithDuration:0.4 animations:^{
        _bottomView.frame = CGRectMake(MATCHSIZE_S(0), MATCHSIZE_S(0), MATCHSIZE_S(750), MATCHSIZE_S(0));
    } completion:^(BOOL finished) {
        _bottomView.frame = CGRectMake(MATCHSIZE_S(0), MATCHSIZE_S(0), MATCHSIZE_S(750), SCREEN_HEIGHT);
    }];
    
    __weak typeof(self) weakSelf = self;
    [_bottomView setCloseBlock:^(){
        
        [UIView animateWithDuration:4 animations:^{
            weakSelf.bottomView.frame = CGRectMake(MATCHSIZE_S(0), MATCHSIZE_S(0), MATCHSIZE_S(750), SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            weakSelf.bottomView.frame = CGRectMake(MATCHSIZE_S(0), MATCHSIZE_S(0), MATCHSIZE_S(750),MATCHSIZE_S(0) );
        }];
        

    }];
}

-(void)rightBottomBtn:(UIButton *)send{
    
}
/**
 *  创建地图
 */
-(void)creatMap{
 
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];

    //是否显示用户的位置
    _mapView.showsUserLocation = YES;
    
    //设置指南针compass，默认是开启状态，大小是定值，显示在地图的右上角
    _mapView.showsCompass = NO;
    
    //设置比例尺scale，默认显示在地图的左上角
    _mapView.showsScale = NO;
    
    //地图的缩放
    [_mapView setZoomLevel:16.1 animated:YES];
    
    //设置地图logo，默认字样是“高德地图”，用logoCenter来设置logo的位置
    _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-50, CGRectGetHeight(self.view.bounds)-10);
    
    _mapView.delegate = self;
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    

    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(64);
        make.bottom.equalTo(self.view).offset(-60);
    }];
    
    //持续定位
    self.locationManager = [[AMapLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
   
    self.locationManager.delegate = self;
    //开启持续定位
    [self.locationManager startUpdatingLocation];


}
/** -------------------------------------------------------- */
/** --------------AMapLocationManagerDelegate--------------- */
/** -------------------------------------------------------- */

/**
 *  成功定位调用
 *
 *  @param manager
 *  @param location
 */
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    //输出的是模拟器的坐标
    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    _mapView.centerCoordinate = coordinate2D;
    
    
    //关闭持续定位
    [self.locationManager stopUpdatingLocation];
}
/**
 *  失败定位调用
 *
 *  @param manager
 *  @param location
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    //定位错误
    NSLog(@"定位失败");
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
    //关闭持续定位
    [self.locationManager stopUpdatingLocation];
}
/** -------------------------------------------------------- */
/** -------------------MAMapViewDelegate-------------------- */
/** -------------------------------------------------------- */

/**
 *  地图将要发生移动时调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction{
    _locationCenter.hidden = NO;
    [self.mapView removeAnnotation:self.pointAnnotation];

}

/**
 *  地图移动结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{

    _locationCenter.hidden = YES;

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
   
    //自动显示气泡信息
    [self.mapView selectAnnotation:_pointAnnotation animated:YES];

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
        annotationView.image = [UIImage imageNamed:@"locationIMG"];
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO

        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
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
//        self.locationCoordinate2D = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        NSLog(@"responseObject: %f   %f", p.location.latitude, p.location.longitude);
    }
}


/**
 *  地图将要发生缩放时调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction{
    
  

}

/**
 *  地图缩放结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction{
    
}

/**
 *  创建定位按钮／中心定位图
 */
-(void)creatLocationSend{
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom
                             ];
    [locationBtn addTarget:self action:@selector(locationSend:) forControlEvents:UIControlEventTouchUpInside];
    
    [locationBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [_mapView addSubview:locationBtn];
    
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mapView).offset(10);
        make.bottom.equalTo(_mapView).offset(-10);
        make.width.offset(40);
        make.height.offset(40);
    }];
    //中心地位坐标
    _locationCenter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"endLocation.png"]];

    _locationCenter.userInteractionEnabled = YES;
    _locationCenter.hidden = YES;
    [_mapView addSubview:_locationCenter];
    
    [_locationCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mapView);
        make.width.offset(MATCHSIZE(20));
        make.height.offset(MATCHSIZE(20));
    }];
}
//定位按钮
-(void)locationSend:(UIButton *)send{
    //开启持续定位
    [self.locationManager startUpdatingLocation];
}

//侧滑代理方法
-(void)leftWillOpen{

}
-(void)leftDidOpen{
    [self addLeftGestures];

}
-(void)leftWillClose{
}

-(void)leftDidClose{
    [self removeLeftGestures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
