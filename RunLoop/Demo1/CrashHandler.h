//
//  CrashHandler.h
//  Demo1(crash)
//
//  Created by ru on 2018/7/3.
//  Copyright © 2018年 ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashHandler : NSObject{
    BOOL ignore;
}

+ (instancetype)sharedInstance;

@end
