//
//  FirstViewController.h
//  HW7lakshmis
//
//  Created by Lakshmi Subramanian on 7/12/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLCalendar.h"
//view controller to display the set of events in tableview

@class EventsDisplayViewController;

@interface FirstViewController : UITableViewController

@property (strong, nonatomic) EventsDisplayViewController *eventViewController;

@property (nonatomic, strong) GTLServiceCalendar *service;
@property (nonatomic, strong) UITextView *output;





@end

