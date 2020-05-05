#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import <Firebase.h>


#import "ColorHeaderRGBType.h"
#import "FansHomeController.h"
@interface AppDelegate ()

@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [AVOSCloud setApplicationId:APP_ID clientKey:APP_KEY serverURLString:API_URL];
     [FIRApp configure];
     return YES;
}



-(void)didFinishLaunchregister:(NSDictionary*)initialProps{

    [[UITabBar appearance] setTintColor:UIColorRGB(AppMianColor)];
    [[UINavigationBar appearance] setBarTintColor:UIColorRGB(AppMianColor)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"PingFang-SC-Medium" size: 18], NSFontAttributeName, nil]];
     [[UITextField appearance] setTintColor:UIColorRGB(AppMianColor)];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"FansHomeController" bundle:nil];
    UINavigationController *rootViewController = [[UINavigationController alloc]initWithRootViewController:[story instantiateViewControllerWithIdentifier:@"HomeMain"]];
    self.window.rootViewController = rootViewController;
}


@end