# YQColorShadowView
彩色阴影 - 仿ios10系统音乐APP的专辑封面效果 - 根据图片颜色产生阴影

#### 微博：畸形滴小男孩
##### iOS端 彩色阴影 根据图片颜色产生阴影

### 效果：
 ![image](https://github.com/976431yang/YQColorShadowView/blob/master/DEMO/image/001.jpg) 
 ![image](https://github.com/976431yang/YQColorShadowView/blob/master/DEMO/image/002.jpg)</br>
如果图片边缘是白色，也会有灰色阴影：</br>
 ![image](https://github.com/976431yang/YQColorShadowView/blob/master/DEMO/image/003.jpg)

### 使用方法：
##### 直接拖到工程中
##### 引入
```objective-c
#import "YQColorShadowView.h"
```
##### 像普通UIiew一样 简单使用，会自动设定好默认参数
```objective-c
    //初始化
    YQColorShadowView *ShadowView = [[YQColorShadowView alloc]initWithFrame:CGRectMake(0,
                                                                                       0,
                                                                                       100,
                                                                                       100)];
    //设置图片
    ShadowView.image = [UIImage imageNamed:@"test.png"];
    
    //添加到View上显示
    [self.view addSubview:ShadowView];
```
##### 动画 改变frame、阴影
###### 注：此方法只会根据 最后一次渲染显示 的效果 进行缩放 来制作动画。
```objective-c
    [ShadowView animationWithDuration:动画时间
                            viewFrame:目标frame
                          closeShadow:是否关闭阴影];
```
###### 效果：
![image](https://github.com/976431yang/YQColorShadowView/blob/master/DEMO/image/animation.gif)
##### 自定义参数
###### 支持一些自定义参数，这些参数 如果在 view第一次显示后发生改变，会立即生效，并重新渲染一遍
###### 具体效果，可下载DEMO查看
```objective-c
    //更换图片
    ShadowView.image = [UIImage imageNamed:@"test.png"];
    //显示圆角
    ShadowView.showCornerRadius = YES;
    //圆角大小
    ShadowView.cornerWidth = 10;
    //彩色阴影的透明度0~1
    ShadowView.shadowAlpha = 1;
    //彩色阴影的宽度
    ShadowView.shadowWidth = 40;
    //像ios10系统音乐一样，阴影稍稍向下一点
    ShadowView.shadowLittleDown = YES;
    //关闭阴影
    ShadowView.closeShadow = NO;
```
