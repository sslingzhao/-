//
//  CityModel.m
//  城市选择器
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 ShineLing. All rights reserved.
//

#import "SLCityModel.h"

@implementation SLCityModel


- (instancetype)initWithName:(NSString *)name areas:(NSArray *)areas{
    if (self = [super init]) {
        _name = name;
        _areas = areas;
    }
    return self;
}


+ (instancetype)cityWithName:(NSString *)cityName areas:(NSArray *)areas {
    
    SLCityModel * city = [[self alloc] initWithName:cityName areas:areas];
    return city;
}

@end
