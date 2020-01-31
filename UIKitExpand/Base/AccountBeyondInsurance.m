#import "AccountBeyondInsurance.h"
#import "PourConsciousnessPassiveController.h"
#import "BriefThornController.h"
#import "ReportZealHandyController.h"
#import "HowUnlikelyUsageController.h"
#import "RetellFingernailController.h"
@interface AccountBeyondInsurance ()<UITabBarDelegate>
@property(nonatomic,strong)NSMutableArray*tabBarSource;
@property(nonatomic,strong)UIButton *wisdom;
@property(nonatomic,strong)UIImageView *tabBarBg;

@property (nonatomic,assign) NSInteger  indexFlag;;
@end
#define wisdom_width  60
#define wisdom_height 60
#define systemic_height 49
@implementation AccountBeyondInsurance



- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"开启启动了哦");
        [self addSubController];
    }
    return self;
}
-(NSMutableArray*)tabBarSource{
    if (!_tabBarSource) {
        _tabBarSource = [NSMutableArray new];
    }
    return _tabBarSource;
}
-(UIButton*)wisdom{
    if (!_wisdom) {
        _wisdom = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-wisdom_width)/2, systemic_height-wisdom_height, wisdom_width, wisdom_height)];
        _wisdom.userInteractionEnabled = NO;
        _wisdom.backgroundColor = [UIColor clearColor];
        _wisdom.titleLabel.font = [UIFont systemFontOfSize:10];
        _wisdom.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
        [_wisdom setImage:[UIImage imageNamed:@"Wisdom"]forState:UIControlStateNormal];
        _wisdom.contentMode =  UIViewContentModeCenter;
        [self.tabBar addSubview:_wisdom];
    }
    return _wisdom;
}
-(UIImageView*)tabBarBg{
    if (!_tabBarBg) {
        _tabBarBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
        _tabBarBg.image = [UIImage imageNamed:@"组-5"];
       _tabBarBg.contentMode = UIViewContentModeCenter;
        [self.tabBar addSubview:_tabBarBg];
    }
    return _tabBarBg;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)addSubController{
    PourConsciousnessPassiveController *homePage = [[PourConsciousnessPassiveController alloc]init];
    [self tabBarControllers:homePage  title:@"首页" imageUrl:@"icon-home"];
    BriefThornController *score = [[BriefThornController alloc]init];
    [self tabBarControllers:score title:@"规则" imageUrl:@"score"];
    RetellFingernailController *personal = [[RetellFingernailController alloc]init];
    [self tabBarControllers:personal title:@"我的" imageUrl:@"icon-account"];
    self.viewControllers = [self.tabBarSource copy];
}
-(void)tabBarControllers:(UIViewController*)controller title:(NSString*)title imageUrl:(NSString*)imageUrl{
    controller.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:imageUrl];
    UINavigationController *tabBar = [[UINavigationController alloc]initWithRootViewController:controller];
    [self.tabBarSource addObject:tabBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - UITabBarDelegate

//通过接收点击事件对每个tabbar item的点击都执行动画
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
  
     NSInteger index = [self.tabBar.items indexOfObject:item];
     DEBUG_NSLog(@"通过接收点击事件对每个tabbar=%@ %ld",item.title ,index);
 
}


-(void)beginAnimation{
       NSInteger index ;
        NSMutableArray *arry = [NSMutableArray array];
           for (UIView *btn in self.tabBar.subviews) {
               if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                    [arry addObject:btn];
               }
        }
       UIView *btnView = [arry objectAtIndex:index];
       CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
        animation.values = @[@0.0, @-4.15, @-7.26, @-9.34, @-10.37, @-9.34, @-7.26, @-4.15, @0.0, @2.0, @-2.9, @-4.94, @-6.11, @-6.42, @-5.86, @-4.44, @-2.16, @0.0];
        animation.duration = 0.8;
        animation.beginTime = CACurrentMediaTime()+1;
        [btnView.layer addAnimation:animation forKey:nil];
}

- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray<UITabBarItem *> *)items {
}
- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray<UITabBarItem *> *)items {
}
- (void)tabBar:(UITabBar *)tabBar willEndCustomizingItems:(NSArray<UITabBarItem *> *)items changed:(BOOL)changed {
}
- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray<UITabBarItem *> *)items changed:(BOOL)changed{
}
@end