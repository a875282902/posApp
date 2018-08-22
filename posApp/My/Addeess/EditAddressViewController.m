//
//  AddAddressViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "EditAddressViewController.h"
#import "SelectCity.h"

@interface EditAddressViewController ()<UIScrollViewDelegate,SelectCityDelegate>
{
    NSDictionary  * provincesDic;//保存省
    NSDictionary  * cityDic;//保存城市
    NSDictionary  * countyDic;//保存区
    UILabel       * selectLabel;//选择城市的label 为了修改文字
    NSString      * isdefault;
}

@property (nonatomic,strong)UIScrollView    * tmpScrollView;
@property (nonatomic,strong)NSMutableArray  * textArr;
@property (nonatomic,strong)SelectCity      * selectCity;
@property (nonatomic,strong)NSMutableArray  * cityArr;

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"编辑地址"];
    [self setNavigationLeftBarButtonWithImageNamed:@"ss_back"];
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"", nil];
    self.cityArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self getLocationDetails];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectCity];
}

- (void)getLocationDetails{
    
    NSDictionary *dic = @{@"service":@"Member.Addressinfo",@"utoken":UTOKEN,@"id":self.addressID};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            NSDictionary *dic = responseObject[@"data"];
            
            weakSelf.textArr = [NSMutableArray arrayWithObjects:dic[@"name"],dic[@"phone"],dic[@"pca"],dic[@"address"],@"",dic[@"address"],@"",@"", nil];
            
            self->provincesDic = @{@"id":dic[@"provinceid"],@"name":dic[@"provinceid"]};
            self->cityDic      = @{@"id":dic[@"cityid"],@"name":dic[@"cityid"]};
            self->countyDic    = @{@"id":dic[@"areaid"],@"name":dic[@"areaid"]};
            self->isdefault    = dic[@"isdefault"];
            [weakSelf setUpUI];
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}


-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTopHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    NSArray *iArr = @[@"add_name",@"add_phone",@"add_add",@"",@"",@""];
    
    NSArray *tArr = @[@"请输入您的姓名",@"请输入您的电话",@"请选择您所在的区域",@"请输入您的详细地址",@""];
    
    for (NSInteger i = 0 ; i < 4 ; i ++ ) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, MDXFrom6(20+50*i), KScreenWidth, MDXFrom6(50))];
        [self.tmpScrollView addSubview:backView];
        
        if (i<3) {
            [backView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(15), MDXFrom6(17.5), MDXFrom6(15), MDXFrom6(15)) image:iArr[i]]];
            [backView addSubview:[Tools setLineView:CGRectMake(MDXFrom6(15), MDXFrom6(49), KScreenWidth - MDXFrom6(30), MDXFrom6(1))]];
        }
        else{
            
            [backView addSubview:[Tools setLineView:CGRectMake(MDXFrom6(45), MDXFrom6(49), KScreenWidth - MDXFrom6(60), MDXFrom6(1))]];
        }
        
        if (i != 2) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(45), 0, KScreenWidth - MDXFrom6(60), MDXFrom6(50))];
            [textField setPlaceholder:tArr[i]];
            [textField setText:self.textArr[i]];
            [textField setFont:[UIFont systemFontOfSize:15]];
            [textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
            [textField setTag:i];
            if (i==1) {
                [textField setKeyboardType:(UIKeyboardTypeNumberPad)];
            }
            [textField addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
            [backView addSubview:textField];
        }
        else{
            
            UILabel *label =[Tools creatLabel:CGRectMake(MDXFrom6(45), 0, KScreenWidth - MDXFrom6(60), MDXFrom6(50)) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:tArr[i]];
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity:)]];
            [label setTag:i];
            [backView addSubview:label];
            
            if ([self.textArr[i] length] != 0) {
                [label setTextColor:[UIColor blackColor]];
                [label setText:self.textArr[i]];
            }
            
            [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - MDXFrom6(35), MDXFrom6(20), MDXFrom6(6), MDXFrom6(10)) image:@"jilu_rili_arrow"]];
            
        }
        
        
    }
    
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(15), MDXFrom6(350), KScreenWidth - MDXFrom6(30), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"确定" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(sureSave) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
}


- (void)textValueChange:(UITextField *)textField{
    
    [self.textArr replaceObjectAtIndex:textField.tag withObject:textField.text];
}


- (void)selectCity:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
    
    
    UILabel *label = (UILabel *)sender.view;
    selectLabel = label;
    
    [self.selectCity show];
}

- (void)sureSave{
    //    @[@"请输入您的姓名",@"请输入您的电话",@"请选择您的省份",@"请选择您的城市",@"请选择您所在的区",@"请输入您的详细地址",@""]
    if ([self.textArr[0] length] == 0) {
        [ViewHelps showHUDWithText:@"请输入您的姓名"];
        return;
    }
    if ([self.textArr[1] length] == 0 || [self.textArr[1] length]>11) {
        [ViewHelps showHUDWithText:@"请输入您的电话"];
        return;
    }
    if (!provincesDic) {
        [ViewHelps showHUDWithText:@"请选择您的省份"];
        return;
    }
    if (!cityDic) {
        [ViewHelps showHUDWithText:@"请选择您的城市"];
        return;
    }
    if (!countyDic) {
        [ViewHelps showHUDWithText:@"请选择您所在的区"];
        return;
    }
    if ([self.textArr[3] length] == 0) {
        [ViewHelps showHUDWithText:@"请输入您的详细地址"];
        return;
    }
    
    NSDictionary *dic = @{@"service":@"Member.Editaddress",@"utoken":UTOKEN,@"id":self.addressID,
                          @"name":self.textArr[0],
                          @"phone":self.textArr[1],
                          @"provinceid":[provincesDic valueForKey:@"id"],
                          @"cityid":[cityDic valueForKey:@"id"],
                          @"areaid":[countyDic valueForKey:@"id"],
                          @"address":self.textArr[3],
                          @"isdefault":isdefault};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            [ViewHelps showHUDWithText:@"编辑成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark --  选择城市的view

- (SelectCity *)selectCity{
    
    if (!_selectCity) {
        
        _selectCity = [[SelectCity alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_selectCity setDelegate:self];
    }
    return _selectCity;
}

- (void)sureProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area{
    
    [selectLabel setTextColor:[UIColor blackColor]];
    [selectLabel setText:[NSString stringWithFormat:@"%@  %@ %@",province[@"name"],city[@"name"] ,area[@"name"]]];
    
    provincesDic = province;
    cityDic = city;
    countyDic = area;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
