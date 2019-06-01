//
//  QiPageViewController.h
//  QiPageController
//
//  Created by qinwanli on 2019/5/26.
//  Copyright © 2019 360. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray*(^ChildViewControllers)(void);

//生成两个协议扔给实现协议的UIView类
@class QiPageViewController;

@protocol QiPageControllerDelegate <NSObject>

@required
/*!
 *@brief 绑定QiPageController的UIPageViewController对象给菜单视图
 *@param pagecontroller 控制器
 */
- (void)menuViewAssociatedQiPageController:(QiPageViewController*)pagecontroller;

/*!
 *@brief 菜单试图将要滑动至某个Index
 *@param index 索引
 *@param pagecontroller 翻页控制器
 */
- (void)menuViewShouldScrollIndex:(NSInteger)index PageController:(UIPageViewController*)pagecontroller;


@end

@interface QiPageViewController : UIViewController<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic,strong)UIPageViewController *pageViewController;

@property (nonatomic,strong)UIView<QiPageControllerDelegate> *titleView;

@property (nonatomic, strong) NSArray *controllerArray; //!< 控制器数组
@property (nonatomic, assign)CGFloat bottomInset;

/*!
 @brief 初始化方法
 @param childViewControllers block块
 @return 实例对象
 */
-(instancetype)initChildViewController:(ChildViewControllers)childViewControllers titleView:(UIView<QiPageControllerDelegate> *)titleView;

@end
