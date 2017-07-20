//
//  UIView+LQColorGrad.h
//  tunnelTone
//
//  Created by monkey on 2016/10/14.
//  Copyright © 2016年 luqiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LQColorGradDirection) {
    LQColorGradDirectionLeftToRight,
    LQColorGradDirectionUpToDown,
};

@interface UIView (LQColorGrad)

- (CAGradientLayer *)colorGradLayerWithStart:(UIColor *)start
                                         end:(UIColor *)end
                                   direction:(LQColorGradDirection)direct;

@end
