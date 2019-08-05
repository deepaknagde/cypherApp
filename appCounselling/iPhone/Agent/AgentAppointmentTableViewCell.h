//
//  AgentAppointmentTableViewCell.h
//  appCounselling
//
//  Created by MindCrew Technologies on 08/03/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@interface AgentAppointmentTableViewCell : UITableViewCell
{
    AppDelegate *appDelegate;

    NSThread *_thread1;
    UIActivityIndicatorView *indicator1;
    
    UILabel *lblCounsellor;
    UILabel *lblUser;
    UILabel *lblDate;
    UILabel *lblMode;
    UILabel *lblStatus;
    UILabel *lblSession;
}

- (void)showAppointments:(NSDictionary *)dictAppointment;
- (void)showCounsellorName:(NSString *)strCounsellorId;

@end
