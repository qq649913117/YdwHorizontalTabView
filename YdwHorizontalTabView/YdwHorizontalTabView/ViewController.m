//
//  ViewController.m
//  YdwHorizontalTabView
//
//  Created by ydw on 16/6/27.
//  Copyright © 2016年 ydw. All rights reserved.
//

#import "ViewController.h"
#import "YDWSelectView.h"
#define XKScreenWidth [UIScreen mainScreen].bounds.size.width
#define XKScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<YDWSelectViewDelegate>
/**
 *  记录当前显示childVC_page
 */
@property (nonatomic ,assign) NSInteger currentPage;
/**
 *  存储viewController的数组 <__kindof UIViewController *>指定数组只能放UIViewController *
 */
@property (nonatomic, strong) NSMutableArray<__kindof UIViewController *> *viewControllers;
/**
 *  水平选项卡
 */
@property (nonatomic, strong) YDWSelectView *ydwSelectView;

@end

@implementation ViewController
-(instancetype)init
{
    if (self = [super init]) {
        self.viewControllers = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"水平选项卡,优化加载界面";
    
    [self SETUI];

}
#pragma mark -- UI
-(void)SETUI
{
    //----------------选项卡----------------------
    [self.view addSubview:self.ydwSelectView];
    //------------SixChildVC---------------------
    NSArray *VCNameArray = @[@"first",
                             @"second",
                             @"third",
                             @"fourth",
                             @"fifth",
                             @"Sixth"];
    [self createSixChildVCWithVCNameArr:VCNameArray];

}
-(void)createSixChildVCWithVCNameArr:(NSArray *)VCNameArray
{
    for (NSInteger i = 0; i < 6; i++) {
        NSString * className = [NSString stringWithFormat:@"%@VC",VCNameArray[i]];
        
        Class myClass = NSClassFromString(className);
        //把sub视图控制器创建出来
        UIViewController * VC = [[myClass alloc]init];
        //将子控制器加入到self里
        [self addChildViewController:VC];
        [self.viewControllers addObject:VC];
        //  默认,加载第一个视图
        [self addSubViewWithCurrentPage:0];
        self.currentPage = 0;
    }
}
//  切换各个标签内容
-(void)addSubViewWithCurrentPage:(NSInteger)currentPage
{
    if (self.viewControllers.count > currentPage) {
        UIView *currentView = self.viewControllers[currentPage].view;
        if (currentView.superview == nil) {
            CGFloat width = self.ydwSelectView.bgScrollView.bounds.size.width;
            CGFloat height = self.ydwSelectView.bgScrollView.bounds.size.height;
            
            currentView.frame = CGRectMake(width * currentPage, 0, width, height);
            [self.ydwSelectView.bgScrollView addSubview:currentView];
        }
    }
}
#pragma mark -- YDWSelectViewDelegate
-(void)YDWSelectView:(YDWSelectView *)selectView moveTableVorCollectionVWithTag:(NSInteger)tag
{
    NSLog(@"%ld",self.currentPage);
    //  点击处于当前页面的按钮,直接跳出
    if (self.currentPage == tag) {
        return;
    }
    [self.ydwSelectView.bgScrollView setContentOffset:CGPointMake(tag * XKScreenWidth, 0) animated:YES];
    
    [self addSubViewWithCurrentPage:tag];
    self.currentPage = tag;
    
}
//拖动self.ydwSelectView.bgScrollView的代理
-(void)YdwSelectViewWhenbottomScrollVDidEndDecelerating
{
    self.currentPage = self.ydwSelectView.bgScrollView.contentOffset.x / self.ydwSelectView.bgScrollView.frame.size.width;
    //加载subView
    [self addSubViewWithCurrentPage:self.currentPage];

}
#pragma mark -- 懒加载
-(YDWSelectView *)ydwSelectView
{
    if (!_ydwSelectView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _ydwSelectView = [[YDWSelectView alloc] initWithFrame:CGRectMake(0, 64, XKScreenWidth, XKScreenHeight - 64)];
        _ydwSelectView.delegate = self;
        NSMutableArray *tabNameArrM = [NSMutableArray array];
        for (NSInteger i = 0; i < 6; i++) {
            NSString *tabName = [NSString stringWithFormat:@"选项 %ld",i+1];
            [tabNameArrM addObject:tabName];
            
        }
        [_ydwSelectView setUpStatusButtonWithTitlt:tabNameArrM NormalColor:[UIColor blackColor] SelectedColor:[UIColor redColor] LineColor:[UIColor redColor]];
    }
    return _ydwSelectView;
}
@end
