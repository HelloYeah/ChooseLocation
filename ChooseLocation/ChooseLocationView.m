//
//  ChooseLocationView.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ChooseLocationView.h"
#import "UIView+MJExtension.h"
#define HYTopViewHeight 40    //顶部视图的高度
#define HYTopTabbarHeight 30  //地址标签栏的高度
#define HYBarItemMargin 20  //地址标签栏之间的间距
#define HYScreenW [UIScreen mainScreen].bounds.size.width

@interface ChooseLocationView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UIView * topTabbar;
@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,weak) UIView * underLine;
@property (nonatomic,strong) NSArray * dataSouce;
@property (nonatomic,strong) NSMutableArray * tableViews;
@property (nonatomic,strong) NSMutableArray * topTabbarItems;
@end

@implementation ChooseLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, HYTopViewHeight)];
    [self addSubview:topView];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"所在地区";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.mj_centerY = topView.mj_h * 0.5;
    titleLabel.mj_centerX = topView.mj_w * 0.5;
    UIView * separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.mj_y = topView.mj_h;
    topView.backgroundColor = [UIColor greenColor];
    
    UIView * topTabbar = [[UIView alloc]initWithFrame:CGRectMake(0, topView.mj_h, self.frame.size.width, HYTopViewHeight)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    [self addTopBarItem];
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.mj_y = topTabbar.mj_h;
    topTabbar.backgroundColor = [UIColor orangeColor];
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.mj_h = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.mj_y = separateLine1.mj_y - underLine.mj_h;
    
    _underLine.backgroundColor = [UIColor greenColor];
    
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.mj_h - HYTopViewHeight - HYTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(HYScreenW, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    
    [self addTableView];
}

- (void)addTableView{

    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * HYScreenW, 0, HYScreenW, _contentView.mj_h)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
}

- (void)addTopBarItem{
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem sizeToFit];
    [_topTabbar addSubview:topBarItem];
    topBarItem.mj_centerY = _topTabbar.mj_h * 0.5;
    UIView * lastView = self.topTabbarItems.lastObject;
    topBarItem.mj_x = HYBarItemMargin + CGRectGetMaxX(lastView.frame);
    [self.topTabbarItems addObject:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)topBarItemClick:(UIButton *)btn{
    
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * HYScreenW, 0);
        [self changeUnderLineFrame:btn];
    }];
}

- (void)changeUnderLineFrame:(UIButton  *)btn{
   
        _underLine.mj_x = btn.mj_x;
        _underLine.mj_w = btn.mj_w;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataSouce[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self addTopBarItem];
    [self addTableView];
    [self scrollToNextItem:self.dataSouce[indexPath.row]];
    
}

- (void)scrollToNextItem:(NSString *)preTitle{
    
    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [UIView animateWithDuration:1.0 animations:^{
        CGSize  size = self.contentView.contentSize;
        self.contentView.contentSize = CGSizeMake(size.width + HYScreenW, 0);
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + HYScreenW, offset.y);
        [self changeUnderLineFrame:self.topTabbarItems.lastObject];
    }];
}

- (UIView *)separateLine{
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    separateLine.backgroundColor = [UIColor lightGrayColor];
    return separateLine;
}

- (NSMutableArray *)tableViews{
    
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems{
    if (_topTabbarItems == nil) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}

- (NSArray *)dataSouce{
    
    if (_dataSouce == nil) {
        NSMutableArray * mArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i ++) {
            NSString * str = [NSString stringWithFormat:@"地址 %d",i];
            [mArray addObject:str];
        }
        _dataSouce = mArray;
    }
    return _dataSouce;
}
@end
