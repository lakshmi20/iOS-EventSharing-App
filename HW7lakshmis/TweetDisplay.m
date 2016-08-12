//
//  TweetDisplay.m
//  HW7lakshmis
//
//  Created by Lakshmi Subramanian on 7/14/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetDisplay.h"

@interface TwitterDisplay()

@end

@implementation TwitterDisplay

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"url,%@",self->_imageURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:self->_imageURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [self->_displayTweetWebView loadRequest:request];
    
    
}

/*-(void)viewDidLoad{
 [super viewDidLoad];
 NSLog(@"url,%@",self->_imageURL);
 NSURLRequest *request = [NSURLRequest requestWithURL:self->_imageURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
 
 [self->_displayTweetWebView loadRequest:request];
 
 }*/

/*-(void) viewDidLoad{
 [super viewDidLoad];
 NSURLRequest *request = [NSURLRequest requestWithURL:self->_imageURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
 NSLog(@"found URL: %@",self->_imageURL);
 [_displayTweetWebView loadRequest:request];*/


//}





@end


