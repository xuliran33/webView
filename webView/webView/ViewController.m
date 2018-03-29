//
//  ViewController.m
//  webView
//
//  Created by yuedao on 2018/3/23.
//  Copyright © 2018年 Yuedao. All rights reserved.
//

#import "ViewController.h"
#import "WKDekegateViewController.h"

//
@interface ViewController ()<WKNavigationDelegate, WKDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWeb;

@property (nonatomic, strong) WKWebViewConfiguration *config;
//@property (weak, nonatomic) IBOutlet WKWebView *wkWeb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.config = [[WKWebViewConfiguration alloc] init];
    
    self.config.preferences = [[WKPreferences alloc] init];
    self.config.preferences.minimumFontSize = 10;
    self.config.preferences.javaScriptEnabled = YES;
    
    self.config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    

    WKUserContentController *wkController = [[WKUserContentController alloc] init];
    
    [wkController addScriptMessageHandler:self name:@"HFAlert"];
    [wkController addScriptMessageHandler:self name:@"closeWindow"];
    self.config.userContentController = wkController;


    self.wkWeb = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:self.config];
    self.wkWeb.navigationDelegate = self;
    self.wkWeb.UIDelegate = self;
    
    [self.view addSubview:self.wkWeb];
    [self.wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://kylinweb.com/testWebView.html"]]];
    
    
    [self.wkWeb addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWeb addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWeb addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
    }else if ([keyPath isEqualToString:@"title"]){
        NSLog(@"title");
    }else if ([keyPath isEqualToString:@"estimatedProgress"]){
        NSLog(@"progress: %f", self.wkWeb.estimatedProgress);
    }
}

// js调用alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    completionHandler();
//    NSLog(@"弹窗: %@", message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"============%@", message.body);

    if ([message.name isEqualToString:@"HFAlert"]) {
        [self getWithString:message.body[@"body"]];
    }
    if ([message.name isEqualToString:@"closeWindow"]) {
        [self closeWindow];
    }
}

- (void)closeWindow{
    
}

- (void)getWithString:(NSString *)str{
    NSString *promptCode = [NSString stringWithFormat:@"iosExport(\"%@\")",str];
    [_wkWeb evaluateJavaScript:promptCode completionHandler:^(id _Nullable aaa, NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)dealloc{
    [self.config.userContentController removeScriptMessageHandlerForName:@"HFAlert"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
