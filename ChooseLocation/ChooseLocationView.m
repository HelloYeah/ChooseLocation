//
//  ChooseLocationView.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ChooseLocationView.h"
#import "AddressView.h"
#import "UIView+Frame.h"

#define HYScreenW [UIScreen mainScreen].bounds.size.width

static  CGFloat  const  kHYTopViewHeight = 40; //顶部视图的高度
static  CGFloat  const  kHYTopTabbarHeight = 30; //地址标签栏的高度

@interface ChooseLocationView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) AddressView * topTabbar;
@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,weak) UIView * underLine;
@property (nonatomic,strong) NSArray * dataSouce;
@property (nonatomic,strong) NSArray * dataSouce1;
@property (nonatomic,strong) NSArray * dataSouce2;
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
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topView];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"所在地区";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.centerY = topView.height * 0.5;
    titleLabel.centerX = topView.width * 0.5;
    UIView * separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.top = topView.top;
    topView.backgroundColor = [UIColor greenColor];
    
    AddressView * topTabbar = [[AddressView alloc]initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    [self addTopBarItem];
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.top = topTabbar.height;
    topTabbar.backgroundColor = [UIColor orangeColor];
    [_topTabbar layoutIfNeeded];
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;
    
    _underLine.backgroundColor = [UIColor greenColor];
    
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - kHYTopViewHeight - kHYTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(HYScreenW, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    [self addTableView];
}

- (void)addTableView{

    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * HYScreenW, 0, HYScreenW, _contentView.height)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
}

- (void)addTopBarItem{
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem sizeToFit];
     topBarItem.centerY = _topTabbar.height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addSubview:topBarItem];
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
   
        _underLine.left = btn.left;
        _underLine.width = btn.width;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.tableViews indexOfObject:tableView] == 0){
        return self.dataSouce.count;
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        return self.dataSouce1.count;
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        return self.dataSouce2.count;
    }
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if([self.tableViews indexOfObject:tableView] == 0){
        cell.textLabel.text = self.dataSouce[indexPath.row][@"name"];
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        if ([self.dataSouce1[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.textLabel.text = self.dataSouce1[indexPath.row];

        }else{
            cell.textLabel.text = self.dataSouce1[indexPath.row][@"name"];
        }
        
        
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        cell.textLabel.text = self.dataSouce2[indexPath.row];
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if([self.tableViews indexOfObject:tableView] == 0){
        
        UITableView * tableView0 = self.tableViews.firstObject;
        NSIndexPath * indexPath0 = [tableView0 indexPathForSelectedRow];
        NSArray *  subArray = self.dataSouce[indexPath.row][@"sub"];
        if (subArray.count > 1) {
            _dataSouce1 = subArray;
        }if (subArray.count == 1){
            _dataSouce1 = subArray.firstObject[@"sub"];
        }
        
        if (indexPath0 != indexPath && indexPath0) {
            
            for (int i = 0; i < self.tableViews.count; i++) {
                [self removeLastItem];
            }
            
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:self.dataSouce[indexPath.row][@"name"]];
            
            return indexPath;
        }
        
        [self addTopBarItem];
        [self addTableView];
        [self scrollToNextItem:self.dataSouce[indexPath.row][@"name"]];
        
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        
        UITableView * tableView0 = self.tableViews[1];
        NSIndexPath * indexPath0 = [tableView0 indexPathForSelectedRow];
        
        if (indexPath0 != indexPath && indexPath0) {
        
            if ([self.dataSouce1[indexPath.row] isKindOfClass:[NSString class]]){
                NSInteger index = self.contentView.contentOffset.x / HYScreenW;
                UIButton * btn = self.topTabbarItems[index];
                [btn setTitle:self.dataSouce1[indexPath.row] forState:UIControlStateNormal];
                [btn sizeToFit];
                [_topTabbar layoutIfNeeded];
                
                UITableView * tableView0 = self.tableViews.firstObject;
                NSIndexPath * indexPath0 = [tableView0 indexPathForSelectedRow];
                
                self.address = [NSString stringWithFormat:@"%@  %@",self.dataSouce[indexPath0.row][@"name"], self.dataSouce1[indexPath.row]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.hidden = YES;
                    if (self.chooseFinish) {
                        self.chooseFinish();
                    }
                });
                return indexPath;
            }
            
            [self removeLastItem];
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:self.dataSouce1[indexPath.row][@"name"]];
            
            return indexPath;

        }

        if ([self.dataSouce1[indexPath.row] isKindOfClass:[NSString class]]){
            NSInteger index = self.contentView.contentOffset.x / HYScreenW;
            UIButton * btn = self.topTabbarItems[index];
            [btn setTitle:self.dataSouce1[indexPath.row] forState:UIControlStateNormal];
            [btn sizeToFit];
            [_topTabbar layoutIfNeeded];
            
            UITableView * tableView0 = self.tableViews.firstObject;
            NSIndexPath * indexPath0 = [tableView0 indexPathForSelectedRow];
            
            self.address = [NSString stringWithFormat:@"%@  %@",self.dataSouce[indexPath0.row][@"name"], self.dataSouce1[indexPath.row]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hidden = YES;
                if (self.chooseFinish) {
                    self.chooseFinish();
                }
            });

            
        }else{
            
            _dataSouce2 = self.dataSouce1[indexPath.row][@"sub"];
            [self addTopBarItem];
            [self addTableView];
             [self scrollToNextItem:self.dataSouce1[indexPath.row][@"name"]];
        }
       
        
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        
        NSInteger index = self.contentView.contentOffset.x / HYScreenW;
        UIButton * btn = self.topTabbarItems[index];
        [btn setTitle:self.dataSouce2[indexPath.row] forState:UIControlStateNormal];
        [btn sizeToFit];
        [_topTabbar layoutIfNeeded];
        
        
        UITableView * tableView0 = self.tableViews.firstObject;
        NSIndexPath * indexPath0 = [tableView0 indexPathForSelectedRow];
        
        UITableView * tableView1 = self.tableViews[1];
        NSIndexPath * indexPath1 = [tableView1 indexPathForSelectedRow];
        
        self.address = [NSString stringWithFormat:@"%@ %@ %@",self.dataSouce[indexPath0.row][@"name"],self.dataSouce1[indexPath1.row][@"name"], self.dataSouce2[indexPath.row]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hidden = YES;
            if (self.chooseFinish) {
                self.chooseFinish();
            }
        });
    }
    
    return indexPath;
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem{

    
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}

- (void)scrollToNextItem:(NSString *)preTitle{
    
    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [UIView animateWithDuration:1.0 animations:^{
        CGSize  size = self.contentView.contentSize;
        self.contentView.contentSize = CGSizeMake(size.width + HYScreenW, 0);
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + HYScreenW, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
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
        NSString * path = [[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil];
        
        NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
        _dataSouce = dict[@"address"];
    }
    return _dataSouce;
}

- (NSArray *)dataSouce1{
    
    if (_dataSouce1 == nil) {
  
        _dataSouce1 = [NSArray array];
    }
    return _dataSouce1;
}

- (NSArray *)dataSouce2{
    
    if (_dataSouce2 == nil) {
     
        _dataSouce2 = [NSArray array];
    }
    return _dataSouce2;
}
@end
