//
//  ComplaintsViewController.m
//  posApp
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ComplaintsViewController.h"

@interface ComplaintsViewController ()<UITextViewDelegate>
{
    UILabel *_placeholdLabel;
    NSString *_content;
}

@end

@implementation ComplaintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"投诉和建议"];
    
    [self.view setBackgroundColor:MDRGBA(246, 246, 246, 1)];
    
    [self setUpInputView];
}


- (void)setUpInputView{
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 20, KScreenWidth - 30,200)];
    [textView setDelegate:self];
    [textView setFont:[UIFont systemFontOfSize:16]];
    [textView setTextColor:[UIColor blackColor]];
    [self.view addSubview:textView];
    
    _placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 9 , KScreenWidth, 16)];
    [_placeholdLabel setTextColor:[UIColor colorWithHexString:@"#666666"]];
    [_placeholdLabel setText:@"请输入您的反馈意见"];
    [_placeholdLabel setFont:[UIFont systemFontOfSize:16]];
    [textView addSubview:_placeholdLabel];
    
    UIButton *btn = [Tools creatButton:CGRectMake(15, 240, KScreenWidth - 30, 45) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"提交" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(advice) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length == 0) {
        [_placeholdLabel setHidden:NO];
    }
    else{
        [_placeholdLabel setHidden:YES];
    }
 
    _content = textView.text;
}

- (void)advice{
    
    if (_content.length == 0) {
        
        [ViewHelps showHUDWithText:@"请输入您的反馈意见"];
        return;
    }
    
    NSDictionary *dic = @{@"service":@"Main.Advice",@"utoken":UTOKEN,@"content":_content};
    
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
