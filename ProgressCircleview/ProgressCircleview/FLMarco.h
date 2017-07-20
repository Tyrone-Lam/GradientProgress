//
//  FLMarco.h
//  ProgressCircleview
//
//  Created by monkey on 2017/7/20.
//  Copyright © 2017年 luqiao. All rights reserved.
//

#ifndef FLMarco_h
#define FLMarco_h

#pragma mark- rgb颜色转换

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#define UIColorFromRGB2(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]
#define UIColorFromRGB3(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#pragma mark- 单例模式
// .h文件
#define LQSingletonH(name) + (instancetype)shared##name;

// .m文件
#define LQSingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

#pragma mark - block weak strong

#define WeakObj(obj) __weak typeof(obj) obj##Weak = obj
#define StrongObj(obj) __strong typeof(obj) obj ## Strong = obj##Weak

#endif /* FLMarco_h */
