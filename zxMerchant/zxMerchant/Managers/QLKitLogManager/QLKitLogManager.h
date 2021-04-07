//
//  QLKitLogManager.h
//  QLCoreiOSKit
//
//  Created by 乔磊 on 2019/12/15.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef DEBUG
#define QLLog(format,...) CustomLog(__FUNCTION__,__LINE__,format,##__VA_ARGS__)
#else
#define QLLog(...)
#endif


/**
 *  自定义Log
 *  @warning 外部可直接调用 
 *
 *  @param func         方法名
 *  @param lineNumber   行号
 *  @param format       Log内容
 *  @param ...          个数可变的Log参数
 */
void CustomLog(const char *func, int lineNumber, NSString *format, ...);

@interface QLKitLogManager : NSObject

/**
 *  Log 输出开关 (默认关闭)
 *
 *  @param flag 是否开启
 */
+ (void)setLogEnable:(BOOL)flag;

/**
 *  是否开启了 Log 输出
 *
 *  @return Log 开关状态
 */
+ (BOOL)logEnable;

@end

NS_ASSUME_NONNULL_END
