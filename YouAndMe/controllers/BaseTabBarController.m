//
//  BaseTabBarController.m
//  YouAndMe
//
//  Created by daiyuzhang on 14-10-30.
//  Copyright (c) 2014年 daiyuzhang. All rights reserved.
//

#import "BaseTabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FivethViewController.h"
#import "BaseNavigationController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addViewControllers
{
    FirstViewController * firstVc = [[FirstViewController alloc] init];
    BaseNavigationController * firstNc = [[BaseNavigationController alloc] initWithRootViewController:firstVc];
    
    SecondViewController * SecondVc = [[SecondViewController alloc] init];
    BaseNavigationController * SecondNc = [[BaseNavigationController alloc] initWithRootViewController:SecondVc];

    ThirdViewController * ThirdVc = [[ThirdViewController alloc] init];
    BaseNavigationController * ThirdNc = [[BaseNavigationController alloc] initWithRootViewController:ThirdVc];

    
    FourthViewController * fourthVc = [[FourthViewController alloc] init];
    BaseNavigationController * fourthNc = [[BaseNavigationController alloc] initWithRootViewController:fourthVc];
    
    firstNc.tabBarItem.title = NSLocalizedString(@"message", nil);
    SecondNc.tabBarItem.title = NSLocalizedString(@"nearby", nil);
    ThirdNc.tabBarItem.title = NSLocalizedString(@"discover", nil);
    fourthNc.tabBarItem.title = NSLocalizedString(@"aboutme", nil);

    
    NSArray * controllers = [NSArray arrayWithObjects:firstNc,SecondNc, ThirdNc, fourthNc, nil];
    self.viewControllers = controllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addViewControllers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
