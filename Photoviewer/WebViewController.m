//
//  WebViewController.m
//  Photoviewer
//
//  Created by Group10 on 11/24/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController


- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
    if (_url) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_url];
        NSLog(@"loadRequest: %@", req);
        [(UIWebView *)self.view loadRequest:req];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
    return io == UIInterfaceOrientationPortrait;
}

@end
