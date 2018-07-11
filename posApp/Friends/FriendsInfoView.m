//
//  FriendsInfoView.m
//  posApp
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FriendsInfoView.h"
#import "FirendsRealTableViewCell.h"
#import "FriendsNoTableViewCell.h"

static NSString *const cellID  = @"FriendsInfoViewTableViewCell";
static NSString *const cellID1 = @"FriendsInfoViewTableViewCell1";

@interface FriendsInfoView ()<UITableViewDelegate,UITableViewDataSource,FirendsRealTableViewCellDelegate,FriendsNoTableViewCellDelegate>

@property (nonatomic,strong) UITableView    * tmpTableView;

@end

@implementation FriendsInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpTableView];
        [self load];
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    if (index == 0) {
        [self setBackgroundColor:[UIColor blueColor]];
    }
    else{
        [self setBackgroundColor:[UIColor redColor]];
    }
    
    _index = index;
    
    [self.tmpTableView reloadData];
}

#pragma mark -- refresh
- (void)load{
    self.tmpTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh:)];
    
    self.tmpTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpLoadMore:)];
    
}

- (void)pullDownRefresh:(MJRefreshNormalHeader *)header{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [header endRefreshing];
        [self.tmpTableView reloadData];
        [self.tmpTableView.footer resetNoMoreData];
    });
    
}

- (void)pullUpLoadMore:(MJRefreshAutoNormalFooter *)footer{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [footer setState:(MJRefreshStateNoMoreData)];
        [footer endRefreshing];
        [footer noticeNoMoreData];
        [self.tmpTableView reloadData];
    });
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.index == 0) {
        FirendsRealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[FirendsRealTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        
        }
        [cell setDelegate:self];
        
        return cell;
    }
    else{
        FriendsNoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell) {
            cell = [[FriendsNoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID1];
        }
        [cell setDelegate:self];
        
        return cell;
    }
                
    
}

- (void)contactUserWithCell:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tmpTableView indexPathForCell:cell];
    
    NSLog(@"%ld",indexPath.row);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_index == 0) {
        return 150;
    }
    return 110;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
