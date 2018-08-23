//
//  MyEarningsViewController.m
//  posApp
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AllEarningViewController.h"

@interface AllEarningViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView         * navView;
@property (nonatomic,strong) UITableView    * tmpTableView;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) UIView         * headerView;

@end

@implementation AllEarningViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArr = [NSMutableArray array];
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"历史收益"];
    [self.view addSubview:self.tmpTableView];
    
    [self getData];
}

- (void)getData{
    
    NSDictionary *dic = @{@"service":@"Member.Lishishouyi",@"utoken":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            for (NSDictionary *dic in responseObject[@"data"][@"lists"]) {
                [weakSelf.dataArr addObject:dic];
            }

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
    
    
    CGFloat height = 25;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    //    [NSString stringWithFormat:@"本月预期收益(元)",[dateFormatter stringFromDate:[NSDate date]]]
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, height, KScreenWidth, 12) font:[UIFont systemFontOfSize:12] color:MDRGBA(157, 170, 192, 1) alignment:(NSTextAlignmentCenter) title:@"累计收益(元)"]];
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, height+25, KScreenWidth, 25) font:[UIFont boldSystemFontOfSize:20] color:MDRGBA(255, 197, 65, 1) alignment:(NSTextAlignmentCenter) title:dic[@"shouyi"]]];
    
    height += 70;
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth , 10)]];
    
    height += 25;
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 15) font:[UIFont systemFontOfSize:15] color:MDRGBA(157, 170, 192, 1) alignment:(NSTextAlignmentLeft) title:@"类别"]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 15) font:[UIFont systemFontOfSize:15] color:MDRGBA(157, 170, 192, 1) alignment:(NSTextAlignmentCenter) title:@"交易额(元)"]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 15) font:[UIFont systemFontOfSize:15] color:MDRGBA(157, 170, 192, 1) alignment:(NSTextAlignmentRight) title:@"收益(元)"]];

    
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, KScreenWidth, KViewHeight -140) style:(UITableViewStylePlain)];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"  AllEarningViewController"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"AllEarningViewController"];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (indexPath.row < self.dataArr.count) {
        
        NSDictionary *dic = self.dataArr[indexPath.row];
        
        [cell.contentView addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth-30, 40) font:[UIFont systemFontOfSize:14] color:MDRGBA(106, 120, 139, 1) alignment:(NSTextAlignmentLeft) title:[NSString stringWithFormat:@"%ld.%@",indexPath.row,dic[@"month"]]]];
        
        [cell.contentView addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth-30, 40) font:[UIFont systemFontOfSize:14] color:MDRGBA(106, 120, 139, 1) alignment:(NSTextAlignmentCenter) title:dic[@"jiaoyie"]]];
        
        [cell.contentView addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth-30, 40) font:[UIFont systemFontOfSize:14] color:MDRGBA(255, 197, 65, 1) alignment:(NSTextAlignmentRight) title:dic[@"shouyi"]]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}


#pragma mark -- 事件
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkHistoryEarning{
    
    
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
