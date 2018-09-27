//
//  PersonInfoViewController.m
//  posApp
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PersonInfoViewController.h"

@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *headerImage;
}

@property (nonatomic,strong) UIImagePickerController * imagePickerController;
@property (nonatomic,strong) UITableView             * tmpTableView;
@property (nonatomic,strong) NSMutableArray          * dataArr;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"个人资料"];
    
    self.dataArr = [NSMutableArray array];
    
    headerImage = [Tools creatImage:CGRectMake(0, 0, 40, 40) image:@"head"];
    [headerImage.layer setCornerRadius:20];
    [headerImage setCenter:CGPointMake(KScreenWidth - 50, 57.5)];
    
    [self.view addSubview:self.tmpTableView];
    
    [self requestData];
}

- (void)requestData{
    
    NSDictionary *dic = @{@"service":@"Member.Memberinfo",@"utoken":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            NSDictionary *data = responseObject[@"data"];
            
            weakSelf.dataArr = [NSMutableArray arrayWithObjects:@[data[@"name"],data[@"phone"],[NSString stringWithFormat:@"V%@",data[@"rankid"]],data[@"zhipai"],data[@"xiapai"]],
                                 @[data[@"invitername"],data[@"inviterphone"]],
                                 @[data[@"banknumber"],data[@"bankname"]], nil];
            [self->headerImage sd_setImageWithURL:[NSURL URLWithString:data[@"headimg"]] placeholderImage:[UIImage imageNamed:@"head"]];
            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, KScreenWidth, KViewHeight) style:(UITableViewStyleGrouped)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setBackgroundColor:[UIColor whiteColor]];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableFooterView:[UIView new]];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoViewControllerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"PersonInfoViewControllerCell"];
    }
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    NSArray *tArr = @[@[@"姓名",@"手机号",@"用户等级",@"直排人数",@"下排所有人数"],@[@"推荐人",@"推荐手机号"],@[@"银行卡号",@"银行名称"]];
    
    [cell.textLabel setText:tArr[indexPath.section][indexPath.row]];
    [cell.textLabel setTextColor:MDRGBA(145, 145, 145, 1)];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",self.dataArr[indexPath.section][indexPath.row]]];
    [cell.detailTextLabel setTextColor:MDRGBA(20, 20, 20, 1)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 85;
    }
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, section==0?85:40)];
    NSArray *arr = @[@"个人信息",@"推荐人信息",@"结算信息"];
    
    [backView addSubview:[Tools creatLabel:CGRectMake(15,section==0?15:25, 200, 15) font:[UIFont systemFontOfSize:12] color:MDRGBA(210, 211, 228, 1) alignment:(NSTextAlignmentLeft) title:arr[section]]];
    
    if (section == 0) {
        
        [backView addSubview:[Tools creatLabel:CGRectMake(15,30, 200, 55) font:[UIFont systemFontOfSize:16] color:MDRGBA(145, 145, 145, 1) alignment:(NSTextAlignmentLeft) title:@"头像"]];
        
 
        [backView addSubview:headerImage];
        
        [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 23, 51, 13, 13) image:@"arrow_right"]];
        
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderImgae)]];
        
    }
    
    
    return backView;
}

- (void)changeHeaderImgae{
    
    [self chooseImageFromIphone];
}

#pragma mark -- 选择照片
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
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    

    [self upLoadImage:selectedImage];
    // 返回（结束模态对话窗体）
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)upLoadImage:(UIImage *)image{
    
    
    NSData* pictureData = UIImageJPEGRepresentation(image,0.2);//进行图片压缩从0.0到1.0（0.0表示最大压缩，质量最低);
    NSLog(@"调用了image@String方法");
    //    NSLog(@"%@这个值是什么实现的？",pictureData);
    NSString* pictureDataString = [pictureData base64Encoding];
    
    
    NSDictionary *dic = @{@"service":@"Main.Upload",@"utoken":UTOKEN,@"img":pictureDataString};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [HttpRequest POST:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [weakSelf changeHeader:responseObject[@"data"][@"url"]];
                
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

- (void)changeHeader:(NSString *)image{
    
    NSDictionary *dic = @{@"service":@"Member.Editheadimg",@"utoken":UTOKEN,@"headimg":image};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            [ViewHelps showHUDWithText:@"修改成功"];
            [self->headerImage sd_setImageWithURL:[NSURL URLWithString:image]];     
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
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
