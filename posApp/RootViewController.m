//
//  RootViewController.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"
#import "BaseNaviViewController.h"
#import "HomeViewController.h"
#import "FriendsViewController.h"
#import "ResultsViewController.h"
#import "MyViewController.h"

#import "NavHidden.h"

#define BCOLOR [UIColor colorWithHexString:@"#1c83d4"]

@interface RootViewController ()<UITabBarControllerDelegate,UITabBarDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //首页
    HomeViewController *home = [[HomeViewController alloc] init];
    BaseNaviViewController *navHome = [[BaseNaviViewController alloc] initWithRootViewController:home];
    [navHome.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_ico1"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    [navHome.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_ico1_selected"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    [navHome.tabBarItem setTitle:@"首页"];
    [navHome.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:BCOLOR} forState:UIControlStateSelected];
    
    //业绩
    ResultsViewController *results = [[ResultsViewController alloc] init];
    BaseNaviViewController *resultsHome = [[BaseNaviViewController alloc] initWithRootViewController:results];
    [resultsHome.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_ico2"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    [resultsHome.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_ico2_selected"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    [resultsHome.tabBarItem setTitle:@"业绩"];
    [resultsHome.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:BCOLOR} forState:UIControlStateSelected];
    
    //盟友
    FriendsViewController *friend = [[FriendsViewController alloc] init];
    BaseNaviViewController *friendHome = [[BaseNaviViewController alloc] initWithRootViewController:friend];
    [friendHome.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_ico3"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    [friendHome.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_ico3_selected"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    [friendHome.tabBarItem setTitle:@"盟友"];
    [friendHome.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:BCOLOR} forState:UIControlStateSelected];
    
    //我的
    MyViewController *my = [[MyViewController alloc] init];
    BaseNaviViewController *myHome = [[BaseNaviViewController alloc] initWithRootViewController:my];
    [myHome.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_ico4"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    [myHome.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_ico4_selected"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    [myHome.tabBarItem setTitle:@"我的"];
    [myHome.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:BCOLOR} forState:UIControlStateSelected];
    
    [self setViewControllers:@[navHome,resultsHome,friendHome,myHome]];
    
    self.delegate = self;
    self.tabBarController.tabBar.delegate = self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    
    [NavHidden shareInstance].isHidden = YES;
    
    return YES;
    
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
