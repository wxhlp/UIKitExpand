#import <UIKit/UIKit.h>
#import "AppUrlprotocol.h"

@interface CJWActivityIndicatorView : UIView
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat radius;
@property (nonatomic) UIColor *tintColor;
@property (nonatomic) UIView *backgroundView;
- (void)startAnimating;
- (void)stopAnimating;
@end
