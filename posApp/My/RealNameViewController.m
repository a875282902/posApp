//
//  AddShopViewController.m
//  posApp
//
//  Created by apple on 2018/7/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RealNameViewController.h"
#import "SelectCity.h"

@interface RealNameViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,SelectCityDelegate>
{
    UIView *_selectView;//选中需要添加image 的view
    NSString *_IDPhoto_front;
    NSString *_IDPhoto_behind;
    NSString *_bankCard_front;
    NSString *_bankCard_behind;
    NSString *_IDPhoto_holder;
    NSString *_busiLicense;
    NSString *_machineCode;
    NSInteger index;//当前需要修改那张图片序号
    
    NSDictionary  * provincesDic;//保存省
    NSDictionary  * cityDic;//保存城市
    NSDictionary  * countyDic;//保存区
    UILabel       * selectLabel;//选择城市的label 为了修改文字
    

}

@property (nonatomic,strong) UIScrollView             * tmpScrollView;
@property (nonatomic,strong) NSMutableArray           * inputArr;
@property (nonatomic,strong) NSMutableArray           * photoArr;
@property (nonatomic,strong) UIImagePickerController  * imagePickerController;
@property (nonatomic,strong) SelectCity               * selectCity;

@end

@implementation RealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"实名认证"];
    
    self.inputArr = [NSMutableArray array];
    self.photoArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self setUpUI];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectCity];
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 0;
    
    height = [self creatInputView:height];
    
    height = [self creatUploadIDPhotoView:height];
    
    height = [self creatSureButtonView:height];
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
}

- (CGFloat)creatInputView:(CGFloat)height{
    
    NSArray * tArr = @[@"姓名",@"身份证号",@"银行卡号",@"开户银行",@"所在区域"];
    
    for (NSInteger i = 0; i < tArr.count ; i ++) {
        
        [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(0, height, 90, 45) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentRight) title:tArr[i]]];
        
        if (i==4) {
            UILabel *label =[Tools creatLabel:CGRectMake(105, height, KScreenWidth - 120, 45) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:tArr[i]];
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity:)]];
            [label setTag:i];
            [self.tmpScrollView addSubview:label];
            
            [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 20, height + 17.5, 10, 10) image:@"arrow_down"]];
        }
        else{
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(105, height, KScreenWidth - 120, 45)];
            [textField setFont:[UIFont systemFontOfSize:15]];
            [textField setPlaceholder:@"请输入"];
            if (i==4) {
                [textField setPlaceholder:@"请选择"];
                
            }
            [textField setTag:i];
            [textField setDelegate:self];
            [textField addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
            [textField setValue:GCOLOR forKeyPath:@"_placeholderLabel.textColor"];
            [self.tmpScrollView addSubview:textField];
            
            [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height + 44, KScreenWidth, 1)]];
            
            [self.inputArr addObject:@""];
        }
        
        height += 45;
    }
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth, 10)]];
    
    return height + 10;
}

- (CGFloat)creatUploadIDPhotoView:(CGFloat)height{
    
    for (NSInteger i = 0 ; i < 2; i ++) {
        
        height += 15;
        
        [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 15) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:i==0?@"身份证正面/反面照片":@"银行卡正面/反面照片"]];
        
        height += 35;
        
        UIImageView *frontView = [Tools creatImage:CGRectMake(30, height, (KScreenWidth/2.0 - 50), (KScreenWidth/2.0 - 50)*7/10.0) image: i==0?@"sfz_1":@"yhk_1"];
        [frontView setTag:i];
        [frontView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUploadIDPhotoFrontView:)]];
        [self.tmpScrollView addSubview:frontView];
        
        
        UIImageView *behindView = [Tools creatImage:CGRectMake(KScreenWidth/2.0 + 20, height, (KScreenWidth/2.0 - 50), (KScreenWidth/2.0 - 50)*7/10.0) image:i==0?@"sfz_2":@"yhk_2"];
        [behindView setTag:i];
        [behindView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUploadIDPhotoBehindView:)]];
        [self.tmpScrollView addSubview:behindView];
        
        
        height += (KScreenWidth/2.0 - 50)*7/10.0 + 10;
        
        [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(30, height, (KScreenWidth/2.0 - 50), 15) font:[UIFont systemFontOfSize:12] color:TCOLOR alignment:(NSTextAlignmentCenter) title:i==0?@"身份证正面":@"银行卡正面"]];
        
        [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(KScreenWidth/2.0 + 20, height, (KScreenWidth/2.0 - 50), 15) font:[UIFont systemFontOfSize:12] color:TCOLOR alignment:(NSTextAlignmentCenter) title:i==0?@"身份证反面":@"银行卡反面"]];
        
        height += 30;
        
        [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth, 10)]];
        
        height += 10;
    }
    
    return height;
}


- (CGFloat)creatSureButtonView:(CGFloat)height{
    
    height += 30;
    
    UIButton *btn = [Tools creatButton:CGRectMake(35,height, KScreenWidth - 70, 45) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"提交" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(sureInfo) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
    
    return height+65;
}


#pragma mark -- 事件
- (void)textValueChange:(UITextField *)sender{
    
    [self.inputArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 4) {
        
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)selectCity:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
    
    
    UILabel *label = (UILabel *)sender.view;
    selectLabel = label;
    
    [self.selectCity show];
}

- (void)selectUploadIDPhotoFrontView:(UITapGestureRecognizer *)sender{
    
    _selectView = sender.view;
    
    index = (sender.view.tag==0?0:2);
    
    [self chooseImageFromIphone];
    
}

- (void)selectUploadIDPhotoBehindView:(UITapGestureRecognizer *)sender{
    
    _selectView = sender.view;
    
    index = (sender.view.tag==0?1:3);
    
    [self chooseImageFromIphone];
    
}

- (void)sureInfo{
    NSArray * tArr = @[@"姓名",@"身份证号",@"银行卡号",@"开户银行",@"所在区域"];;
    for (NSInteger i = 0 ; i < self.inputArr.count ; i++) {
        if ([self.inputArr[i] length]==0 && i!=4) {
            [ViewHelps showHUDWithText:[NSString stringWithFormat:@"请输入%@",tArr[i]]];
            return;
        }
    }
    
    if (!provincesDic) {
        [ViewHelps showHUDWithText:@"请选择您的所在区域"];
        return;
    }
    if (!cityDic) {
        [ViewHelps showHUDWithText:@"请选择您的所在区域"];
        return;
    }
    if (!countyDic) {
        [ViewHelps showHUDWithText:@"请选择您的所在区域"];
        return;
    }
    
    NSArray * iArr = @[@"身份证正面照",@"身份证反面照",@"银行卡正面照",@"银行卡反面照"];
    for (NSInteger i = 0 ; i < iArr.count ; i++) {
        if ([self.photoArr[i] length]==0) {
            [ViewHelps showHUDWithText:[NSString stringWithFormat:@"请上传%@",iArr[i]]];
            return;
        }
    }
    
    NSDictionary *dic = @{@"service":@"Member.Auth",
                          @"utoken":UTOKEN,
                          @"name":self.inputArr[0],
                          @"cardnumber":self.inputArr[1],
                          @"banknumber":self.inputArr[2],
                          @"bankname":self.inputArr[3],
                          @"provinceid":[provincesDic valueForKey:@"id"],
                          @"cityid":[cityDic valueForKey:@"id"],
                          @"areaid":[countyDic valueForKey:@"id"],
                          @"card1":self.photoArr[0],
                          @"card2":self.photoArr[1],
                          @"bank1":self.photoArr[2],
                          @"bank2":self.photoArr[3]};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            [ViewHelps showHUDWithText:@"认证成功"];
            [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark --  上传照片
- (void)chooseImageFromIphone{
    
    // 判断有没有访问相册的权限
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        NSLog(@"没有访问相册的权限");
        return;
        
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        
        [self creatAlertViewControllerWithMessage:@"2"];
    }
    else{
        
        [self creatAlertViewControllerWithMessage:@"1"];
    }
    
    
    
}

- (void)creatAlertViewControllerWithMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *trueA = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        
        [self.imagePickerController setDelegate:self];
        // 设置来自相册
        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        // 设置允许编辑
        [self.imagePickerController setAllowsEditing:YES];
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *trueB = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        
        [self.imagePickerController setDelegate:self];
        // 设置来自相机
        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        // 设置允许编辑
        [self.imagePickerController setAllowsEditing:YES];
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *falseA = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    if ([message isEqualToString:@"2"]) {
        
        [alert addAction:trueB];
    }
    
    [alert addAction:trueA];
    [alert addAction:falseA];
    [self presentViewController:alert animated:YES completion:nil];
    
}

// 选择图片的回调
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 图片类型是修改后的图片
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 返回（结束模态对话窗体）
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self upLoadImage:selectedImage];
    }];
    
    
}


- (void)upLoadImage:(UIImage *)image{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData* pictureData = UIImageJPEGRepresentation(image,1);//进行图片压缩从0.0到1.0（0.0表示最大压缩，质量最低);
    NSLog(@"调用了image@String方法");
    //    NSLog(@"%@这个值是什么实现的？",pictureData);
    NSString* pictureDataString = [pictureData base64Encoding];
    
    NSDictionary *dic = @{@"service":@"Main.Upload",@"utoken":UTOKEN,@"img":pictureDataString};
    
    __weak typeof(self) weakSelf = self;
    [HttpRequest POST:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [weakSelf.photoArr replaceObjectAtIndex:self->index withObject:responseObject[@"data"][@"url"]];
                
                [weakSelf showUploadSuccessImage];
                
            }else{
                [ViewHelps showHUDWithText:@"加载失败，请重新选择图片"];
            }
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

- (void)showUploadSuccessImage{
    
    if ([_selectView isKindOfClass:[UIImageView class]]) {
        [(UIImageView *)_selectView sd_setImageWithURL:[NSURL URLWithString:self.photoArr[index]]];
    }
    else{
        if ([_selectView.subviews count]>1) {
            [_selectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            [_selectView addSubview:[Tools creatImage:CGRectMake(0, 0, _selectView.frame.size.width, _selectView.frame.size.height) url:self.photoArr[index] image:@""]];
            
        }
        else if ([_selectView.subviews count] == 1){
            
            __block typeof(self) weakSelf = self;
            
            [_selectView.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[UIImageView class]]) {
                    [obj sd_setImageWithURL:[NSURL URLWithString:weakSelf.photoArr[self->index]]];
                }
                
            }];
        }
    }
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
