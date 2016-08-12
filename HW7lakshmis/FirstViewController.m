//
//  FirstViewController.m
//  HW7lakshmis
//
//  Created by Lakshmi Subramanian on 7/12/16.
//  Copyright © 2016 Lakshmi Subramanian. All rights reserved.
//

#import "FirstViewController.h"
#import "EventsDisplayViewController.h"

@interface FirstViewController ()

@property NSMutableArray *objects;

@end
//calendar api client id details
static NSString *const kKeychainItemName = @"Google Calendar API";
static NSString *const kClientID = @"148427413193-io6tr4v8bca9eoeqifkbj7l7m5t2qomv.apps.googleusercontent.com";


@implementation FirstViewController {
    
    NSMutableArray *eventsStart;
    
    NSMutableArray *eventsName;
    
    NSMutableArray *eventsEnd;
    
    NSMutableArray *eventsLocation;
    
    
}


- (void)viewDidLoad {
    
    eventsStart = [[NSMutableArray alloc] init];
    
    eventsEnd = [[NSMutableArray alloc] init];
    
    
    eventsName = [[NSMutableArray alloc] init];
    
    eventsLocation = [[NSMutableArray alloc] init];
    
    self.service = [[GTLServiceCalendar alloc] init];
    self.service.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientID
                                                      clientSecret:nil];
    
    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        [self presentViewController:[self createAuthController] animated:YES completion:nil];
        
    } else {
        
        [self fetchEvents];
        
    }
    [super viewDidLoad];
    
}
// When the view appears, ensure that the Google Calendar API service is authorized, and perform API calls.
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
}

// Construct a query and get a list of upcoming events from the user calendar. Display the
// start dates and event summaries in the UITextView.
- (void)fetchEvents {
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:@"5lr4v461mdd2pu55onfcu6prl8@group.calendar.google.com"];
    query.maxResults = 20;
    query.timeMin = [GTLDateTime dateTimeWithDate:[NSDate date]
                                         timeZone:[NSTimeZone localTimeZone]];;
    query.singleEvents = YES;
    query.orderBy = kGTLCalendarOrderByStartTime;
    
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

- (void)displayResultWithTicket:(GTLServiceTicket *)ticket
             finishedWithObject:(GTLCalendarEvents *)events
                          error:(NSError *)error {
    if (error == nil) {
        
        NSMutableString *eventString = [[NSMutableString alloc] init];
        if (events.items.count > 0) {
            
            [eventString appendString:@"Upcoming 20 events:\n"];
            
            for (GTLCalendarEvent *event in events) {
                GTLDateTime *start = event.start.dateTime ?: event.start.date;
                GTLDateTime *end = event.end.dateTime ?: event.end.date;
                NSString *startString =
                [NSDateFormatter localizedStringFromDate:[start date]
                                               dateStyle:NSDateFormatterShortStyle
                                               timeStyle:NSDateFormatterShortStyle];
                NSString *endString =[NSDateFormatter localizedStringFromDate:[end date]
                                                                    dateStyle:NSDateFormatterShortStyle
                                                                    timeStyle:NSDateFormatterShortStyle];
                NSString *location= event.location;
                
                [eventString appendFormat:@"%@ - %@, %@ at %@\n", startString,endString, event.summary, location];
                
                // append the contents of the string  in a array
                
                [eventsStart addObject: startString];
                
                [eventsEnd addObject: endString];
                
                [eventsName addObject: event.summary];
                
                [eventsLocation addObject: location];
                
                [self.tableView reloadData];
            }
        }
        
        else {
            [eventString appendString:@"There is no upcoming events."];
        }
        
    }
    
    else
    {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}

// Creates the auth controller for authorizing access to Google Calendar API.
- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeCalendarReadonly, nil];
    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:kClientID
                      clientSecret:nil
                      keychainItemName:kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and update the Google Calendar API
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        self.eventViewController = [segue destinationViewController];
    
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return eventsName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.frame = CGRectMake(3,
                            3,
                            self.tableView.frame.size.width,
                            cell.frame.size.height);
    
    cell.textLabel.text = [eventsName objectAtIndex:indexPath.row];
    //enter the event related details in the sub title portion of the tableview.
    
    NSString *subLabel = [@"\rStart Time: " stringByAppendingString:[eventsStart objectAtIndex:indexPath.row]];
    subLabel = [subLabel stringByAppendingString:@"\rStop Time: "];
    
    subLabel = [subLabel stringByAppendingString: [eventsEnd objectAtIndex:indexPath.row]];
    
    subLabel = [subLabel stringByAppendingString:@"\rLocation: "];
    
    subLabel = [subLabel stringByAppendingString: [eventsLocation objectAtIndex:indexPath.row]];
    
    cell.detailTextLabel.text = subLabel;
    
    subLabel = nil;
    
    
    return cell;
}

/*

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
 
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // self.detailViewController.detailItem =  [NSMutableDictionary dictionaryWithObject:_eventDate[indexPath.row] forKey:_eventName[indexPath.row]];
    
    self.eventViewController.eventname = eventsName[indexPath.row];
    
    self.eventViewController.startTime = eventsStart[indexPath.row];
    
    self.eventViewController.stopTime = eventsEnd[indexPath.row];
    
    self.eventViewController.eventLocation = eventsLocation[indexPath.row];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
