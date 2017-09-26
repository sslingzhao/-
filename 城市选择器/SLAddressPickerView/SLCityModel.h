//
//  CityModel.h
//  城市选择器
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 ShineLing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLCityModel : NSObject

@property(nonatomic, copy) NSString *name; /**< 市名 */
@property(nonatomic, copy) NSString *area;

@property(nonatomic ,strong) NSArray *areas; /**< 城市包含的所有地区*/
@property(nonatomic, strong) NSMutableArray *areaModels; /**< 该省包含的所有区模型*/


+ (instancetype)cityWithName:(NSString *)cityName areas:(NSArray *)areas;

@end
