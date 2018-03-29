//
//  WKDekegateViewController.h
//  webView
//
//  Created by yuedao on 2018/3/23.
//  Copyright © 2018年 Yuedao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol WKDelegate <NSObject>

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@interface WKDekegateViewController : UIViewController<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKDelegate> delegate;

@end
