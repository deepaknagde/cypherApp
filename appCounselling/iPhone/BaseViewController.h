//
//  BaseViewController.h
//  appCounselling
//
//  Created by MindCrew Technologies on 23/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "AppDelegate.h"

#define isDevelopmentModeOn NO

//#define colorHeader [UIColor colorWithRed:32/255.0f green:62/255.0f blue:75/255.0f alpha:1.0]
//#define colorViewBg [UIColor colorWithRed:26/255.0f green:52/255.0f blue:64/255.0f alpha:1.0]
#define colorHeader [UIColor colorWithRed:50/255.0f green:177/255.0f blue:160/255.0f alpha:1.0]
#define colorViewBg [UIColor colorWithRed:226/255.0f green:230/255.0f blue:220.0f/255.0f alpha:1.0]

#define colorWhiteOrBlack [UIColor blackColor]

//let colorHeader : UIColor = UIColor(red: CGFloat(50.0 / 255), green: CGFloat(177.0 / 255), blue: CGFloat(160 / 255.0), alpha: CGFloat(1))
//let colorSubHeader : UIColor = UIColor(red: CGFloat(55.0 / 255), green: CGFloat(194.0 / 255), blue: CGFloat(184 / 255.0), alpha: CGFloat(1))
//let colorViewBg : UIColor = UIColor.init(colorLiteralRed: 226.0/255, green: 230.0/255, blue: 220.0/255, alpha: 1.0)

#define strKeyWebService @"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R"

@interface BaseViewController : UIViewController
{
    AppDelegate *appDelegate;

    UILabel *lblTitle;
    UIView *viewTopBar;
    UIButton *btnMenu;
    UIButton *btnBack;
    UIButton *btnTimeIncreament;
    
    BOOL isFromViewDidLoad;
}

@property(nonatomic) UILabel *lblTitle;

- (void)designTopBar;
- (void)showBackButton;
- (void)showMenuButton;

- (void)showInternetErrorMessage;
- (void)showAlertMessage:(NSString *)strMessage;

- (BOOL)isiOS8OrAbove;
- (void)showBackButtonNoBar;
- (void)btnBackClicked;

-(NSString *)getEncryptedString:(NSString *)strString;
- (NSString *)getDycryptString:(NSString *)secret;
@end
