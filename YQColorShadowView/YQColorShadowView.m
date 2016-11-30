//
//  YQColorShadowView.m
//  YQShadowColor
//
//  Created by problemchild on 2016/11/25.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//

#import "YQColorShadowView.h"
#import <GLKit/GLKit.h>

@interface YQColorShadowView()

//标记第一次显示
@property bool showed;

//显示图片的IMGV
@property(nonatomic,strong)UIImageView  *mainIMGV;

//mainIMGV下方的灰色Shadow，在白色图片的时候起作用。存在原因是因为中心IMGV需要masktobound（圆角）

@property(nonatomic,strong)UIView       *mainShadow;
//给mainShadow产生阴影的View，frame和mainIMGV，不用mainIMGV是因为动画需要（有时需要关闭阴影）

@property(nonatomic,strong)UIView       *mainShadowUp;

//彩色模糊阴影 背景
@property(nonatomic,strong)UIImageView  *backView;

//裁剪过的IMG，只裁剪一次。
@property(nonatomic,strong)UIImage      *cutIMG;

//初始backView的frame
@property CGRect shadowRect;

//初始IMGV的frame
@property CGRect IMGVRect;

//滤镜
@property(nonatomic,strong)CIFilter     *filter;
//context
@property(nonatomic,strong)CIContext    *context;

@end

@implementation YQColorShadowView

#pragma mark ---Set&Get
-(void)setImage:(UIImage *)image{
    _image = image;
    self.cutIMG = [self getThumbImageWithImage:_image andSize:self.bounds.size];
    if(self.showed){
        [self drawTheImage];
    }
}
-(void)setShowCornerRadius:(BOOL)showCornerRadius{
    _showCornerRadius = showCornerRadius;
    if(self.showed){
        [self drawTheImage];
    }
}
-(void)setCornerWidth:(CGFloat)cornerWidth{
    _cornerWidth = cornerWidth;
    if(self.showed){
        [self drawTheImage];
    }
}
-(void)setShadowAlpha:(CGFloat)shadowAlpha{
    _shadowAlpha = shadowAlpha;
    if(self.showed){
        [self drawTheImage];
    }
}
-(void)setShadowWidth:(CGFloat)shadowWidth{
    _shadowWidth = shadowWidth;
    if(self.showed){
        [self drawTheImage];
    }
}
-(void)setShadowLittleDown:(BOOL)shadowLittleDown{
    _shadowLittleDown = shadowLittleDown;
    if(self.showed){
        [self drawTheImage];
    }
}
-(void)setCloseShadow:(BOOL)closeShadow{
    _closeShadow = closeShadow;
    if(self.showed){
        [self drawTheImage];
    }
}


#pragma mark ---init-初始化
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    //默认参数
    self.showCornerRadius = YES;
    self.cornerWidth = 10;
    self.shadowAlpha = 1;
    self.shadowWidth = 40;
    self.shadowLittleDown = YES;
    self.closeShadow = NO;
    self.backgroundColor = [UIColor clearColor];
    self.showed = NO;
    self.layer.masksToBounds = NO;
    
    //opemGL
    EAGLContext *eaglctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.context = [CIContext contextWithEAGLContext:eaglctx
                                             options:@{kCIContextWorkingColorSpace:[NSNull null]}];
    
    //back
    self.backView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
    
    
    //mainshadow
    self.mainShadow = [[UIView alloc]initWithFrame:self.bounds];
    self.mainShadow.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mainShadow];
    self.mainShadowUp = [[UIView alloc]initWithFrame:self.bounds];
    self.mainShadowUp.backgroundColor = [UIColor whiteColor];
    self.mainShadowUp.layer.masksToBounds = YES;
    [self.mainShadow addSubview:self.mainShadowUp];
    
    //中心IMGV
    self.mainIMGV = [[UIImageView alloc]initWithFrame:self.bounds];
    self.mainIMGV.backgroundColor = [UIColor clearColor];
    self.mainIMGV.contentMode = UIViewContentModeScaleAspectFill;
    self.mainIMGV.layer.masksToBounds = YES;
    [self addSubview:self.mainIMGV];
    
    //创建filter滤镜
    self.filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [self.filter setDefaults];
    
    return self;
}

#pragma mark ---delegate-系统代理
-(void)drawRect:(CGRect)rect{
    [self drawTheImage];
    self.showed = YES;
}


#pragma mark ---showIMG-绘制显示图片
//计算&渲染&显示
-(void)drawTheImage{
    
    if(self.image != nil){
        //圆角
        if(self.showCornerRadius){
            self.mainIMGV.layer.cornerRadius = self.cornerWidth;
            self.mainShadowUp.layer.cornerRadius = self.cornerWidth;
        }else{
            self.mainIMGV.layer.cornerRadius = 0;
            self.mainShadowUp.layer.cornerRadius = 0;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mainShadow.frame = self.bounds;
            self.mainShadow.layer.shadowOffset = CGSizeMake(0, 0);
            self.mainShadow.layer.shadowOpacity = 0.6;
            self.mainShadow.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            self.mainShadow.layer.shadowRadius = self.shadowWidth/2;
            if((!self.mainIMGV.image)||(self.mainIMGV.image != self.cutIMG)){
                self.mainIMGV.image = self.cutIMG;
            }
            self.mainIMGV.frame = self.bounds;
            self.mainShadowUp.frame = self.mainIMGV.frame;
            self.IMGVRect = self.mainIMGV.frame;
        });
        
        CIImage *ciImage = [[CIImage alloc]initWithImage:self.cutIMG];
        [self.filter setValue:ciImage forKey:kCIInputImageKey];
        [self.filter setValue:[NSNumber numberWithFloat:self.shadowWidth] forKey:kCIInputRadiusKey];
        
        CGImageRef outputimage = [self.context createCGImage:self.filter.outputImage
                                                 fromRect:CGRectMake(-self.shadowWidth*4,
                                                                     -self.shadowWidth*4,
                                                                     (self.cutIMG.size.width+self.shadowWidth*4)*2,
                                                                     (self.cutIMG.size.height+self.shadowWidth*4)*2)];
        
        UIImage *outIMG = [UIImage imageWithCGImage:outputimage];
        CGImageRelease(outputimage);
        CGFloat bili = 1;
        
        if(self.cutIMG.size.width>=self.cutIMG.size.height){
            //按宽缩放
            bili = self.frame.size.width/self.cutIMG.size.width;
        }else{
            //按高缩放
            bili = self.frame.size.height/self.cutIMG.size.height;
        }
        bili = bili/2+0.001;
        
        CGFloat WHB = self.frame.size.width/self.frame.size.height;
        
        CGFloat showWidth = bili * outIMG.size.width;
        CGFloat showHeight = bili * outIMG.size.height / WHB;
        CGFloat showX = -(showWidth - self.frame.size.width)/2;
        CGFloat showY = -(showHeight - self.frame.size.height)/2;
        if(self.shadowLittleDown){
            showY = showY+10;
        }
        
        if(self.closeShadow){
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat width = showWidth *0.6;
                CGFloat height = showHeight *0.6 ;
                CGFloat x = -(width - self.frame.size.width)/2;
                CGFloat Y = -(height - self.frame.size.height)/2;
                self.backView.frame = CGRectMake(x, Y, width, height);
                self.mainShadow.frame = CGRectMake((self.bounds.size.width-self.bounds.size.width*0.5)/2,
                                                   (self.bounds.size.height-self.bounds.size.height*0.5)/2,
                                                   self.bounds.size.width*0.5,
                                                   self.bounds.size.height*0.5);
                self.mainShadowUp.frame = self.mainShadow.bounds;
                self.mainIMGV.frame = self.bounds;
                self.backView.image = outIMG;
                self.backView.alpha = self.shadowAlpha;
                self.shadowRect = CGRectMake(showX,
                                             showY,
                                             showWidth,
                                             showHeight);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backView.frame = CGRectMake(showX,
                                                 showY,
                                                 showWidth,
                                                 showHeight);
                self.backView.image = outIMG;
                self.backView.alpha = self.shadowAlpha;
                self.shadowRect = self.backView.frame;
            });
        }
    }else{
        NSLog(@"没有传入图片，不显示");
    }
}

#pragma mark ---裁剪图片
-(UIImage *)getThumbImageWithImage:(UIImage *)image andSize:(CGSize)Size{
    
    UIGraphicsBeginImageContextWithOptions(Size, NO, 0.0);
    
    CGRect rect = CGRectMake(0,
                             0,
                             Size.width,
                             Size.height);
    
    
    CGFloat bili_imageWH = image.size.width/image.size.height;
    CGFloat bili_SizeWH  = Size.width/Size.height;
    
    if (bili_imageWH > bili_SizeWH) {
        CGFloat bili_SizeH_imageH = Size.height/image.size.height;
        CGFloat height = image.size.height*bili_SizeH_imageH;
        CGFloat width = height * bili_imageWH;
        CGFloat x = -(width - Size.width)/2;
        CGFloat y = 0;
        rect = CGRectMake(x,
                          y,
                          width,
                          height);
    }else{
        CGFloat bili_SizeW_imageW = Size.width/image.size.width;
        CGFloat width = image.size.width * bili_SizeW_imageW;
        CGFloat height = width / bili_imageWH;
        CGFloat x = 0;
        CGFloat y = -(height - Size.height)/2;
        rect = CGRectMake(x,
                          y,
                          width,
                          height);
    }
    
    [[UIColor clearColor] set];
    UIRectFill(rect);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


#pragma mark ---动画
-(void)animationWithDuration:(float)time
                   viewFrame:(CGRect)viewFrame
                 closeShadow:(BOOL)closeShadow
{
    [UIView animateWithDuration:time animations:^{
        
        self.frame = viewFrame;
        
        CGRect shadowBeforeRect = self.shadowRect;
        CGRect IMGVBeforeRect   = self.IMGVRect;
        
        CGFloat widthBili = self.bounds.size.width / IMGVBeforeRect.size.width;
        CGFloat heightBili = self.bounds.size.height / IMGVBeforeRect.size.height;
        
        
        if(closeShadow){
            CGFloat width = shadowBeforeRect.size.width * widthBili*0.6;
            CGFloat height = shadowBeforeRect.size.height *heightBili *0.6 ;
            CGFloat x = -(width - self.frame.size.width)/2;
            CGFloat Y = -(height - self.frame.size.height)/2;
            self.backView.frame = CGRectMake(x, Y, width, height);
            self.mainShadow.frame = CGRectMake((self.bounds.size.width-self.bounds.size.width*0.5)/2,
                                               (self.bounds.size.height-self.bounds.size.height*0.5)/2,
                                               self.bounds.size.width*0.5,
                                               self.bounds.size.height*0.5);
            self.mainShadowUp.frame = self.mainShadow.bounds;
            self.mainIMGV.frame = self.bounds;
            
        }else{
            CGFloat width = shadowBeforeRect.size.width * widthBili;
            CGFloat height = shadowBeforeRect.size.height *heightBili ;
            CGFloat x = -(width - self.frame.size.width)/2;
            CGFloat Y = -(height - self.frame.size.height)/2;
            if(self.shadowLittleDown){
                Y = Y+(10*heightBili);
            }
            self.backView.frame = CGRectMake(x, Y, width, height);
            self.mainShadow.frame = self.bounds;
            self.mainShadowUp.frame = self.bounds;
            self.mainIMGV.frame = self.bounds;
        }
        
        
    }];
}


@end
