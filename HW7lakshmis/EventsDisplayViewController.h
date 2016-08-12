//
//  EventsDisplayViewController.h
//  HW7lakshmis
//
//  Created by Lakshmi Subramanian on 7/13/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocationManager.h>
#import "Social/Social.h"
#import "Accounts/Accounts.h"


@interface EventsDisplayViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>{
    SLComposeViewController *mySLComposer;

}
//lable to display the event details
@property (weak, nonatomic) IBOutlet UILabel *event;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)tweetPhoto:(id)sender;


@property (strong, nonatomic) CLLocationManager *locManager;
//NSString object that receives the details from the tableview
@property (strong, nonatomic) NSString *eventname;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *stopTime;
@property (strong, nonatomic) NSString *eventLocation;

//SLComposeViewController *mySLComposer;





@end
