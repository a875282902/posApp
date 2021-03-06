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
@property (nonatomic,strong) NSArray *dataArr;

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
    
    [self.tmpTableView.header beginRefreshing];
}

#pragma mark -- refresh
- (void)load{
    self.tmpTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh:)];
    
}

- (void)pullDownRefresh:(MJRefreshNormalHeader *)header{
    
    NSDictionary *dic = @{@"service":@"Member.Mengyou",@"utoken":UTOKEN,@"status":[NSString stringWithFormat:@"%ld",2-_index]};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            weakSelf.dataArr = responseObject[@"data"];
            
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
    
//    if (self.index == 0) {
        FirendsRealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[FirendsRealTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        
        }
        [cell setDelegate:self];
        [cell bandDataWithDictionary:self.dataArr[indexPath.row]];
        return cell;
//    }
//    else{
//        FriendsNoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
//        if (!cell) {
//            cell = [[FriendsNoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID1];
//        }
//        [cell setDelegate:self];
//
//        return cell;
//    }
//
    
}

- (void)contactUserWithCell:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tmpTableView indexPathForCell:cell];
    
    NSLog(@"%ld",indexPath.row);
    
    [self callPhone:self.dataArr[indexPath.row][@"phone"]];
}

-(void)callPhone:(NSString *)phoneNumber{
    
    NSString *cleanedString =[[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str_url = [[NSString alloc]initWithFormat:@"tel://%@", escapedPhoneNumber];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:str_url, escapedPhoneNumber]];
    UIWebView *mCallWebview = [[UIWebView alloc] init] ;
    [self addSubview:mCallWebview];
    [mCallWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_index == 0) {
        return 150;
    }
    return 150;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
