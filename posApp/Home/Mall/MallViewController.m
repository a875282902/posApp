//
//  MallViewController.m
//  posApp
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MallViewController.h"
#import "MallModel.h"
#import "MallCollectionViewCell.h"
#import "MallDetailsViewController.h"

static NSString *const size = @"10";

@interface MallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * tmpCollectionView;
@property (nonatomic,strong) NSMutableArray   * dataArr;
@property (nonatomic,assign) NSInteger          page;

@end

@implementation MallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"商城列表"];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self.view addSubview:self.tmpCollectionView];
    
    [self load];
    
    [self pullDownRefresh];
}


#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.tmpCollectionView.footer resetNoMoreData];
        [weakSelf pullDownRefresh];
    }];
    
    self.tmpCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{
    
    NSDictionary *dic = @{@"service":@"Good.Lists",@"utoken":UTOKEN,@"p":[NSString stringWithFormat:@"%ld",self.page],@"size":size};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        [weakSelf.dataArr removeAllObjects];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    MallModel *model = [[MallModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        [weakSelf.tmpCollectionView reloadData];
        [weakSelf.tmpCollectionView.header endRefreshing];
        
        if (weakSelf.dataArr.count < weakSelf.page * [size integerValue]) {
            [weakSelf.tmpCollectionView.footer noticeNoMoreData];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
        [weakSelf.tmpCollectionView.header endRefreshing];
    }];
}
//上拉加载
- (void)pullUpLoadMore{
    
    NSDictionary *dic = @{@"service":@"Good.Lists",@"utoken":UTOKEN,@"p":[NSString stringWithFormat:@"%ld",self.page],@"size":size};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {

        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    MallModel *model = [[MallModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        [weakSelf.tmpCollectionView reloadData];
        [weakSelf.tmpCollectionView.footer endRefreshing];
        
        if (weakSelf.dataArr.count < weakSelf.page * [size integerValue]) {
            [weakSelf.tmpCollectionView.footer noticeNoMoreData];
        }
        
    } failure:^(NSError *error) {
        weakSelf.page -- ;
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
        [weakSelf.tmpCollectionView.footer endRefreshing];
    }];
}

#pragma mark -tmpCollectionView
-(UICollectionView *)tmpCollectionView{
    
    if (!_tmpCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(MDXFrom6(167), MDXFrom6(230))];
        [layout setSectionInset:UIEdgeInsetsMake(MDXFrom6(5), MDXFrom6(10), MDXFrom6(5), MDXFrom6(10))];
        [layout setMinimumLineSpacing:10];
        _tmpCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight) collectionViewLayout:layout];
        [_tmpCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_tmpCollectionView setDelegate:self];
        [_tmpCollectionView setDataSource:self];
        [_tmpCollectionView registerClass:[MallCollectionViewCell class] forCellWithReuseIdentifier:@"MallCollectionViewCell"];
    }
    return _tmpCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallCollectionViewCell" forIndexPath:indexPath];
    [cell bandDataWithModel:self.dataArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MallModel *model = self.dataArr[indexPath.row];
    
    MallDetailsViewController *VC = [[MallDetailsViewController alloc] init];
    VC.goodsID = model.ID;
    [self.navigationController pushViewController:VC animated:YES];
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
