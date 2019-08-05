//
//  AgentHomeViewController.m
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "AgentHomeViewController.h"
#import "AgentParser.h"
#import "appCounsellingLoginParser.h"
#import "AgentAppointmentTableViewCell.h"
#import "AssessmentForm_VC.h"

@interface AgentHomeViewController ()

@end

@implementation AgentHomeViewController

- (void)clearMemory
{
    appDelegate.viewMenuPanal.delegate = nil;
    appDelegate.viewMenuPanal = nil;

    txtFieldAgentPointName.delegate = nil;
    txtFieldAgentMobileNumber.delegate = nil;
    txtFieldNameOfYP.delegate = nil;
    txtFieldMobileNumberYP.delegate = nil;
    txtFieldNumberOfSession.delegate = nil;

    txtFieldAgentPointName = nil;
    txtFieldAgentMobileNumber = nil;
    txtFieldNameOfYP = nil;
    txtFieldMobileNumberYP = nil;
    txtFieldNumberOfSession = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignAllTextField];
    [self hidePickerView];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    
    self.view.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    
    [UIView commitAnimations];

}
- (void)resignAllTextField
{
    [txtFieldAgentPointName resignFirstResponder];
    [txtFieldAgentMobileNumber resignFirstResponder];
    [txtFieldNameOfYP resignFirstResponder];
    [txtFieldMobileNumberYP resignFirstResponder];
    [txtFieldNumberOfSession resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    arrAppointment = [[NSMutableArray alloc] init];
    
    
    strCountryCode = @"44";
    strCountryCodeYP = @"44";
    strCountryCodeAgent = @"44";

    UIImageView *imgViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake((appDelegate.screenWidth-100)/2.0, 80, 100, 100)];
    imgViewLogo.layer.cornerRadius = 10.0;
    imgViewLogo.clipsToBounds = YES;
    //imgViewLogo.contentMode = UIViewContentModeCenter;
    imgViewLogo.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"180" ofType:@"png"]];
    imgViewLogo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imgViewLogo];
    imgViewLogo = nil;
    
    [self screenDesigning];
    [self designPickerView];
    [self designMenu];
    self.view.backgroundColor = colorViewBg;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)designMenu
{
    if(appDelegate.viewMenuPanal==nil)
    {
        appDelegate.viewMenuPanal = [[MenuView alloc] init];
        appDelegate.viewMenuPanal.delegate = self;
        appDelegate.viewMenuPanal.tblMenuPanal.tag = 1001;
        [appDelegate.viewMenuPanal.tblMenuPanal reloadData];
        appDelegate.viewMenuPanal.frame = CGRectMake(-appDelegate.screenWidth, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        //        appDelegate.viewMenuPanal.tblMenuPanal.backgroundColor = colorHeader;
        //        if(appDelegate.dictProfile==nil)
        //            [appDelegate.viewMenuPanal callwebServiceForProfileDetails];
        //        else
        //            [appDelegate.viewMenuPanal setProfileParameter];
        
        appDelegate.viewMenuPanal.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [self.view addSubview:appDelegate.viewMenuPanal];
        
        UIButton *btnHideMenu = [[UIButton alloc] init];
        btnHideMenu.backgroundColor = [UIColor clearColor];
        btnHideMenu.frame = CGRectMake(190, 20, 44, 44);
        [btnHideMenu addTarget:self action:@selector(hideMenuPanal) forControlEvents:UIControlEventTouchUpInside];
        //    [btnHideMenu setTitle:@"=" forState:UIControlStateNormal];
        [btnHideMenu setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btnMenu" ofType:@"png"]] forState:UIControlStateNormal];
        [appDelegate.viewMenuPanal addSubview:btnHideMenu];
    }
}

- (void)showMenuPanal
{
    [self hidePickerView];
    [self resignAllTextField];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    
    [appDelegate.viewMenuPanal removeFromSuperview];
    [self.view addSubview:appDelegate.viewMenuPanal];
    
    appDelegate.viewMenuPanal.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    
    [UIView commitAnimations];
}

- (void)hideMenuPanal
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    
    if(appDelegate.viewMenuPanal.frame.origin.x == 0)
    {
        appDelegate.viewMenuPanal.frame = CGRectMake(-appDelegate.screenWidth, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    }
    
    [UIView commitAnimations];
}

- (void)btnMenuClicked
{
    [self showMenuPanal];
}

#pragma mark - Menu Delegate

- (void)showThePage:(NSString *)strPageName
{
    self.lblTitle.text = strPageName;
    
//    if(objLiveVC!=nil)
//        [objLiveVC.view removeFromSuperview];
//    if(objCalendarVC!=nil)
//        [objCalendarVC.view removeFromSuperview];
//    if(objCounsellingVC!=nil)
//        [objCounsellingVC.view removeFromSuperview];
//    if(objRescheduleVC!=nil)
//        [objRescheduleVC.view removeFromSuperview];

    if([strPageName isEqualToString:@"Agent"])
    {
        [self hideMenuPanal];
        [tblAppointments removeFromSuperview];
    }
    else if([strPageName isEqualToString:@"Counsellings"])
    {
        [self hideMenuPanal];
        [appDelegate addChargementLoader];
        //[self getAgencyAppointments];
        [self getAgentAppointments];
        
    }
    else if([strPageName isEqualToString:@"Logout"])
    {
        
        appDelegate.dictProfile = nil;
        NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
        [defaultUser removeObjectForKey:@"Username"];
        [defaultUser removeObjectForKey:@"Pin"];

        [defaultUser removeObjectForKey:@"counsellorid"];
        [defaultUser removeObjectForKey:@"type"];
        [defaultUser removeObjectForKey:@"profile_image"];
        [defaultUser removeObjectForKey:@"email"];

        [appDelegate.navControl popToRootViewControllerAnimated:YES];

        [self clearMemory];

        self.lblTitle.text = strPageName;

        [appDelegate.viewMenuPanal removeFromSuperview];
        [self.view addSubview:appDelegate.viewMenuPanal];
    }
}

- (void)screenDesigning
{
    viewTopBar = [[UIView alloc] init];
    viewTopBar.frame = CGRectMake(0, 0, appDelegate.screenWidth, 64);
    viewTopBar.backgroundColor = colorHeader;
    [self.view addSubview:viewTopBar];
    
    lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(50, 20, appDelegate.screenWidth-100, 44);
    lblTitle.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    lblTitle.text = @"Agent";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:lblTitle];
    
    
    btnMenu = [[UIButton alloc] init];
    btnMenu.backgroundColor = [UIColor clearColor];
    btnMenu.frame = CGRectMake(0, 20, 44, 44);
    [btnMenu addTarget:self action:@selector(btnMenuClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnMenu setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btnMenu" ofType:@"png"]] forState:UIControlStateNormal];
    [viewTopBar addSubview:btnMenu];
    

    float xRef = -2.0;
    float yRef = 160.0;
    float height = 40;
    float width = appDelegate.screenWidth+4;
    float ySpace = -1;

    UIColor *colorTxtFieldBG = [UIColor clearColor];
    
    yRef = yRef+height+ySpace;

    txtFieldAgentPointName = [[UITextField alloc] init];
    txtFieldAgentPointName.delegate = self;
    txtFieldAgentPointName.layer.borderColor = colorWhiteOrBlack.CGColor;
    txtFieldAgentPointName.layer.borderWidth = 1.0;
    txtFieldAgentPointName.backgroundColor = [UIColor clearColor];
    txtFieldAgentPointName.leftViewMode = UITextFieldViewModeAlways;
    txtFieldAgentPointName.textColor = colorWhiteOrBlack;
    
    UIImageView *imgL = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height+20, height)];
    imgL.contentMode = UIViewContentModeCenter;
    imgL.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"email" ofType:@"png"]];
    txtFieldAgentPointName.leftView = imgL;
    txtFieldAgentPointName.placeholder = @"Enter access point name";
    txtFieldAgentPointName.frame = CGRectMake(xRef, yRef, width, height);
    txtFieldAgentPointName.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:txtFieldAgentPointName];
//    UIColor *color = [UIColor lightTextColor];
//    txtFieldAgentPointName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter access point name" attributes:@{NSForegroundColorAttributeName: color}];
    
    yRef = yRef+height+ySpace;
    
    txtFieldAgentMobileNumber = [[UITextField alloc] init];
    txtFieldAgentMobileNumber.delegate = self;
    txtFieldAgentMobileNumber.layer.cornerRadius = 1;
    txtFieldAgentMobileNumber.leftViewMode = UITextFieldViewModeAlways;
    txtFieldAgentMobileNumber.textColor = colorWhiteOrBlack;

    UIButton *btnPluse = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, height+20, height)];
    btnPluse.tag = 1001;
    [btnPluse setTitle:[NSString stringWithFormat:@"+%@", strCountryCodeAgent] forState:UIControlStateNormal];
    btnPluse.titleLabel.textColor = [UIColor lightGrayColor];
    [btnPluse setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnPluse.backgroundColor = [UIColor clearColor];
    [btnPluse addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];

    txtFieldAgentMobileNumber.leftView = btnPluse;
    txtFieldAgentMobileNumber.placeholder = @"Enter agent mobile number";
    txtFieldAgentMobileNumber.frame = CGRectMake(xRef, yRef, width, height);
    txtFieldAgentMobileNumber.layer.borderColor = colorWhiteOrBlack.CGColor;
    txtFieldAgentMobileNumber.layer.borderWidth = 1.0;
    txtFieldAgentMobileNumber.backgroundColor = [UIColor clearColor];
    txtFieldAgentMobileNumber.returnKeyType = UIReturnKeyNext;
    txtFieldAgentMobileNumber.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:txtFieldAgentMobileNumber];
    
//    txtFieldAgentMobileNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter agent mobile number" attributes:@{NSForegroundColorAttributeName: color}];
    
    yRef = yRef+height+ySpace;
    
    txtFieldNameOfYP = [[UITextField alloc] init];
    txtFieldNameOfYP.delegate = self;
    txtFieldNameOfYP.layer.borderColor = colorWhiteOrBlack.CGColor;
    txtFieldNameOfYP.layer.borderWidth = 1.0;
    txtFieldNameOfYP.backgroundColor = [UIColor clearColor];
    txtFieldNameOfYP.leftViewMode = UITextFieldViewModeAlways;
    txtFieldNameOfYP.textColor = colorWhiteOrBlack;
    imgL = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height+20, height)];
    imgL.contentMode = UIViewContentModeCenter;
    imgL.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"email" ofType:@"png"]];
    txtFieldNameOfYP.leftView = imgL;
    txtFieldNameOfYP.placeholder = @"Enter name of young person";
    txtFieldNameOfYP.frame = CGRectMake(xRef, yRef, width, height);
    txtFieldNameOfYP.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:txtFieldNameOfYP];
//    txtFieldNameOfYP.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter name of young person" attributes:@{NSForegroundColorAttributeName: color}];
    
    yRef = yRef+height+ySpace;
    
    txtFieldMobileNumberYP = [[UITextField alloc] init];
    txtFieldMobileNumberYP.delegate = self;
    txtFieldMobileNumberYP.layer.cornerRadius = 1;
    txtFieldMobileNumberYP.leftViewMode = UITextFieldViewModeAlways;
    txtFieldMobileNumberYP.textColor = colorWhiteOrBlack;
    
    btnPluse = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, height+20, height)];
    btnPluse.tag = 1002;
    [btnPluse setTitle:[NSString stringWithFormat:@"+%@", strCountryCodeYP] forState:UIControlStateNormal];
    btnPluse.titleLabel.textColor = [UIColor grayColor];
    [btnPluse setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnPluse.backgroundColor = [UIColor clearColor];
    [btnPluse addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];
    
    txtFieldMobileNumberYP.leftView = btnPluse;
    txtFieldMobileNumberYP.placeholder = @"Enter mobile number of young person";
    txtFieldMobileNumberYP.frame = CGRectMake(xRef, yRef, width, height);
    txtFieldMobileNumberYP.layer.borderColor = colorWhiteOrBlack.CGColor;
    txtFieldMobileNumberYP.layer.borderWidth = 1.0;
    txtFieldMobileNumberYP.backgroundColor = [UIColor clearColor];
    txtFieldMobileNumberYP.returnKeyType = UIReturnKeyNext;
    txtFieldMobileNumberYP.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:txtFieldMobileNumberYP];
    
//    txtFieldMobileNumberYP.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter mobile of young person" attributes:@{NSForegroundColorAttributeName: color}];
    
    yRef = yRef+height+ySpace;
    
    txtFieldNumberOfSession = [[UITextField alloc] init];
    txtFieldNumberOfSession.delegate = self;
    txtFieldNumberOfSession.layer.cornerRadius = 1;
    txtFieldNumberOfSession.leftViewMode = UITextFieldViewModeAlways;
    txtFieldNumberOfSession.textColor = colorWhiteOrBlack;
    imgL = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height+20, height)];
    imgL.contentMode = UIViewContentModeCenter;
    imgL.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"password" ofType:@"png"]];
    txtFieldNumberOfSession.leftView = imgL;
    txtFieldNumberOfSession.placeholder = @"Enter number of session";
    txtFieldNumberOfSession.text = @"6";
    txtFieldNumberOfSession.frame = CGRectMake(xRef, yRef, width, height);
    txtFieldNumberOfSession.layer.borderColor = colorWhiteOrBlack.CGColor;
    txtFieldNumberOfSession.layer.borderWidth = 1.0;
    txtFieldNumberOfSession.backgroundColor = [UIColor clearColor];
    txtFieldNumberOfSession.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:txtFieldNumberOfSession];
    
//    txtFieldNumberOfSession.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter number of session" attributes:@{NSForegroundColorAttributeName: color}];

    yRef = yRef+height+ySpace+10;

    UIButton *btnSubmit = [[UIButton alloc] init];
    btnSubmit.backgroundColor = colorHeader;
    btnSubmit.frame = CGRectMake(xRef, yRef, width, 40);
    [btnSubmit addTarget:self action:@selector(btnSubmitClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    [self.view addSubview:btnSubmit];
    
    txtFieldAgentPointName.backgroundColor = colorTxtFieldBG;
    txtFieldAgentMobileNumber.backgroundColor = colorTxtFieldBG;
    txtFieldNameOfYP.backgroundColor = colorTxtFieldBG;
    txtFieldMobileNumberYP.backgroundColor = colorTxtFieldBG;
    txtFieldNumberOfSession.backgroundColor = colorTxtFieldBG;

}

- (void)btnSubmitClicked
{
    [self hidePickerView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    
    self.view.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    
    [UIView commitAnimations];
    
    [self hidePickerView];
    [self resignAllTextField];
    //http://webilogic.com.md-in-16.webhostbox.net/HumbleBabies/Registration/name/email/password
    
    if (txtFieldAgentPointName.text.length>0 && txtFieldAgentMobileNumber.text.length>0 && txtFieldNameOfYP.text.length>0 && txtFieldMobileNumberYP.text.length>0 && txtFieldNumberOfSession.text.length>0)
    {
        if(txtFieldAgentMobileNumber.text.length<7)
        {
            [self showAlertMessage:@"please entesr valid mobile number."];
            return;
        }
        if(txtFieldMobileNumberYP.text.length<7)
        {
            [self showAlertMessage:@"please entesr valid mobile number."];
            return;
        }
        if(txtFieldNumberOfSession.text.intValue>30)
        {
            [self showAlertMessage:@"Number of sessions can not be more than 30."];
            return;
        }
        if(txtFieldNumberOfSession.text.intValue<=0)
        {
            [self showAlertMessage:@"Number of sessions can not be zero or negative."];
            return;
        }

        if(appDelegate.isNetAvailable)
        {
            [appDelegate addChargementLoader];
            [self agentWebServiceCall];
        }
        else
        {
            [self showInternetErrorMessage];
        }
    }
    else
    {
        [self showAlertMessage:@"Please enter all the fields."];
    }
}

- (void)agentWebServiceCall
{
//    {
//        "requestData":
//        {
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "requestType":"sendCounsellingCode",
//            "data":{
//                "accesspointname":"testing",
//                "agentmobile":"8962317149",
//                "clun01":"qMTrir5/a7Nota+tQwdxTA==",
//                "usermobile":"8878117942",
//                "allowsession":"5",
//                "agency_unq_id":"test123456",
//                "agent_mobile_number_preview":"91",
//                "mobile_yount_person_preview":"91",
//                "agent_unq_id":"testag"
//                
//            }
//        }
//    }
    NSString *strAgencyID = [appDelegate.dictProfile objectForKey:@"agencyId"];
    NSString *strAgentUID = [appDelegate.dictProfile objectForKey:@"counsellorid"];
    NSString *strYPName = [super getEncryptedString:txtFieldNameOfYP.text];

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:txtFieldAgentPointName.text, txtFieldAgentMobileNumber.text, strYPName, txtFieldMobileNumberYP.text, txtFieldNumberOfSession.text, strAgencyID, strCountryCodeAgent, strCountryCodeYP, strAgentUID, nil] forKeys:[NSArray arrayWithObjects: @"accesspointname", @"agentmobile", @"clun01", @"usermobile", @"allowsession", @"agency_unq_id", @"agent_mobile_number_preview", @"mobile_yount_person_preview", @"agent_unq_id", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"sendCounsellingCode", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    NSLog(@"dictParameter = %@", dictParameter);
    
    [AgentParser sharedManager].strMethod = @"SendCounsellingCode";
    [[AgentParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [self showStatusOfTheCode];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self agentWebServiceCall];
            }
            else {
                [appDelegate removeChargementLoader];
                [self showAlertMessage:@"Please enter valid informations!"];
            }
        });
    }];
}

- (void)showStatusOfTheCode
{
    txtFieldAgentPointName.text = @"";
    txtFieldAgentMobileNumber.text = @"";
    txtFieldNameOfYP.text = @"";
    txtFieldMobileNumberYP.text = @"";
    txtFieldNumberOfSession.text = @"6";

    [self showAlertMessage:@"Counselling code generated and sent to user's number."];
}

#pragma mark - CountryCode
- (void)designPickerView
{
    isYoungPerson = NO;
    arrCountryCode = [[NSMutableArray alloc] init];
    
    [arrCountryCode addObject:@"Afghanistan(+93)"];
    [arrCountryCode addObject:@"Aland Islands(+358)"];
    [arrCountryCode addObject:@"Albania(+355)"];
    [arrCountryCode addObject:@"Algeria(+213)"];
    [arrCountryCode addObject:@"American Samoa(+1684)"];
    [arrCountryCode addObject:@"Andorra(+376)"];
    [arrCountryCode addObject:@"Angola(+244)"];
    [arrCountryCode addObject:@"Anguilla(+1264)"];
    [arrCountryCode addObject:@"Antarctica(+)"];
    [arrCountryCode addObject:@"Antigua and Barbuda(+1268)"];
    [arrCountryCode addObject:@"Argentina(+54)"];
    [arrCountryCode addObject:@"Armenia(+374)"];
    [arrCountryCode addObject:@"Aruba(+297)"];
    [arrCountryCode addObject:@"Australia(+61)"];
    [arrCountryCode addObject:@"Austria(+43)"];
    [arrCountryCode addObject:@"Azerbaijan(+994)"];
    [arrCountryCode addObject:@"The Bahamas(+1242)"];
    [arrCountryCode addObject:@"Bahrain(+973)"];
    [arrCountryCode addObject:@"Bangladesh(+880)"];
    [arrCountryCode addObject:@"Barbados(+1246)"];
    [arrCountryCode addObject:@"Belarus(+375)"];
    [arrCountryCode addObject:@"Belgium(+32)"];
    [arrCountryCode addObject:@"Belize(+501)"];
    [arrCountryCode addObject:@"Benin(+229)"];
    [arrCountryCode addObject:@"Bermuda(+1441)"];
    [arrCountryCode addObject:@"Bhutan(+975)"];
    [arrCountryCode addObject:@"Bolivia(+591)"];
    [arrCountryCode addObject:@"Bonaire(+5997)"];
    [arrCountryCode addObject:@"Bosnia and Herzegovina(+387)"];
    [arrCountryCode addObject:@"Botswana(+267)"];
    [arrCountryCode addObject:@"Bouvet Island(+)"];
    [arrCountryCode addObject:@"Brazil(+55)"];
    [arrCountryCode addObject:@"British Indian Ocean Territory(+246)"];
    [arrCountryCode addObject:@"United States Minor Outlying Islands(+)"];
    [arrCountryCode addObject:@"Virgin Islands (British)(+1284)"];
    [arrCountryCode addObject:@"Virgin Islands (U.S.)(+1 340)"];
    [arrCountryCode addObject:@"Brunei(+673)"];
    [arrCountryCode addObject:@"Bulgaria(+359)"];
    [arrCountryCode addObject:@"Burkina Faso(+226)"];
    [arrCountryCode addObject:@"Burundi(+257)"];
    [arrCountryCode addObject:@"Cambodia(+855)"];
    [arrCountryCode addObject:@"Cameroon(+237)"];
    [arrCountryCode addObject:@"Canada(+1)"];
    [arrCountryCode addObject:@"Cape Verde(+238)"];
    [arrCountryCode addObject:@"Cayman Islands(+1345)"];
    [arrCountryCode addObject:@"Central African Republic(+236)"];
    [arrCountryCode addObject:@"Chad(+235)"];
    [arrCountryCode addObject:@"Chile(+56)"];
    [arrCountryCode addObject:@"China(+86)"];
    [arrCountryCode addObject:@"Christmas Island(+61)"];
    [arrCountryCode addObject:@"Cocos (Keeling) Islands(+61)"];
    [arrCountryCode addObject:@"Colombia(+57)"];
    [arrCountryCode addObject:@"Comoros(+269)"];
    [arrCountryCode addObject:@"Republic of the Congo(+242)"];
    [arrCountryCode addObject:@"Democratic Republic of the Congo(+243)"];
    [arrCountryCode addObject:@"Cook Islands(+682)"];
    [arrCountryCode addObject:@"Costa Rica(+506)"];
    [arrCountryCode addObject:@"Croatia(+385)"];
    [arrCountryCode addObject:@"Cuba(+53)"];
    [arrCountryCode addObject:@"CuraÁao(+599)"];
    [arrCountryCode addObject:@"Cyprus(+357)"];
    [arrCountryCode addObject:@"Czech Republic(+420)"];
    [arrCountryCode addObject:@"Denmark(+45)"];
    [arrCountryCode addObject:@"Djibouti(+253)"];
    [arrCountryCode addObject:@"Dominica(+1767)"];
    [arrCountryCode addObject:@"Dominican Republic(+1809)"];
    [arrCountryCode addObject:@"Ecuador(+593)"];
    [arrCountryCode addObject:@"Egypt(+20)"];
    [arrCountryCode addObject:@"El Salvador(+503)"];
    [arrCountryCode addObject:@"Equatorial Guinea(+240)"];
    [arrCountryCode addObject:@"Eritrea(+291)"];
    [arrCountryCode addObject:@"Estonia(+372)"];
    [arrCountryCode addObject:@"Ethiopia(+251)"];
    [arrCountryCode addObject:@"Falkland Islands(+500)"];
    [arrCountryCode addObject:@"Faroe Islands(+298)"];
    [arrCountryCode addObject:@"Fiji(+679)"];
    [arrCountryCode addObject:@"Finland(+358)"];
    [arrCountryCode addObject:@"France(+33)"];
    [arrCountryCode addObject:@"French Guiana(+594)"];
    [arrCountryCode addObject:@"French Polynesia(+689)"];
    [arrCountryCode addObject:@"French Southern and Antarctic Lands(+)"];
    [arrCountryCode addObject:@"Gabon(+241)"];
    [arrCountryCode addObject:@"The Gambia(+220)"];
    [arrCountryCode addObject:@"Georgia(+995)"];
    [arrCountryCode addObject:@"Germany(+49)"];
    [arrCountryCode addObject:@"Ghana(+233)"];
    [arrCountryCode addObject:@"Gibraltar(+350)"];
    [arrCountryCode addObject:@"Greece(+30)"];
    [arrCountryCode addObject:@"Greenland(+299)"];
    [arrCountryCode addObject:@"Grenada(+1473)"];
    [arrCountryCode addObject:@"Guadeloupe(+590)"];
    [arrCountryCode addObject:@"Guam(+1671)"];
    [arrCountryCode addObject:@"Guatemala(+502)"];
    [arrCountryCode addObject:@"Guernsey(+44)"];
    [arrCountryCode addObject:@"Guinea(+224)"];
    [arrCountryCode addObject:@"Guinea-Bissau(+245)"];
    [arrCountryCode addObject:@"Guyana(+592)"];
    [arrCountryCode addObject:@"Haiti(+509)"];
    [arrCountryCode addObject:@"Heard Island and McDonald Islands(+)"];
    [arrCountryCode addObject:@"Holy See(+379)"];
    [arrCountryCode addObject:@"Honduras(+504)"];
    [arrCountryCode addObject:@"Hong Kong(+852)"];
    [arrCountryCode addObject:@"Hungary(+36)"];
    [arrCountryCode addObject:@"Iceland(+354)"];
    [arrCountryCode addObject:@"India(+91)"];
    [arrCountryCode addObject:@"Indonesia(+62)"];
    [arrCountryCode addObject:@"Ivory Coast(+225)"];
    [arrCountryCode addObject:@"Iran(+98)"];
    [arrCountryCode addObject:@"Iraq(+964)"];
    [arrCountryCode addObject:@"Republic of Ireland(+353)"];
    [arrCountryCode addObject:@"Isle of Man(+44)"];
    [arrCountryCode addObject:@"Israel(+972)"];
    [arrCountryCode addObject:@"Italy(+39)"];
    [arrCountryCode addObject:@"Jamaica(+1876)"];
    [arrCountryCode addObject:@"Japan(+81)"];
    [arrCountryCode addObject:@"Jersey(+44)"];
    [arrCountryCode addObject:@"Jordan(+962)"];
    [arrCountryCode addObject:@"Kazakhstan(+76)"];
    [arrCountryCode addObject:@"Kenya(+254)"];
    [arrCountryCode addObject:@"Kiribati(+686)"];
    [arrCountryCode addObject:@"Kuwait(+965)"];
    [arrCountryCode addObject:@"Kyrgyzstan(+996)"];
    [arrCountryCode addObject:@"Laos(+856)"];
    [arrCountryCode addObject:@"Latvia(+371)"];
    [arrCountryCode addObject:@"Lebanon(+961)"];
    [arrCountryCode addObject:@"Lesotho(+266)"];
    [arrCountryCode addObject:@"Liberia(+231)"];
    [arrCountryCode addObject:@"Libya(+218)"];
    [arrCountryCode addObject:@"Liechtenstein(+423)"];
    [arrCountryCode addObject:@"Lithuania(+370)"];
    [arrCountryCode addObject:@"Luxembourg(+352)"];
    [arrCountryCode addObject:@"Macau(+853)"];
    [arrCountryCode addObject:@"Republic of Macedonia(+389)"];
    [arrCountryCode addObject:@"Madagascar(+261)"];
    [arrCountryCode addObject:@"Malawi(+265)"];
    [arrCountryCode addObject:@"Malaysia(+60)"];
    [arrCountryCode addObject:@"Maldives(+960)"];
    [arrCountryCode addObject:@"Mali(+223)"];
    [arrCountryCode addObject:@"Malta(+356)"];
    [arrCountryCode addObject:@"Marshall Islands(+692)"];
    [arrCountryCode addObject:@"Martinique(+596)"];
    [arrCountryCode addObject:@"Mauritania(+222)"];
    [arrCountryCode addObject:@"Mauritius(+230)"];
    [arrCountryCode addObject:@"Mayotte(+262)"];
    [arrCountryCode addObject:@"Mexico(+52)"];
    [arrCountryCode addObject:@"Federated States of Micronesia(+691)"];
    [arrCountryCode addObject:@"Moldova(+373)"];
    [arrCountryCode addObject:@"Monaco(+377)"];
    [arrCountryCode addObject:@"Mongolia(+976)"];
    [arrCountryCode addObject:@"Montenegro(+382)"];
    [arrCountryCode addObject:@"Montserrat(+1664)"];
    [arrCountryCode addObject:@"Morocco(+212)"];
    [arrCountryCode addObject:@"Mozambique(+258)"];
    [arrCountryCode addObject:@"Myanmar(+95)"];
    [arrCountryCode addObject:@"Namibia(+264)"];
    [arrCountryCode addObject:@"Nauru(+674)"];
    [arrCountryCode addObject:@"Nepal(+977)"];
    [arrCountryCode addObject:@"Netherlands(+31)"];
    [arrCountryCode addObject:@"New Caledonia(+687)"];
    [arrCountryCode addObject:@"New Zealand(+64)"];
    [arrCountryCode addObject:@"Nicaragua(+505)"];
    [arrCountryCode addObject:@"Niger(+227)"];
    [arrCountryCode addObject:@"Nigeria(+234)"];
    [arrCountryCode addObject:@"Niue(+683)"];
    [arrCountryCode addObject:@"Norfolk Island(+672)"];
    [arrCountryCode addObject:@"North Korea(+850)"];
    [arrCountryCode addObject:@"Northern Mariana Islands(+1670)"];
    [arrCountryCode addObject:@"Norway(+47)"];
    [arrCountryCode addObject:@"Oman(+968)"];
    [arrCountryCode addObject:@"Pakistan(+92)"];
    [arrCountryCode addObject:@"Palau(+680)"];
    [arrCountryCode addObject:@"Palestine(+970)"];
    [arrCountryCode addObject:@"Panama(+507)"];
    [arrCountryCode addObject:@"Papua New Guinea(+675)"];
    [arrCountryCode addObject:@"Paraguay(+595)"];
    [arrCountryCode addObject:@"Peru(+51)"];
    [arrCountryCode addObject:@"Philippines(+63)"];
    [arrCountryCode addObject:@"Pitcairn Islands(+64)"];
    [arrCountryCode addObject:@"Poland(+48)"];
    [arrCountryCode addObject:@"Portugal(+351)"];
    [arrCountryCode addObject:@"Puerto Rico(+1787)"];
    [arrCountryCode addObject:@"Qatar(+974)"];
    [arrCountryCode addObject:@"Republic of Kosovo(+383)"];
    [arrCountryCode addObject:@"RÈunion(+262)"];
    [arrCountryCode addObject:@"Romania(+40)"];
    [arrCountryCode addObject:@"Russia(+7)"];
    [arrCountryCode addObject:@"Rwanda(+250)"];
    [arrCountryCode addObject:@"Saint BarthÈlemy(+590)"];
    [arrCountryCode addObject:@"Saint Helena(+290)"];
    [arrCountryCode addObject:@"Saint Kitts and Nevis(+1869)"];
    [arrCountryCode addObject:@"Saint Lucia(+1758)"];
    [arrCountryCode addObject:@"Saint Martin(+590)"];
    [arrCountryCode addObject:@"Saint Pierre and Miquelon(+508)"];
    [arrCountryCode addObject:@"Saint Vincent and the Grenadines(+1784)"];
    [arrCountryCode addObject:@"Samoa(+685)"];
    [arrCountryCode addObject:@"San Marino(+378)"];
    [arrCountryCode addObject:@"S„o TomÈ and PrÌncipe(+239)"];
    [arrCountryCode addObject:@"Saudi Arabia(+966)"];
    [arrCountryCode addObject:@"Senegal(+221)"];
    [arrCountryCode addObject:@"Serbia(+381)"];
    [arrCountryCode addObject:@"Seychelles(+248)"];
    [arrCountryCode addObject:@"Sierra Leone(+232)"];
    [arrCountryCode addObject:@"Singapore(+65)"];
    [arrCountryCode addObject:@"Sint Maarten(+1721)"];
    [arrCountryCode addObject:@"Slovakia(+421)"];
    [arrCountryCode addObject:@"Slovenia(+386)"];
    [arrCountryCode addObject:@"Solomon Islands(+677)"];
    [arrCountryCode addObject:@"Somalia(+252)"];
    [arrCountryCode addObject:@"South Africa(+27)"];
    [arrCountryCode addObject:@"South Georgia(+500)"];
    [arrCountryCode addObject:@"South Korea(+82)"];
    [arrCountryCode addObject:@"South Sudan(+211)"];
    [arrCountryCode addObject:@"Spain(+34)"];
    [arrCountryCode addObject:@"Sri Lanka(+94)"];
    [arrCountryCode addObject:@"Sudan(+249)"];
    [arrCountryCode addObject:@"Suriname(+597)"];
    [arrCountryCode addObject:@"Svalbard and Jan Mayen(+4779)"];
    [arrCountryCode addObject:@"Swaziland(+268)"];
    [arrCountryCode addObject:@"Sweden(+46)"];
    [arrCountryCode addObject:@"Switzerland(+41)"];
    [arrCountryCode addObject:@"Syria(+963)"];
    [arrCountryCode addObject:@"Taiwan(+886)"];
    [arrCountryCode addObject:@"Tajikistan(+992)"];
    [arrCountryCode addObject:@"Tanzania(+255)"];
    [arrCountryCode addObject:@"Thailand(+66)"];
    [arrCountryCode addObject:@"East Timor(+670)"];
    [arrCountryCode addObject:@"Togo(+228)"];
    [arrCountryCode addObject:@"Tokelau(+690)"];
    [arrCountryCode addObject:@"Tonga(+676)"];
    [arrCountryCode addObject:@"Trinidad and Tobago(+1868)"];
    [arrCountryCode addObject:@"Tunisia(+216)"];
    [arrCountryCode addObject:@"Turkey(+90)"];
    [arrCountryCode addObject:@"Turkmenistan(+993)"];
    [arrCountryCode addObject:@"Turks and Caicos Islands(+1649)"];
    [arrCountryCode addObject:@"Tuvalu(+688)"];
    [arrCountryCode addObject:@"Uganda(+256)"];
    [arrCountryCode addObject:@"Ukraine(+380)"];
    [arrCountryCode addObject:@"United Arab Emirates(+971)"];
    [arrCountryCode addObject:@"United Kingdom(+44)"];
    [arrCountryCode addObject:@"United States(+1)"];
    [arrCountryCode addObject:@"Uruguay(+598)"];
    [arrCountryCode addObject:@"Uzbekistan(+998)"];
    [arrCountryCode addObject:@"Vanuatu(+678)"];
    [arrCountryCode addObject:@"Venezuela(+58)"];
    [arrCountryCode addObject:@"Vietnam(+84)"];
    [arrCountryCode addObject:@"Wallis and Futuna(+681)"];
    [arrCountryCode addObject:@"Western Sahara(+212)"];
    [arrCountryCode addObject:@"Yemen(+967)"];
    [arrCountryCode addObject:@"Zambia(+260)"];
    [arrCountryCode addObject:@"Zimbabwe(+263)"];
    
    
    viewPicker = [[UIView alloc] init];
    viewPicker.frame = CGRectMake(0, appDelegate.screenHeight, appDelegate.screenWidth, 300);
    viewPicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewPicker];
    
    pickerCountryCode = [[UIPickerView alloc] init];
    pickerCountryCode.frame = CGRectMake(0, 44, appDelegate.screenWidth, 256);
    pickerCountryCode.backgroundColor = [UIColor whiteColor];
    pickerCountryCode.delegate = self;
    pickerCountryCode.dataSource = self;
    [viewPicker addSubview:pickerCountryCode];
    
    UIButton *btnDone = [[UIButton alloc] init];
    [btnDone addTarget:self action:@selector(donePickerView) forControlEvents:UIControlEventTouchUpInside];
    btnDone.backgroundColor = [UIColor whiteColor];
    btnDone.frame = CGRectMake(appDelegate.screenWidth-80, 0, 80, 44);
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.titleLabel.textColor = [UIColor blackColor];
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [viewPicker addSubview:btnDone];

    UIButton *btnCancel = [[UIButton alloc] init];
    [btnCancel addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.backgroundColor = [UIColor whiteColor];
    btnCancel.frame = CGRectMake(0, 0, 80, 44);
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    btnCancel.titleLabel.textColor = [UIColor blackColor];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [viewPicker addSubview:btnCancel];

}

- (void)showPickerView:(UIButton *)sender
{
    [self resignAllTextField];
    
    if(sender.tag==1001)
        isYoungPerson = NO;
    else if(sender.tag==1002)
        isYoungPerson = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    
    viewPicker.frame = CGRectMake(0, appDelegate.screenHeight-300, appDelegate.screenWidth, 300);
    
    [UIView commitAnimations];
}

- (void)hidePickerView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    
    viewPicker.frame = CGRectMake(0, appDelegate.screenHeight, appDelegate.screenWidth, 300);
    
    [UIView commitAnimations];
}

- (void)donePickerView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    
    viewPicker.frame = CGRectMake(0, appDelegate.screenHeight, appDelegate.screenWidth, 300);
    
    [UIView commitAnimations];
    
    int index = (int)[pickerCountryCode selectedRowInComponent:0];
    
    if(isYoungPerson)
    {
        UIButton *btnPluse = (UIButton *)txtFieldMobileNumberYP.leftView;
        
        strCountryCodeYP = [[[arrCountryCode objectAtIndex:index] componentsSeparatedByCharactersInSet:
                             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                            componentsJoinedByString:@""];
        
        [btnPluse setTitle:[NSString stringWithFormat:@"+%@", strCountryCodeYP] forState:UIControlStateNormal];
    }
    else
    {
        UIButton *btnPluse = (UIButton *)txtFieldAgentMobileNumber.leftView;
        
        strCountryCodeAgent = [[[arrCountryCode objectAtIndex:index] componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];
        
        [btnPluse setTitle:[NSString stringWithFormat:@"+%@", strCountryCodeAgent] forState:UIControlStateNormal];
    }
}

#pragma mark - UIPickerView delegate and datasource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrCountryCode.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrCountryCode objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(isYoungPerson)
    {
        UIButton *btnPluse = (UIButton *)txtFieldMobileNumberYP.leftView;
        
        strCountryCodeYP = [[[arrCountryCode objectAtIndex:row] componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];
        
        [btnPluse setTitle:[NSString stringWithFormat:@"+%@", strCountryCode] forState:UIControlStateNormal];
    }
    else if(isYoungPerson)
    {
        UIButton *btnPluse = (UIButton *)txtFieldAgentMobileNumber.leftView;
        
        strCountryCodeAgent = [[[arrCountryCode objectAtIndex:row] componentsSeparatedByCharactersInSet:
                           [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                          componentsJoinedByString:@""];
        
        [btnPluse setTitle:[NSString stringWithFormat:@"+%@", strCountryCode] forState:UIControlStateNormal];
    }
}

#pragma  mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self hidePickerView];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    

    if([textField isEqual:txtFieldNameOfYP])
    {
        self.view.frame = CGRectMake(0, -60, appDelegate.screenWidth, appDelegate.screenHeight);
        //        [txtFieldPassword becomeFirstResponder];
    }
    else if([textField isEqual:txtFieldMobileNumberYP])
    {
        self.view.frame = CGRectMake(0, -120, appDelegate.screenWidth, appDelegate.screenHeight);
        //        [txtFieldConfirmPassword becomeFirstResponder];
    }
    else if([textField isEqual:txtFieldNumberOfSession])
    {
        self.view.frame = CGRectMake(0, -180, appDelegate.screenWidth, appDelegate.screenHeight);
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
    if(string.length==0)
        return YES;
    
    if([textField isEqual:txtFieldAgentMobileNumber] || [textField isEqual:txtFieldMobileNumberYP] || [textField isEqual:txtFieldNumberOfSession])
    {
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
        
        BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
        return stringIsValid;
    }
    else
    {
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
        
        BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
        return !stringIsValid;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    if([textField isEqual:txtFieldAgentPointName])
    {
        //        self.view.frame = CGRectMake(0, -100, appDelegate.screenWidth, appDelegate.screenHeight);
        [txtFieldAgentMobileNumber becomeFirstResponder];
    }
    else if([textField isEqual:txtFieldAgentMobileNumber])
    {
        //        self.view.frame = CGRectMake(0, -100, appDelegate.screenWidth, appDelegate.screenHeight);
        [txtFieldNameOfYP becomeFirstResponder];
    }
    else if([textField isEqual:txtFieldNameOfYP])
    {
        //        self.view.frame = CGRectMake(0, -100, appDelegate.screenWidth, appDelegate.screenHeight);
        [txtFieldMobileNumberYP becomeFirstResponder];
    }
    else if([textField isEqual:txtFieldMobileNumberYP])
    {
        //        self.view.frame = CGRectMake(0, -100, appDelegate.screenWidth, appDelegate.screenHeight);
        [txtFieldNumberOfSession becomeFirstResponder];
    }
    else if([textField isEqual:txtFieldNumberOfSession])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationRepeatCount:0];
        
        self.view.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        
        [UIView commitAnimations];
        
        [txtFieldNumberOfSession resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Appointment Showing
- (void)showAppointment
{
    if(tblAppointments==nil)
    {
        tblAppointments = [[UITableView alloc] init];
        tblAppointments.frame = CGRectMake(0, 64, appDelegate.screenWidth, appDelegate.screenHeight-64);
        tblAppointments.backgroundColor = colorViewBg;
        tblAppointments.delegate = self;
        tblAppointments.dataSource = self;
        tblAppointments.bounces = NO;
        tblAppointments.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tblAppointments.separatorColor = [UIColor whiteColor];
        [self.view addSubview:tblAppointments];
    }
    else
    {
        [self.view addSubview:tblAppointments];
        [tblAppointments reloadData];
    }
}

-(void)getAgencyAppointments
{
//    {
//        "requestData":{
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data":{
//                "agnc_unq_id":"1lShhBCdaKjResIdncr/TQ==1493972717789"
//            },
//            "requestType":"getAppointmentForAgency" 
//        }
//    }

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"agencyId"], nil] forKeys:[NSArray arrayWithObjects: @"agnc_unq_id",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointmentForAgency", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];

    NSLog(@"dictParameter = %@", dictParameter);
    
    [appCounsellingLoginParser sharedManager].strMethod = @"getAppointmentForAgency";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            [arrAppointment removeAllObjects];
            for (NSDictionary *dictData in responseDict)
            {
                [arrAppointment addObject:dictData];
                
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [self showAppointment];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getAgencyAppointments];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

-(void)getAgentAppointments
{
    //    {
    //        "requestData":{
    //            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //            "data":{
    //                "agent_unq_id":"1lShhBCdaKjResIdncr/TQ==1493972717789"
    //            },
    //            "requestType":"getAppointmentForAgent"
    //        }
    //    }
    
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"counsellorid"], nil] forKeys:[NSArray arrayWithObjects: @"agent_unq_id",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointmentForAgent", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"dictParameter = %@", dictParameter);
    
    [appCounsellingLoginParser sharedManager].strMethod = @"getAppointmentForAgency";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            [arrAppointment removeAllObjects];
            for (NSDictionary *dictData in responseDict)
            {
                [arrAppointment addObject:dictData];
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [self showAppointment];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getAgentAppointments];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}
#pragma mark - Appointment UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrAppointment count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dictAppointment = [arrAppointment objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [dictAppointment objectForKey:@"apntmnt_id"];
    AgentAppointmentTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = (AgentAppointmentTableViewCell *)[[AgentAppointmentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell showAppointments:dictAppointment];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
