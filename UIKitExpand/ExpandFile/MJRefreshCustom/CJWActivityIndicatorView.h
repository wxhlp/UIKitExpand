#import <UIKit/UIKit.h>
#import "SportsBallFile.h"
@interface CJWActivityIndicatorView : UIView
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat radius;
@property (nonatomic) UIColor *tintColor;
@property (nonatomic) UIView *backgroundView;
- (void)startAnimating;
- (void)stopAnimating;
@end