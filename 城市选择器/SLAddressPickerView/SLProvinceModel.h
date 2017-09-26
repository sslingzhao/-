//
//  ProvinceModel.h
//  城市选择器
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 ShineLing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLCityModel.h"

@interface SLProvinceModel : NSObject

@property(nonatomic, copy) NSString *name; /**< 省名 */
@property(nonatomic, copy) NSString *city;

@property(nonatomic, strong) NSArray *cities; /**< 该省包含的所有城市名称*/
@property(nonatomic, strong) NSMutableArray *cityModels; /**< 该省包含的所有城市模型*/

+ (instancetype)provinceWithName:(NSString *)name cities:(NSArray *)cities;


@end
