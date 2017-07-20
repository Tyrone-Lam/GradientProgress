//
//  UIView+LQColorGrad.m
//  tunnelTone
//
//  Created by monkey on 2016/10/14.
//  Copyright © 2016年 luqiao. All rights reserved.
//

#import "UIView+LQColorGrad.h"

@implementation UIView (LQColorGrad)

- (CAGradientLayer *)colorGradLayerWithStart:(UIColor *)start
                                         end:(UIColor *)end
                                   direction:(LQColorGradDirection)direct
{
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
//    [self.layer addSublayer:gradientLayer];
    
    if (direct == LQColorGradDirectionUpToDown) {
        //设置渐变区域的起始和终止位置（范围为0-1）
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
    }
    else if (direct == LQColorGradDirectionLeftToRight) {
        //水平渐变
        gradientLayer.startPoint = CGPointMake(0, .5);
        gradientLayer.endPoint = CGPointMake(1, .5);
    }
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)start.CGColor,
                             (__bridge id)end.CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    return gradientLayer;
}

@end
