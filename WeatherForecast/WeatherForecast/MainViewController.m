//
//  ViewController.m
//  天气预报
//
//  Created by 吴其涛 on 15/9/23.
//  Copyright (c) 2015年 wuqitao. All rights reserved.
//

#import "MainViewController.h"
#import "Masonry.h"
@interface MainViewController ()

@property(strong,nonatomic)UILabel * cityNameLabel;
@property(strong,nonatomic)UILabel * timeLabel;
@property(strong,nonatomic)UILabel * dateLabel;
@property(strong,nonatomic)NSMutableArray * cityPinYinArray;
@property(strong,nonatomic)NSMutableDictionary * cityWeatherDict;
@property(strong,nonatomic)NSString * cityName;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingMainView];
    [self showDate];
   
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [self chinesePinyin];
    [self getCityWeatherIfo];
    
}
//属性初始化
-(void)initialization{
    
    self.cityWeatherDict = [[NSMutableDictionary alloc]init];
    self.cityPinYinArray = [[NSMutableArray alloc]init];
    
}
#pragma mark -主界面
-(void)settingMainView{

//    //设置背景
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qingtian.jpg"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.size.equalTo(self.view);
    }];


    //左侧添加按钮
    UIButton * leftAddButton = [[UIButton alloc]init];
    [leftAddButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftAddButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [leftAddButton addTarget:self action:@selector(searchAddCity) forControlEvents:UIControlEventTouchUpInside];
    leftAddButton.layer.cornerRadius = 15;
    leftAddButton.clipsToBounds = TRUE;
    [self.view addSubview:leftAddButton];
    [leftAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //左侧设置按钮
    UIButton * rightSetButton = [[UIButton alloc]init];
    [rightSetButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightSetButton addTarget:self action:@selector(weatherSettings) forControlEvents:UIControlEventTouchUpInside];
    [rightSetButton setBackgroundImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [self.view addSubview:rightSetButton];
    [rightSetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //城市名字
    self.cityNameLabel = [[UILabel alloc]init];
    self.cityNameLabel.text = @"Weather forecast";
    self.cityNameLabel.textAlignment = NSTextAlignmentCenter;
    self.cityNameLabel.textColor = [UIColor whiteColor];
    self.cityNameLabel.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:30];
    [self.view addSubview:self.cityNameLabel];
    [self.cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-self.view.frame.size.height*0.35);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width,self.view.frame.size.height*0.34));
    }];
    //时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:20];
    [self.view addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-self.view.frame.size.height*0.3);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width*0.3,self.view.frame.size.height*0.34));
        
    }];
    //日期
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:30];
    [self.view addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-self.view.frame.size.height*0.25);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width,self.view.frame.size.height*0.34));
        
        
    }];
}
#pragma mark 获取系统时间
//显示时间
-(void)showDate{
    //先获取一个时间
    self.timeLabel.text = [self getTime];
    //延迟两秒钟运行
    [self performSelector:@selector(timer) withObject:nil afterDelay:0.1f];
    self.dateLabel.text = [self getDate:0];
}

//计时器每秒获取一次时间
-(void)timer{
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]run];
    
}
//获取时间
-(NSString*)getTime{
    
    NSDate * date = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    
    formatter.dateFormat = @"HH:mm:ss";
    
    self.timeLabel.text = [formatter stringFromDate:date];
    return [formatter stringFromDate:date];
}
//获取日期
-(NSString*)getDate:(int)dayDelay{
    //dayDelay代表向后推几天，如果是0则代表是今天，如果是1就代表向后推24小时，如果想向后推12小时，就可以改成dayDelay*12*60*60,让dayDelay＝1
    NSDate * dateNow = [NSDate dateWithTimeIntervalSinceNow:dayDelay*24*60*60];
    //设置成中国阳历
    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents * comps = [[NSDateComponents alloc]init];
    
    NSInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday;
    
    comps = [calendar components:unitFlags fromDate:dateNow];
    
    //获取年月日
    long year = [comps year];
    long month = [comps month];
    long day = [comps day];
    //获取星期对应的长整形
    long weekNum = [comps weekday];
    
    //调用获取星期的方法
    NSString* date = [NSString stringWithFormat:@"%ld.%ld.%ld %@",year,month,day,[self getWeekday:weekNum]];

    return date;
}
//获取星期
-(NSString*)getWeekday:(NSInteger)num{
    NSString * weekday;
    
    switch (num) {
        case 1:
            weekday = @"Sunday";
            break;
        case 2:
            weekday = @"Monday";
            break;
        case 3:
            weekday = @"Tuesday";
            break;
        case 4:
            weekday = @"Wednesday";
            break;
        case 5:
            weekday = @"Thursday";
            break;
        case 6:
            weekday = @"Friday";
            break;
        case 7:
            weekday = @"Saturday";
            break;
        default:
            break;
    }

    return weekday;
}

#pragma mark -自定义button方法
//添加城市
-(void)searchAddCity{

    
}
//天气设置
-(void)weatherSettings{

}
#pragma mark -网络
//中文转换成拼音
-(void)chinesePinyin{
    
    [self.cityPinYinArray removeAllObjects];
    
    NSString *hanziText = @"五指山";
    
    if ([hanziText isEqualToString:@"香港特别行政区"]) {
        
        self.cityName = @"hongkong";
        
    }else if ([hanziText isEqualToString:@"澳门特别行政区"]){
    
        self.cityName = @"macao";
    
    }else{
    if ([hanziText length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
        //将汉字转成拼音带音标
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            
        }
        //去掉音标
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
           
            self.cityName = [NSString stringWithFormat:@"%@",ms];
            self.cityName = [self.cityName stringByReplacingOccurrencesOfString:@" " withString:@""];
           
        }
        
        
    }
    }
}
//调用获取城市天气信息的方法
-(void)getCityWeatherIfo{
    
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/weather";
    NSString *httpArg = [NSString stringWithFormat:@"citypinyin=%@",self.cityName];
    NSLog(@"%@",self.cityName);
    [self request: httpUrl withHttpArg: httpArg];
    
}
//从接口获取数据
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg{
    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    
    NSURL *url = [NSURL URLWithString: urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    
    [request setHTTPMethod: @"GET"];
    
    [request addValue: @"5837b895080202cfd2f5b3cd1183cea9" forHTTPHeaderField: @"apikey"];
    
    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue]completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
        
//                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                   NSLog(@"HttpResponseCode:%ld", (long)responseCode);
//                   NSLog(@"HttpResponseBody %@",responseString);
        if (!data) {
            NSLog(@"dataweikong");
            return ;
        }
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (!json) {
            NSLog(@"解析失败");
            abort();
        }
       NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        
        
       dict = json;
        NSLog(@"%@",dict[@"errMsg"]);
        
//        //如果没有该地区就弹框返回
        if ([dict[@"errNum"] integerValue] == 0){
            
            NSArray * array = dict[@"retData"];
            NSLog(@"array=%@",array);
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"⚠️" message:@"没有该地区" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
            
        }

        
        
    }];
    
    
}


//点击屏幕结束时调用
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    
   
}
//隐藏状态栏
//-(BOOL)prefersStatusBarHidden{
//    
//    
//    return YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
