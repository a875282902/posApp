//
//  MallDetailsViewController.m
//  posApp
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MallDetailsViewController.h"
#import "PayViewController.h"

#import "OrderViewController.h"

@interface MallDetailsViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *tmpScrollView;

@property (nonatomic,strong) NSMutableDictionary * goodsInfo;

@end

@implementation MallDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self baseForDefaultLeftNavButton];
    [self setTitle:@"产品详情"];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self getGoodsData];
    
    [self createButton];
}

- (void)getGoodsData{
    
    NSDictionary *dic = @{@"service":@"Good.Info",@"utoken":UTOKEN,@"id":self.goodsID};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            weakSelf.goodsInfo = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
        [weakSelf setUpUI];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight - 50)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 0;
    
    [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(0, 0, KScreenWidth, KScreenWidth) url:self.goodsInfo[@"thumb"] image:@""]];
    
    height += KScreenWidth +10;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:17] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.goodsInfo[@"name"]]];
    
    height += 60;
    
    NSString *price = [NSString stringWithFormat:@"￥%@",self.goodsInfo[@"price"]];
    NSString *num = [NSString stringWithFormat:@"数量：%@",self.goodsInfo[@"stocknum"]];
    NSString *str = [NSString stringWithFormat:@"%@    %@",price,num];
    
    NSMutableAttributedString *attS = [[NSMutableAttributedString alloc] initWithString:str];
    [attS addAttribute:NSForegroundColorAttributeName value:GCOLOR range:NSMakeRange(str.length - num.length, num.length)];
    
    UILabel *textLabel = [Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 20) font:[UIFont systemFontOfSize:15] color:[UIColor redColor] alignment:(NSTextAlignmentLeft) title:@""];
    [textLabel setAttributedText:attS];
    [self.tmpScrollView addSubview:textLabel];
    
    height += 30;
    
    UILabel *fahuoLabel = [Tools creatLabel:CGRectMake(15, height, 65, 20) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"当天发货"];
    [fahuoLabel.layer setCornerRadius:10];
    [fahuoLabel setBackgroundColor:OCOLOR];
    [self.tmpScrollView addSubview:fahuoLabel];
    
    UILabel *freeLabel = [Tools creatLabel:CGRectMake(90, height, 55, 20) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"免运费"];
    [freeLabel.layer setCornerRadius:10];
    [freeLabel setBackgroundColor:MDRGBA(0, 206, 171, 1)];
    [self.tmpScrollView addSubview:freeLabel];
    
    height += 30;
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
}

- (void)createButton{
    
    
    UIButton *btn = [Tools creatButton:CGRectMake(0, KViewHeight - 50, KScreenWidth/2, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"我的订单" image:@""];
    [btn setBackgroundColor:OCOLOR];
    [btn addTarget:self action:@selector(checkMyOrder) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 = [Tools creatButton:CGRectMake(KScreenWidth/2, KViewHeight - 50, KScreenWidth/2, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"交纳定金" image:@""];
    [btn1 setBackgroundColor:MDRGBA(255, 60, 17, 1)];
    [btn1 addTarget:self action:@selector(payDeposit) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn1];
    
    
    
}

- (void)checkMyOrder{
    
    OrderViewController *vc = [[OrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)payDeposit{
    
    PayViewController *vc = [[PayViewController alloc] init];
    vc.goodsDic = self.goodsInfo;
    [self.navigationController pushViewController:vc animated:YES];
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
