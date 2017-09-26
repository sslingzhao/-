//
//  PickerView.h
//  城市选择器
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 ShineLing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ PickerViewCancelBlock)();
typedef void(^ PickerViewOkBlock)(NSString *addressStr);
@interface SLPickerView : UIView


/**
 取消按钮 block
 */
- (void)cancelSelected:(PickerViewCancelBlock)cancelBlock;

/**
 完成按钮 block
 */
- (void)okSelected:(PickerViewOkBlock)okBlock;


/**
 显示城市选择器
 */
- (void)show;

/**
 隐藏城市选择器
 */
- (void)hide;

@end
