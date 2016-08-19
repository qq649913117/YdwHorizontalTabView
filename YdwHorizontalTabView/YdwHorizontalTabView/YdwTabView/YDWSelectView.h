//
//  YDWSelectView.h
//  YDWSelectView
//
//  Created by ydw on 16/6/27.
//  Copyright © 2016年 ydw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDWSelectView;
/**
 *  设置代理，点击btn去改变scroll的偏移量显示对应内容
 */
@protocol YDWSelectViewDelegate <NSObject>

/**
 *  交给控制器去完成点击选项卡去移动相应tableView或者collectView
 */
@optional
-(void)YDWSelectView:(YDWSelectView *)selectView moveTableVorCollectionVWithTag:(NSInteger)tag;
/**
 *  拖动下面scrollV时候触发的传值代理
 */
-(void)YdwSelectViewWhenbottomScrollVDidEndDecelerating;

@end

@interface YDWSelectView : UIView<UIScrollViewDelegate>
/**
 *  选项卡下面装自定义View的背景scrollView的容器
 */
@property (nonatomic, strong) UIScrollView *bgScrollView;
/**
 *  代理
 */
@property (nonatomic, weak) id<YDWSelectViewDelegate> delegate;
/**
 *  界面UI初始化
 *  @param titleArray    储存选项卡标题数组
 *  @param normalColor   正常标题颜色
 *  @param selectedColor 选中的颜色
 *  @param lineColor     下面线条颜色，如果等于nil就没有线条
 */
- (void)setUpStatusButtonWithTitlt:(NSArray *)titleArray NormalColor:(UIColor *)normalColor SelectedColor:(UIColor *)selectedColor LineColor:(UIColor *)lineColor;

@end
