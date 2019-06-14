//
//  QiPageMenuView.h
//  QiPageController
//
//  Created by qinwanli on 2019/5/26.
//  Copyright © 2019 360. All rights reserved.
//
#import <UIKit/UIKit.h>

@class QiPageItem;

typedef NSString * QiPageMenuViewDataSourceKey NS_EXTENSIBLE_STRING_ENUM;

typedef CGFloat(^QiPageMenuViewDataSource)(void);

//dasource对应的各项属性
static QiPageMenuViewDataSourceKey const QiPageMenuViewLeftMargin = @"QiPageMenuViewLeftMargin";//!<左间距 @(10)
static QiPageMenuViewDataSourceKey const QiPageMenuViewRightMargin = @"QiPageMenuViewRightMargin";//!<右间距 @(10)
static QiPageMenuViewDataSourceKey const QiPageMenuViewItemsAutoResizing = @"QiPageMenuViewItemsAutoResizing";//!<是否自定义大小 @(YES)
static QiPageMenuViewDataSourceKey const QiPageMenuViewItemIsVerticalCentred = @"QiPageMenuViewItemIsVerticalCentred";//!<是否垂直居中 @(YES)
static QiPageMenuViewDataSourceKey const QiPageMenuViewItemPadding = @"QiPageMenuViewItemPadding";//!<间距 @(10)
static QiPageMenuViewDataSourceKey const QiPageMenuViewItemTopPadding = @"QiPageMenuViewItemTopPadding";//!<上间距 @(10) 居中
static QiPageMenuViewDataSourceKey const QiPageMenuViewItemHeight = @"QiPageMenuViewItemHeight";//!<高度 @(30)
static QiPageMenuViewDataSourceKey const QiPageMenuViewItemWidth = @"QiPageMenuViewItemWidth";//!<宽度-固定值 @(100) 就不能AutoResizing了
static QiPageMenuViewDataSourceKey const QiPageMenuViewHasUnderLine = @"QiPageMenuViewHasUnderLine";//!<是否有下划线
static QiPageMenuViewDataSourceKey const QiPageMenuViewNormalTitleColor = @"QiPageMenuViewNormalTitleColor";
static QiPageMenuViewDataSourceKey const QiPageMenuViewSelectedTitleColor = @"QiPageMenuViewSelectedTitleColor";
static QiPageMenuViewDataSourceKey const QiPageMenuViewTitleFont = @"QiPageMenuViewTitleFont";
static QiPageMenuViewDataSourceKey const QiPageMenuViewSelectedTitleFont = @"QiPageMenuViewSelectedTitleFont";
static QiPageMenuViewDataSourceKey const QiPageMenuViewLineColor = @"QiPageMenuViewLineColor";
static QiPageMenuViewDataSourceKey const QiPageMenuViewItemTitlePadding = @"QiPageMenuViewItemTitlePadding";
static QiPageMenuViewDataSourceKey const QiPageMenuViewLineTopPadding = @"QiPageMenuViewLineTopPadding";
static QiPageMenuViewDataSourceKey const QiPageMenuViewLineHeight = @"QiPageMenuViewLineHeight";
static QiPageMenuViewDataSourceKey const QiPageMenuViewLineWidth = @"QiPageMenuViewLineWidth";

@protocol QiPageMenuViewDelegate <NSObject>

/**
 菜单点击了某个item
 
 @param index 点击了index
 */
- (void)pageMenuViewDidClickedIndex:(NSInteger)index beforeIndex:(NSInteger)beforeIndex;

@end

@interface QiPageMenuView : UIScrollView
/**
 菜单栏点击事件:block回调
 */
@property (nonatomic,copy)void(^pageItemClicked)(NSInteger clickedIndex,NSInteger beforeIndex,QiPageMenuView *menu);

/**
 菜单栏点击事件:代理回调 若实现block代理不会走
 */
@property (nonatomic, weak) id<QiPageMenuViewDelegate> menuViewDelgate;
/**
 常态item的字体颜色
 */
@property (nonatomic,strong)UIColor *normalTitleColor;
/**
 选中item的字体颜色
 */
@property (nonatomic,strong)UIColor *selectedTitleColor;
/**
 常态item的字体
 */
@property (nonatomic,strong)UIFont *titleFont;
/**
 选中Item的字体
 */
@property (nonatomic,strong)UIFont *selectedTitleFont;
/**
 字体距离item两边的间距,itemsAutoResizing = YES时 设置有效
 */
@property (nonatomic,assign)CGFloat itemTitlePadding;
/**
 item距上的间距。itemIsVerticalCentred = NO的时候设置有效
 */
@property (nonatomic,assign)CGFloat itemTopPadding;

/**
 items的左边缩进
 */
@property (nonatomic,assign)CGFloat leftMargin;
/**
 items的右边缩进
 */
@property (nonatomic,assign)CGFloat rightMargin;
/**
 是否根据文字的长度自动计算item的width default YES
 */
@property (nonatomic,assign)BOOL itemsAutoResizing;
/**
 item是否垂直居中显示，默认yes;  itemTopPadding 与 lineTopPadding 不会生效；设置NO itemHeight会自适应高
 */
@property (nonatomic,assign)BOOL itemIsVerticalCentred;
/**
 item之间的间距
 */
@property (nonatomic,assign)CGFloat itemSpace;
/**
 每个item的高度
 */
@property (nonatomic,assign)CGFloat itemHeight;
/**
 每个item的宽度。itemsAutoResizing = YES不必赋值也可。反之必须给值。
 */
@property (nonatomic,assign)CGFloat itemWidth;
/**
 是否显示下划线 default YES
 */
@property (nonatomic,assign)BOOL hasUnderLine;
/**
 下划线颜色
 */
@property (nonatomic,strong)UIColor *lineColor;
/**
 下划线到item的间距
 */
@property (nonatomic,assign)CGFloat lineTopPadding;
/**
 下划线的高度
 */
@property (nonatomic,assign)CGFloat lineHeight;
/**
 下划线的宽度
 */
@property (nonatomic,assign)CGFloat lineWitdh;

/**
 pageController滑动完成
 */
@property (nonatomic,assign)NSInteger pageScrolledIndex;

/**
 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles dataSource:(NSDictionary<QiPageMenuViewDataSourceKey, id> *)dataSource;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles;
/**
 滑动到某一项
 
 @param pageItem item
 */
- (void)scrollToPageItem:(QiPageItem*)pageItem;
/*!
 @brief 更新标题数组
 @param items selectedIndex重置选中的item
 */
- (void)updateMenuViewWithNewItemArray:(NSArray *)items selectedIndex:(NSInteger)selectedIndex;

@end



@interface QiPageItem :UIView

@property (nonatomic,strong)UIButton *button;

@property (nonatomic,assign)BOOL selected;
/**
 文字两边的间距
 */
@property (nonatomic,assign)CGFloat padding;

/**
 自己计算宽度
 */
@property (nonatomic,assign)BOOL autoResizing;

/**
 按钮标题
 */
@property (nonatomic,copy)NSString *title;

/**
 常态item的字体颜色
 */
@property (nonatomic,strong)UIColor *normalTitleColor;
/**
 选中item的字体颜色
 */
@property (nonatomic,strong)UIColor *selectedTitleColor;
/**
 item的字体
 */
@property (nonatomic,strong)UIFont *titleFont;
/**
 选中Item的字体
 */
@property (nonatomic,strong)UIFont *selectedTitleFont;

//固定的宽度
-(instancetype)initWithFrame:(CGRect)frame widthAutoResizing:(BOOL)autoResizing title:(NSString*)title padding:(CGFloat)padding clicked:(void(^)(UIButton*button))itemClicked;

@end
