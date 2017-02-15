//
//  ViewController.m
//  图片的截取
//
//  Created by 上海均衡 on 2017/1/22.
//  Copyright © 2017年 上海均衡. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,assign)CGPoint startPoint;
@property(nonatomic,weak) UIView *clipView;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController
-(UIView *)clipView{
    if (_clipView==nil) {
        UIView *view=[[UIView alloc]init];
        _clipView=view;
        view.alpha=0.5;
        view.backgroundColor=[UIColor blackColor];
        [self.view addSubview:_clipView];
    }
    return _clipView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //给当前控制器添加一个pan手势
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}
#pragma mark 手势的移动
-(void)pan:(UIPanGestureRecognizer *)pan{
    //获取一开始的触摸点
    CGPoint endPoint=CGPointZero;
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startPoint= [pan locationInView:self.view];
    }else if (pan.state == UIGestureRecognizerStateChanged){
        endPoint=[pan locationInView:self.view];
        CGFloat width=endPoint.x-self.startPoint.x;
        CGFloat height=endPoint.y-self.startPoint.y;
        
        CGRect rect=CGRectMake(self.startPoint.x, self.startPoint.y, width, height);
        //生成截取的范围
        self.clipView.frame=rect;
        
    }else if(pan.state == UIGestureRecognizerStateEnded){

        //开启上下文
         UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
        //设置裁剪区域
        UIBezierPath *path=[UIBezierPath bezierPathWithRect:self.clipView.frame];
        [path addClip];
        CGContextRef context = UIGraphicsGetCurrentContext();
        //把空间上的内容渲染到上下文中
        [self.imageView.layer renderInContext:context];
        //生成一张图片
        self.imageView.image=UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        //先移除，再清空
        [self.clipView removeFromSuperview];
        self.clipView = nil;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
