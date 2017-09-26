//
//  ProvinceModel.m
//  城市选择器
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 ShineLing. All rights reserved.
//

#import "SLProvinceModel.h"

@implementation SLProvinceModel


// 成员方法创建
- (instancetype)initWithName:(NSString *)name cities:(NSArray *)cities {
    if (self = [super init]) {
        _name = name;
        _cities = cities;
    }
    
    return self;
}

// 类方法创建
+ (instancetype)provinceWithName:(NSString *)name cities:(NSArray *)cities{
    SLProvinceModel *p = [[self alloc] initWithName:name cities:cities];
    return p;
}


@end
