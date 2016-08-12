//
//  TwitterFeed.h
//  HW7lakshmis
//
//  Created by Lakshmi Subramanian on 7/14/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface TwitterFeed : UIViewController
<UITableViewDataSource, UITableViewDelegate>
//table view outlet
@property (strong, nonatomic) IBOutlet UITableView *tweetTableView;

@property (strong, nonatomic) NSArray *dataSource;
// NSURL object to store the image url
@property (strong,nonatomic) NSURL *imageURL;

@property (strong, nonatomic) NSString *media_url;

@end


