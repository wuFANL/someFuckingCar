//
//  QLKitLogManager.m
//  QLCoreiOSKit
//
//  Created by 乔磊 on 2019/12/15.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLKitLogManager.h"
#import "NSString+QLUtil.h"
// Log 开关状态，默认不输出log信息
static BOOL QLKitLog_Switch = NO;

@implementation QLKitLogManager

void CustomLog(const char *func, int lineNumber, NSString *format, ...) {
    if ([QLKitLogManager logEnable]) {
        // 开启了Log
        va_list args;
        va_start(args, format);
        NSString *logStr = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        NSString *strFormat = [NSString stringWithFormat:@"\n-------%s, Line:第 %i 行,\n Log:%@",func,lineNumber,logStr.unicodeString];
        fprintf(stderr,"%s", [strFormat UTF8String]);
    }
}

+ (BOOL)logEnable {
    return QLKitLog_Switch;
}

+ (void)setLogEnable:(BOOL)flag {
    QLKitLog_Switch = flag;
}

@end
