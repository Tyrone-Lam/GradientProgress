//
//  LQRingDiagram.h
//  roadBridge
//
//  Created by monkey on 2017/7/5.
//  Copyright © 2017年 luqiao. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 请将此视图比例设置为 1:1
@interface LQRingDiagram : UIView

@property (assign, nonatomic) CGFloat progress;

/// 多对象同时走此方法仅最后一个有效
- (void)setProgressWithAnimation:(CGFloat)progress;

@end
