//
//  ViewController.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ViewController.h"
#import "ChooseLocationView.h"

@interface ViewController ()
@property (nonatomic,weak) ChooseLocationView * chooseLocationView;

@property (weak, nonatomic) IBOutlet UILabel *addresslabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ChooseLocationView * chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
    [self.view addSubview:chooseLocationView];
    _chooseLocationView = chooseLocationView;
    _chooseLocationView.chooseFinish = ^{
    
        _addresslabel.text = _chooseLocationView.address;
    };
    _chooseLocationView.hidden = YES;
}


- (IBAction)chooseLocation:(UIButton *)sender {
    
    _chooseLocationView.hidden = !_chooseLocationView.hidden;

}

@end
