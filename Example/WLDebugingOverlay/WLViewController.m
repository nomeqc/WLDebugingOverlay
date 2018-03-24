//
//  WLViewController.m
//  WLDebugingOverlay
//
//  Created by Fallrainy on 03/24/2018.
//  Copyright (c) 2018 Fallrainy. All rights reserved.
//

#import "WLViewController.h"

@interface WLViewController ()

@end

@implementation WLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"连续点击信号栏3次，弹出调试窗口";
    label.textColor = [UIColor darkTextColor];
    [self.view addSubview:label];
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
