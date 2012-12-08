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

#define kButtonRect @"kButtonRect"
#define kButtonImageStr @"kButtonImageStr"
#define kButtonImageHighStr @"kButtonImageHighStr"
#define kButtonTargetClass @"kButtonTargetClass"

@interface UUMainVC ()

@property (nonatomic, strong) NSMutableArray *buttonInfos;

- (void)buttonClicked:(id)sender;

@end

@implementation UUMainVC

@synthesize buttonInfos;

- (id)init
{
    self = [super init];
    if(self){
        buttonInfos = [NSMutableArray array];
        
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setObject:NSStringFromCGRect(CGRectMake(8, 10, 148, 125)) forKey:kButtonRect];
        [dic1 setObject:@"icon_Calendar_normal" forKey:kButtonImageStr];
        [dic1 setObject:@"icon_Calendar_press" forKey:kButtonImageHighStr];
        [dic1 setObject:UUActivityVC.class forKey:kButtonTargetClass];
        [buttonInfos addObject:dic1];
        
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setObject:NSStringFromCGRect(CGRectMake(164, 10, 148, 125)) forKey:kButtonRect];
        [dic2 setObject:@"icon_zhengce_normal" forKey:kButtonImageStr];
        [dic2 setObject:@"icon_zhengce_press" forKey:kButtonImageHighStr];
        [dic2 setObject:UUGoodPolicyVC.class forKey:kButtonTargetClass];
        [buttonInfos addObject:dic2];
        
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
        [dic3 setObject:NSStringFromCGRect(CGRectMake(8, 145, 148, 125)) forKey:kButtonRect];
        [dic3 setObject:@"icon_zixun_normal" forKey:kButtonImageStr];
        [dic3 setObject:@"icon_zixun_press" forKey:kButtonImageHighStr];
        [dic3 setObject:UUNewInfoVC.class forKey:kButtonTargetClass];
        [buttonInfos addObject:dic3];
        
        NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
        [dic4 setObject:NSStringFromCGRect(CGRectMake(164, 145, 148, 125)) forKey:kButtonRect];
        [dic4 setObject:@"icon_xiangmu_normal" forKey:kButtonImageStr];
        [dic4 setObject:@"icon_xiangmu_press" forKey:kButtonImageHighStr];
        [dic4 setObject:UUProjectShowVC.class forKey:kButtonTargetClass];
        [buttonInfos addObject:dic4];
        
        NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
        [dic5 setObject:NSStringFromCGRect(CGRectMake(8, 280, 148, 125)) forKey:kButtonRect];
        [dic5 setObject:@"icon_huoban_normal" forKey:kButtonImageStr];
        [dic5 setObject:@"icon_huoban_press" forKey:kButtonImageHighStr];
        [dic5 setObject:UUPartnersVC.class forKey:kButtonTargetClass];
        [buttonInfos addObject:dic5];
        
        NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
        [dic6 setObject:NSStringFromCGRect(CGRectMake(164, 280, 148, 125)) forKey:kButtonRect];
        [dic6 setObject:@"icon_me_normal" forKey:kButtonImageStr];
        [dic6 setObject:@"icon_me_press" forKey:kButtonImageHighStr];
        [dic6 setObject:UUAboutVC.class forKey:kButtonTargetClass];
        [buttonInfos addObject:dic6];
    }
    return self;
}


- (void)loadView
{
    [super loadView];
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = UU_BG_SLATE_GRAY;
    self.navigationItem.title = @"首页";
    for(int i=0; i<6; i++){
        NSDictionary *dic = [buttonInfos objectAtIndex:i];
        CGRect rect = CGRectFromString([dic objectForKey:kButtonRect]);
        NSString *imageStr = [dic objectForKey:kButtonImageStr];
        NSString *imageHighStr = [dic objectForKey:kButtonImageHighStr];
        UIButton *button =[UUUIHelper createButtonWithFrame:rect normalBgImageStr:imageStr highlightedBgImageStr:imageHighStr target:self selector:@selector(buttonClicked:)];
        button.tag = i;
        [self.view addSubview:button];
    }
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
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - private methods

- (void)buttonClicked:(id)sender
{
    int tagIndex = ((UIButton *)sender).tag;
    NSDictionary *dic = [self.buttonInfos objectAtIndex:tagIndex];
    Class class = [dic objectForKey:kButtonTargetClass];
    [self.navigationController pushViewController:[[class alloc] init] animated:YES];
}


@end
