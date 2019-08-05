//
//  ViewController.h
//  appCounselling
//
//  Created by MindCrew Technologies on 23/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "appCounsellingLoginParser.h"

@interface ViewController : BaseViewController <UITextFieldDelegate, appCounsellingLoginParserDelegate>
{
    UITextField *txtFieldEmail;
    UITextField *txtFieldPassword;
    UIButton *btnSignIn;
    
    UIImageView *imgViewHideLogin;
}

@end

