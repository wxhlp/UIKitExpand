#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
typedef enum : NSInteger {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} NetworkStatus;
#pragma mark IPv6 Support
extern NSString *kReachabilityChangedNotification;
@interface GeologicalFluid : NSObject
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;
+ (instancetype)reachabilityForInternetConnection;
#pragma mark reachabilityForLocalWiFi
- (BOOL)fetchYesterdayCarelessHalt;
- (void)immigrateTowardsChangeableHedge;
- (NetworkStatus)currentReachabilityStatus;
- (BOOL)wasSalt;
@end