; //
//  ViewController.m
//  appCounselling
//
//  Created by MindCrew Technologies on 23/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "ViewController.h"
#import "CounsellorHomeViewController.h"
#import "AgentHomeViewController.h"
#import "MenuView.h"
#import "CounsellingViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imgViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight)];
    //imgViewLogo.contentMode = UIViewContentModeCenter;
//    imgViewLogo.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testBg" ofType:@"png"]];
    imgViewLogo.backgroundColor = colorViewBg;
    [self.view addSubview:imgViewLogo];
    imgViewLogo = nil;
    
    //UIImageView *
    imgViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake((appDelegate.screenWidth-100)/2.0, 84, 100, 100)];
    //imgViewLogo.contentMode = UIViewContentModeCenter;
    imgViewLogo.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"180" ofType:@"png"]];
    imgViewLogo.layer.cornerRadius = 10.0;
    imgViewLogo.clipsToBounds = YES;
    imgViewLogo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imgViewLogo];
    imgViewLogo = nil;
    
    [self screenDesigning];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(isFromViewDidLoad==YES)
    {
        isFromViewDidLoad = NO;
        [self checkAlreadyLogedIn];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    txtFieldEmail.text = @"";
    txtFieldPassword.text = @"";

    [super viewWillDisappear:animated];
}

- (void)checkAlreadyLogedIn
{
    if(appDelegate.isNetAvailable)
    {
        NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
        NSString *strUsername = [defaultUser objectForKey:@"Username"];
        NSString *strPassword = [defaultUser objectForKey:@"Pin"];
        
        if(strUsername!=nil && strPassword!=nil)
        {
            txtFieldEmail.text = strUsername;
            txtFieldPassword.text = strPassword;
            
            [appDelegate removeChargementLoader];
            
            imgViewHideLogin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight)];
            //imgViewHideLogin.image = [UIImage imageNamed:@"loginBG.jpg"];
            imgViewHideLogin.image = [UIImage imageNamed:@"SplashImage.png"];
            imgViewHideLogin.backgroundColor = colorViewBg;
            [self.view addSubview:imgViewHideLogin];
            
            [self btnSignInClicked];
        }
        else
        {
            
        }
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *strToken = [userDefault objectForKey:@"Token"];
        NSLog(@"strToken = = %@", strToken);
        if(strToken!=nil)
        {
            [appDelegate saveTokenID:strToken];
        }
    }
    else
    {
        [self showInternetErrorMessage];
    }
}
- (void)screenDesigning
{
    UILabel *lblSignIn = [[UILabel alloc] init];
    lblSignIn.frame = CGRectMake(0, 220, appDelegate.screenWidth, 40);
    lblSignIn.text = @"Sign In";
    lblSignIn.textAlignment = NSTextAlignmentCenter;
    lblSignIn.textColor = colorWhiteOrBlack;
    lblSignIn.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:lblSignIn];
    
    float xRef = -2.0;
    float yRef = 260.0;
    float height = 40;
    float width = appDelegate.screenWidth+4;
    float ySpace = -1;

    txtFieldEmail = [[UITextField alloc] init];
    txtFieldEmail.delegate = self;
    txtFieldEmail.layer.borderColor = colorWhiteOrBlack.CGColor;
    txtFieldEmail.layer.borderWidth = 1.0;
    txtFieldEmail.backgroundColor = [UIColor clearColor];
    txtFieldEmail.leftViewMode = UITextFieldViewModeAlways;
    txtFieldEmail.textColor = colorWhiteOrBlack;
    UIImageView *imgL = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height/2, height)];
    imgL.contentMode = UIViewContentModeCenter;
    imgL.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"email" ofType:@"png"]];
    txtFieldEmail.leftView = imgL;
    txtFieldEmail.placeholder = @"Enter username";
    txtFieldEmail.frame = CGRectMake(xRef, yRef, width, height);
    txtFieldEmail.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:txtFieldEmail];
//    UIColor *color = [UIColor lightTextColor];
//    txtFieldEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];

    yRef = yRef+height+ySpace;
    
    txtFieldPassword = [[UITextField alloc] init];
    txtFieldPassword.delegate = self;
    txtFieldPassword.layer.cornerRadius = 1;
    txtFieldPassword.leftViewMode = UITextFieldViewModeAlways;
    txtFieldPassword.textColor = colorWhiteOrBlack;
    imgL = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height/2, height)];
    imgL.contentMode = UIViewContentModeCenter;
    imgL.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"password" ofType:@"png"]];
    txtFieldPassword.leftView = imgL;
    txtFieldPassword.placeholder = @"Enter pin";
    txtFieldPassword.frame = CGRectMake(xRef, yRef, width, height);
    txtFieldPassword.layer.borderColor = colorWhiteOrBlack.CGColor;
    txtFieldPassword.layer.borderWidth = 1.0;
    txtFieldPassword.backgroundColor = [UIColor clearColor];
    txtFieldPassword.returnKeyType = UIReturnKeyDone;
    txtFieldPassword.secureTextEntry = YES;
    txtFieldPassword.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:txtFieldPassword];
    
//    txtFieldPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Pin" attributes:@{NSForegroundColorAttributeName: color}];

    yRef = yRef+height+10;
    
    btnSignIn = [[UIButton alloc] init];
    btnSignIn.backgroundColor = colorHeader;
    //btnSignIn.titleLabel.textColor = colorWhiteOrBlack
    btnSignIn.frame = CGRectMake(xRef, yRef, width, height);
    [btnSignIn addTarget:self action:@selector(btnSignInClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnSignIn setTitle:@"Log in" forState:UIControlStateNormal];
    [self.view addSubview:btnSignIn];
    
}

- (void)btnSignInClicked
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    
    self.view.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    
    [UIView commitAnimations];
    
    [txtFieldEmail resignFirstResponder];
    [txtFieldPassword resignFirstResponder];
    
    //http://webilogic.com.md-in-16.webhostbox.net/HumbleBabies/Registration/name/email/password
    
    if (txtFieldEmail.text.length>0 && txtFieldPassword.text.length>0)
    {
//        NSString *str_email=txtFieldEmail.text;
//        NSString *emailEx =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//        NSPredicate *emailExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailEx];
//        BOOL emailValidation = [emailExPredicate evaluateWithObject:str_email];
//        
//        if (emailValidation)
        {
            if(appDelegate.isNetAvailable)
            {
                [appDelegate addChargementLoader];
                [self loginWebServiceCall];
            }
            else
            {
                [self showInternetErrorMessage];
            }
        }
//        else
//        {
//            [self showAlertMessage:@"Enter a valid email."];
//        }
    }
    else
    {
        [self showAlertMessage:@"Please enter username and pin."];
    }
}

- (void)loginWebServiceCall
{
    //    Request format: {
    //        "requestData": {
    //            "apikey": "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //            "requestType": "getLogin",
    //            "username": "Maria",
    //            "password": "1437"
    //        }
    //    }
    
    //  {"requestData":{"apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R","is_testing":"0","password":"1234","requestType":"getLogin","username":"sourabh01"}}

    //BlueMix
//    {
//        "requestData":{
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data":{
//                "clcnslrun01":"pyAtscTYswMf7aatrZ+gLQ\u003d\u003d",
//                "clpin01":"Ucf/glNoAYMipSRsuzx57Q\u003d\u003d"
//            },
//            "requestType":"getLogin"
//        }
//    }

    NSString *strUsername = [txtFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *strEncUsername = [super getEncryptedString:strUsername];
    NSString *strEncPassword = [super getEncryptedString:txtFieldPassword.text];
    
//    strEncUsername = @"pyAtscTYswMf7aatrZ+gLQ==";
//    strEncPassword = @"Ucf/glNoAYMipSRsuzx57Q==";
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];

    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strEncUsername, strEncPassword, nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01", @"clpin01", nil]];

    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getLogin", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];

    [dictParameter setObject:parameters forKey:@"requestData"];
    NSLog(@"Login = %@", dictParameter);
    
    [appCounsellingLoginParser sharedManager].strMethod = @"getLogin";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dictData in responseDict)
            {
                appDelegate.dictProfile = [[NSMutableDictionary alloc] init];
                
                if([dictData objectForKey:@"counsellor_firstname"] != nil)
                {
                    appDelegate.strFirstname = [dictData objectForKey:@"counsellor_firstname"];
                    if(appDelegate.strFirstname != nil)
                        [appDelegate.dictProfile setValue:[dictData objectForKey:@"counsellor_firstname"] forKey:@"firstname"];
                }
                [appDelegate.dictProfile setValue:[dictData objectForKey:@"clcnslrun01"] forKey:@"username"];
                [appDelegate.dictProfile setValue:[dictData objectForKey:@"clpin01"] forKey:@"Pin"];
                [appDelegate.dictProfile setValue:[dictData objectForKey:@"counc_unq_id"] forKey:@"counsellorid"];

                [appDelegate.dictProfile setValue:[dictData objectForKey:@"type"] forKey:@"type"];
//                [appDelegate.dictProfile setValue:[dictData objectForKey:@"profile_image"]?[dictData objectForKey:@"profile_image"]:@"" forKey:@"profile_image"];
                [appDelegate.dictProfile setValue:[dictData objectForKey:@"clemail01"] forKey:@"email"];

                [appDelegate.dictProfile setValue:[dictData objectForKey:@"agency_unq_id"] forKey:@"agencyId"];
                
                [appDelegate.dictProfile setValue:[dictData objectForKey:@"agency_name"] forKey:@"agency_name"];
                [appDelegate.dictProfile setValue:[dictData objectForKey:@"clcontct01"] forKey:@"clcontct01"];

                [appDelegate.dictProfile setValue:[dictData objectForKey:@"from"] forKey:@"from"];
                [appDelegate.dictProfile setValue:[dictData objectForKey:@"to"] forKey:@"to"];

                [appDelegate.dictProfile setValue:[dictData objectForKey:@"age_range_from"]?[dictData objectForKey:@"age_range_from"]:@"" forKey:@"age_range_from"];
                [appDelegate.dictProfile setValue:[dictData objectForKey:@"age_range_to"]?[dictData objectForKey:@"age_range_to"]:@"" forKey:@"age_range_to"];
                
                if(appDelegate.strFirstname == nil || [appDelegate.strFirstname isEqualToString:@""])
                {
                    appDelegate.strFirstname = [appDelegate.dictProfile objectForKey:@"username"];
                }

//                appDelegate.dictProfile = dictData;
                NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
                [defaultUser setObject:txtFieldEmail.text forKey:@"Username"];
                [defaultUser setObject:txtFieldPassword.text forKey:@"Pin"];
                [defaultUser setObject:[appDelegate.dictProfile objectForKey:@"counsellorid"] forKey:@"counsellorid"];
                [defaultUser setObject:[appDelegate.dictProfile objectForKey:@"type"] forKey:@"type"];
//                [defaultUser setObject:[appDelegate.dictProfile objectForKey:@"profile_image"]!=nil?[appDelegate.dictProfile objectForKey:@"profile_image"]:@"" forKey:@"profile_image"];
                [defaultUser setObject:[appDelegate.dictProfile objectForKey:@"email"] forKey:@"email"];
                
                NSString *strCounsellorID = [appDelegate.dictProfile objectForKey:@"username"];
                if(strCounsellorID)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginNotification"
                                                                        object:nil
                                                                      userInfo:@{
                                                                                 @"userId" : strCounsellorID
                                                                                 }];
                }
                break;
            }
            NSLog(@"Request sent");
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.dictProfile)
            {
                if(appDelegate.strFirstname == nil || [appDelegate.strFirstname isEqualToString:@""])
                {
                    if(imgViewHideLogin && imgViewHideLogin.superview)
                    {
                        [imgViewHideLogin removeFromSuperview];
                    }
                    
                    [appDelegate removeChargementLoader];

                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Login"
                                                                                              message: @"Input username and password"
                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = @"first name";
                        textField.textColor = [UIColor blueColor];
                        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                        textField.borderStyle = UITextBorderStyleRoundedRect;
                    }];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                        UITextField *firstTextField = [alertController.textFields firstObject];
                        appDelegate.strFirstname = [self getEncryptedString:firstTextField.text];

                        if(appDelegate.strFirstname == nil || [appDelegate.strFirstname isEqualToString:@""])
                        {
                            appDelegate.strFirstname = [appDelegate.dictProfile objectForKey:@"username"];
                        }

                        [self gotoTheHomeViewController];

                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else {
                    [appDelegate removeChargementLoader];
                    [self gotoTheHomeViewController];
                }
            }
            else
            {
                if(imgViewHideLogin && imgViewHideLogin.superview)
                {
                    [imgViewHideLogin removeFromSuperview];
                }

                [appDelegate removeChargementLoader];
                [self showAlertMessage:@"Please enter your correct Username and PIN."];
            }
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self loginWebServiceCall];
            }
            else {
                if(imgViewHideLogin && imgViewHideLogin.superview)
                {
                    [imgViewHideLogin removeFromSuperview];
                }
                [appDelegate removeChargementLoader];
                [self showAlertMessage:@"Please enter your correct Username and PIN."];
            }
        });
    }];
}

- (void)gotoTheHomeViewController
{
    if(imgViewHideLogin && imgViewHideLogin.superview)
    {
        [imgViewHideLogin removeFromSuperview];
    }

    if(appDelegate.dictProfile)
    {
        if([[appDelegate.dictProfile objectForKey:@"type"] isEqualToString:@"Counsellor"])
        {
            appDelegate.objCounsellorHomeVC = nil;            
            appDelegate.objCounsellorHomeVC = [[CounsellorHomeViewController alloc] init];
            [appDelegate.navControl pushViewController:appDelegate.objCounsellorHomeVC animated:NO];
//            if(appDelegate.isFromNotification)
//            {
//                appDelegate.isFromNotification = NO;
//                NSString *strAlert = appDelegate.strNotificationType;
//                if ([strAlert isEqualToString:@"1Hour"] || [strAlert isEqualToString:@"24Hour"] || [strAlert isEqualToString:@"Appoinment Accepted"])
//                {
//                    [appDelegate.objCounsellorHomeVC showThePage:@"Counselling"];
//                }
//                else if ([strAlert isEqualToString:@"New Appointment"])
//                {
//                    [appDelegate.objCounsellorHomeVC showThePage:@"Counselling"];
//                    [appDelegate.objCounsellorHomeVC.objCounsellingVC btnAcceptedPendingClicked:appDelegate.objCounsellorHomeVC.objCounsellingVC.btnPending];
//                }
//                else if ([strAlert isEqualToString:@"Time Suggestion"] || [strAlert isEqualToString:@"SameCounsellor NewAppoinment"])
//                {
//                    [appDelegate.objCounsellorHomeVC showThePage:@"Reschedule"];
//                }
//            }
        }
        else if([[appDelegate.dictProfile objectForKey:@"type"] isEqualToString:@"Agent"])
        {
            appDelegate.objAgentVC = [[AgentHomeViewController alloc] init];
//            appDelegate.objAgentVC.view.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
//            [self.view addSubview:appDelegate.objAgentVC.view];
            [appDelegate.navControl pushViewController:appDelegate.objAgentVC animated:YES];
        }
    }
}

#pragma  mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    
    if([textField isEqual:txtFieldEmail])
    {
        self.view.frame = CGRectMake(0, -100, appDelegate.screenWidth, appDelegate.screenHeight);
        //        [txtFieldPassword becomeFirstResponder];
    }
    else if([textField isEqual:txtFieldPassword])
    {
        self.view.frame = CGRectMake(0, -150, appDelegate.screenWidth, appDelegate.screenHeight);
        //        [txtFieldConfirmPassword becomeFirstResponder];
    }
    
    [UIView commitAnimations];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:txtFieldEmail])
    {
        //        self.view.frame = CGRectMake(0, -100, appDelegate.screenWidth, appDelegate.screenHeight);
        [txtFieldPassword becomeFirstResponder];
    }
    else if([textField isEqual:txtFieldPassword])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationRepeatCount:0];
        
        self.view.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        
        [UIView commitAnimations];
        
        [txtFieldPassword resignFirstResponder];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
