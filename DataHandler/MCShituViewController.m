//
//  MCShituViewController.m
//  mycity
//
//  Created by openapp on 15/5/28.
//  Copyright (c) 2015年 openapp. All rights reserved.
//

#import "MCShituViewController.h"
#import "MCShitu.h"

@interface MCShituViewController ()<MCShituDelegate, UIWebViewDelegate>
@end

@implementation MCShituViewController{
    UIWebView *webview;
    UIView *loading1;
    UIView *loading2;
    MCShitu *shitu;
}

+ (instancetype)createWebViewPageWithGPS:(CLLocationCoordinate2D)gps andImageUrl:(NSString *)imageUrl
{
    MCShituViewController *webView = [[MCShituViewController alloc] init];
    webView.gps = gps;
    webView.imageUrl = imageUrl;
    return webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    loading1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    [loading1 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:loading1];
    loading2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    [loading2 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:loading2];
    
    shitu = [[MCShitu alloc] init];
    shitu.delegate = self;
    [shitu fetchWithGPS:self.gps andImage:self.imageUrl];
    
    
    //self.navigationController.navigationBarHidden = NO;
    //self.navigationController.navigationBar.translucent = NO;
}

- (NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary
{
    NSMutableArray *parameterArray = [NSMutableArray array];
    
    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [self percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (void)doneWithShops:(NSString *)shops baidu:(NSString *)baidu sogou:(NSString *)sogou {
    webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webview.delegate = self;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.12.135.92/st/post.php"]];
    
    NSString *postStr = [shops stringByAppendingFormat:@"%@\t%@", baidu, sogou];
    NSDictionary *params = @{@"body": postStr};
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[self httpBodyForParamsDictionary:params]];
    
    
    [webview loadRequest:request];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view insertSubview:webview atIndex:0];
    [UIView animateWithDuration:0.5f animations:^(void){
        loading1.frame = CGRectMake(0, 0, loading1.frame.size.width, 0);
        loading2.frame = CGRectMake(0, self.view.bounds.size.height, loading2.frame.size.width, 0);
    } completion:^(BOOL finished){
        [loading1 removeFromSuperview];
        [loading2 removeFromSuperview];
    }];
    
}

@end;