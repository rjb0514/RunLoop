//
//  ViewController.m
//  RunloopCrash
//
//  Created by ru on 2018/7/14.
//  Copyright © 2018年 ru. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *arr = @[@"22"];
    
//    NSString *str = arr[2];
//    NSLog(@"%@",str);

    NSArray *array =[NSArray array];
    NSLog(@"%@",[array objectAtIndex:1]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
