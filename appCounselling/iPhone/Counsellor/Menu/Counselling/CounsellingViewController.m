//
//  CounsellingViewController.m
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "CounsellingViewController.h"
#import "appCounsellingLoginParser.h"
#import "AppointmentTableViewCell.h"
#import "BookCounsellingCalenderViewController.h"
#import "AssessmentFormView.h"
#import "AssessmentForm_VC.h"
#define tagAccepted 1001
#define tagPending 1002
#define colorGreen [UIColor colorWithRed:150/255.0f green:230/255.0f blue:70/255.0f alpha:1.0]

@interface CounsellingViewController ()

@end

@implementation CounsellingViewController

@synthesize strTitle;
@synthesize btnAccepted;
@synthesize btnPending;

- (void)clearMemory
{
    arrPendings = nil;
    arrAccepted = nil;
    
    btnAccepted = nil;
    btnPending = nil;
    viewSelectedIndicator = nil;
    
    tblAppointments.delegate = nil;
    tblAppointments.dataSource = nil;
    tblAppointments = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self designTopBar];
//    [self showBackButton];

//    lblTitle.text = strTitle;
    
    arrPendings = [[NSMutableArray alloc] init];
    arrAccepted = [[NSMutableArray alloc] init];

    self.view.backgroundColor = colorViewBg;
    
    [self screenDesigning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [appDelegate addChargementLoader];
    
    if(btnPending.enabled)
        [self getAcceptedAppointmentOfCounsellor];
    else
        [self getPendingAppointmentOfCounsellor];
}

- (void)screenDesigning
{
    lblNoAppointment = [[UILabel alloc] init];
    lblNoAppointment.frame = CGRectMake(20, 64, appDelegate.screenWidth-40, appDelegate.screenHeight-380);
    lblNoAppointment.textColor = colorWhiteOrBlack;
    lblNoAppointment.textAlignment = NSTextAlignmentCenter;
    lblNoAppointment.text = @"You do not have any accepted appointment.";
    lblNoAppointment.numberOfLines = 0;
    [self.view addSubview:lblNoAppointment];
    lblNoAppointment.hidden = YES;

    float yRef = 1;
    float width = self.view.frame.size.width/2.0;
    
    btnAccepted = [[UIButton alloc] initWithFrame:CGRectMake(0, yRef, width-1, 30)];
    [btnAccepted setTitle:@"Accepted" forState:UIControlStateNormal];
    btnAccepted.backgroundColor = colorHeader;
    [btnAccepted setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAccepted addTarget:self action:@selector(btnAcceptedPendingClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAccepted];
    
    btnPending = [[UIButton alloc] initWithFrame:CGRectMake(width+1, yRef, width-1, 30)];
    btnPending.backgroundColor = colorHeader;
    [btnPending setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnPending setTitle:@"Pending" forState:UIControlStateNormal];
    [btnPending addTarget:self action:@selector(btnAcceptedPendingClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPending];
    
    viewSelectedIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, yRef+30, width, 2)];
    viewSelectedIndicator.backgroundColor = [UIColor colorWithRed:173/255.0 green:57.0/255 blue:72/255.0 alpha:1.0];
    [self.view addSubview:viewSelectedIndicator];

    tblAppointments = [[UITableView alloc] initWithFrame:CGRectMake(0, 34, appDelegate.screenWidth, appDelegate.screenHeight-96) style:UITableViewStylePlain];
    tblAppointments.tag = tagAccepted;
    tblAppointments.bounces = NO;
    tblAppointments.delegate = self;
    tblAppointments.dataSource = self;
    tblAppointments.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tblAppointments.separatorColor = [UIColor clearColor];
    tblAppointments.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tblAppointments];
}

- (void)btnAcceptedPendingClicked:(UIButton *)sender
{
    NSString *strMode = [sender titleForState:UIControlStateNormal];
    
    btnPending.enabled = YES;
    btnAccepted.enabled = YES;
    
    sender.enabled = NO;
    
    if([strMode isEqualToString:@"Accepted"])
    {
        viewSelectedIndicator.frame = CGRectMake(0, viewSelectedIndicator.frame.origin.y, viewSelectedIndicator.frame.size.width, 2);

        [appDelegate addChargementLoader];
        [self getAcceptedAppointmentOfCounsellor];
    }
    else if([strMode isEqualToString:@"Pending"])
    {
        viewSelectedIndicator.frame = CGRectMake(viewSelectedIndicator.frame.size.width, viewSelectedIndicator.frame.origin.y, viewSelectedIndicator.frame.size.width, 2);
        [appDelegate addChargementLoader];
        [self getPendingAppointmentOfCounsellor];
    }
}

- (void)showPendingAppointments
{
    if(arrPendings.count==0)
        lblNoAppointment.hidden = NO;

    tblAppointments.tag = tagPending;
    [tblAppointments reloadData];
}

- (void)showAcceptedAppointments
{
    if(arrAccepted.count==0)
        lblNoAppointment.hidden = NO;
    
    tblAppointments.tag = tagAccepted;
    [tblAppointments reloadData];
}

- (void)showLiveScreen
{
    //dictAppointment =
    /*
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
     [dateFormatter setDateFormat:formatServer];
     NSDate *appointmentDate = [dateFormatter dateFromString:[objBookedAppointment objectForKey:@"apntmnt_date"]];
     
     NSDate *currDate = [iFriendSingleton getCurrentServerTime];
     NSTimeInterval distanceBetweenDates = [appointmentDate timeIntervalSinceDate:currDate];
     
     long seconds = lroundf(distanceBetweenDates);
     int hours = (seconds / 3600);
     int mins = (seconds % 3600) / 60;
     int secs = seconds % 60;
     
     int intTimeLeft = secs+(60*mins);
     
     NSString *strStatus = [objBookedAppointment objectForKey:@"Status"];
     
     int intTimeDuration = 60*appDelegate.timeDuration;
     NSLog(@"intTimeDuration = %i", intTimeDuration);
     
     if(intTimeLeft<300 && [strStatus isEqualToString:@"Accepted"])
     {
     if(intTimeLeft>0 && hours==0)
     {
     [self gotoLiveCounsellingTimer];
     }
     else if(intTimeLeft>-intTimeDuration && hours==0)
     {
     [self gotoCounsellingMode];
     }
     else
     {
     NSString *strUserCame = [objBookedAppointment objectForKey:@"userCameAt"];
     NSString *strCounselorCame = [objBookedAppointment objectForKey:@"counsellorCameAt"];
     
     //Both Came |Y|Y|
     if(strUserCame && strUserCame.length>0 && strCounselorCame && strCounselorCame.length>0)
     [self completeTheAppointment];
     //|N|Y|
     else if((strUserCame==nil || strUserCame.length==0) && (strCounselorCame && strCounselorCame.length>0))
     [self completeTheAppointment];
     //|Y|N|
     else if((strUserCame && strUserCame.length>0) && (strCounselorCame==nil || strCounselorCame.length==0))
     [self cancelAppointment];
     //|N|N|
     else//Admin will do here
     [self getUserSession];
     }
     }
     else
     {
     [self designAlreadyBooked];
     }
     
     if(developmentModeON)
     {
     //            if([strStatus isEqualToString:@"Pending"]){
     //                [objAppointment setObject:@"Accepted" forKey:@"Status"];//Accepted//Pending//Completed
     //                [objAppointment save];
     //                [objAppointment delete];
     //            }
     }
     */
}

#pragma mark - UITAbleView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == tagAccepted)
    {
        lblNoAppointment.hidden = (arrAccepted.count>0);
        return [arrAccepted count];
    }
    else{
        lblNoAppointment.hidden = (arrPendings.count>0);
        return [arrPendings count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == tagAccepted)
    {
        static NSString *CellIdentifier = @"Accepted";
        AppointmentTableViewCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = (AppointmentTableViewCell *)[[AppointmentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dictAppointment = [arrAccepted objectAtIndex:indexPath.row];
        [cell setParameter:dictAppointment];

        cell.btnReschedule.tag = indexPath.row;
        cell.btnGoAssesmetform.tag = indexPath.row;
        
        
        [cell.btnReschedule addTarget:self action:@selector(rescheduleAcceptedAppointmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.btnGoAssesmetform addTarget:self action:@selector(GoAssesmetformButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Pending";
        AppointmentTableViewCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = (AppointmentTableViewCell *)[[AppointmentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//            cell.delegate = self;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = colorGreen;
        
        NSDictionary *dictAppointment = [arrPendings objectAtIndex:indexPath.row];
        [cell setParameter:dictAppointment];

        cell.btnAccept.tag = indexPath.row;
        cell.btnDeniey.tag = indexPath.row;
        cell.btnReschedule.tag = indexPath.row;
        
        
        [cell.btnAccept addTarget:self action:@selector(acceptButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDeniey addTarget:self action:@selector(denyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReschedule addTarget:self action:@selector(rescheduleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark- Cell Button Actions 

- (void)acceptButtonClicked:(UIButton *)sender
{
    if(appDelegate.strFirstname == nil || [appDelegate.strFirstname isEqualToString:@""])
    {
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

            NSDictionary *dictAppointment = [arrPendings objectAtIndex:sender.tag];
            [appDelegate addChargementLoader];
            [self acceptAppointment:dictAppointment];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        NSDictionary *dictAppointment = [arrPendings objectAtIndex:sender.tag];
        [appDelegate addChargementLoader];
        [self acceptAppointment:dictAppointment];
    }
}

- (void)denyButtonClicked:(UIButton *)sender
{
    NSDictionary *dictAppointment = [arrPendings objectAtIndex:sender.tag];
    [appDelegate addChargementLoader];
    [self deneyAppointment:dictAppointment];
}

- (void)GoAssesmetformButtonClicked:(UIButton *)sender
{
   NSDictionary *dictAppointment = [arrAccepted objectAtIndex:sender.tag];
    NSLog(@"pavan%@", dictAppointment);
    NSNumber *userqid = [dictAppointment objectForKey:@"qid"];
    NSString *userclun01 = [dictAppointment objectForKey:@"clun01"];
    
    NSLog(@"%@", userqid);
     NSLog(@"%@", userclun01);
    
    [self getLiveAppointment:userqid clun_01:userclun01];
}
// start pavan get assestment form
- (void)getLiveAppointment:(NSString *)q_id clun_01:(NSString *)clun_01
{
    [appDelegate addChargementLoader];
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: clun_01 , q_id, nil] forKeys:[NSArray arrayWithObjects: @"clun01", @"qid",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAssesmentAnswerCounselling", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setValue:parameters forKey:@"requestData"];
    
    NSLog(@"strClcnslrun01=%@", dictParameter);
    
    NSMutableArray *arrAcceptedAppointments = [[NSMutableArray alloc] init];
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        NSLog(@"strClcnslrun01=%@", responseDict);
        
        NSArray *localArray = [[NSArray alloc] initWithArray:[responseDict valueForKey:@"clquestioneranswer01"]];
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dictData in responseDict)
            {
                [arrAcceptedAppointments addObject:dictData];
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            
            [self Show_Ass_VC:localArray];
            //            [self checkIfLiveAppointment:arrAcceptedAppointments];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                //                [self getData];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

-(void)Show_Ass_VC:(NSArray *)Loac_Array {
    
    NSLog(@"-- Loac_Array --%@", Loac_Array);
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"VideoCall" bundle:nil];
    
    AssessmentForm_VC *screen = [sb instantiateViewControllerWithIdentifier:@"AssessmentForm_VC"];
    
    screen.JsonArr = [[NSMutableArray alloc] initWithArray:Loac_Array];

    [appDelegate.navControl pushViewController:screen animated:YES];

  
}

// end pavan

- (void)rescheduleButtonClicked:(UIButton *)sender
{
    if(appDelegate.strFirstname == nil || [appDelegate.strFirstname isEqualToString:@""])
    {
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

            NSDictionary *dictAppointment = [arrPendings objectAtIndex:sender.tag];
            
            BookCounsellingCalenderViewController *objCallenderVC = [[BookCounsellingCalenderViewController alloc] init];
            objCallenderVC.dictAppointment = [[NSMutableDictionary alloc] initWithDictionary:dictAppointment];
            
            [appDelegate.navControl pushViewController:objCallenderVC animated:YES];
            
            objCallenderVC = nil;
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
    
        NSDictionary *dictAppointment = [arrPendings objectAtIndex:sender.tag];
        
        BookCounsellingCalenderViewController *objCallenderVC = [[BookCounsellingCalenderViewController alloc] init];
        objCallenderVC.dictAppointment = [[NSMutableDictionary alloc] initWithDictionary:dictAppointment];
        
        [appDelegate.navControl pushViewController:objCallenderVC animated:YES];
        
        objCallenderVC = nil;
    }
}

- (void)rescheduleAcceptedAppointmentButtonClicked:(UIButton *)sender
{
    NSDictionary *dictAppointment = [arrAccepted objectAtIndex:sender.tag];

    if(appDelegate.strFirstname == nil || [appDelegate.strFirstname isEqualToString:@""])
    {
        appDelegate.strFirstname = [dictAppointment objectForKey:@"counsellor_firstname"];
        
        if(appDelegate.strFirstname == nil || [appDelegate.strFirstname isEqualToString:@""])
        {
            appDelegate.strFirstname = [appDelegate.dictProfile objectForKey:@"username"];
        }
    }
    
    if(appDelegate.strFirstname == nil || [appDelegate.strFirstname isEqualToString:@""])
    {
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

            // CAlll new web service
            
            BookCounsellingCalenderViewController *objCallenderVC = [[BookCounsellingCalenderViewController alloc] init];
            objCallenderVC.dictAppointment = [[NSMutableDictionary alloc] initWithDictionary:dictAppointment];
            
            [appDelegate.navControl pushViewController:objCallenderVC animated:YES];
            
            objCallenderVC = nil;
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
    
        // CAlll new web service
        
        BookCounsellingCalenderViewController *objCallenderVC = [[BookCounsellingCalenderViewController alloc] init];
        objCallenderVC.dictAppointment = [[NSMutableDictionary alloc] initWithDictionary:dictAppointment];
        
        [appDelegate.navControl pushViewController:objCallenderVC animated:YES];
        
        objCallenderVC = nil;
    }
}

#pragma mark- Parsers
- (void)getAcceptedAppointmentOfCounsellor
{
    lblNoAppointment.hidden = YES;
    lblNoAppointment.text = @"You do not have any accepted appointment.";

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], @"Accepted", nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01", @"status", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointment", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];

    [appCounsellingLoginParser sharedManager].strMethod = @"getAppointment";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {

        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            [arrAccepted removeAllObjects];
            for (NSDictionary *dictData in responseDict)
            {
                [arrAccepted addObject:dictData];
            }
            NSLog(@"Request sent");
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [self showAcceptedAppointments];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getAcceptedAppointmentOfCounsellor];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];    
}

- (void)getPendingAppointmentOfCounsellor
{
    //    {
    //        "requestData": {
    //            "apikey": "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //            "requestType": "getAppointment",
    //            "counsellorid": "LxyllWw9Xf",
    //            "status": "All"
    //        }
    //    }
    
    lblNoAppointment.hidden = YES;
    lblNoAppointment.text = @"You do not have any appointment to accept.";

//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//
//    NSDictionary *dictdata = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointment", [appDelegate.dictProfile objectForKey:@"counsellorid"], @"Pending", nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"counsellorid", @"status", nil]];
//    
//    [params setObject:dictdata forKey:@"requestData"];

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], @"Pending", nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01", @"status", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointment", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    NSLog(@"%@", parameters);
    [dictParameter setObject:parameters forKey:@"requestData"];

    [appCounsellingLoginParser sharedManager].strMethod = @"getAppointment";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            [arrPendings removeAllObjects];
            for (NSDictionary *dictData in responseDict)
            {
//                NSString *strSameCounsellor = [dictData objectForKey:@"same_cnslr"];

                NSNumber *numSameCounsellor = [dictData objectForKey:@"same_cnslr"];
                BOOL isSame = numSameCounsellor.boolValue;
                if(isSame == NO)
                    [arrPendings addObject:dictData];
//                if(![strSameCounsellor isEqualToString:@"true"])
//                    [arrPendings addObject:dictData];
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [self showPendingAppointments];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getPendingAppointmentOfCounsellor];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)deneyAppointment:(NSDictionary *)dictAppointment
{
//    {
//        "requestData":
//        {
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "requestType":"appointmentAction",
//            "data":{
//                "status": "Accepted",
//                "appointmentid": "test123457",
//                "counsellorid":"rizwan3123234",
//                "acceptedBy":"Counsellor",
//                "clun01":"W8hNrRAQQIEPXuBy3FJ0ww=="
//            }
//        }
//    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Denied", [dictAppointment objectForKey:@"apntmnt_id"], [appDelegate.dictProfile objectForKey:@"username"], @"Counsellor", [dictAppointment objectForKey:@"clun01"], appDelegate.strFirstname, nil] forKeys:[NSArray arrayWithObjects: @"status", @"appointmentid", @"counsellorid", @"acceptedBy", @"clun01", @"counsellor_firstname", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"appointmentAction", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    [appCounsellingLoginParser sharedManager].strMethod = @"appointmentAction";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [self getPendingAppointmentOfCounsellor];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self deneyAppointment:dictAppointment];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)acceptAppointment:(NSDictionary *)dictAppointment
{
//    {
//        "requestData":
//        {
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "requestType":"appointmentAction",
//            "data":{
//                "status": "Accepted",
//                "appointmentid": "test123457",
//                "counsellorid":"rizwan3123234",
//                "acceptedBy":"Counsellor",
//                "clun01":"W8hNrRAQQIEPXuBy3FJ0ww=="
//                "counsellor_firstname":"W8hNrRAQQIEPXuBy3FJ0ww=="
//            }
//        }
//    }

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Accepted", [dictAppointment objectForKey:@"apntmnt_id"], [appDelegate.dictProfile objectForKey:@"username"], @"Counsellor", [dictAppointment objectForKey:@"clun01"], appDelegate.strFirstname, nil] forKeys:[NSArray arrayWithObjects: @"status", @"appointmentid", @"counsellorid", @"acceptedBy", @"clun01", @"counsellor_firstname", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"appointmentAction", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];

    [appCounsellingLoginParser sharedManager].strMethod = @"appointmentAction";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"requestAccept" object:nil];
            [self getPendingAppointmentOfCounsellor];
        });
    } failure:^(NSError *error) {
        [appDelegate removeChargementLoader];

        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self acceptAppointment:dictAppointment];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
