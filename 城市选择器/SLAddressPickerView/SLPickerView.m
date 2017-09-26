//
//  PickerView.m
//  城市选择器
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 ShineLing. All rights reserved.
//

#import "SLPickerView.h"
#import "SLProvinceModel.h"
#import "SLCityModel.h"
#import "SLAreaModel.h"


@interface SLPickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, strong) UIPickerView *cityPickerView;

@property (nonatomic ,strong) UIView *titleBackgroundView; /**< 标题栏背景*/
@property (nonatomic ,strong) UIButton *cancelBtn; /**< 取消按钮*/
@property (nonatomic, strong) UIButton *completedBtn; /**< 完成按钮*/
@property (nonatomic, strong) UILabel *titleLabel; /**< 选择城市Lab*/

@property(nonatomic, strong) NSMutableArray *loadCityAddressData;

@property(nonatomic, strong) NSMutableArray *proArr; /**< 省份*/

@property(nonatomic, copy) PickerViewCancelBlock cancelBlock; /**< 取消按钮 block*/
@property(nonatomic, copy) PickerViewOkBlock okBlock; /**< 完成按钮 block*/

@end

@implementation SLPickerView


- (UIView *)titleBackgroundView{
    if (!_titleBackgroundView) {
        _titleBackgroundView = [[UIView alloc]initWithFrame: CGRectMake(0, self.frame.size.height-215-40, self.frame.size.width, 40)];
        _titleBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _titleBackgroundView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelBtn.frame), 0, self.frame.size.width -200, 40)];
        _titleLabel.text = @"选择城市";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame: CGRectMake(0, 0, 100, 40)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)completedBtn{
    if (!_completedBtn) {
        _completedBtn = [[UIButton alloc]initWithFrame: CGRectMake(self.frame.size.width - 100, 0, 100, 40)];
        [_completedBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completedBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_completedBtn addTarget:self action:@selector(completedBtnClicked)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _completedBtn;
}

#pragma mark - 加载标题栏
- (void)setupCityPickerTitleView {
    [self addSubview:self.titleBackgroundView];
    [self.titleBackgroundView addSubview:self.cancelBtn];
    [self.titleBackgroundView addSubview:self.completedBtn];
    [self.titleBackgroundView addSubview:self.titleLabel];
}

- (UIPickerView *)cityPickerView{
    if (!_cityPickerView) {
        _cityPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 215, self.frame.size.width, 215)];
        _cityPickerView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
        _cityPickerView.delegate = self;
        _cityPickerView.dataSource = self;
    }
    return _cityPickerView;
}


- (NSMutableArray *)loadCityAddressData {
    
    if (_loadCityAddressData == nil) {
        
        _proArr = [NSMutableArray array];
        
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        NSError *error;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

        for (NSDictionary *provinceDict in jsonObject) { // 获取省份
            SLProvinceModel
            *provinceModel = [SLProvinceModel provinceWithName:provinceDict[@"name"] cities:provinceDict[@"city"]];
            [_proArr addObject:provinceModel];
            
            // 获取市
            NSMutableArray *cityArr = [NSMutableArray array];
            for (NSDictionary *cityDict in provinceDict[@"city"]) {
                SLCityModel *cityModel = [SLCityModel cityWithName:cityDict[@"name"] areas:cityDict[@"area"]];
                [cityArr addObject:cityModel];
                
                // 获取城区
                NSMutableArray *areaArr = [NSMutableArray array];
                for (NSString *areaStr in cityDict[@"area"]) {
                    SLAreaModel *areaModel = [[SLAreaModel alloc] init];
                    areaModel.area = areaStr;
                    [areaArr addObject:areaModel];
                }
                cityModel.areaModels = areaArr;
            }
            provinceModel.cityModels = cityArr;
        }
    }
    
    return _loadCityAddressData;
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadCityAddressData];
        
        [self setupCityPickerTitleView];
        
        [self setupCityPickerView];
        
        
        __weak __typeof(self)weakSelf = self;
        [self getIdx:^(NSInteger proIndex, NSInteger cityIndex, NSInteger areaIndex) {
            [weakSelf.cityPickerView selectRow:proIndex inComponent:0 animated:NO];
            [weakSelf.cityPickerView selectRow:cityIndex inComponent:1 animated:NO];
            [weakSelf.cityPickerView selectRow:areaIndex inComponent:2 animated:NO];
        }];
        
    }
    return self;
}
#pragma mark - 添加UIPickerView
- (void)setupCityPickerView {
    
    [self addSubview:self.cityPickerView];
}

#pragma mark - 取消
- (void)cancelBtnClicked {
    NSLog(@"取消");
    if (_cancelBlock) {
        _cancelBlock();
    }
}

#pragma mark - 完成
- (void)completedBtnClicked {
    NSLog(@"完成");
    
    NSInteger provinceComp = [self.cityPickerView selectedRowInComponent:0];
    NSInteger cityComp = [self.cityPickerView selectedRowInComponent:1];
    NSInteger areaComp = [self.cityPickerView selectedRowInComponent:2];
    
    SLProvinceModel *proModel = _proArr[provinceComp];
    
    if (provinceComp > proModel.cityModels.count - 1) {
        provinceComp = proModel.cityModels.count - 1;
    }
    
    SLCityModel *cityModel = proModel.cityModels[cityComp];
    
    if (areaComp > cityModel.areas.count - 1) {
        areaComp = cityModel.areas.count - 1;
    }
    
    SLAreaModel *areaModel = cityModel.areaModels[areaComp];
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@", proModel.name, cityModel.name, areaModel.area];
    if (_okBlock) {
        _okBlock(address);
    }
    
    [self setProvinceIdx:provinceComp cityIdx:cityComp areaIdx:areaComp];
    
}

// 保存 选中的省市区 的 index
- (void)setProvinceIdx:(NSInteger)proIndex cityIdx:(NSInteger)cityIndex areaIdx:(NSInteger)areaIndex {
    [[NSUserDefaults standardUserDefaults] setValue:@(proIndex) forKey:@"AddressProvinceIdx"];
    [[NSUserDefaults standardUserDefaults] setValue:@(cityIndex) forKey:@"AddressCityIdx"];
    [[NSUserDefaults standardUserDefaults] setValue:@(areaIndex) forKey:@"AddressAreaIdx"];
}

typedef void(^SelectedIdxBlock)(NSInteger proIndex, NSInteger cityIndex, NSInteger areaIndex);

- (void)getIdx:(SelectedIdxBlock)block {
    NSNumber *proIndex = [[NSUserDefaults standardUserDefaults] valueForKey:@"AddressProvinceIdx"];
    NSNumber *cityIndex = [[NSUserDefaults standardUserDefaults] valueForKey:@"AddressCityIdx"];
    NSNumber *areaIndex = [[NSUserDefaults standardUserDefaults] valueForKey:@"AddressAreaIdx"];
    
    if (proIndex.integerValue && cityIndex.integerValue && areaIndex.integerValue) {
        block(proIndex.integerValue, cityIndex.integerValue, areaIndex.integerValue);
    }
}

#pragma mark - 显示城市选择器
- (void)show{
    [self showOrHide:YES];
}

#pragma mark - 隐藏城市选择器
- (void)hide{
    [self showOrHide:NO];
}

#pragma mark - 动画 显示 / 隐藏 城市选择器
- (void)showOrHide:(BOOL)isShow{
    
    CGFloat selfY = self.frame.origin.y;
    __block CGFloat selfkY = selfY;
    [UIView animateWithDuration:0.3 animations:^{
        
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        
        // 改变它的frame的x,y的值
        if (isShow) {
            selfkY = [UIScreen mainScreen].bounds.size.height - 215 -40;
        }else {
            selfkY = [UIScreen mainScreen].bounds.size.height;
        }
        self.frame = CGRectMake(0, selfkY, self.bounds.size.width, 215 +40);
        
        [UIView commitAnimations];
    }];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _proArr.count;
    }else if (component == 1) {
        NSInteger selectProvince = [pickerView selectedRowInComponent:0];
        SLProvinceModel *proModel = _proArr[selectProvince];
        return proModel.cities.count;
    }else {
        NSInteger selectProRow = [pickerView selectedRowInComponent:0];
        NSInteger selectCityRow     = [pickerView selectedRowInComponent:1];
        SLProvinceModel  *selectProModel = _proArr[selectProRow];
        if (selectCityRow > selectProModel.cityModels.count - 1) {
            return 0;
        }
        SLCityModel * c = selectProModel.cityModels[selectCityRow];
        return c.areaModels.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) { // 省份
        SLProvinceModel *proModel = _proArr[row];
        return proModel.name;
    }else if (component == 1) { // 市
        SLProvinceModel * selectP = _proArr[[pickerView selectedRowInComponent:0]];
        if (row > selectP.cities.count - 1) {
            return nil;
        }
        SLCityModel *cityModel = selectP.cityModels[row];
        return cityModel.name;
    }else { // 城区
        SLProvinceModel * selectP = _proArr[[pickerView selectedRowInComponent:0]];
        SLCityModel *selectCtityModel = selectP.cityModels[[pickerView selectedRowInComponent:1]];
        SLAreaModel *aModel = selectCtityModel.areaModels[row];
        return aModel.area;
    }
}

#pragma mark - pickerView 被选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (0 == component) {
//        NSInteger selectCity = [pickerView selectedRowInComponent:1];
//        NSInteger selectArea = [pickerView selectedRowInComponent:2];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES]; // 滚动时默认选中第一行
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES]; // 滚动时默认选中第一行
        
    } else if (1 == component){
//        NSInteger selectArea = [pickerView selectedRowInComponent:2];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row  forComponent:component];
    return pickerLabel;
    
}


- (void)cancelSelected:(PickerViewCancelBlock)cancelBlock {
    _cancelBlock = [cancelBlock copy];
}

- (void)okSelected:(PickerViewOkBlock)okBlock {
    _okBlock = [okBlock copy];
}



@end
