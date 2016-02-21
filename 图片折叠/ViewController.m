//
//  ViewController.m
//  图片折叠
//
//  Created by 王志盼 on 16/2/16.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *containView;

@property (nonatomic, weak) CAGradientLayer *gradientLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupOtherView];
    
    //设置渐变的阴影
    [self setupShadow];
}

- (void)setupOtherView
{
    //设置contentsRect用来表示图片显示的大小，可以做边下载边显示的UI效果,取值是(0--1)
    self.topView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    self.topView.layer.anchorPoint = CGPointMake(0.5, 1);
    
    self.bottomView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    self.bottomView.layer.anchorPoint = CGPointMake(0.5, 0);
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.containView addGestureRecognizer:gesture];
}

- (void)setupShadow
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bottomView.bounds;
    
    gradientLayer.opacity = 0;
    
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    
    self.gradientLayer = gradientLayer;
    
    [self.bottomView.layer addSublayer:gradientLayer];
    
    // 设置渐变颜色
    //    gradientL.colors = @[(id)[UIColor redColor].CGColor,(id)[UIColor greenColor].CGColor,(id)[UIColor yellowColor].CGColor];
    
    // 设置渐变定位点
    //    gradientL.locations = @[@0.1,@0.4,@0.5];
    
    // 设置渐变开始点，取值0~1
    //    gradientL.startPoint = CGPointMake(0, 1);
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    CGFloat y = [recognizer translationInView:self.containView].y;
    
    if (y >= 300) y = 300;
    
    if (y <= -300) y = -300;
    
    // 旋转角度,往下逆时针旋转
    CGFloat angle = -y / 320.0 * M_PI;
    
    self.topView.layer.transform = CATransform3DIdentity;
    
    CATransform3D transfrom = CATransform3DIdentity;
    
    transfrom.m34 = -1 / 500.0;
    
    self.topView.layer.transform = CATransform3DRotate(transfrom, angle, 1, 0, 0);
    
    self.gradientLayer.opacity = y / 300.0;
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        // 弹簧效果的动画
        // SpringWithDamping:弹性系数,越小，弹簧效果越明显
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:11 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.topView.layer.transform = CATransform3DIdentity;
            self.gradientLayer.opacity = 0;
        } completion:nil];
    }
}

@end
