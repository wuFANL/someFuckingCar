//
//  QLBadgeButton.h
//  
//
//  Created by 乔磊 on 12-4-2.
//  Copyright (c) 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLBadgeButton : UIButton
/*
 *设置角标数量
 */
@property (nonatomic, copy) NSString *badgeValue;
/**
 *是否显示数量
 */
@property (nonatomic, assign) BOOL showNum;
@end
