//
//  ViewController.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ViewController.h"
#import "ChooseLocationView.h"

@interface ViewController ()<NSURLSessionDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) ChooseLocationView *chooseLocationView;
@property (nonatomic,strong) UIView  *cover;
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)chooseLocation:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform =CGAffineTransformMakeScale(0.95, 0.95);
    }];
    self.cover.hidden = !self.cover.hidden;
    self.chooseLocationView.hidden = self.cover.hidden;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
//        CGPoint point = [gestureRecognizer locationInView:_chooseLocationView];
//        [_chooseLocationView hitTest:point withEvent:[[UIEvent alloc]init]];
        return NO;
    }

    return YES;
}
- (void)tapCover:(UITapGestureRecognizer *)tap{

    
   
        if (_chooseLocationView.chooseFinish) {
         _chooseLocationView.chooseFinish();
    }

}



- (UIView *)cover{

    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_cover];
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
        [_cover addSubview:_chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.addresslabel.text = weakSelf.chooseLocationView.address;
                weakSelf.view.transform = CGAffineTransformIdentity;
                weakSelf.cover.hidden = YES;
            }];
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;
    }
    return _cover;
}
@end
