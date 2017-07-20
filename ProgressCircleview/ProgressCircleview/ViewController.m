//
//  ViewController.m
//  ProgressCircleview
//
//  Created by monkey on 2017/7/20.
//  Copyright © 2017年 luqiao. All rights reserved.
//

#import "ViewController.h"
#import "LQRingDiagram.h"


@interface ViewController ()

@property (strong, nonatomic) LQRingDiagram *circleView;

@property (weak, nonatomic) IBOutlet LQRingDiagram *circleView_bottom;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _circleView = [[LQRingDiagram alloc] initWithFrame:CGRectMake(50, 100, 250, 250)];
    [self.view addSubview:_circleView];
    
    [_circleView setProgressWithAnimation:0.9];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_circleView_bottom setProgressWithAnimation:0.95];
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
