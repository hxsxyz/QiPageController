//
//  QiPageViewController.m
//  QiPageController
//
//  Created by qinwanli on 2019/5/26.
//  Copyright © 2019 360. All rights reserved.
//

#import "QiPageViewController.h"

@interface QiPageViewController ()

@end

@implementation QiPageViewController

-(instancetype)initChildViewController:(ChildViewControllers)childViewControllers titleView:(UIView<QiPageControllerDelegate> *)titleView {
    
    self = [super init];
    
    if (self) {
        
        self.controllerArray = childViewControllers();
        //!添加标题栏
        self.titleView = titleView;
        
        [self.view addSubview:self.titleView];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (!self.titleView.superview) {
        [self.view addSubview:self.titleView];
    }
    self.pageViewController.view.frame = CGRectMake(0, self.titleView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.titleView.frame.size.height - self.bottomInset);
}


- (void)setTitleView:(UIView<QiPageControllerDelegate> *)titleView {
    
    if (_titleView!=titleView) {
        _titleView = titleView;
        //!根据菜单视图重置视图的frame
    }
    self.pageViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(self.titleView.frame)-self.bottomInset);
    if (!self.titleView.superview) {
        [self.view addSubview:self.titleView];
        if ([self.titleView respondsToSelector:@selector(menuViewAssociatedQiPageController:)]) {
            [self.titleView menuViewAssociatedQiPageController:self];
        }
    }
    
}


- (void)setControllerArray:(NSArray *)controllerArray {
    if (_controllerArray!=controllerArray) {
        _controllerArray = controllerArray;
    }
    if (_controllerArray.count) {
        [self.pageViewController setViewControllers:@[self.controllerArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - PrivateMethod


- (NSInteger)indexOfChildViewController:(UIViewController*)controller {
    return [self.controllerArray indexOfObject:controller];
}

#pragma mark - UIPageViewControllerDataSource


//! 前一个页面,如果返回为nil,那么UIPageViewController就会认为当前页面是第一个页面
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index = [self indexOfChildViewController:viewController];
    if (index==NSNotFound||index==0) {
        return nil;
    }
    
    return [self.controllerArray objectAtIndex:index-1];
}

//! 下一个页面,如果返回为nil,那么UIPageViewController就会认为当前页面是最后一个页面
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfChildViewController:viewController];
    if (index==NSNotFound||index==self.controllerArray.count-1) {
        
        return nil;
    }
    
    return [self.controllerArray objectAtIndex:index+1];
}
//!返回多少个控制器
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.controllerArray.count;
}
#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0) {
    
}
//滑动完成；
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    //获取滑动后的控制,
    UIViewController *afertViewcontroller = self.pageViewController.viewControllers.firstObject;
    //获取index变换titleItem;
    NSInteger index = [self indexOfChildViewController:afertViewcontroller];
    
    if ([self.titleView respondsToSelector:@selector(menuViewShouldScrollIndex:PageController:)]) {
        [self.titleView menuViewShouldScrollIndex:index PageController:pageViewController];
    }
}
#pragma mark - Getter
- (UIPageViewController*)pageViewController {
    if (!_pageViewController) {
        /*UIPageViewControllerOptionInterPageSpacingKey:滑动风格生效，表示滑动的子控制器之间的间距
         UIPageViewControllerOptionSpineLocationKey:翻页生效，值为枚举类型
         */
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:10] forKey:UIPageViewControllerOptionInterPageSpacingKey]];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        if (self.controllerArray.count) {
            [_pageViewController setViewControllers:@[self.controllerArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            }];
        }
    }
    
    return _pageViewController;
}

@end
