//
//  AddressListViewController.m
//  posApp
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressListTableViewCell.h"

@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tmpTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"地址"];
    self.dataArr = [NSMutableArray array];
    [self.view addSubview:self.tmpTableView];
    
    [self load];
    [self pullDownRefresh];
}


#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.dataArr removeAllObjects];
      
        [weakSelf pullDownRefresh];
    }];
    
    
}
//下拉刷新
- (void)pullDownRefresh{
    
    NSDictionary *dic = @{@"service":@"Member.Addresslists",@"utoken":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            weakSelf.dataArr = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        
            [weakSelf.tmpTableView.header endRefreshing];
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
    
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressListTableViewCell"];
    if (!cell) {
        cell = [[AddressListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"AddressListTableViewCell"];
    }
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    if (indexPath.row < self.dataArr.count) {
    
        [cell bandDataWithDictionary:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectAddress(self.dataArr[indexPath.row]);
    
    [self.navigationController popViewControllerAnimated:YES];
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
