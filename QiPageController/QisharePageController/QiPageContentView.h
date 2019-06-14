//
//  QiPageContentView.h
//  QiPageController
//
//  Created by qinwanli on 2019/6/14.
//  Copyright © 2019 qishare. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QiPageContentViewDelegate <NSObject>

/**
 滑动完成回调
 
 @param index 滑动至index
 */
- (void)pageContentViewDidScrollToIndex:(NSInteger)index beforeIndex:(NSInteger)beforeIndex;


@end

@interface QiPageContentView : UIView<UIPageViewControllerDelegate, UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *controllerArray; //!< 控制器数组
/**
 滑动结束:block回调
 */
@property (nonatomic,copy)void(^pageContentViewDidScroll)(NSInteger currentIndex,NSInteger beforeIndex,QiPageContentView *pageView);

/**
 滑动结束:代理回调 若实现block代理不会走
 */
@property (nonatomic, weak) id<QiPageContentViewDelegate> contentViewDelgate;

/**
 设置滑动至某一个c控制器

 @param index index
 @param beforeIndex 控制方向
 */
- (void)setPageContentShouldScrollToIndex:(NSInteger)index beforIndex:(NSInteger)beforeIndex;

/**
 初始化方法

 @param frame frame
 @param childViewControllers childViewControllers
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame childViewController:(NSArray*)childViewControllers;

@end

NS_ASSUME_NONNULL_END
