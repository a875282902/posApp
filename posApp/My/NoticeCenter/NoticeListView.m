//
//  NoticeListView.m
//  posApp
//
//  Created by apple on 2018/7/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NoticeListView.h"
#import "NoticeListTableViewCell.h"
#import "NoticeDetailsViewController.h"

@interface NoticeListView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    NSString *_type;
}

@property (nonatomic,strong) UITableView     * tmpTableView;
@property (nonatomic,strong) NSMutableArray  * dataArr;
@end

@implementation NoticeListView

- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type{
    
    if (self == [super initWithFrame:frame]) {
        
        _page = 1;
        _type = type;
        self.dataArr = [NSMutableArray array];
        [self addSubview:self.tmpTableView];
        
        [self load];
        
    }
    return self;
}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->_page = 1;
        
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.tmpTableView.footer resetNoMoreData];
        [weakSelf pullDownRefresh];
    }];
    
    self.tmpTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self->_page ++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{
    
    NSDictionary *dic = @{@"service":@"Notice.Lists",@"utoken":UTOKEN,@"type":_type,@"p":[NSString stringWithFormat:@"%ld",_page]};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responseObject[@"data"]) {
                    [weakSelf.dataArr addObject:dict];
                }
            }else{
                
                [weakSelf.tmpTableView.footer noticeNoMoreData];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        [weakSelf.tmpTableView.header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
//上拉加载
- (void)pullUpLoadMore{
    
    NSDictionary *dic = @{@"service":@"Notice.Lists",@"utoken":UTOKEN,@"type":_type,@"p":[NSString stringWithFormat:@"%ld",_page]};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responseObject[@"data"]) {
                    [weakSelf.dataArr addObject:dict];
                }
            }else{
                
                [weakSelf.tmpTableView.footer noticeNoMoreData];
            }
            
        }
        else{
            self->_page --;
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        self->_page --;
        [weakSelf.tmpTableView.footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:(UITableViewStylePlain)];
        [_tmpTableView setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
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
    
    NoticeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeListTableViewCell"];
    if (!cell) {
        cell = [[NoticeListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"NoticeListTableViewCell"];
    }
    if (indexPath.row < self.dataArr.count) {
        
        [cell bandDataWithDic:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeDetailsViewController *vc = [[NoticeDetailsViewController alloc] init];
    vc.noticeID = self.dataArr[indexPath.row][@"id"];
    [self.delegate pushNoticeDetails:vc];
}

@end
