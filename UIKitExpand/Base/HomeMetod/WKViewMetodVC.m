
#import "WKViewMetodVC.h"
#import <WebKit/WebKit.h>


#import <MJRefresh.h>
#import "AppUrlprotocol.h"
#import "GeneralBanner.h"
#import "UnderlineDizzyTable.h"
#import "UIView+LoadState.h"
#import "NSString+IMAdditions.h"
#import "HttpNetWorkManager.h"
@interface WKViewMetodVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property(nonatomic,copy)WKWebView *webView;
@property(nonatomic,copy)NSString *metaUrl;

@property(nonatomic,strong)GeneralBanner*banner;
@property(nonatomic,strong)UIView * headerView;

@end

@implementation WKViewMetodVC

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


-(instancetype)initGetLoadWitheresponseObjectUrl:(NSString*)url banner:(NSArray*)banner{
    if(self = [super init]){
        [self.view showLoadStateWithMaskViewStateType:viewStateWithLoading];
        WS(weakSelf);
        [self.view loadStateReturnBlock:^(ViewStateReturnType viewStateReturnType) {
            if (viewStateReturnType == ViewStateReturnReloadViewDataType) {
                [weakSelf.view showLoadStateWithMaskViewStateType:viewStateWithLoading];
                [weakSelf getLoad:url];
            }
        }];
        [self getLoad:url];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor =  [UIColor whiteColor];
    [self webView];
    [self banner];
}

-(GeneralBanner*)banner{
    if (!_banner) {
        _banner = [GeneralBanner cycleScrollViewWithFrame:CGRectMake(0,IPHONE_X?88:64, SCREEN_WIDTH, 190) delegate:nil];
        [_banner setShowPageControl:YES];
        [_banner  setPageControlStyle:bannerPageContolStyleClassic];
        [_banner setPageControlAliment:bannerPageContolAlimentCenter];
        [_banner setAutoScrollTimeInterval:5.5f];
        [self.view addSubview:_banner];
    }
    return _banner;
}
-(WKWebView*)webView{
    if (!_webView) {
         _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, IPHONE_X?278:254, SCREEN_WIDTH, SCREEN_HEIGHT-(IPHONE_X?278:254)) configuration:[[WKWebViewConfiguration alloc] init]];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator=YES;
        _webView.scrollView.showsHorizontalScrollIndicator=NO;
//        _webView.scrollView.backgroundColor = [UIColor whiteColor];
       _webView.backgroundColor = [UIColor whiteColor];
       _webView.opaque = NO;
        [self.view addSubview:_webView];
        _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self->_webView reload];
        }];
    }
    return _webView;
}
- (void)getLoad:(NSString*)url{
    [[HttpNetWorkManager sharedManager] getNewsSportpath:url params:@{} completed:^(BOOL ret, id obj) {
            if (ret) {
                NSMutableArray*data = [[NSMutableArray alloc]init];
                 NSDictionary*  meta = [obj objectForKey:@"meta"];
                 NSDictionary*  body = [obj objectForKey:@"body"];
                NSString *  metaUrl = [meta objectForKey:@"id"];
               
             
                
                NSArray *banner = [body objectForKey:@"img"];
                for (NSDictionary *dic in banner) {
                      NSString *url = [dic objectForKey:@"url"];
                      [data addObject:url];
              
                }
                if ([metaUrl containsString:@"http"]) {
                                         
                      [[HttpNetWorkManager sharedManager] getNewsSportpath:metaUrl params:@{} completed:^(BOOL ret, id obj) {
                                NSDictionary*body = [obj objectForKey:@"body"];
                                if (ret) {
                                    NSString*html = body[@"text"];
                                    if (data.count>0|| [html isNull]) {
                                         [self.view dismessStateView];
                                         [[self banner] setArrayStringUrl:[data copy]];
                                         [self.webView loadHTMLString:html baseURL:nil];
                                    }else{
                                         [self.view showLoadStateWithMaskViewStateType:viewStateWithLoadError];
                                    }
                                }else{
                                     [self.view showLoadStateWithMaskViewStateType:viewStateWithLoadError];
                                }
                               }];
                            
                            }else{
                                 [self.view showLoadStateWithMaskViewStateType:viewStateWithLoadError];
                            }
                }else{
                     [self.view showLoadStateWithMaskViewStateType:viewStateWithLoadError];
                }
           }];
 
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
   [webView.scrollView.mj_header endRefreshing];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
     [webView.scrollView.mj_header endRefreshing];
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString*absoluteString = navigationResponse.response.URL.absoluteString;
    NSURL *URL = navigationResponse.response.URL;
    if ([absoluteString containsString:@"load_ty"]) {
        [[UIApplication sharedApplication]openURL:URL options:@{} completionHandler:^(BOOL success) {  }];
         decisionHandler(WKNavigationResponsePolicyCancel);
    }else{
         decisionHandler(WKNavigationResponsePolicyAllow);
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"--------\n%@", message.body);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
}

@end