//
//  QiPageMenuView.m
//  QiPageController
//
//  Created by qinwanli on 2019/5/26.
//  Copyright © 2019 360. All rights reserved.
//

#import "QiPageMenuView.h"
#import "UIView+frame.h"

@interface QiPageMenuView ()

@property (nonatomic,strong) UIView *underLineView;

@property (nonatomic,strong) NSArray<NSString*> *itemTitles;
@property (nonatomic,strong) NSArray *itemsArray;

@property (nonatomic,strong)NSMutableArray *itemsTempArray;

@end

@implementation QiPageMenuView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles {
    return [self initWithFrame:frame titles:titles dataSource:nil];
}
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles dataSource:(NSDictionary<QiPageMenuViewDataSourceKey, id> *)dataSource {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollsToTop = NO;
        self.itemsTempArray = [NSMutableArray array];
        _itemTitles = titles?:[NSArray array];
        _hasUnderLine =  [dataSource[QiPageMenuViewHasUnderLine] boolValue];
        _leftMargin   =  dataSource[QiPageMenuViewLeftMargin]?[dataSource[QiPageMenuViewLeftMargin] floatValue]:10.0;
        _rightMargin  =  dataSource[QiPageMenuViewRightMargin]?[dataSource[QiPageMenuViewRightMargin] floatValue]:10.0;
        _itemSpace    =  dataSource[QiPageMenuViewItemPadding]?[dataSource[QiPageMenuViewItemPadding] floatValue]:10.0;
        //需要固定宽时 此项必须赋值
        _itemWidth    =  dataSource[QiPageMenuViewItemWidth]?[dataSource[QiPageMenuViewItemWidth] floatValue]:0;
        _itemHeight   =  dataSource[QiPageMenuViewItemHeight]?[dataSource[QiPageMenuViewItemHeight] floatValue]:30;
        
        _itemTitlePadding = dataSource[QiPageMenuViewItemTitlePadding]?[dataSource[QiPageMenuViewItemTitlePadding] floatValue]:10;
        _itemsAutoResizing = dataSource[QiPageMenuViewItemsAutoResizing]!=nil?[dataSource[QiPageMenuViewItemsAutoResizing] boolValue]:YES;
        _itemIsVerticalCentred = dataSource[QiPageMenuViewItemIsVerticalCentred]!=nil?[dataSource[QiPageMenuViewItemIsVerticalCentred] boolValue]:YES;
        // _itemTopPadding 初始值10，需要根据实际情况计算得到
        _itemTopPadding = dataSource[QiPageMenuViewItemTopPadding]?[dataSource[QiPageMenuViewItemTopPadding] floatValue]:10;
        _hasUnderLine =   dataSource[QiPageMenuViewHasUnderLine]!=nil?[dataSource[QiPageMenuViewHasUnderLine] boolValue]:YES;
        _lineColor = dataSource[QiPageMenuViewLineColor]?dataSource[QiPageMenuViewLineColor]:[UIColor colorWithRed:12.0/255.0 green:216.0/255 blue:98.0/255.0 alpha:1];
        _lineHeight = dataSource[QiPageMenuViewLineHeight]?[dataSource[QiPageMenuViewLineHeight] floatValue]:2.0;
        _lineWitdh = dataSource[QiPageMenuViewLineWidth]?[dataSource[QiPageMenuViewLineWidth] floatValue]:_itemWidth;
        _lineTopPadding = dataSource[QiPageMenuViewLineTopPadding]?[dataSource[QiPageMenuViewLineTopPadding] floatValue]:4.0;
        _normalTitleColor = dataSource[QiPageMenuViewNormalTitleColor]?dataSource[QiPageMenuViewNormalTitleColor]:[UIColor colorWithRed:51.0/255.0 green:51.0/255 blue:51.0/255.0 alpha:1];
        _selectedTitleColor = dataSource[QiPageMenuViewSelectedTitleColor]?dataSource[QiPageMenuViewSelectedTitleColor]: [UIColor colorWithRed:51.0/255.0 green:51.0/255 blue:51.0/255.0 alpha:1];
        _titleFont = dataSource[QiPageMenuViewTitleFont]?dataSource[QiPageMenuViewTitleFont]:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _selectedTitleFont = dataSource[QiPageMenuViewSelectedTitleFont]?dataSource[QiPageMenuViewSelectedTitleFont]:[UIFont systemFontOfSize:24 weight:UIFontWeightMedium];;
        [self setUpItems];
    }
    
    return self;
}
#pragma override

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat leftMargin = self.leftMargin;
    CGFloat rightMargin = self.rightMargin;
    CGFloat itemSpace = self.itemSpace;
    CGFloat itemWidth = self.itemWidth;
    CGFloat itemHeight = self.itemHeight;
    BOOL itemsAutoResizing = self.itemsAutoResizing;
    BOOL itemIsVeticalCentred = self.itemIsVerticalCentred;
    CGFloat orignal_x = leftMargin;
    
    for (int i = 0 ; i < self.itemsArray.count; i ++) {
        QiPageItem *beforeItem = i>0?[self.itemsArray objectAtIndex:i-1]:[QiPageItem new];
        if (i>0) {
            orignal_x = CGRectGetMaxX(beforeItem.frame)+itemSpace;
        }
        QiPageItem *pageItem = self.itemsArray[i];
        pageItem.frame = CGRectMake(orignal_x, itemIsVeticalCentred?(self.frame.size.height-itemHeight)/2 : _itemTopPadding, itemWidth, itemHeight);
        pageItem.autoResizing = itemsAutoResizing;//根据字数确定宽度，需要根据实际情况确定一个label到item两边的间距；
        //pageItem.padding = 10;//default 10
        pageItem.title = self.itemTitles[i];
        pageItem.titleFont = self.titleFont;
        pageItem.selectedTitleFont = self.selectedTitleFont;
        pageItem.normalTitleColor = self.normalTitleColor;
        pageItem.selectedTitleColor = self.selectedTitleColor;
        pageItem.padding = self.itemTitlePadding;
        //更新布局
        [self refreshUnderLineViewPosition:pageItem];
        if (i==self.itemTitles.count-1) {
            self.contentSize = CGSizeMake(CGRectGetMaxX(pageItem.frame)+rightMargin, self.frame.size.height);
        }
    }
    
}
#pragma mark - private method
- (void)setUpItems {
    
    if (self.itemsTempArray.count > 0) {
        [self.itemsTempArray removeAllObjects];
    }
    
    CGFloat leftMargin = self.leftMargin;
    CGFloat rightMargin = self.rightMargin;
    CGFloat itemSpace = self.itemSpace;
    CGFloat itemWidth = self.itemWidth;
    CGFloat itemHeight = self.itemHeight;
    BOOL itemsAutoResizing = self.itemsAutoResizing;
    BOOL itemIsVeticalCentred = self.itemIsVerticalCentred;
    CGFloat orignal_x = leftMargin;
    
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < self.itemTitles.count; i++) {
        QiPageItem *beforeItem = i>0?[self.itemsTempArray objectAtIndex:i-1]:[QiPageItem new];
        if (i>0) {
            orignal_x = CGRectGetMaxX(beforeItem.frame)+itemSpace;
        }
        //不能只考虑item会垂直居中的情况，有时候可能需要Item向下偏移，so 要改
        QiPageItem *pageItem =
        [[QiPageItem alloc]initWithFrame:CGRectMake(orignal_x, itemIsVeticalCentred?(self.frame.size.height-itemHeight)/2:_itemTopPadding, itemWidth, itemHeight) widthAutoResizing:itemsAutoResizing title:self.itemTitles[i] padding:_itemTitlePadding clicked:^(UIButton *button) {
            
            NSInteger scrollIndex = [weakSelf.itemsTempArray indexOfObject:(QiPageItem*)button.superview];
            //滑动方向需要beforeIndex
            NSInteger beforeIndex = weakSelf.pageScrolledIndex;
            self.pageScrolledIndex = scrollIndex;
            if (weakSelf.pageItemClicked) {
                //调用之处设置了pageScrollIndex
                weakSelf.pageItemClicked(scrollIndex,beforeIndex,weakSelf);
            }else{
                
                if ([weakSelf.menuViewDelgate respondsToSelector:@selector(pageMenuViewDidClickedIndex:beforeIndex:)]) {
                    [weakSelf.menuViewDelgate pageMenuViewDidClickedIndex:[weakSelf.itemsTempArray indexOfObject:(QiPageItem*)button.superview]beforeIndex:beforeIndex];
                }
            }
        }];
        
        pageItem.selected = (i==0);
        [self addSubview:pageItem];
        [self refreshUnderLineViewPosition:pageItem];
        if (i==self.itemTitles.count-1) {
            self.contentSize = CGSizeMake(CGRectGetMaxX(pageItem.frame)+rightMargin, self.frame.size.height);
        }
        [self.itemsTempArray addObject:pageItem];
    };
    self.itemsArray = [self.itemsTempArray copy];
}
- (void)refreshUnderLineViewPosition:(QiPageItem*)pageItem
{
    if (self.hasUnderLine) {
        if (!self.underLineView.superview) {
            [self addSubview:self.underLineView];
        }
        if (pageItem.selected) {
            self.underLineView.width =  self.lineWitdh;
            self.underLineView.height = _lineHeight;
            self.underLineView.layer.cornerRadius = _lineHeight/2;
            self.underLineView.top = _itemIsVerticalCentred ? (self.height - _lineHeight) : (CGRectGetMaxY(pageItem.frame) + _lineTopPadding);
            [UIView animateWithDuration:.25 animations:^{
                self.underLineView.centerX = pageItem.centerX;
            } completion:^(BOOL finished) {
                
            }];
        }
    }else
    {
        if (self.underLineView.superview) {
            [self.underLineView removeFromSuperview];
        }
    }
    
}

#pragma mark - Public functions

- (void)scrollToPageItem:(QiPageItem*)pageItem {
    
    [self refreshUnderLineViewPosition:pageItem];
    
    if (self.contentSize.width <= self.width) {
        return;
    }
    
    CGRect originalRect = pageItem.frame;
    CGRect convertRect = [self convertRect:originalRect toView:self.superview];
    CGFloat targetX;
    CGFloat realMidX = CGRectGetMinX(originalRect)+CGRectGetWidth(originalRect)/2;
    if (CGRectGetMidX(convertRect) < CGRectGetMidX(self.frame)) {
        //是否需要右滑
        if (realMidX > CGRectGetMidX(self.frame)) {
            targetX = realMidX-CGRectGetMidX(self.frame);
        }else
        {
            targetX = 0;
        }
        [self setContentOffset:CGPointMake(targetX, 0) animated:YES];
        
    }else if(CGRectGetMidX(convertRect) > CGRectGetMidX(self.frame))
    {
        if (realMidX+CGRectGetMidX(self.frame)<self.contentSize.width) {
            targetX = realMidX-CGRectGetMidX(self.frame);
            
        }else
        {
            targetX = self.contentSize.width - CGRectGetMaxX(self.frame);
        }
        [self setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }
    
}

- (void)updateMenuViewWithNewItemArray:(NSArray *)items selectedIndex:(NSInteger)selectedIndex {
    
    if (items != nil && items.count > 0) {
        _itemTitles = items;
        if (self.subviews.count > 0) {
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        [self setUpItems];
        self.pageScrolledIndex = selectedIndex;
       
    }
    
}

#pragma mark - setter
- (void)setHasUnderLine:(BOOL)hasUnderLine
{
    _hasUnderLine = hasUnderLine;
    [self setNeedsLayout];
}
- (void)setItemSpace:(CGFloat)itemSpace
{
    _itemSpace = itemSpace;
    [self setNeedsLayout];
}
- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    [self setNeedsLayout];
}
- (void)setItemHeight:(CGFloat)itemHeight
{
    _itemHeight = itemHeight;
    CGFloat totalHeight = self.itemIsVerticalCentred ? _itemHeight + self.underLineView.height*2 : _itemHeight +_itemTopPadding+self.underLineView.height+self.lineTopPadding;
    if (totalHeight > self.height) {
        if (self.itemIsVerticalCentred) {
            self.height = _itemHeight + self.underLineView.height*2;
        }else{
            self.height = _itemHeight +_itemTopPadding+self.underLineView.height+self.lineTopPadding;
        }
    }
    [self setNeedsLayout];
}
- (void)setLeftMargin:(CGFloat)leftMargin
{
    _leftMargin = leftMargin;
    [self setNeedsLayout];
}
- (void)setRightMargin:(CGFloat)rightMargin
{
    _rightMargin = rightMargin;
    [self setNeedsLayout];
}
- (void)setItemsAutoResizing:(BOOL)itemsAutoResizing
{
    _itemsAutoResizing = itemsAutoResizing;
    [self setNeedsLayout];
}
- (void)setItemIsVerticalCentred:(BOOL)itemIsVerticalCentred
{
    _itemIsVerticalCentred = itemIsVerticalCentred;
    [self setNeedsLayout];
}
- (void)setItemTopPadding:(CGFloat)itemTopPadding{
    _itemTopPadding = itemTopPadding;
    [self setNeedsLayout];
}
- (void)setLineColor:(UIColor *)lineColor
{
    if (_lineColor!=lineColor) {
        _lineColor = lineColor;
        self.underLineView.backgroundColor = _lineColor;
    }
}
- (void)setLineHeight:(CGFloat)lineHeight{
    _lineHeight = lineHeight;
    //更新self的高度
    self.underLineView.height = _lineHeight;
    CGFloat totalHeight = self.itemIsVerticalCentred?_itemHeight + self.underLineView.height*2:_itemHeight +_itemTopPadding+self.underLineView.height+self.lineTopPadding;
    if (totalHeight > self.height) {
        if (self.itemIsVerticalCentred) {
            self.height = _itemHeight + self.underLineView.height*2;
        }else{
            self.height = _itemHeight +_itemTopPadding+self.underLineView.height+self.lineTopPadding;
        }
    }
    [self setNeedsLayout];
}
- (void)setLineTopPadding:(CGFloat)lineTopPadding
{
    _lineTopPadding = lineTopPadding;
    CGFloat totalHeight = self.itemIsVerticalCentred?_itemHeight + self.underLineView.height*2:_itemHeight +_itemTopPadding+self.underLineView.height+self.lineTopPadding;
    if (totalHeight > self.height) {
        if (self.itemIsVerticalCentred) {
            self.height = _itemHeight + self.underLineView.height*2;
        }else{
            self.height = _itemHeight +_itemTopPadding+self.underLineView.height+self.lineTopPadding;
        }
    }
    [self setNeedsLayout];
}
- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont !=titleFont) {
        _titleFont = titleFont;
        //更新布局
        [self setNeedsLayout];
    }
}
- (void)setSelectedTitleFont:(UIFont *)selectedTitleFont
{
    if (_selectedTitleFont!=selectedTitleFont) {
        _selectedTitleFont = selectedTitleFont;
        [self setNeedsLayout];
    }
}
- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    if (_normalTitleColor != normalTitleColor) {
        _normalTitleColor = normalTitleColor;
        [self setNeedsLayout];
        
    }
}
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    if (_selectedTitleColor != selectedTitleColor) {
        _selectedTitleColor = selectedTitleColor;
        [self setNeedsLayout];
    }
}


#pragma mark - pageScrolledIndex setter方法控制item滑动
- (void)setPageScrolledIndex:(NSInteger)pageScrolledIndex
{
    _pageScrolledIndex = pageScrolledIndex;
    QiPageItem *curPageItem = [self.itemsArray objectAtIndex:pageScrolledIndex];
    curPageItem.selected = YES;
    __weak typeof(self) weakSelf = self;
    [self.itemsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QiPageItem *pageObj = (QiPageItem*)obj;
        if (curPageItem!=pageObj&&pageObj.selected) {
            pageObj.selected = NO;
            //根据字体大小 需要重新计算frame button sizeToFit 只依据 normal下才能正确计算 所以在选中时需要同步改变下normal下的titleFont 算出正确的大小 再进行还原
            if (weakSelf.itemsAutoResizing){
                NSAttributedString *normaltitle = [[NSAttributedString alloc]initWithString:pageObj.title attributes:@{NSForegroundColorAttributeName:weakSelf.normalTitleColor,NSFontAttributeName:weakSelf.titleFont}];
                [pageObj.button setAttributedTitle:normaltitle forState:UIControlStateNormal];
                [pageObj.button sizeToFit];
                [pageObj layoutIfNeeded];
                
            }
        }
    }];
    [self scrollToPageItem:curPageItem];
    
}
#pragma mark - getter

- (UIView*)underLineView{
    if (!_underLineView) {
        _underLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _underLineView.backgroundColor = _lineColor;
    }
    return _underLineView;
}

- (void)dealloc
{
    NSLog(@"%@🔥🔥🔥🔥🔥🔥",NSStringFromClass(self.class));
}

@end


@interface QiPageItem ()

@property (nonatomic,assign)CGFloat buttonWidth;

@property (nonatomic, copy)void (^itemClicked) (UIButton *button);

@end
@implementation QiPageItem
-(instancetype)initWithFrame:(CGRect)frame widthAutoResizing:(BOOL)autoResizing title:(NSString*)title padding:(CGFloat)padding clicked:(void(^)(UIButton*button))itemClicked;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _autoResizing = autoResizing;
        _padding = padding;
        _title = title;
        _normalTitleColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255 blue:51.0/255.0 alpha:1];
        _selectedTitleColor = [UIColor colorWithRed:12.0/255.0 green:216.0/255 blue:98.0/255.0 alpha:1];
        _titleFont =_selectedTitleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _itemClicked = itemClicked;
        self.button = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:self.bounds];
            NSAttributedString *normaltitle = [[NSAttributedString alloc]initWithString:_title attributes:@{NSForegroundColorAttributeName:_normalTitleColor,NSFontAttributeName:_titleFont}];
            [btn setAttributedTitle:normaltitle forState:UIControlStateNormal];
            NSAttributedString *selectedtitle = [[NSAttributedString alloc]initWithString:_title attributes:@{NSForegroundColorAttributeName:_selectedTitleColor,NSFontAttributeName:_selectedTitleFont}];
            [btn setAttributedTitle:selectedtitle forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:self.button];
        self.buttonWidth = self.button.width;
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (_autoResizing) {
        static BOOL isCalculate = NO;
        if (!isCalculate) {
            isCalculate = YES;
            [self.button sizeToFit];
            CGRect cframe = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.button.width+_padding*2, self.height);
            self.frame = cframe;
            //! 每次重新计算button的width
            self.button.frame = self.bounds;
            isCalculate = NO;
        }
       
        
    }else
    {
        self.button.frame = self.bounds;
    }
}

#pragma mark - Action functions

- (void)buttonClicked:(UIButton*)btn {
    
     __weak typeof(self) weakSelf = self;
    
    if (!btn.isSelected) {
        weakSelf.selected = !btn.isSelected;
        if (_itemClicked) {
            _itemClicked(btn);
        }
    }
    //重新设置字体大小
    if (_autoResizing) {
        //根据字体大小 需要重新计算frame button sizeToFit 只依据 normal下才能正确计算 所以在选中时需要同步改变下normal下的titleFont 算出正确的大小 再进行还原
        NSAttributedString *normaltitle = [[NSAttributedString alloc]initWithString:_title attributes:@{NSForegroundColorAttributeName:_normalTitleColor,NSFontAttributeName:_selectedTitleFont}];
        [self.button setAttributedTitle:normaltitle forState:UIControlStateNormal];
        [self.button sizeToFit];
        self.buttonWidth = self.button.width;
        [self layoutIfNeeded];
        NSAttributedString *renormaltitle = [[NSAttributedString alloc]initWithString:_title attributes:@{NSForegroundColorAttributeName:_normalTitleColor,NSFontAttributeName:_titleFont}];
        [self.button setAttributedTitle:renormaltitle forState:UIControlStateNormal];
    
    }
}

- (void)setPadding:(CGFloat)padding{
    _padding = padding;
    [self layoutIfNeeded];
}
- (void)setAutoResizing:(BOOL)autoResizing
{
    _autoResizing = autoResizing;
    [self layoutIfNeeded];
}
- (void)setTitle:(NSString *)title
{
    if (_title!=title) {
        _title = title;
        NSAttributedString *normaltitle = [[NSAttributedString alloc]initWithString:_title attributes:@{NSForegroundColorAttributeName:_normalTitleColor,NSFontAttributeName:_titleFont}];
        [self.button setAttributedTitle:normaltitle forState:UIControlStateNormal];
        NSAttributedString *selectedtitle = [[NSAttributedString alloc]initWithString:_title attributes:@{NSForegroundColorAttributeName:_selectedTitleColor,NSFontAttributeName:_selectedTitleFont}];
        [self.button setAttributedTitle:selectedtitle forState:UIControlStateSelected];
        [self.button sizeToFit];
        self.buttonWidth = self.button.width;
        //需要更新布局
        [self layoutIfNeeded];
    }
}
- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont !=titleFont&&titleFont != nil) {
        _titleFont = titleFont;
        NSAttributedString *normaltitle = [[NSAttributedString alloc]initWithString:_title attributes:@{NSForegroundColorAttributeName:_normalTitleColor,NSFontAttributeName:_titleFont}];
        [self.button setAttributedTitle:normaltitle forState:UIControlStateNormal];
        [self.button sizeToFit];
        self.buttonWidth = self.button.width;
        //需要更新布局
        [self layoutIfNeeded];
    }
}
- (void)setSelectedTitleFont:(UIFont *)selectedTitleFont
{
    if (_selectedTitleFont != selectedTitleFont) {
        _selectedTitleFont = selectedTitleFont;
        NSAttributedString *selectedtitle = [[NSAttributedString alloc]initWithString:_title attributes:@{NSForegroundColorAttributeName:_selectedTitleColor,NSFontAttributeName:_selectedTitleFont}];
        [self.button setAttributedTitle:selectedtitle forState:UIControlStateSelected];
        [self.button sizeToFit];
        self.buttonWidth = self.button.width;
        //需要更新布局
        if (_autoResizing) {
            [self layoutIfNeeded];
        }
    }
}
- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    if (_normalTitleColor != normalTitleColor && normalTitleColor!=nil) {
        _normalTitleColor = normalTitleColor;
        NSAttributedString *normaltitle = [[NSAttributedString alloc]initWithString:_title attributes:@{NSForegroundColorAttributeName:_normalTitleColor,NSFontAttributeName:_titleFont}];
        [self.button setAttributedTitle:normaltitle forState:UIControlStateNormal];
    }
}
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    if (_selectedTitleColor != selectedTitleColor && selectedTitleColor!= nil) {
        _selectedTitleColor = selectedTitleColor;
        NSAttributedString *selectedtitle = [[NSAttributedString alloc]initWithString:_title attributes:@{NSForegroundColorAttributeName:_selectedTitleColor,NSFontAttributeName:_selectedTitleFont}];
        [self.button setAttributedTitle:selectedtitle forState:UIControlStateSelected];
    }
}
- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.button.selected = _selected;
    
}

@end
