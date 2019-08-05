//
//  CounsellorHomeViewController.h
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "MenuView.h"

@class LiveViewController, RescheduleViewController, CounsellingViewController, CalendarViewController, CounsellorAppointmentViewController;
@interface CounsellorHomeViewController : BaseViewController <MenuViewDelegate>
{
    UIButton *btnRefresh;
    
    LiveViewController *objLiveVC;
    RescheduleViewController *objRescheduleVC;
    CounsellingViewController *objCounsellingVC;
    CalendarViewController *objCalendarVC;
    CounsellorAppointmentViewController *objOldAppointmentVC;
    
    NSMutableDictionary *dictInfo;

}

@property(nonatomic, strong) LiveViewController *objLiveVC;
- (IBAction)Btn_Mute:(id)sender;
    @property(nonatomic, strong) RescheduleViewController *objRescheduleVC;
@property(nonatomic, strong) CounsellingViewController *objCounsellingVC;
@property(nonatomic, strong) CalendarViewController *objCalendarVC;

@property(nonatomic, strong) NSString *strTag;

- (void)showThePage:(NSString *)strPageName;
- (void)TestDemo:(NSString *)strpageName;
    
    
@end



