//
//  CrashHandler.m
//  Demo1(crash)
//
//  Created by ru on 2018/7/3.
//  Copyright © 2018年 ru. All rights reserved.
//

#import "CrashHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>

NSString * const kSignalExceptionName = @"kSignalExceptionName";
NSString * const kSignalKey = @"kSignalKey";
NSString * const kCaughtExceptionStackInfoKey = @"kCaughtExceptionStackInfoKey";

void HandleException(NSException *exception);
void SignalHandler(int signal);


@interface CrashHandler ()<UIAlertViewDelegate>


@end


@implementation CrashHandler

static CrashHandler *instance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setCatchExceptionHandler];
    }
    return self;
}

- (void)setCatchExceptionHandler
{
    // 1.捕获一些异常导致的崩溃
    NSSetUncaughtExceptionHandler(&HandleException);
    
    // 2.捕获非异常情况，通过signal传递出来的崩溃
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i = 0; i < frames; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 0) {
        ignore = YES;
    } else if (anIndex == 1) {
        NSLog(@"起死回生");
    }
}


- (void)handleException:(NSException *)exception
{
    
    NSString *message = [NSString stringWithFormat:@"崩溃原因如下:\n%@\n%@",
                         [exception reason],
                         [[exception userInfo] objectForKey:kCaughtExceptionStackInfoKey]];
    NSLog(@"%@",message);


    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"程序崩溃了"
                                                    message:@"如果你能让程序起死回生，那你的决定是？"
                                                   delegate:self
                                          cancelButtonTitle:@"崩就蹦吧"
                                          otherButtonTitles:@"起死回生", nil];
    [alert show];
    
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!ignore) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            NSLog(@"频繁不");
              CFRunLoopRunResult result = CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
//
//        static CFRunLoopRunResult result = 0;
//
//        do {
//            NSLog(@"开始");
//
//            result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, CGFLOAT_MAX, false);
//            NSLog(@"结束");
//        } while (result != kCFRunLoopRunStopped);
//
    
//    CFRunLoopRunInMode(kCFRunLoopDefaultMode, CGFLOAT_MAX, false);
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:kSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:kSignalKey] intValue]);
    } else {
        [exception raise];
    }
}

void HandleException(NSException *exception)
{
    // 获取异常的堆栈信息
    NSArray *callStack = [exception callStackSymbols];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:callStack forKey:kCaughtExceptionStackInfoKey];
    
    CrashHandler *crashObject = [CrashHandler sharedInstance];
    NSException *customException = [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo];
    [crashObject performSelectorOnMainThread:@selector(handleException:) withObject:customException waitUntilDone:YES];
}

void SignalHandler(int signal)
{
    // 这种情况的崩溃信息，就另某他法来捕获吧
    NSArray *callStack = [CrashHandler backtrace];
    NSLog(@"信号捕获崩溃，堆栈信息：%@",callStack);
    
    CrashHandler *crashObject = [CrashHandler sharedInstance];
    NSException *customException = [NSException exceptionWithName:kSignalExceptionName
                                                           reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.", nil),signal]
                                                         userInfo:@{kSignalKey:[NSNumber numberWithInt:signal]}];
    
    [crashObject performSelectorOnMainThread:@selector(handleException:) withObject:customException waitUntilDone:YES];
}





@end