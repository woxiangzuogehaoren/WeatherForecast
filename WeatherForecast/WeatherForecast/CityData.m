//
//  CityData.m
//  天气预报
//
//  Created by 吴其涛 on 15/9/24.
//  Copyright (c) 2015年 wuqitao. All rights reserved.
//

#import "CityData.h"
static CityData * _cityData = nil;
@implementation CityData
+(CityData*)shareManager{
    
    if (!_cityData) {
        
        _cityData = [[CityData alloc]init];
        _cityData.addCiytArrary = [[NSMutableArray alloc]init];
        
    }
    return _cityData;
}
@end
