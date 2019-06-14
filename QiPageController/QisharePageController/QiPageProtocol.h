//
//  QiPageProtocol.h
//  QiPageController
//
//  Created by qinwanli on 2019/6/14.
//  Copyright © 2019 qishare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol QiPageContentViewDelegate <NSObject>

/**
 滑动完成回调
 
 @param index 滑动至index
 */
- (void)pageContentViewDidScrollToIndex:(NSInteger)index beforeIndex:(NSInteger)beforeIndex;


@end

@protocol QiPageMenuViewDelegate <NSObject>

/**
 菜单点击了某个item
 
 @param index 点击了index
 */
- (void)pageMenuViewDidClickedIndex:(NSInteger)index beforeIndex:(NSInteger)beforeIndex;


@end


@interface QiPageProtocol : NSObject

@end

NS_ASSUME_NONNULL_END
