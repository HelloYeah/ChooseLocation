//
//  ViewController.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ViewController.h"
#import "ChooseLocationView.h"
#import "CitiesDataTool.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
const static CGFloat SCALING = 0.95;

@interface ViewController ()<NSURLSessionDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) ChooseLocationView *chooseLocationView;
@property (nonatomic,strong) UIView  *cover;
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[CitiesDataTool sharedManager] requestGetData];
    [self.view addSubview:self.cover];
    self.chooseLocationView.address = @"广东省 广州市 越秀区";
    self.chooseLocationView.areaCode = @"440104";
    self.addresslabel.text = @"广东省 广州市 越秀区";
}

- (IBAction)chooseLocation:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform =CGAffineTransformMakeScale(SCALING, SCALING);
        self.chooseLocationView.frame = CGRectMake(-(kScreenWidth * (1 - SCALING)), kScreenHeight - 350, kScreenWidth * (2.0 - SCALING), 350);
    }];
    self.cover.hidden = !self.cover.hidden;
    self.chooseLocationView.hidden = self.cover.hidden;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
        return NO;
    }
    return YES;
}


- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    if (_chooseLocationView.chooseFinish) {
         _chooseLocationView.chooseFinish();
    }
}

- (ChooseLocationView *)chooseLocationView{
    
    if (!_chooseLocationView) {
       _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(-(kScreenWidth * (1 - SCALING)), kScreenHeight, kScreenWidth * (2.0 - SCALING), 350) withScaling:SCALING];
    }
    return _chooseLocationView;
}

- (UIView *)cover{

    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_cover addSubview:self.chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.addresslabel.text = weakSelf.chooseLocationView.address;
                weakSelf.view.transform = CGAffineTransformIdentity;
                weakSelf.cover.alpha = 0;
                weakSelf.chooseLocationView.frame = CGRectMake(-(kScreenWidth * (1 - SCALING)), kScreenHeight, kScreenWidth * (2.0 - SCALING), 350);
            } completion:^(BOOL finished) {
                weakSelf.cover.hidden = YES;
            }];
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;
    }
    _cover.alpha = 1;
    return _cover;
}
@end
