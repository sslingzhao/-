//
//  ViewController.m
//  城市选择器
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 ShineLing. All rights reserved.
//

#import "ViewController.h"
#import "SLPickerView.h"

#define SCREEN [UIScreen mainScreen].bounds.size

@interface ViewController ()

@property (nonatomic, strong) SLPickerView *pickerView;
@property (nonatomic, strong) UIView *pickerBgView;

@property (nonatomic ,strong) UILabel *addressLabel;

@end

@implementation ViewController

- (UIView *)pickerBgView {
    if (!_pickerBgView) {
        _pickerBgView = [[UIView alloc] initWithFrame:self.view.bounds];
        _pickerBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _pickerBgView.hidden = YES;
    }
    return _pickerBgView;
}

- (SLPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[SLPickerView alloc]initWithFrame:CGRectMake(0, SCREEN.height , SCREEN.width, 215 +40)];
        _pickerView.backgroundColor = [UIColor redColor];
    }
    return _pickerView;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, 30)];
        _addressLabel.text = @"ready to select address";
        _addressLabel.textColor = [UIColor blackColor];
        _addressLabel.center = CGPointMake(SCREEN.width/2, SCREEN.height/2);
        _addressLabel.textAlignment = 1;
    }
    return _addressLabel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    
    [self.view addSubview:self.addressLabel];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 50)];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.pickerBgView];
    [self.view addSubview:self.pickerView];

    
    [self.pickerView okSelected:^(NSString *addressStr) {
        NSLog(@" 地址 %@", addressStr);
        weakSelf.addressLabel.text = addressStr;
        [weakSelf.pickerView hide];
        weakSelf.pickerBgView.hidden = YES;
    }];
    
    [self.pickerView cancelSelected:^{
        [weakSelf.pickerView hide];
        weakSelf.pickerBgView.hidden = YES;
    }];
}

- (void)btnAction {
    NSLog(@" 显示 pickerView");
    
    [self.pickerView show];
    self.pickerBgView.hidden = NO;
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@" 隐藏 pickerView");
    [self.pickerView hide];
    self.pickerBgView.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
