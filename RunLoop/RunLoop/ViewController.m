//
//  ViewController.m
//  RunLoop
//
//  Created by ru on 2018/7/3.
//  Copyright © 2018年 ru. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSThread         *thread;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(creatThread) object:nil];
    _thread = thread;
    [thread start];
    
    
    
}

- (void)calculate {
    static NSInteger num = 20;
    if (num) {
        NSLog(@"现在数为：%zd",num);
        num -- ;
    }
}

- (void)creatThread {
    //创建线程的时候最好加上 自动释放池
    @autoreleasepool{
        NSPort *port = [[NSPort alloc] init];
        //为了保证runLoop不退出 需要有事件源  这个port就是占位的
        [[NSRunLoop currentRunLoop] addPort:port forMode:NSDefaultRunLoopMode];
        //开启运行循环  如果不开启的话 后期再这个线程是没法执行任务
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self performSelector:@selector(calculate) onThread:self.thread withObject:nil waitUntilDone:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
