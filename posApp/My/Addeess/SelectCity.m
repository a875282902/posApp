//
//  SelectCity.m
//  anjuyi1
//
//  Created by 李 on 2018/6/21.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SelectCity.h"

static CGFloat vHeight = 250;

static CGFloat sHeight = 50;

@interface SelectCity()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSDictionary *provinceDic;
    NSDictionary *cityDic;
    NSDictionary *areaDic;
}


@property (nonatomic,strong)UIPickerView *tmpPickerView;

@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)NSMutableArray  * provinceArr;
@property (nonatomic,strong)NSMutableArray  * cityArr;
@property (nonatomic,strong)NSMutableArray  * areaArr;


@end

@implementation SelectCity


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [self setBackgroundColor:MDRGBA(0, 0, 0, 0.8)];
        self.provinceArr = [NSMutableArray array];
        self.cityArr = [NSMutableArray array];
        self.areaArr = [NSMutableArray array];
        [self setUpUI];
        [self setHidden:YES];
        
        [self getCityData:@"0"];
    }
    
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight , KScreenWidth, vHeight)];
    [self.backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.tmpPickerView];
    
    UIButton *cancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancel setFrame:CGRectMake(0, 0 , 60, sHeight)];
    [cancel addTarget:self action:@selector(cancelDidPress) forControlEvents:(UIControlEventTouchUpInside)];
    [cancel setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [cancel setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.backView addSubview:cancel];
    
    UIButton *sure = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sure setFrame:CGRectMake(KScreenWidth - 60, 0 , 60, sHeight)];
    [sure addTarget:self action:@selector(sureDidPress) forControlEvents:(UIControlEventTouchUpInside)];
    [sure setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [sure setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.backView addSubview:sure];
    
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, sHeight, KScreenWidth, 1)]];
}

#pragma mark --  tmpPickerView
- (UIPickerView *)tmpPickerView{
    
    if (!_tmpPickerView) {
        _tmpPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, sHeight, KScreenWidth, vHeight-sHeight)];
        [_tmpPickerView setDelegate:self];
        [_tmpPickerView setDataSource:self];
    }
    return _tmpPickerView;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0)
        return self.provinceArr.count;
    
    if (component == 1)
        return self.cityArr.count;
    
    return self.areaArr.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dic ;
    if (component == 0) {
        dic = self.provinceArr[row];
        
    }
    if (component == 1) {
        dic = self.cityArr[row];
        
    }
    if (component ==2) {
        
        dic = self.areaArr[row];
    }
    
    return  dic[@"name"];

}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        provinceDic = self.provinceArr[row];
        
        [self.cityArr removeAllObjects];
        [self.areaArr removeAllObjects];
        
        [self getCityData:self.provinceArr[row][@"id"]];
    }
    
    if (component == 1) {
        [self.areaArr removeAllObjects];
        cityDic = self.cityArr[row];
        [self getCityData:self.cityArr[row][@"id"]];
        
    }
    if (component == 2) {
        areaDic = self.areaArr[row];
        
    }
}
- (void)getCityData:(NSString *)cityID{
    
    NSDictionary *dic = @{@"service":@"Main.Area",@"utoken":UTOKEN,@"pid":cityID};
    
    __weak typeof(self) weakSelf = self;
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        if ([responseObject[@"ret"] integerValue]==200) {
            
            NSArray *arr = responseObject[@"data"];
            
            if ([cityID integerValue] == 0) {//添加省数组
                [weakSelf.provinceArr removeAllObjects];
                for (NSDictionary *dic in arr) {
                    [weakSelf.provinceArr addObject:dic];
                }
                [weakSelf.tmpPickerView reloadComponent:0];
                
                if (weakSelf.cityArr.count == 0 && weakSelf.provinceArr.count > 0) {
                    self -> provinceDic = weakSelf.provinceArr[0];
                    [weakSelf getCityData:weakSelf.provinceArr[0][@"id"]];
                }
                
            }
            else{//添加城市数组
                if (weakSelf.cityArr.count == 0) {
                    
                    for (NSDictionary *dic in arr) {
                        [weakSelf.cityArr addObject:dic];
                    }
                    [weakSelf.tmpPickerView reloadComponent:1];
                    
                    if (weakSelf.cityArr.count > 0 && weakSelf.areaArr.count == 0) {
                        self -> cityDic = weakSelf.cityArr[0];
                        [weakSelf getCityData:weakSelf.cityArr[0][@"id"]];
                    }
                    
                    [weakSelf.tmpPickerView selectRow:0 inComponent:1 animated:YES];
                    
                }
                
                else{
                    
                    for (NSDictionary *dic in arr) {
                        [weakSelf.areaArr addObject:dic];
                    }
                    [weakSelf.tmpPickerView reloadComponent:2];
                    
                    if (weakSelf.areaArr.count > 0) {
                        self -> areaDic = weakSelf.areaArr[0];
                        
                    }
                    
                    [weakSelf.tmpPickerView selectRow:0 inComponent:2 animated:YES];
                
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        
        [RequestSever showMsgWithError:error];
    }];
}
#pragma mark -- 事件
- (void)cancelDidPress{
    
    [self hidden];
}

- (void)sureDidPress{
    if (!provinceDic) {
        provinceDic = self.provinceArr[0];
    }
    if (!cityDic) {
        cityDic = self.cityArr[0];
    }
    if (!areaDic) {
        areaDic = self.areaArr[0];
    }
    
    [self.delegate sureProvince:provinceDic city:cityDic area:areaDic];
    [self hidden];
}


- (void)show{
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(0, KScreenHeight - vHeight, KScreenWidth, vHeight)];
    }];
}

- (void)hidden{
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(0, KScreenHeight , KScreenWidth, vHeight)];
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self setHidden:YES];
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touc = [touches anyObject];
    
    CGPoint p =  [touc locationInView:self];
    
    if (p.y < KScreenHeight - vHeight) {
        [self hidden];
    }
    
}

@end
