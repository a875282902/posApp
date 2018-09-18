//
//  FriendsInfoView.m
//  posApp
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HistoryInfoView.h"
#import "HistioryResultTableViewCell.h"

static NSString *const cellID  = @"HistoryInfoViewTableViewCell";
static NSString *const cellID1 = @"HistoryInfoViewTableViewCell1";

@interface HistoryInfoView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    * tmpTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) NSInteger  page;

@end

@implementation HistoryInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpTableView];
        self.dataArr = [NSMutableArray array];
        [self load];
    }
    return self;
}

- (void)setIndex:(NSInteger)index{

    _index = index;
    
    [self.tmpTableView.header beginRefreshing];
}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.dataArr removeAllObjects];
        
        [weakSelf pullDownRefresh];
    }];
    
    self.tmpTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{
    NSDictionary *dic = @{@"service":@"Member.Yeji",@"utoken":UTOKEN,@"p":[NSString stringWithFormat:@"%ld",self.page],@"type":self.index==0?@"2":@"1"};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            for (NSDictionary *dic  in responseObject[@"data"][@"data"]) {
                [weakSelf.dataArr addObject:dic];
            }
            
            [weakSelf.tmpTableView.header endRefreshing];
            [weakSelf.tmpTableView reloadData];
        }
        else{
            [weakSelf.tmpTableView.header endRefreshing];
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tmpTableView.header endRefreshing];
        
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
//上拉加载
- (void)pullUpLoadMore{
    NSDictionary *dic = @{@"service":@"Member.Yeji",@"utoken":UTOKEN,@"p":[NSString stringWithFormat:@"%ld",self.page],@"type":self.index==0?@"2":@"1"};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            for (NSDictionary *dic  in responseObject[@"data"][@"data"]) {
                [weakSelf.dataArr addObject:dic];
            }
            
            [weakSelf.tmpTableView.footer endRefreshing];
            [weakSelf.tmpTableView reloadData];
        }
        else{
            [weakSelf.tmpTableView.footer endRefreshing];
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tmpTableView.footer endRefreshing];
        weakSelf.page --;
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}


#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.frame.size.height) style:(UITableViewStylePlain)];
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
    
    HistioryResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HistioryResultTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        
    }
    [cell bandDataWithDictionary:self.dataArr[indexPath.row]];
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
