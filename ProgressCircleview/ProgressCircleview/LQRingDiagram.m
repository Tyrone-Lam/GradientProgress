//
//  LQRingDiagram.m
//  roadBridge
//
//  Created by monkey on 2017/7/5.
//  Copyright © 2017年 luqiao. All rights reserved.
//

#import "LQRingDiagram.h"
#import "UIView+LQColorGrad.h"
#import "LQPollingTimer.h"
#import "FLMarco.h"

#define TWO_M_PI (M_PI*2)

#define CircleStart (0.4 * TWO_M_PI) // 以 0.25*TWO_M_PI 为初始，增大即为开口 -- 0.5*TWO_M_PI 为半环
#define CircleEndDr (TWO_M_PI + (M_PI/2 * 2) - CircleStart) // M_PI/2 表示圆开口从底部开始
#define IntegralCircle(Per) (CircleStart + (CircleEndDr - CircleStart) * Per)

#define kBorderWidth 8.0

static CGFloat changePro = 0.0;

@interface LQRingDiagram () <LQPollingTimerDelegate>

@property (strong, nonatomic) UIBezierPath *trackPath;
@property (strong, nonatomic) CAShapeLayer *trackLayer;
@property (strong, nonatomic) UIBezierPath *progressPath;
@property (strong, nonatomic) CAShapeLayer *progressLayer;

@property (assign, nonatomic) CGFloat animationProgress;

@end

@implementation LQRingDiagram

- (void)dealloc {
    [[LQPollingTimer sharedPollingTimer] deallocTimer];
    [LQPollingTimer sharedPollingTimer].delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBezierPath_Ornamental:self.bounds];
        [self createBezierPath_Bottom:self.bounds];
        [self createBezierPath_Top:self.bounds];
        
        /// 左右渐变起始颜色 -- 可提取设置
        CAGradientLayer *graLayer = [self colorGradLayerWithStart:UIColorFromRGB(0x17e1ff)
                                                              end:UIColorFromRGB(0xfd2c80)
                                                        direction:LQColorGradDirectionLeftToRight];
        [graLayer setMask:_progressLayer];
        [self.layer addSublayer:graLayer];
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        self.progressLayer.strokeEnd = 0;
        [CATransaction commit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createBezierPath_Ornamental:self.bounds];
        [self createBezierPath_Bottom:self.bounds];
        [self createBezierPath_Top:self.bounds];
        
        CAGradientLayer *graLayer = [self colorGradLayerWithStart:UIColorFromRGB(0x17e1ff)
                                                              end:UIColorFromRGB(0xfd2c80)
                                                        direction:LQColorGradDirectionLeftToRight];
        [graLayer setMask:_progressLayer];
        [self.layer addSublayer:graLayer];
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        self.progressLayer.strokeEnd = 0;
        [CATransaction commit];
    }
    return self;
}


#pragma mark - private method

/// 外层 -- 装饰圆
- (void)createBezierPath_Ornamental:(CGRect)mybound {
    CGFloat width = mybound.size.width;
    
    CGFloat lineWidth = 2.0;
    
    UIBezierPath *ornamentalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, width/2)
                                                radius:width/2 - lineWidth
                                            startAngle:0
                                              endAngle:TWO_M_PI
                                             clockwise:YES];
    
    CAShapeLayer *ornamental = [CAShapeLayer new];
    [self.layer addSublayer:ornamental];
    ornamental.fillColor = nil;
    ornamental.strokeColor = UIColorFromRGB(0xefefef).CGColor;
    ornamental.lineCap = kCALineCapRound;
    ornamental.path = ornamentalPath.CGPath;
    ornamental.lineWidth = lineWidth;
    ornamental.frame = mybound;
}

/// 底层 -- 圆
- (void)createBezierPath_Bottom:(CGRect)mybound {
    CGFloat width = mybound.size.width;
    
    _trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, width/2)
                                                radius:width/2 - kBorderWidth - 10
                                            startAngle:CircleStart
                                              endAngle:CircleEndDr
                                             clockwise:YES];
    
    _trackLayer = [CAShapeLayer new];
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = nil;
    _trackLayer.strokeColor = UIColorFromRGB(0xe5e5e5).CGColor;
    _trackLayer.lineCap = kCALineCapRound;
    _trackLayer.path = _trackPath.CGPath;
    _trackLayer.lineWidth = kBorderWidth;
    _trackLayer.frame = mybound;
}

/// 表层 -- 圆 -- progress
- (void)createBezierPath_Top:(CGRect)mybound {
    CGFloat width = mybound.size.width;

    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, width/2)
                                                   radius:width/2 - kBorderWidth - 10
                                               startAngle:CircleStart
                                                 endAngle:IntegralCircle(1)
                                                clockwise:YES];
    
    _progressLayer = [CAShapeLayer new];
    [self.layer addSublayer:_progressLayer];
    _progressLayer.fillColor = nil;
    _progressLayer.strokeColor = [UIColor blackColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.path = _progressPath.CGPath;
    _progressLayer.lineWidth = kBorderWidth;
    _progressLayer.frame = mybound;
    
}

- (void)setProgressWithAnimation:(CGFloat)progress {
    changePro = 0.0;
    _animationProgress = progress;
    
    //环形图动画
    [[LQPollingTimer sharedPollingTimer] deallocTimer];
    [[LQPollingTimer sharedPollingTimer] startTimerWithStartTime:0 withTimeInterval:0.0045 withContinuedtime:100];
    [[LQPollingTimer sharedPollingTimer] setDelegate:self];
}

#pragma mark - theTimerTarget

- (void)theTimerTarget {
    if (changePro <= _animationProgress) {
        [self setProgress:changePro];
        if (changePro == _animationProgress) {
            [[LQPollingTimer sharedPollingTimer] deallocTimer];
        }
    }
    else {
        changePro = _animationProgress;
    }
    changePro += 0.01;
}

- (void)didEndOfTimer {
    [self setProgress:_animationProgress];
}

#pragma mark - getters and setter

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.progressLayer.strokeEnd = progress;
    [CATransaction commit];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
