//
//  BusinessViewController.m
//  posApp
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BusinessViewController.h"
#import "BusinessModel.h"
#import "BusinessTableViewCell.h"
#import "BusinessDetailsViewController.h"

static NSString *const size = @"10";

@interface BusinessViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UITableView    *tmpTableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)NSInteger       page;


@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"辅助资料"];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self.view addSubview:self.tmpTableView];
    [self load];
    
    [self pullDownRefresh];
}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.tmpTableView.footer resetNoMoreData];
        [weakSelf pullDownRefresh];
    }];
    
    self.tmpTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{
    
    NSDictionary *dic = @{@"service":@"Yewu.Lists",@"utoken":UTOKEN,@"p":[NSString stringWithFormat:@"%ld",self.page],@"size":size};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        [weakSelf.dataArr removeAllObjects];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    BusinessModel *model = [[BusinessModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.header endRefreshing];
        
        if (weakSelf.dataArr.count < weakSelf.page * [size integerValue]) {
            [weakSelf.tmpTableView.footer noticeNoMoreData];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
        [weakSelf.tmpTableView.header endRefreshing];
    }];
}
//上拉加载
- (void)pullUpLoadMore{
    
    NSDictionary *dic = @{@"service":@"Yewu.Lists",@"utoken":UTOKEN,@"p":[NSString stringWithFormat:@"%ld",self.page],@"size":size};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    BusinessModel *model = [[BusinessModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.footer endRefreshing];
        
        if (weakSelf.dataArr.count < weakSelf.page * [size integerValue]) {
            [weakSelf.tmpTableView.footer noticeNoMoreData];
        }
        
    } failure:^(NSError *error) {
        weakSelf.page -- ;
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
        [weakSelf.tmpTableView.footer endRefreshing];
    }];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight) style:(UITableViewStylePlain)];
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
    
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessTableViewCell"];
    if (!cell) {
        cell = [[BusinessTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"BusinessTableViewCell"];
    }
    if (indexPath.row < self.dataArr.count) {
    
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BusinessModel *model = self.dataArr[indexPath.row];
    
    BusinessDetailsViewController *vc = [[BusinessDetailsViewController alloc] init];
    vc.businessID = model.ID;
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
