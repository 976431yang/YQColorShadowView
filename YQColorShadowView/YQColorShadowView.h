//
//  YQColorShadowView.h
//  YQShadowColor
//
//  Created by problemchild on 2016/11/25.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//

//注：请使用真机调试,模拟器渲染速度非常慢

#import <UIKit/UIKit.h>

@interface YQColorShadowView : UIView

//显示的图片
@property(nonatomic,strong)UIImage  *image;

//是否需要圆角
@property (nonatomic)BOOL showCornerRadius;

//圆角宽度
@property (nonatomic)CGFloat cornerWidth;

//阴影透明度
@property (nonatomic)CGFloat shadowAlpha;

//阴影宽度
@property (nonatomic)CGFloat shadowWidth;

//阴影稍稍向下一点，像苹果音乐的效果一样
@property (nonatomic)BOOL shadowLittleDown;

//不显示阴影
@property (nonatomic)BOOL closeShadow;

//动画 变形
//time动画时间，viewframe目标frame，closeShadow是否关闭阴影
//注：只会根据 最后一次渲染显示 的效果 进行缩放 来制作动画。
-(void)animationWithDuration:(float)time
                   viewFrame:(CGRect)viewFrame
                 closeShadow:(BOOL)closeShadow;

@end
