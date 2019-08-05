//
//  CalendarViewController.h
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "CalenderView.h"

@interface CalendarViewController : BaseViewController <CalenderViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    CalenderView *viewCalender;
    
    UITableView *tblAppointment;
    NSMutableArray *arrAppointment;
    NSMutableArray *arrAppointmentKey;
    NSMutableArray *arrDateAppointment;
    NSMutableDictionary *dictAllAppointments;
    
    NSDate *selectedDate;
}

@property(nonatomic) NSString *strTitle;

- (void)setTodayDateToCalender;

@end
