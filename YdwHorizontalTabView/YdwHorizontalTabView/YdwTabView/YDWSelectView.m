//
//  YDWSelectView.m
//  YDWSelectView
//
//  Created by ydw on 16/6/27.
//  Copyright © 2016年 ydw. All rights reserved.
//

#import "YDWSelectView.h"
#define XKScreenWidth [UIScreen mainScreen].bounds.size.width

@interface YDWSelectView ()

//选项卡的高
@property (nonatomic, assign) CGFloat SelectViewHeight;
/**
 *  存放btns
 */
@property (nonatomic,strong)NSMutableArray *buttonArray;
/**
 *  横线
 */
@property (nonatomic,strong) UIView *lineView;
/**
 *  当前点击下标
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  装选项卡的scrollView
 */
@property (nonatomic, strong) UIScrollView *TabScrollView;

@property (nonatomic, assign) CGFloat width;


@end
@implementation YDWSelectView

//选项卡界面的搭建
-(void)setUpStatusButtonWithTitlt:(NSArray *)titleArray NormalColor:(UIColor *)normalColor SelectedColor:(UIColor *)selectedColor LineColor:(UIColor *)lineColor
{
    _SelectViewHeight = 45;
    NSInteger tabCount = titleArray.count;
    //选项按钮的创建 默认屏幕可见最多创建 5个选项卡
    if (tabCount <= 5) {
        _width =  XKScreenWidth / tabCount;
    }else
    {
        _width = XKScreenWidth / 5;
        
    }
    /** 为了让选项卡上下都有边线 */
    self.TabScrollView .frame = CGRectMake(-1, 0, XKScreenWidth + 2, _SelectViewHeight-0.5);
    self.TabScrollView.layer.borderWidth = 0.5;
    self.TabScrollView.layer.borderColor = [UIColor colorWithWhite:0.667 alpha:0.500].CGColor;
    self.TabScrollView.contentSize = CGSizeMake(tabCount * _width, _SelectViewHeight);
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_width*i, 0, _width, _SelectViewHeight-3);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(buttonTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.TabScrollView addSubview:button];
        [self.buttonArray addObject:button];
        
        if (i == 0) {
            button.selected = YES;
        }
    }
    self.currentIndex = 0;
    //线条
    if (lineColor) {
        self.lineView.frame = CGRectMake(_width / 3, _SelectViewHeight-3, _width / 3, 3);
        self.lineView.backgroundColor = lineColor;
    }
    [self addSubview:self.bgScrollView];
    self.bgScrollView.contentSize = CGSizeMake(tabCount * XKScreenWidth, self.frame.size.height - _SelectViewHeight);
}
- (void)changeStateWithTag:(NSInteger)tag
{
    //改变当前选中的下标,并且使其处于被选中状态
    self.currentIndex = tag;
    UIButton *selectBtn = self.buttonArray[tag];
    selectBtn.selected = YES;
    //同时关闭上一个选中Btn的选中状态
    for (NSInteger i = 0; i < self.buttonArray.count; i++) {
        if (i != self.currentIndex) {
            UIButton *btn = self.buttonArray[i];
            btn.selected = NO;
        }
    }
    //移动下划线到对应btn下面
    if (self.lineView) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect lineRect = self.lineView.frame;
            lineRect.origin.x = _width * tag + _width / 3;
            self.lineView.frame = lineRect;
        }];
    }
}
//点击选项Btn，所有状态相应的改变
- (void)buttonTouchEvent:(UIButton *)button{
    
    if (button.tag == self.currentIndex) {
        return;
    }
    [self changeStateWithTag:button.tag];
//    代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(YDWSelectView:moveTableVorCollectionVWithTag:)]) {
        
        [self.delegate YDWSelectView:self moveTableVorCollectionVWithTag:button.tag];
    }

}
#pragma mark - scrollView代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.bgScrollView) {
        NSInteger touchIndex = scrollView.contentOffset.x / XKScreenWidth;
        [self changeStateWithTag:touchIndex];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(YdwSelectViewWhenbottomScrollVDidEndDecelerating)]) {
            [self.delegate YdwSelectViewWhenbottomScrollVDidEndDecelerating];
        }
    }
}
#pragma mark -- 懒加载
- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
         
    }
    return _buttonArray;
}
-(UIScrollView *)TabScrollView
{
    if (!_TabScrollView) {
        _TabScrollView = [[UIScrollView alloc] init];
//        _TabScrollView.delegate = self;
        _TabScrollView.showsVerticalScrollIndicator = NO;
        _TabScrollView.showsHorizontalScrollIndicator = NO;
        _TabScrollView.backgroundColor = [UIColor whiteColor];
        _TabScrollView.bounces = NO;
        _TabScrollView.backgroundColor = [UIColor colorWithRed:0.299 green:0.947 blue:0.599 alpha:1.000];
        [self addSubview:_TabScrollView];
    }
    return _TabScrollView;
}
- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [self.TabScrollView addSubview:_lineView];
    }
    return _lineView;
}
-(UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _SelectViewHeight, XKScreenWidth, self.frame.size.height - _SelectViewHeight)];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.delegate = self;
        _bgScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _bgScrollView;
}
@end
