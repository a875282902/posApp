//
//  ShopRegisterViewController.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShopRegisterViewController.h"
#import "ShopRegisterTableViewCell.h"
#import "ShopModel.h"
#import "AddShopViewController.h"

#import "EditShopViewController.h"

static NSString * const cellID = @"ShopRegisterTableViewCell";

@interface ShopRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,ShopRegisterTableViewCellDelegate>

@property (nonatomic,strong)UITableView    * tmpTableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation ShopRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"资料登记"];
    [self baseForDefaultLeftNavButton];
    
    self.dataArr = [NSMutableArray array];
    
    [self setNavigationRightBarButtonWithImageNamed:@"dengji-1"];
    
    [self.view addSubview:self.tmpTableView];
    
    [self getShopListsData];
    
}

- (void)getShopListsData{

    NSDictionary *dic = @{@"service":@"Shop.Shoplists",@"utoken":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                
                [weakSelf.dataArr removeAllObjects];
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    ShopModel *model = [[ShopModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
                [weakSelf.tmpTableView reloadData];
            }
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
    
    ShopRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ShopRegisterTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    
    [cell setDelegate:self];
    
    if (indexPath.row < self.dataArr.count) {
        [cell bandDataWithShopModel:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 170;
}

- (void)rightButtonTouchUpInside:(id)sender{
    
    AddShopViewController *VC = [[AddShopViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)editAddressWithCell:(ShopRegisterTableViewCell *)cell{
    
    NSIndexPath *index = [self.tmpTableView indexPathForCell:cell];
    ShopModel *model = self.dataArr[index.row];
    EditShopViewController *VC = [[EditShopViewController alloc] init];
    VC.shop_id = model.ID;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)copeAddressWithCell:(ShopRegisterTableViewCell *)cell{
    
    
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
