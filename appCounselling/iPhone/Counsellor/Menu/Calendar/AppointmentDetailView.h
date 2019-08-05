//
//  AppointmentDetailView.h
//  appCounselling
//
//  Created by MindCrew Technologies on 28/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AppointmentDetailView : UIView
{
    AppDelegate *appDelegate;
    UIView *viewDetailPopUp;
    
    UILabel *lblSessionLeft;
    UILabel *lblDate;
    UILabel *lblMode;
    UILabel *lblTimeInterval;
    
    UILabel *lblAppointmentOrder;

    int intSessionDuration;
}

- (void)setParameter:(NSDictionary *)dictAppointment;

@end
