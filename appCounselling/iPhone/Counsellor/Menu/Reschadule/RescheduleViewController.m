//
//  RescheduleViewController.m
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "RescheduleViewController.h"
#import "appCounsellingLoginParser.h"
#import "AppointmentTableViewCell.h"
#import "BookCounsellingCalenderViewController.h"

@interface RescheduleViewController ()

@end

@implementation RescheduleViewController

@synthesize strTitle;

- (void)clearMemory
{
    tblAppointments.delegate = nil;
    tblAppointments.dataSource = nil;
    tblAppointments = nil;
    arrPending = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self designTopBar];
    arrPending = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = colorViewBg;
    
    [self screenDesigning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [appDelegate addChargementLoader];
    [self getReschaduleAppointmentOfCounsellor];
}

- (void)screenDesigning
{
    lblNoAppointment = [[UILabel alloc] init];
    lblNoAppointment.frame = CGRectMake(20, 64, appDelegate.screenWidth-40, appDelegate.screenHeight-380);
    lblNoAppointment.textColor = colorWhiteOrBlack;
    lblNoAppointment.textAlignment = NSTextAlignmentCenter;
    lblNoAppointment.text = @"You do not have any rescheduled appointment.";
    lblNoAppointment.numberOfLines = 0;
    [self.view addSubview:lblNoAppointment];
    lblNoAppointment.hidden = YES;

    tblAppointments = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight-64) style:UITableViewStylePlain];
    tblAppointments.delegate = self;
    tblAppointments.dataSource = self;
    tblAppointments.bounces = NO;
    tblAppointments.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblAppointments.separatorColor = [UIColor clearColor];
    tblAppointments.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tblAppointments];
}

- (void)showAppointments
{
    if(arrPending.count==0)
        lblNoAppointment.hidden = NO;
    else
        lblNoAppointment.hidden = YES;
    [tblAppointments reloadData];
}


#pragma mark - UITAbleView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrPending count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Reschedule";
    AppointmentTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = (AppointmentTableViewCell *)[[AppointmentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSMutableDictionary *dictAppointment = [arrPending objectAtIndex:indexPath.row];
    [cell setParameterForReschedule:dictAppointment];
    
    cell.btnAccept.tag = indexPath.row+100;
    cell.btnReschedule.tag = indexPath.row;

    [cell.btnAccept addTarget:self action:@selector(acceptButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnReschedule addTarget:self action:@selector(rescheduleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
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
    NSMutableDictionary *dictAppointment = [arrPending objectAtIndex:sender.tag-100];
    [appDelegate addChargementLoader];
    [self acceptAppointment:dictAppointment];

}

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

            // CAlll new web service
            
            NSMutableDictionary *dictAppointment = [arrPending objectAtIndex:sender.tag];
            
            BookCounsellingCalenderViewController *objCallenderVC = [[BookCounsellingCalenderViewController alloc] init];
            objCallenderVC.dictAppointment = dictAppointment;
            
            [appDelegate.navControl pushViewController:objCallenderVC animated:YES];
            
            objCallenderVC = nil;
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        NSMutableDictionary *dictAppointment = [arrPending objectAtIndex:sender.tag];
        
        BookCounsellingCalenderViewController *objCallenderVC = [[BookCounsellingCalenderViewController alloc] init];
        objCallenderVC.dictAppointment = dictAppointment;
        
        [appDelegate.navControl pushViewController:objCallenderVC animated:YES];
        
        objCallenderVC = nil;
    }
}

#pragma mark - Parser

- (void)getReschaduleAppointmentOfCounsellor
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
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], @"Pending", nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01", @"status", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointment", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    [appCounsellingLoginParser sharedManager].strMethod = @"getAppointment";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            [arrPending removeAllObjects];
            
            for (NSDictionary *dictData in responseDict)
            {
                NSString *strSuggestedBy = [dictData objectForKey:@"suggested_by"];

                NSNumber *numSameCounsellor = [dictData objectForKey:@"same_cnslr"];
                BOOL isSame = numSameCounsellor.boolValue;
                
                if(isSame == YES && [strSuggestedBy isEqualToString:@"User"])
                {
                    NSMutableDictionary *mutable = [dictData mutableCopy];
                    [arrPending addObject:mutable];
                }
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [self showAppointments];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getReschaduleAppointmentOfCounsellor];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate removeChargementLoader];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"requestAccept" object:nil];
            });
        });
    } failure:^(NSError *error) {
        
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
