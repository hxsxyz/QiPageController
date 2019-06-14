//
//  QiPageContentView.m
//  QiPageController
//
//  Created by qinwanli on 2019/6/14.
//  Copyright © 2019 qishare. All rights reserved.
//

#import "QiPageContentView.h"
#import "UIView+frame.h"
@interface QiPageContentView ()

@property (nonatomic, strong) UIScrollView *scrollView;
//! 记录前一个页面的index
@property (nonatomic, assign) NSInteger beforeIndex;

@end
@implementation QiPageContentView

- (instancetype)initWithFrame:(CGRect)frame childViewController:(NSArray*)childViewControllers;
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.controllerArray = childViewControllers;
        self.pageViewController.view.frame = self.bounds;
        if ([self.pageViewController.view.subviews.firstObject isKindOfClass:[UIScrollView class]]) {
            _scrollView = self.pageViewController.view.subviews.firstObject;
            _scrollView.delegate = self;
            
        }
    }
    return self;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if ([self viewController]!= nil) {
        [[self viewController] addChildViewController:self.pageViewController];
    }
    
}
#pragma mark - Public functions

- (void)setPageContentShouldScrollToIndex:(NSInteger)index beforIndex:(NSInteger)beforeIndex{
    __weak typeof(self) weakPage = self;
    //翻页顺序控制
    if (beforeIndex < index) {
        [weakPage.pageViewController setViewControllers:@[weakPage.controllerArray[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            if (finished) {
                weakPage.beforeIndex = index;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakPage.pageViewController setViewControllers:@[weakPage.controllerArray[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
                });
                
            }
        }];
    }else{
        [weakPage.pageViewController setViewControllers:@[weakPage.controllerArray[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            if (finished) {
                 weakPage.beforeIndex = index;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakPage.pageViewController setViewControllers:@[weakPage.controllerArray[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
                });
                
            }
        }];
    }
};

#pragma mark - Private functions

- (UIViewController*)viewController
{
    UIResponder *responder = self.nextResponder;
    while (responder!=nil) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)responder;
        }
        responder = responder.nextResponder;
    }
    return nil;
}

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
    if (self.pageContentViewDidScroll) {
        self.pageContentViewDidScroll(index, _beforeIndex, self);
    } else {
        if ([self.contentViewDelgate respondsToSelector:@selector(pageContentViewDidScrollToIndex:beforeIndex:)]) {
            [self.contentViewDelgate pageContentViewDidScrollToIndex:index beforeIndex:_beforeIndex];
        }
    }
    _beforeIndex = index;

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /*scrollView.contentOffset.x起始点并不是0，向右：是从控件的宽开始 到宽*2结束  向左：控件的宽->0
     因此会得到一个滑动的百分比。
     */
//    float trasitionProgress = (scrollView.contentOffset.x - self.width)/self.width;
//    NSLog(@"%.2f",trasitionProgress);
}

#pragma mark - Getter
- (UIPageViewController*)pageViewController {
    if (!_pageViewController) {
        /*UIPageViewControllerOptionInterPageSpacingKey:滑动风格生效，表示滑动的子控制器之间的间距
         UIPageViewControllerOptionSpineLocationKey:翻页生效，值为枚举类型
         */
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:0] forKey:UIPageViewControllerOptionInterPageSpacingKey]];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        [self addSubview:_pageViewController.view];
        if (self.controllerArray.count) {
            [_pageViewController setViewControllers:@[self.controllerArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            }];
        }
    }
    
    return _pageViewController;
}

#pragma mark - setter

- (void)setControllerArray:(NSArray *)controllerArray {
    if (_controllerArray!=controllerArray) {
        _controllerArray = controllerArray;
    }
    if (_controllerArray.count) {
        _beforeIndex = 0;
        [self.pageViewController setViewControllers:@[self.controllerArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        }];
    }
}

- (void)dealloc{
    NSLog(@"%@🔥🔥🔥🔥",NSStringFromClass(self.class));
}

@end
