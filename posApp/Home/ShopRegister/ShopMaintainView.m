//
//  FriendsInfoView.m
//  posApp
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShopMaintainView.h"
#import "ShopMaintainTableViewCell.h"

static NSString *const cellID  = @"ShopMaintainTableViewCell";

@interface ShopMaintainView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView       * tmpTableView;
@property (nonatomic,strong) NSMutableArray    * dataArr;

@end

@implementation ShopMaintainView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpTableView];

//        [self load];
    }
    return self;
}

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setIndex:(NSInteger)index{
    if (index == 0) {
        [self setBackgroundColor:[UIColor blueColor]];
    }
    else{
        [self setBackgroundColor:[UIColor redColor]];
    }
    
    _index = index;
    
    [self pullDownRefresh];
}

#pragma mark -- refresh
- (void)load{
    self.tmpTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh)];
    
    self.tmpTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpLoadMore)];
    
}

- (void)pullDownRefresh{
    
    NSDictionary *dic = @{@"service":@"Shop.Shoplists",@"utoken":UTOKEN,@"type":[NSString stringWithFormat:@"%ld",self.index+1]};
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        
        if ([responseObject[@"ret"] integerValue]==200) {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                ShopModel *model = [[ShopModel alloc] initWithDictionary:dic];
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        
        [RequestSever showMsgWithError:error];
    }];
}

- (void)pullUpLoadMore{

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
    
    
    ShopMaintainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ShopMaintainTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        
    }
    if (indexPath.row <self.dataArr.count) {
    
        [cell bandDataWithShopModel:self.dataArr[indexPath.row]];
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_index == 0) {
        return 75;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.index == 0?75:0)];
    [view setBackgroundColor:[UIColor whiteColor]];
    if (_index == 0) {
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(15, 15, KScreenWidth - 30, 60)];
        [back setBackgroundColor:MDRGBA(255, 241, 218, 1)];
        [back.layer setCornerRadius:5];
        [view addSubview:back];
        [back addSubview:[Tools creatLabel:CGRectMake(10, 0, KScreenWidth - 50, 60) font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"检测到他们已经有一段时间没有进行交易了，联系商户，输入翻番，今天的你打电话了吗？"]];
    }
    
    return view;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
