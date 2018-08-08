//
//  MyViewController.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyViewController.h"

#import "NavHidden.h"
#import "PersonInfoViewController.h"


#import "OrderViewController.h"
#import "AddressViewController.h"

#import "NoticeCenterViewController.h"


static NSString * const cellID = @"myViewCell";

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UITableView *tmpTableView;
@property (nonatomic,strong)UIView      *headerView;

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:[NavHidden shareInstance].isHidden animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.tmpTableView];
    
}

- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(200))];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        
        [_headerView addSubview:[Tools creatImage:CGRectMake(0, 0, KScreenWidth, MDXFrom6(123)) image:@"profile_bg"]];
        
        UIImageView *header = [Tools creatImage:CGRectMake(0, 0, 60, 60) image:@""];
        [header setBackgroundColor:[UIColor blackColor]];
        [header.layer setCornerRadius:30];
        [header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPersonInfo)]];
        [header setCenter:CGPointMake(KScreenWidth/2, MDXFrom6(100))];
        [_headerView addSubview:header];
        
        [_headerView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(140), KScreenWidth, 20) font:[UIFont systemFontOfSize:17] color:TCOLOR alignment:(NSTextAlignmentCenter) title:@"name"]];
        
        [_headerView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(170), KScreenWidth, 20) font:[UIFont systemFontOfSize:17] color:GCOLOR alignment:(NSTextAlignmentCenter) title:@"name"]];
        
    }
    return _headerView;
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MDXFrom6(0), KScreenWidth, KScreenHeight - KTabBarHeight - MDXFrom6(0)) style:(UITableViewStyleGrouped)];
        [_tmpTableView setBackgroundColor:[UIColor whiteColor]];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableFooterView:[UIView new]];
        [_tmpTableView setTableHeaderView:self.headerView];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
    }
    
    NSArray *iArr = @[@[@"my_ico1",@"my_ico2"],
                      @[@"my_ico3",@"my_ico4",@"my_ico5"],
                      @[@"my_ico6",@"my_ico7",@"my_ico8"]];
    
    NSArray *tArr = @[@[@"订单查询",@"收货地址管理"],
                      @[@"实名认证",@"二维码名片",@"消息中心"],
                      @[@"投诉建议",@"关于我们",@"更多设置"]];
    
    [cell.textLabel setText:tArr[indexPath.section][indexPath.row]];
    [cell.textLabel setTextColor:TCOLOR];
    [cell.imageView setImage:[UIImage imageNamed:iArr[indexPath.section][indexPath.row]]];
    [cell.imageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    [cell.detailTextLabel setTextColor:GCOLOR];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell.detailTextLabel setText:@"认证成功"];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray *arr = @[@"订单",@"信息",@"设置"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    [view addSubview:[Tools creatLabel:CGRectMake(10, 0, KScreenWidth, 40) font:[UIFont systemFontOfSize:13] color:GCOLOR alignment:(NSTextAlignmentLeft) title:arr[section]]];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            OrderViewController *vc = [[OrderViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            AddressViewController *VC = [[AddressViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    
    else if (indexPath.section == 1){
        
        if (indexPath.row == 2) {
            NoticeCenterViewController *vc = [[NoticeCenterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)showPersonInfo{
    
    PersonInfoViewController *vc = [[PersonInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tmpTableView) {
        CGFloat offY = scrollView.contentOffset.y;
        if (offY < 0) {
            scrollView.contentOffset = CGPointZero;
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
