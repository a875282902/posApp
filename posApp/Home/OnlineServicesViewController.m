//
//  OnlineServicesViewController.m
//  posApp
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OnlineServicesViewController.h"
#import "IQKeyboardManager.h"
#import "QuestDetailsViewController.h"

#define BColor [UIColor colorWithHexString:@"#f5f5f5"]

@interface OnlineServicesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_questionText;
}

@property (nonatomic,strong)UITableView *tmpTableView;
@property (nonatomic,strong)NSMutableArray *sectionArr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UIView         *inputView;
@property (nonatomic,strong)UIView         *headerView;


@end

@implementation OnlineServicesViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //点击背景收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f5f5f5"]];
    
    [self baseForDefaultLeftNavButton];
    
    [self setTitle:@"在线客服"];
    
    self.sectionArr = [NSMutableArray array];
    
    self.dataArr = [NSMutableArray array];

    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:self.inputView];
    
    [self getHotQuest];
}

- (void)getHotQuest{

    NSDictionary *dic = @{@"service":@"Main.Questions",@"utoken":UTOKEN,@"ishot":@"1"};

    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            [self setUpHeaderView:responseObject[@"data"]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
        [_headerView setBackgroundColor:BColor];
    }
    return _headerView;
}

- (void)setUpHeaderView:(NSArray *)arr{
    
    [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.headerView setFrame:CGRectMake(0, 0, KScreenWidth, (arr.count +2)*50+40)];
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 40, (arr.count +2)*50)];
    [back.layer setCornerRadius:20];
    [back setClipsToBounds:YES];
    [back setBackgroundColor:[UIColor whiteColor]];
    [self.headerView addSubview:back];
    
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-40, 50)];
    [tView setBackgroundColor:[UIColor colorWithHexString:@"#00c6ff"]];
    [tView addSubview:[Tools creatLabel:CGRectMake(0, 0, KScreenWidth - 40, 50) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"热门问题"]];
    [back addSubview:tView];

    for (NSInteger i = 0 ; i < arr.count ; i ++) {
        
        NSDictionary *dic = arr[i];
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0,50+ 50*i, KScreenWidth - 40, 50)];
        [backView addSubview:[Tools creatLabel:CGRectMake(10, 0, KScreenWidth - 80, 50) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:dic[@"title"]]];
        [backView addSubview:[Tools setLineView:CGRectMake(0, 50, KScreenWidth-40, 1)]];
        [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 40 - 30, 17.5, 15, 15) image:@"arrow_right"]];
        [backView setTag:[dic[@"id"] integerValue]];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHotAnswer:)]];
        [back addSubview:backView];
    }
    
    UIButton *btn = [Tools creatButton:CGRectMake(0, (arr.count+1)*50, KScreenWidth - 40, 50) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] title:@" 换一批" image:@"shauxin"];
    [btn addTarget:self action:@selector(reloadHotQuest) forControlEvents:(UIControlEventTouchUpInside)];
    [back addSubview:btn];
    
    
}

- (void)showHotAnswer:(UITapGestureRecognizer *)sender{
    
    QuestDetailsViewController *vc = [[QuestDetailsViewController alloc] init];
    vc.questID =[NSString stringWithFormat:@"%ld",sender.view.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadHotQuest{
    [self getHotQuest];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight - 50) style:(UITableViewStyleGrouped)];
        [_tmpTableView setBackgroundColor:BColor];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setTableHeaderView:self.headerView];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnlineServicesViewController"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"OnlineServicesViewController"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [cell.contentView setBackgroundColor:BColor];
    
    CGFloat height = [self.sectionArr[indexPath.section][@"cellheight"] floatValue];
    
    NSArray * arr = self.dataArr[indexPath.section];
    if (arr.count == 0) {
        [cell.contentView addSubview:[Tools creatLabel:CGRectMake(20, 0, KScreenWidth - 40, 50) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"换个问题试试~~暂未找到相关问题"]];
    }
    else{
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, height)];
        
        [back setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:back];
        
        //绘制圆角 要设置的圆角 使用“|”来组合
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:back.bounds byRoundingCorners:UIRectCornerTopRight| UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 20)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        //设置大小
        maskLayer.frame = back.bounds;
        
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        back.layer.mask = maskLayer;
        
        for (NSInteger i = 0 ; i < arr.count ; i ++) {
            
            NSDictionary *dic = arr[i];
            
            UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*i, KScreenWidth - 40, 50)];
            [backView addSubview:[Tools creatLabel:CGRectMake(10, 0, KScreenWidth - 80, 50) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:dic[@"title"]]];
            [backView addSubview:[Tools setLineView:CGRectMake(0, 50, KScreenWidth-40, 1)]];
            [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 40 - 30, 17.5, 15, 15) image:@"arrow_right"]];
            [backView setTag:indexPath.section*100+i];
            [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAnswer:)]];
            [back addSubview:backView];
            
        }
    
    }
    
    
    return cell;
}

- (void)showAnswer:(UITapGestureRecognizer *)sender{
    
    NSInteger n = sender.view.tag/100;
    NSInteger l = sender.view.tag%100;
    
    NSDictionary *dic = self.dataArr[n][l];

    
    QuestDetailsViewController *vc = [[QuestDetailsViewController alloc] init];
    vc.questID = dic[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.sectionArr[indexPath.section][@"cellheight"] floatValue];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [self.sectionArr[section][@"height"] floatValue]+40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *question = self.sectionArr[section][@"title"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, [self.sectionArr[section][@"height"] floatValue]+40)];
    
    
    UIView *backView = [[UIView alloc] init];
    [backView setBackgroundColor:[UIColor colorWithHexString:@"#00c6ff"]];
    [backView setClipsToBounds:YES];
    [view addSubview:backView];
    
    CGFloat wid = KHeight(question, 100000, 14, 14).size.width;
    CGFloat height = KHeight(question, KScreenWidth - 60, 100000, 14).size.height;
    
    if (wid < KScreenWidth - 60) {
        
        [backView setFrame:CGRectMake(KScreenWidth - wid - 40, 20, wid+20, 40)];
        [backView addSubview:[Tools creatLabel:CGRectMake(10, 13, wid, 14) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] alignment:(NSTextAlignmentLeft) title:question]];
        
        
    }
    else{
        
        [backView setFrame:CGRectMake(20, 20, KScreenWidth - 40, height+26)];
        [backView addSubview:[Tools creatLabel:CGRectMake(10, 13, KScreenWidth - 60, height) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] alignment:(NSTextAlignmentLeft) title:question]];
        
    }
    
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 20)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    //设置大小
    maskLayer.frame = backView.bounds;
    
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    backView.layer.mask = maskLayer;
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}


- (void)keyboardWasShown:(NSNotification *)aNotification{
    
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:.2 animations:^{
        [self.inputView setFrame:CGRectMake(0,KViewHeight- keyBoardFrame.size.height - 50 , KScreenWidth, 50)];
    }];
}
-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
    [UIView animateWithDuration:.2 animations:^{
        [self.inputView setFrame:CGRectMake(0,KViewHeight - 50 , KScreenWidth, 50)];
    }];
    
}

- (UIView *)inputView{
    
    if (!_inputView) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, KViewHeight - 50, KScreenWidth , 50)];
        [_inputView setBackgroundColor:BColor];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(20, 8, KScreenWidth - 40, 34)];
        [back setBackgroundColor:[UIColor whiteColor]];
        [back.layer setCornerRadius:17];
        [_inputView addSubview:back];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth - 80-40, 34)];
        [textField setPlaceholder:@"请输入你要咨询的问题"];
        [textField setFont:[UIFont systemFontOfSize:14]];
        [back addSubview:textField];
        
        _questionText = textField;
        
        UIImageView * fasong = [Tools creatImage:CGRectMake(KScreenWidth - 40 - 34, 0, 34, 34) image:@"fasong"];
        [fasong addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fasong)]];
        [back addSubview:fasong];
    }
    
    return _inputView;
}


- (void)fasong{
    [self.view endEditing:YES];
    if (_questionText.text.length == 0) {
        [ViewHelps showHUDWithText:@"请输入问题"];
        return;
    }

    NSDictionary *dic = @{@"service":@"Main.Questions",@"utoken":UTOKEN,@"keywords":_questionText.text};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            NSArray *arr = responseObject[@"data"];
            
            [weakSelf.dataArr addObject:responseObject[@"data"]];
            
            CGFloat height = KHeight(self->_questionText.text, KScreenWidth - 60, 100000, 14).size.height+26;
            [weakSelf.sectionArr addObject:@{@"height":[NSString stringWithFormat:@"%f",height],@"title":self->_questionText.text,@"cellheight":arr.count==0?@"50":[NSString stringWithFormat:@"%ld",50*arr.count]}];
            
            [weakSelf.tmpTableView reloadData];
            
            
            
            [weakSelf.tmpTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:weakSelf.sectionArr.count-1] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
            
            [self->_questionText setText:@""];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
            
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
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
