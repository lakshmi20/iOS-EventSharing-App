//
//  TweetDisplay.h
//  HW7lakshmis
//
//  Created by Lakshmi Subramanian on 7/14/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface TwitterDisplay : UIViewController<UIWebViewDelegate>{
    
    NSURL *imageURL;
}

@property (weak, nonatomic) IBOutlet UIWebView *displayTweetWebView;

@property (weak,nonatomic) NSURL *imageURL;

//@property (nonatomic,retain) NSURL *imageURL;
@end


