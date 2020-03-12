//
//  ConservativePrejudiceView.h
//  Marbles
//
//  Created by hqtech on 2018/4/21.
//  Copyright © 2018年 tulip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConservativePrejudiceView : UIView

/**
 所在行
 */
@property (nonatomic, assign, readonly) NSInteger row;

/**
 所在列
 */
@property (nonatomic, assign, readonly) NSInteger col;

/**
 初始化成space x space大小的正方形图片

 @param space 宽、高
 */
- (instancetype)initWithSpace:(NSInteger)space;

#pragma mark 移动

/**
 向左移动
 */
- (void)starveAmongstAir;

/**
 向上移动
 */
- (void)wrestleAsIncident;

/**
 向右移动
 */
- (void)purelySophisticatedPane;

/**
 向下移动
 */
- (void)especiallyUnpleasantHorn;

@end






