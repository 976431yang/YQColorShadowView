//
//  ViewController2.m
//  YQShadowColor
//
//  Created by problemchild on 2016/11/25.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//

#import "ViewController.h"

#import "YQColorShadowView.h"


@interface ViewController ()

@property(nonatomic,strong)YQColorShadowView *shadowView;

@property(nonatomic,strong)NSArray *IMGArr;
@property (weak, nonatomic) IBOutlet UISlider *Slide_shadowAlpha;
@property (weak, nonatomic) IBOutlet UISlider *Slide_cornerWidth;
@property (weak, nonatomic) IBOutlet UISlider *Slide_shadowWidth;
@property (weak, nonatomic) IBOutlet UISwitch *Switch_showConer;

@property CGRect oldRect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //像常规UIView一样初始化。
    self.shadowView = [[YQColorShadowView alloc]initWithFrame:CGRectMake(0,
                                                                         50,
                                                                         self.view.frame.size.width-80,
                                                                         self.view.frame.size.width-80)];
    self.shadowView.center = CGPointMake(self.view.center.x, self.shadowView.center.y);
    
    //添加到view上显示
    [self.view addSubview:self.shadowView];
    
    //设置图片
    self.shadowView.image = [UIImage imageNamed:@"test2.PNG"];
    
    //--------------------------------------------------
    self.IMGArr = @[[UIImage imageNamed:@"test1.PNG"],
                    [UIImage imageNamed:@"test2.PNG"],
                    [UIImage imageNamed:@"test3.PNG"],
                    [UIImage imageNamed:@"test4.PNG"],
                    [UIImage imageNamed:@"white.PNG"]
                    ];
    
    self.oldRect = self.shadowView.frame;
    
    UIAlertView *alertDialog = [[UIAlertView alloc]
                   initWithTitle:@"请使用真机调试"
                   message:@"请使用真机调试,模拟器渲染速度会很慢"
                   delegate:nil
                   cancelButtonTitle:@"OK"
                   otherButtonTitles:nil];
    [alertDialog show];
}

-(void)test{
    
    [self.shadowView animationWithDuration:1
                                 viewFrame:CGRectMake(30, 30, 200, 200)
                               closeShadow:YES];
}


-(void)test2{
    [self.shadowView animationWithDuration:1
                                 viewFrame:CGRectMake(200, 50, 280, 280)
                               closeShadow:NO];
}
- (IBAction)changeIMG:(id)sender {
    int count = rand()%self.IMGArr.count;
    UIImage *img = self.IMGArr[count];
    
    self.shadowView.image = img;
}
- (IBAction)UpdateView:(id)sender {
    if(sender == self.Slide_shadowAlpha){
        self.shadowView.shadowAlpha = self.Slide_shadowAlpha.value;
    }else if (sender == self.Slide_shadowWidth){
        self.shadowView.shadowWidth = self.Slide_shadowWidth.value;
    }else if (sender == self.Slide_cornerWidth){
        self.shadowView.cornerWidth = self.Slide_cornerWidth.value;
    }else if (sender == self.Switch_showConer){
        self.shadowView.showCornerRadius = self.Switch_showConer.isOn;
    }
}
- (IBAction)closeShadowAndChangeFrame:(id)sender {
    [self.shadowView animationWithDuration:0.5
                                 viewFrame:CGRectMake(30,
                                                      30,
                                                      150,
                                                      150)
                               closeShadow:YES];
}
- (IBAction)openShadowAndBackFrame:(id)sender {
    [self.shadowView animationWithDuration:0.5
                                 viewFrame:self.oldRect
                               closeShadow:NO];
}
- (IBAction)ChangeFrame:(id)sender {
    [self.shadowView animationWithDuration:0.5
                                 viewFrame:CGRectMake(40,
                                                      50,
                                                      self.oldRect.size.width,
                                                      self.oldRect.size.height/2)
                               closeShadow:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
