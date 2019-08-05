//
//  AppCounselllingLiveChatViewController.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 27/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCounsellingChatView.h"
#import "BaseViewController.h"
#import "CallViewController.h"

@class AppDelegate;
@class MoodGraphView;
@interface AppCounselllingLiveChatViewController : BaseViewController<AppCounsellingChatViewDelegate, SINCallClientDelegate>
{
    UIImage *imgMoodGraph;
    
    MoodGraphView *viewMoodGraph;
    NSString *strMoodGraphURL;
    
    AppCounsellingChatView *viewMessageDetails;
    UITextField *txtFieldMessage;
    
}

@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSDictionary *dictAppointment;

@property(nonatomic, strong) CallViewController *CallVC;

@end
