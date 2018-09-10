//
//  MyEarningsViewController.m
//  posApp
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyEarningsViewController.h"
#import "NavHidden.h"
#import "AllEarningViewController.h"
#import "TixianViewController.h"

@interface MyEarningsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView         * navView;
@property (nonatomic,strong) UITableView    * tmpTableView;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) UIView         * headerView;

@end

@implementation MyEarningsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.dataArr = [NSMutableArray array];
    
    
    [self.view addSubview:self.tmpTableView];
    
    [self getData];
}

- (void)getData{
    
    NSDictionary *dic = @{@"service":@"Member.Myshouyi",@"utoken":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            for (NSDictionary *dic in responseObject[@"data"][@"lists"]) {
                [weakSelf.dataArr addObject:dic];
            }
            
            [weakSelf setUpHeaderView:responseObject[@"data"]];
            [weakSelf setUpBanner:responseObject[@"data"]];
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

#pragma mark -- tableView 上面的
- (void)setUpBanner:(NSDictionary *)dic{
    
    [self.view addSubview:[Tools creatImage:CGRectMake(0, 0, KScreenWidth, MDXFrom6(220)) image:@"shouyi_bg"]];
    
    CGFloat height = (MDXFrom6(220) - KTopHeight-52)/3 + KTopHeight;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
//    [NSString stringWithFormat:@"本月预期收益(元)",[dateFormatter stringFromDate:[NSDate date]]]

    [self.view addSubview:[Tools creatLabel:CGRectMake(0, height, KScreenWidth, 12) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"本月预期收益(元)"]];
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, height+22, KScreenWidth, 30) font:[UIFont boldSystemFontOfSize:30] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:dic[@"shouyi"]]];
    
    [self.view addSubview:self.navView];
    
    
    UIButton *btn = [Tools creatButton:CGRectMake(KScreenWidth - 80, height, 60, 20) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"点击提现" image:@""];
    [btn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [btn.layer setBorderWidth:1];
    [btn.layer setCornerRadius:10];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(tiixan:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (void)tiixan:(UIButton *)sender{
    TixianViewController * VC = [[TixianViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (UIView *)navView{
    
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KTopHeight)];
        [_navView setBackgroundColor:MDRGBA(255, 255, 255, 0)];
        
        [_navView addSubview:[Tools creatLabel:CGRectMake(0, KStatusBarHeight, KScreenWidth , 44) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"我的收益"]];
        
        UIButton *back = [Tools creatButton:CGRectMake(MDXFrom6(10), KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"my_back"];
        [back addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:back];
        
        UIButton *share = [Tools creatButton:CGRectMake(KScreenWidth - 80, KStatusBarHeight + 2, 80, 40) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"历史收益" image:@""];
        [share addTarget:self action:@selector(checkHistoryEarning) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:share];

    }
    return _navView;
}

- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
    }
    return _headerView;
}

- (void)setUpHeaderView:(NSDictionary *)dic{
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 30, 45) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"月度收益"]];
    [self.headerView addSubview:[Tools setLineView:CGRectMake(0, 44, KScreenWidth, 1)]];
    
    CGFloat height = 60;
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(15, height,( KScreenWidth - 30)/2, 12) font:[UIFont systemFontOfSize:12] color:MDRGBA(157, 170, 192, 1) alignment:(NSTextAlignmentCenter) title:@"交易额(元)"]];
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(15 + ( KScreenWidth - 30)/2, height,( KScreenWidth - 30)/2, 12) font:[UIFont systemFontOfSize:12] color:MDRGBA(157, 170, 192, 1) alignment:(NSTextAlignmentCenter) title:@"收益(元)"]];
    
    height += 25;
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(15, height,( KScreenWidth - 30)/2, 15) font:[UIFont systemFontOfSize:15] color:MDRGBA(106, 120, 139, 1) alignment:(NSTextAlignmentCenter) title:dic[@"jiaoyie"]]];
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(15 + ( KScreenWidth - 30)/2, height,( KScreenWidth - 30)/2, 12) font:[UIFont systemFontOfSize:12] color:MDRGBA(225, 190, 36, 1) alignment:(NSTextAlignmentCenter) title:dic[@"shouyi"]]];
    
    height += 30;
    
    [self.headerView addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth, 10)]];
    
    height+= 10;
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 45) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"当月收益明细"]];
    
    [self.headerView addSubview:[Tools setLineView:CGRectMake(0, height+44, KScreenWidth, 1)]];
    
    height += 60;
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 15) font:[UIFont systemFontOfSize:15] color:MDRGBA(157, 170, 192, 1) alignment:(NSTextAlignmentLeft) title:@"类别"]];
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 15) font:[UIFont systemFontOfSize:15] color:MDRGBA(157, 170, 192, 1) alignment:(NSTextAlignmentCenter) title:@"交易额(元)"]];
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 15) font:[UIFont systemFontOfSize:15] color:MDRGBA(157, 170, 192, 1) alignment:(NSTextAlignmentRight) title:@"收益(元)"]];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MDXFrom6(220), KScreenWidth, KScreenHeight - MDXFrom6(220)) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"  MyEarningsTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MyEarningsTableViewCell"];
    }
   
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (indexPath.row < self.dataArr.count) {
        
        NSDictionary *dic = self.dataArr[indexPath.row];
        
        [cell.contentView addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth-30, 40) font:[UIFont systemFontOfSize:14] color:MDRGBA(106, 120, 139, 1) alignment:(NSTextAlignmentLeft) title:[NSString stringWithFormat:@"%ld.%@",indexPath.row,dic[@"remark"]]]];
        
        [cell.contentView addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth-30, 40) font:[UIFont systemFontOfSize:14] color:MDRGBA(106, 120, 139, 1) alignment:(NSTextAlignmentCenter) title:dic[@"dealnum"]]];
        
        [cell.contentView addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth-30, 40) font:[UIFont systemFontOfSize:14] color:MDRGBA(225, 190, 36, 1) alignment:(NSTextAlignmentRight) title:dic[@"amount"]]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

#pragma mark -- 事件
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkHistoryEarning{
    
    AllEarningViewController *vc = [[AllEarningViewController alloc] init];
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
