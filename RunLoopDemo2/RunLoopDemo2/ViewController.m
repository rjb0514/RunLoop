//
//  ViewController.m
//  RunLoopDemo2
//
//  Created by ru on 2018/7/3.
//  Copyright © 2018年 ru. All rights reserved.
//

#import "ViewController.h"
#import "BSBacktraceLogger.h"
#import <CrashReporter/CrashReporter.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSString *str = [BSBacktraceLogger bs_backtraceOfAllThread];
    NSLog(@"%@",str);
    
    NSData *lagData = [[[PLCrashReporter alloc]
                        initWithConfiguration:[[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll]] generateLiveReport];
    PLCrashReport *lagReport = [[PLCrashReport alloc] initWithData:lagData error:NULL];
    NSString *lagReportString = [PLCrashReportTextFormatter stringValueForCrashReport:lagReport withTextFormat:PLCrashReportTextFormatiOS];
    //将字符串上传服务器
    NSLog(@"lag happen, detail below: \n %@",lagReportString);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
