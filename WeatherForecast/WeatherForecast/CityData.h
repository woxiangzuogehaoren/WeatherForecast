//
//  CityData.h
//  天气预报
//
//  Created by 吴其涛 on 15/9/24.
//  Copyright (c) 2015年 wuqitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityData : NSObject
@property (strong,nonatomic)NSMutableArray * addCiytArrary;
+(CityData*)shareManager;
@end
