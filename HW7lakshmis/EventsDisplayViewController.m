//
//  EventsDisplayViewController.m
//  HW7lakshmis
//
//  Created by Lakshmi Subramanian on 7/13/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import "EventsDisplayViewController.h"
#import "Social/Social.h"
#import "Accounts/Accounts.h"

@implementation EventsDisplayViewController

NSString *address;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.event.text = self.eventname;
    self.start.text = self.startTime;
    self.end.text = self.stopTime;
    self.location.text = self.eventLocation;
    address = self.eventLocation;
    [_event sizeToFit];
    [_location sizeToFit];
    
    self.title = self.eventname;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateSpan span = MKCoordinateSpanMake(1.25, 1.25);
                         MKCoordinateRegion region = MKCoordinateRegionMake(placemark.coordinate, span);
                         
                         // MKCoordinateRegion region = self.mapView.region;
                         region.center = [(CLCircularRegion *)placemark.region center];
                         region.span.longitudeDelta /= 100.0;
                         region.span.latitudeDelta /= 100.0;
                         
                         [self.mapView setRegion:region animated:YES];
                         [self.mapView addAnnotation:placemark];
                         
                         
                         
                     }
                 }
     ];
    
    _mapView.showsUserLocation = YES;
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
        return nil;
    }
    
    static NSString *reuseId = @"pin";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pinView.enabled = YES;
        pinView.canShowCallout = YES;
        pinView.tintColor = [UIColor orangeColor];
    }
    
    else {
        pinView.annotation = annotation;
    }
    
    return pinView;
    
}


- (IBAction)pushToTweet:(id)sender {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tweetPhoto:(id)sender {
    
    
    
   /* if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        
    {
        
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSDate *date = [[NSDate alloc]init];
        
        //Declare Date Formatter to format date according to problem
        
        //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
        
        //NSString *dateString = [dateFormatter stringFromDate:date];
        
        //NSString *OSVersion = (NSString *)[[UIDevice currentDevice] systemVersion];
        
        //NSString *DeviceInfo = (NSString *)[[UIDevice currentDevice] model];*/
        
        NSString *andrewID = @"lakshmis";
        NSString *mobileapp = @"@MobileApp4";
         // NSString *myString = @"abcdefg";
        //NSString *mySmallerString = [_stopTime substringToIndex:8];
    
    //NSLog(@"%@",mySmallerString);
    
    NSArray *split;
    NSString *stopstring;
    NSString *startstring;
    
    split = [self.stopTime componentsSeparatedByString:@","];
    stopstring = split[1];
    
    split = [self.startTime componentsSeparatedByString:@","];
    startstring = split[0];
    
    startstring = [startstring substringToIndex:(startstring.length - 3)];
    
    
    startstring = [startstring stringByAppendingString:split[1]];

    
    
    
    
    
    NSString *_str = [NSString stringWithFormat: @"%@ %@ %@ %@-%@ %@",mobileapp,andrewID,_eventname,startstring,stopstring,_eventLocation];
    
    NSLog(@"%@",_str);
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =
                 [arrayOfAccounts lastObject];
                 
                 
                 NSDictionary *message = @ {@"status": _str };
                 
                 NSURL *requestURL = [NSURL
                                      URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:message];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest
                  performRequestWithHandler:^(NSData *responseData,
                                              NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      NSLog(@"Twitter HTTP response: %i",
                            [urlResponse statusCode]);
                      
                      int response = [urlResponse statusCode];
                      
                      if(response == 200){
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle :@"Posted"
                                                message:@"Your tweet has been posted successfully"
                                                delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector
                           (show) withObject:nil waitUntilDone:YES];
                          
                      }
                      
                      if(response == 401){
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle :@"Not authorized"
                                                message:@"Incorrect or missing credentials"
                                                delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector
                           (show) withObject:nil waitUntilDone:YES];
                          
                      }
                      
                      
                      if(response == 403){
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle :@"Denied Access"
                                                message:@"The access is denied either because the event details are already tweeted or the length is greater than 140 "
                                                delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector
                           (show) withObject:nil waitUntilDone:YES];
                          
                      }
                      if(response == 500){
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle :@"Server Error"
                                                message:@"There seems to a issue posting your information.Please check your network connection and try again "
                                                delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector
                           (show) withObject:nil waitUntilDone:YES];
                          
                      }
                      
                      if(response == 502){
                          UIAlertView *alert = [[UIAlertView alloc]
                                                initWithTitle :@"Bad Gateway"
                                                message:@"Twitter server is down.Please try again later "
                                                delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
                          
                          [alert performSelectorOnMainThread:@selector
                           (show) withObject:nil waitUntilDone:YES];
                          
                      }
                      
                      
                  }];
                 
             }
             
             else{
                 UIAlertView *alert = [[UIAlertView alloc]
                                       initWithTitle :@"No account"
                                       message:@"You do not have a valid twitter account.Please setup up your account details in the Setting option and try again"
                                       delegate:self
                                       cancelButtonTitle:@"ok"
                                       otherButtonTitles:nil];
                 
                 [alert performSelectorOnMainThread:@selector
                  (show) withObject:nil waitUntilDone:YES];
                 
             }
         }
         else{
             UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle :@"Permission Denied"
                                   message:@"Access to the twitter account is denied"
                                   delegate:self
                                   cancelButtonTitle:@"ok"
                                   otherButtonTitles:nil];
             
             [alert performSelectorOnMainThread:@selector
              (show) withObject:nil waitUntilDone:YES];
             
         }
     }];
    

       // [tweetSheet setInitialText: [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",mobileapp,andrewID,_eventname,_startTime,_stopTime,_eventLocation]];
        
        /*[tweetSheet addImage:ImageView.image];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    } else {
        
        [self twitterExceptionHandling:@"Please Sign in to Twitter to post the picture"];
    }
}

-(void)twitterExceptionHandling:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"User pressed Cancel");
                                   }];
    
    UIAlertAction *settingsAction = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"Settings", @"Settings action")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         NSLog(@"Settings Pressed");
                                         
                                         //code for opening settings app in iOS 8
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                         
                                     }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    [self presentViewController:alertController animated:YES completion:nil];
*/
}



@end


