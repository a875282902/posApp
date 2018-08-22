//
//  ChangeBankViewController.m
//  posApp
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ChangeBankViewController.h"

@interface ChangeBankViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *inputArr;

@end

@implementation ChangeBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    [self setTitle:@"更换结算卡"];
    
    self.inputArr = [NSMutableArray array];
    
    CGFloat height = [self creatInputView:0];
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(35),height+25, KScreenWidth - MDXFrom6(70), MDXFrom6(45)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"提交" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(editbank) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
}

- (CGFloat)creatInputView:(CGFloat)height{
    
    NSArray * tArr = @[@"姓名",@"银行卡号",@"开户银行"];
    
    for (NSInteger i = 0; i < 3 ; i ++) {
        
        [self.view addSubview:[Tools creatLabel:CGRectMake(0, height, 90, 45) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentRight) title:tArr[i]]];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(105, height, KScreenWidth - 120, 45)];
        [textField setFont:[UIFont systemFontOfSize:15]];
        [textField setPlaceholder:@"请输入"];
        if (i==0) {
            [textField setText:[[NSUserDefaults standardUserDefaults]valueForKey:@"name"]];
        }
        [textField setTag:i];
        [textField setDelegate:self];
        [textField addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        [textField setValue:GCOLOR forKeyPath:@"_placeholderLabel.textColor"];
        [self.view addSubview:textField];
        
        [self.view addSubview:[Tools setLineView:CGRectMake(0, height + 44, KScreenWidth, 1)]];
        
        [self.inputArr addObject:@""];
        
        height += 45;
    }
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth, 10)]];
    
    return height + 10;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 0) {
        
        return NO;
    }
    
    return YES;
}

- (void)textValueChange:(UITextField *)sender{
    
    [self.inputArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}

- (void)editbank{
    
    if ([self.inputArr[1] length]==0) {
        [ViewHelps showHUDWithText:@"请输入银行卡号"];
        return;
    }
    if ([self.inputArr[2] length]==0) {
        [ViewHelps showHUDWithText:@"请输入银行名称"];
        return;
    }
    
    NSDictionary *dic = @{@"service":@"Member.Editbank",@"utoken":UTOKEN,@"banknumber":self.inputArr[1],@"bankname":self.inputArr[2]};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            [ViewHelps showHUDWithText:@"提交成功"];
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
