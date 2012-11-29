//
//  UUViewController.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUMainVC.h"
#import "AFJSONRequestOperation.h"
#import "UUGoodPolicyVC.h"
#import "UUActivityVC.h"
#import "UUProjectShowVC.h"
#import "UUNewInfoVC.h"
#import "UUPartnersVC.h"
#import "UUAboutVC.h"
#import "UUUIHelper.h"

@interface UUMainVC ()



- (void)buttonClicked:(UIButton *)sender;
- (void)pushGoodPolicyVC;
- (void)pushActivityVC;
- (void)pushNewInfoVC;
- (void)pushProjectShowVC;
- (void)pushPartnersVC;
- (void)pushAboutVC;

@end

@implementation UUMainVC

- (id)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = UU_BG_SLATE_GRAY;
    
    UIButton *activityButton = [UUUIHelper createButtonWithFrame:CGRectMake(5, 10, 150, 140) normalBgImageStr:@"homepage_big_button_normal" highlightedBgImageStr:@"homepage_big_button_press" target:self selector:@selector(pushActivityVC)];
    [activityButton setTitle:@"活动日历" forState:UIControlStateNormal];
    [activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:activityButton];
    
    UIButton *goodPolicyButton = [UUUIHelper createButtonWithFrame:CGRectMake(160, 10, 150, 140) normalBgImageStr:@"homepage_big_button_normal" highlightedBgImageStr:@"homepage_big_button_press" target:self selector:@selector(pushGoodPolicyVC)];
    [goodPolicyButton setTitle:@"利好政策" forState:UIControlStateNormal];
    [goodPolicyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:goodPolicyButton];
    
    UIButton *newInfoButton = [UUUIHelper createButtonWithFrame:CGRectMake(5, 160, 150, 140) normalBgImageStr:@"homepage_big_button_normal" highlightedBgImageStr:@"homepage_big_button_press" target:self selector:@selector(pushNewInfoVC)];
    [newInfoButton setTitle:@"业内资讯" forState:UIControlStateNormal];
    [newInfoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:newInfoButton];
    
    UIButton *projectButton = [UUUIHelper createButtonWithFrame:CGRectMake(160, 160, 150, 140) normalBgImageStr:@"homepage_big_button_normal" highlightedBgImageStr:@"homepage_big_button_press" target:self selector:@selector(pushProjectShowVC)];
    [projectButton setTitle:@"项目展示" forState:UIControlStateNormal];
    [projectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:projectButton];
    
    UIButton *partnersButton = [UUUIHelper createButtonWithFrame:CGRectMake(5, 310, 150, 140) normalBgImageStr:@"homepage_big_button_normal" highlightedBgImageStr:@"homepage_big_button_press" target:self selector:@selector(pushPartnersVC)];
    [partnersButton setTitle:@"合作伙伴" forState:UIControlStateNormal];
    [partnersButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:partnersButton];
    
    UIButton *aboutButton = [UUUIHelper createButtonWithFrame:CGRectMake(160, 310, 150, 140) normalBgImageStr:@"homepage_big_button_normal" highlightedBgImageStr:@"homepage_big_button_press" target:self selector:@selector(pushAboutVC)];
    [aboutButton setTitle:@"关于我们" forState:UIControlStateNormal];
    [aboutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:aboutButton];

}

- (void)buttonClicked:(UIButton *)sender
{
    UUGoodPolicyVC *goodPolicy = [[UUGoodPolicyVC alloc] init];
    [self.navigationController pushViewController:goodPolicy animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - private methods

- (void)pushGoodPolicyVC
{
    [self.navigationController pushViewController:[[UUGoodPolicyVC alloc] init] animated:YES];
}

- (void)pushActivityVC
{
    [self.navigationController pushViewController:[[UUActivityVC alloc] init] animated:YES];
}

- (void)pushNewInfoVC
{
    [self.navigationController pushViewController:[[UUNewInfoVC alloc] init] animated:YES];
}

- (void)pushProjectShowVC
{
    [self.navigationController pushViewController:[[UUProjectShowVC alloc] init] animated:YES];
}

- (void)pushPartnersVC
{
    [self.navigationController pushViewController:[[UUPartnersVC alloc] init] animated:YES];
}

- (void)pushAboutVC
{
    [self.navigationController pushViewController:[[UUAboutVC alloc] init] animated:YES];
}

@end
