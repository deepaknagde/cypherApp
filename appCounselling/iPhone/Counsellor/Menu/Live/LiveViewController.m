//
//  LiveViewController.m
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "LiveViewController.h"
#import "appCounsellingLoginParser.h"
#import "AppCounselllingLiveTimerViewController.h"
#import "AppCounselllingLiveChatViewController.h"
#import "AppCounsellingRattingViewController.h"
#import "SetAvailabilityViewController.h"
#import "AssessmentFormView.h"

@interface LiveViewController ()

@end

@implementation LiveViewController

@synthesize strTitle;
@synthesize isCommingFromRatting;
@synthesize isCommingFromCounselling;

- (void)clearMemory
{
    arrAcceptedAppointments = nil;
    arrPendingRatting = nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrDays = [[NSMutableArray alloc] init];
    [arrDays addObject:@"Monday"];
    [arrDays addObject:@"Tuesday"];
    [arrDays addObject:@"Wednesday"];
    [arrDays addObject:@"Thursday"];
    [arrDays addObject:@"Friday"];
    [arrDays addObject:@"Saturday"];
    [arrDays addObject:@"Sunday"];
    
    arrTimeSlots = [[NSMutableArray alloc] init];
//    [arrTimeSlots addObject:@"Mon"];
//    [arrTimeSlots addObject:@"Tue"];
//    [arrTimeSlots addObject:@"Wed"];
//    [arrTimeSlots addObject:@"Thu"];
//    [arrTimeSlots addObject:@"Fri"];
//    [arrTimeSlots addObject:@"Sat"];
//    [arrTimeSlots addObject:@"Sun"];
    
    arrOption = [[NSMutableArray alloc] init];
    [arrOption addObject:@"You are always available"];
    [arrOption addObject:@"You are not available"];
    [arrOption addObject:@"Set your 7 days available time"];
    [arrOption addObject:@"Set your availability day wise"];
    
    NSString *strAgencyID = [appDelegate.dictProfile objectForKey:@"agencyId"];

    if([strAgencyID isEqualToString:appDelegate.strUKMainAgencyID] == YES)
    {
        [arrOption addObject:@"Set your age range for counselling"];
    }
    
    isCommingFromRatting = NO;
    isCommingFromCounselling = NO;
    
    [self designTopBar];

    arrAcceptedAppointments = [[NSMutableArray alloc] init];
    arrPendingRatting = [[NSMutableArray alloc] init];
    
    arrOldAppointmentPendingRatting = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = colorViewBg;

    [self screenDesigning];
    
//    [self testing];
}

- (void)testing
{
    AssessmentFormView *viewAF = [[AssessmentFormView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight-64)];
    viewAF.backgroundColor = [UIColor whiteColor];
    [viewAF getAllQuestionsWebServiceCall:@"ZpJhigkWqc34SDuSOh/t3g=="];
    [self.view addSubview:viewAF];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(isCommingFromRatting==YES)
    {
        [arrPendingRatting removeAllObjects];
        [arrOldAppointmentPendingRatting removeAllObjects];
        
        isCommingFromRatting = NO;
      
        [appDelegate addChargementLoader];
        [self getLiveAppointment];
    }
    else if(isCommingFromCounselling == NO)
    {
        [appDelegate addChargementLoader];
        [self getPendingQuestions];
    }
    isCommingFromCounselling = NO;
    
    [arrTimeSlots removeAllObjects];
    [arrTimeSlots addObject:@"Mon"];
    [arrTimeSlots addObject:@"Tue"];
    [arrTimeSlots addObject:@"Wed"];
    [arrTimeSlots addObject:@"Thu"];
    [arrTimeSlots addObject:@"Fri"];
    [arrTimeSlots addObject:@"Sat"];
    [arrTimeSlots addObject:@"Sun"];

    [self getAvailableSlots];
}

- (void)refreshlivePage
{
    [appDelegate addChargementLoader];
    [self getPendingQuestions];
}



- (void)screenDesigning
{
    txtFieldAgeRange = [[UITextField alloc] init];
    txtFieldAgeRange.frame = CGRectMake(50, 0, appDelegate.screenWidth-50, 33);
    txtFieldAgeRange.backgroundColor = [UIColor clearColor];
    txtFieldAgeRange.placeholder = @"please enter client age range";
    
    strFromAge = [appDelegate.dictProfile objectForKey:@"age_range_from"];
    strToAge = [appDelegate.dictProfile objectForKey:@"age_range_to"];
    
    if(strFromAge == nil || strToAge == nil){
        txtFieldAgeRange.text = @"";
        strFromAge = @"11";
        strToAge = @"80";
    }
    else {
        txtFieldAgeRange.text = [NSString stringWithFormat:@"client age range : %@ to %@", strFromAge, strToAge];
    }

    pickerAgeRange = [[UIPickerView alloc] init];
    pickerAgeRange.frame = CGRectMake(0, 44, appDelegate.screenWidth, 256);
    pickerAgeRange.backgroundColor = colorViewBg;//[UIColor whiteColor];
    pickerAgeRange.delegate = self;
    pickerAgeRange.dataSource = self;
    txtFieldAgeRange.inputView = pickerAgeRange;
    
    UIView *viewHeader = [[UIView alloc] init];
    viewHeader.frame = CGRectMake(0, 0, appDelegate.screenWidth, 44);
    viewHeader.backgroundColor = colorHeader;
    [pickerAgeRange addSubview:viewHeader];
    
    UILabel *lblAgeRange = [[UILabel alloc] init];
    lblAgeRange.frame = CGRectMake(20, 0, appDelegate.screenWidth-40, 44);
    lblAgeRange.text = @"please enter client age range";
    lblAgeRange.font = [UIFont systemFontOfSize:17];
    lblAgeRange.textAlignment = NSTextAlignmentCenter;
    lblAgeRange.textColor = [UIColor whiteColor];
    [pickerAgeRange addSubview:lblAgeRange];

    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];//[[UIButton alloc] init];
    btnDone.frame = CGRectMake(0, 0, 60, 33);
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setTintColor:[UIColor whiteColor]];
    btnDone.titleLabel.font = [UIFont boldSystemFontOfSize:17];;
    [btnDone addTarget:self action:@selector(btnDoneAgeRangeClicked) forControlEvents:UIControlEventTouchUpInside];
    btnDone.backgroundColor = colorHeader;
//    [viewHeader addSubview:btnDone];
    txtFieldAgeRange.rightView = btnDone;
    txtFieldAgeRange.rightViewMode = UITextFieldViewModeWhileEditing;
    
    tblOption = [[UITableView alloc] init];
    tblOption.tag = 101;
    tblOption.frame = CGRectMake(0, 1, appDelegate.screenWidth, 133+33+40);
    tblOption.backgroundColor = colorViewBg;//colorHeader;
    tblOption.delegate = self;
    tblOption.dataSource = self;
    tblOption.bounces = NO;
    tblOption.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tblOption.separatorColor = [UIColor grayColor];
    [self.view addSubview:tblOption];
    
    viewSetTime = [[UIView alloc] initWithFrame:CGRectMake(0, 155, appDelegate.screenWidth, appDelegate.screenHeight-150)];
    viewSetTime.backgroundColor = colorViewBg;
    [self.view addSubview:viewSetTime];
    
    UILabel *lblFrom = [[UILabel alloc] init];
    lblFrom.frame = CGRectMake(20, 0, (appDelegate.screenWidth-100)/2.0, 40);
    lblFrom.textColor = colorWhiteOrBlack;
    lblFrom.textAlignment = NSTextAlignmentCenter;
    lblFrom.text = @"From";
    [viewSetTime addSubview:lblFrom];

    btnFrom = [[UIButton alloc] init];
    btnFrom.frame = CGRectMake(20, 40, (appDelegate.screenWidth-100)/2.0, 40);
    [btnFrom setTitle:@"00:00" forState:UIControlStateNormal];
    [viewSetTime addSubview:btnFrom];
    
    [btnFrom addTarget:self action:@selector(showFromTime) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblTo = [[UILabel alloc] init];
    lblTo.frame = CGRectMake((appDelegate.screenWidth-(((appDelegate.screenWidth-100)/2.0)+20)), 0, (appDelegate.screenWidth-100)/2.0, 40);
    lblTo.textColor = colorWhiteOrBlack;
    lblTo.textAlignment = NSTextAlignmentCenter;
    lblTo.text = @"To";
    [viewSetTime addSubview:lblTo];

    btnTo = [[UIButton alloc] init];
    btnTo.frame = CGRectMake((appDelegate.screenWidth-(((appDelegate.screenWidth-100)/2.0)+20)), 40, (appDelegate.screenWidth-100)/2.0, 40);
    [btnTo setTitle:@"00:00" forState:UIControlStateNormal];
    [viewSetTime addSubview:btnTo];

    [btnTo addTarget:self action:@selector(showToTime) forControlEvents:UIControlEventTouchUpInside];
    
    btnFrom.backgroundColor = colorHeader;
    btnTo.backgroundColor = colorHeader;

    btnFrom.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    btnTo.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [self showFromTime];
    [self showToTime];
    
    btnSubmit = [[UIButton alloc] init];
    btnSubmit.frame = CGRectMake(20, 330, appDelegate.screenWidth-40, 40);
    btnSubmit.layer.cornerRadius = 10.0;
    btnSubmit.clipsToBounds = YES;
    btnSubmit.backgroundColor = colorHeader;
    [btnSubmit setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(submitAvailibility) forControlEvents:UIControlEventTouchUpInside];
    [viewSetTime addSubview:btnSubmit];
    
    if(appDelegate.screenHeight<=(568))
    {
        btnSubmit.frame = CGRectMake(20, 310, appDelegate.screenWidth-40, 40);
    }
    
    tblDays = [[UITableView alloc] init];
    tblDays.tag = 102;
    tblDays.frame = CGRectMake(0, 0, appDelegate.screenWidth, 198+40);
    tblDays.backgroundColor = colorHeader;
    tblDays.delegate = self;
    tblDays.dataSource = self;
    tblDays.bounces = NO;
    tblDays.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tblDays.separatorColor = [UIColor grayColor];
    [viewSetTime addSubview:tblDays];
    tblDays.hidden = YES;
    viewSetTime.hidden = YES;

    lblNoAppointment = [[UILabel alloc] init];
//    lblNoAppointment.frame = CGRectMake(20, 64, appDelegate.screenWidth-40, appDelegate.screenHeight-380);
//    lblNoAppointment.textColor = colorWhiteOrBlack;
//    lblNoAppointment.textAlignment = NSTextAlignmentCenter;
//    lblNoAppointment.text = @"You can see scheduled counselling and pending ratings here";
//    lblNoAppointment.numberOfLines = 0;
//    [self.view addSubview:lblNoAppointment];
//    lblNoAppointment.hidden = YES;
}

- (void)showFromTime
{
    
    if(pickerFrom == nil)
    {
        pickerFrom = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, appDelegate.screenHeight, appDelegate.screenWidth, 256)];
        pickerFrom.datePickerMode = UIDatePickerModeTime;
        pickerFrom.minuteInterval = 30;
        [pickerFrom addTarget:self action:@selector(setFromTime) forControlEvents:UIControlEventValueChanged];
        [viewSetTime addSubview:pickerFrom];
    }
    
    pickerFrom.frame = CGRectMake(0, 90, appDelegate.screenWidth/2.0, 256);
    
    viewSetTime.hidden = NO;
    btnSubmit.hidden = NO;
    pickerTo.hidden = NO;
    pickerFrom.hidden = NO;

}

- (void)showToTime
{
    if(pickerTo == nil)
    {
        pickerTo = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, appDelegate.screenHeight, appDelegate.screenWidth, 256)];
        pickerTo.datePickerMode = UIDatePickerModeTime;
        pickerTo.minuteInterval = 30;
        [pickerTo addTarget:self action:@selector(setToTime) forControlEvents:UIControlEventValueChanged];
        [viewSetTime addSubview:pickerTo];
    }
    
    pickerTo.frame = CGRectMake(appDelegate.screenWidth/2.0, 80, appDelegate.screenWidth/2.0, 256);
    
    viewSetTime.hidden = NO;
    btnSubmit.hidden = NO;
    pickerTo.hidden = NO;
    pickerFrom.hidden = NO;

}

- (void)setFromTime
{
    NSLog(@"pickerFrom.date = %@", pickerFrom.date);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    [btnFrom setTitle:[formatter stringFromDate:pickerFrom.date] forState:UIControlStateNormal];
    formatter = nil;
}

- (void)setToTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    [btnTo setTitle:[formatter stringFromDate:pickerTo.date] forState:UIControlStateNormal];
    formatter = nil;
}

- (void)submitAvailibility
{
    NSString *strFrom = [btnFrom titleForState:UIControlStateNormal];
    NSString *strTo = [btnTo titleForState:UIControlStateNormal];

    if(strFrom == strTo)
    {
        [self showAlertMessage:@"Please select minimum two hours"];
    }
    else {
        
        NSTimeInterval distanceBetweenDates = [pickerTo.date timeIntervalSinceDate:pickerFrom.date];
        
        long seconds = lroundf(distanceBetweenDates);
        int hours = (int)(seconds / 3600);
        int mins = (seconds % 3600) / 60;
        int secs = seconds % 60;
        
        int intTimeLeft = secs+(60*mins)+(hours*60*60);
        
        
        if(intTimeLeft<7200 && intTimeLeft>0)
        {
            [self showAlertMessage:@"Please select minimum two hours"];
        }
        else{
            [appDelegate addChargementLoader];
            [self updateCounsellorAvailableTime];
        }
    }
}

#pragma mark - UITableView

#pragma mark - UITAbleView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag == 101)
    {
        if(arrOption.count==5)
            return 2;
        else
            return 1;
    }
    else
    {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 101)
    {
        if(section == 0) {
            if(arrOption.count==5)
                return [arrOption count]-1;
            else
                return arrOption.count;
        }
        else {
            return 1;
        }
    }
    else {
        return [arrTimeSlots count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 101)
    {
        if(arrOption.count==5) {
            return 20.0;
        }
        else
        {
            return 1.0;
        }
    }
    else
        return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 101)
    {
        UIView *viewHeader = [[UIView alloc] init];
        
        if(arrOption.count==5) {
            viewHeader.frame = CGRectMake(0, 0, appDelegate.screenWidth, 20);
            viewHeader.backgroundColor = colorHeader;
            
            UILabel *lbl = [[UILabel alloc] init];
            lbl.frame = CGRectMake(0, 0, appDelegate.screenWidth, 20);
            lbl.textColor = [UIColor whiteColor];
            [viewHeader addSubview:lbl];
            
            if(section==0)
            {
                lbl.text = @"Please set your availability";
            }
            else {
                lbl.text = @"Please set client age range";
            }
        }
        else
        {
            
        }
            
        return viewHeader;
    }
    else
    {
        UIView *viewHeader = [[UIView alloc] init];
        viewHeader.frame = CGRectMake(0, 0, appDelegate.screenWidth, 40);
        viewHeader.backgroundColor = colorHeader;
        
        UILabel *lblHeader = [[UILabel alloc] init];
        lblHeader.frame = CGRectMake(0, 0, appDelegate.screenWidth, 40);
        lblHeader.text = @"Your 7 days available time";
        lblHeader.textAlignment = NSTextAlignmentCenter;
        lblHeader.textColor = [UIColor whiteColor];
        lblHeader.backgroundColor = [UIColor clearColor];
        [viewHeader addSubview:lblHeader];
        
        return viewHeader;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 101)
    {
        static NSString *CellIdentifier = @"Option";
        UITableViewCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = colorViewBg;
        cell.textLabel.textColor = colorWhiteOrBlack;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        
        [txtFieldAgeRange removeFromSuperview];
        
//        if(indexPath.row<4){
        if(indexPath.section == 0){
    
            cell.textLabel.text = [arrOption objectAtIndex:indexPath.row];

            if(indexPath.row==intSelectedOption)
                cell.imageView.image = [UIImage imageNamed:@"accept.png"];
            else
                cell.imageView.image = [UIImage imageNamed:@"reject.png"];
        }
        else {
            cell.textLabel.text = @"";
            cell.imageView.image = [UIImage imageNamed:@"reject.png"];
            [cell addSubview:txtFieldAgeRange];
            txtFieldAgeRange.frame = CGRectMake(cell.textLabel.frame.origin.x, 0, appDelegate.screenWidth-50, 33);
        }
        
        UIView *viewSelected = [[UIView alloc] init];
        viewSelected.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        cell.selectedBackgroundView = viewSelected;
        
        return cell;
    }
    else
    {
        NSString *CellIdentifier = [arrDays objectAtIndex:indexPath.row];
        UITableViewCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.textColor = colorWhiteOrBlack;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        cell.textLabel.text = [arrDays objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        
        NSString *strSlot = [arrTimeSlots objectAtIndex:indexPath.row];
        if([strSlot isEqualToString:@"always"])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ available", strSlot];
        }
        else if([strSlot isEqualToString:@"not"])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ available", strSlot];
        }
        else
        {
            cell.detailTextLabel.text = [arrTimeSlots objectAtIndex:indexPath.row];
        }
        
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        
        cell.selected = NO;
        cell.backgroundColor = colorViewBg;
        
        UIView *viewSelected = [[UIView alloc] init];
        viewSelected.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        cell.selectedBackgroundView = viewSelected;
        
//        if(intSelectedOption==indexPath.row)
//            cell.backgroundColor = [UIColor colorWithWhite:0.84 alpha:1.0];
//        else
            cell.backgroundColor = colorViewBg;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(tableView.tag == 101)
//    {
//        if(section == 0) {
//            if(arrOption.count==5)
//                return [arrOption count]-1;
//            else
//                return arrOption.count;
//        }
//        else {
//            return 1;
//        }
//    }
//    else {
//        return [arrTimeSlots count];
//    }

    if(tableView.tag == 101)
    {
        tblDays.hidden = YES;
        intSelectedOption = (int)indexPath.row;
        [tblOption reloadData];
        if(indexPath.section == 0) {
            if(indexPath.row == 0)
            {
                viewSetTime.hidden = YES;
                
                [appDelegate addChargementLoader];
                [self updateCounsellorAvailableTimeAlwaysAvailable];
            }
            else if(indexPath.row == 1)
            {
                viewSetTime.hidden = YES;
                
                [appDelegate addChargementLoader];
                [self updateCounsellorAvailableTimeNotAvailable];
            }
            else if(indexPath.row == 2)
            {
                viewSetTime.hidden = NO;
                btnSubmit.hidden = NO;
                pickerTo.hidden = NO;
                pickerFrom.hidden = NO;
                
            }
            else if(indexPath.row == 3)
            {
                viewSetTime.hidden = YES;
                [self gotoSetAvailableTime];
            }
        }
        else //if(indexPath.section == 1)
        {
            if(indexPath.row == 0)
            {
                viewSetTime.hidden = YES;
                [txtFieldAgeRange resignFirstResponder];
                //[self gotoSetAvailableTime];
            }
        }
    }
    else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)gotoSetAvailableTime
{
    SetAvailabilityViewController *objSetTimeVC = [[SetAvailabilityViewController alloc] init];
    objSetTimeVC.arrTimeSlots = arrTimeSlots;
    
    if(self.navigationController)
        [self.navigationController pushViewController:objSetTimeVC animated:YES];
    else
        [appDelegate.navControl pushViewController:objSetTimeVC animated:YES];
    objSetTimeVC = nil;
}

#pragma mark - Parser

- (void)getPendingQuestions
{    
//    {
//        "requestData": {
//            "apikey": "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data": {
//                "counsellorid":"rizwan1"
//            },
//            "requestType": "getCounsellorQuestions"
//        }
//    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], nil] forKeys:[NSArray arrayWithObjects: @"counsellorid",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getCounsellorQuestions", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];

    NSLog(@"getCounsellorQuestions = %@", dictParameter);
    [appCounsellingLoginParser sharedManager].strMethod = @"getCounsellorQuestions";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        [arrPendingRatting removeAllObjects];
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dictData in responseDict)
            {
                [arrPendingRatting addObject:dictData];
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [appDelegate updateCurrentTime];
            [self getLiveAppointment];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getPendingQuestions];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)getLiveAppointment
{
//
//    {
//        "requestData":
//        {
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "requestType":"getAppointment",
//            "data":{
//                "clcnslrun01":"rizwan3",
//                "status":"Accepted"
//            }
//        }
//    }
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], @"Accepted", nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01", @"status", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointment", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    NSLog(@"--parameters--%@", parameters);
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    NSLog(@"%@", dictParameter);
    [appCounsellingLoginParser sharedManager].strMethod = @"getAppointment";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            [arrAcceptedAppointments removeAllObjects];
            for (NSDictionary *dictData in responseDict)
            {
//                [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"yes"];
//                [[NSUserDefaults standardUserDefaults] synchronize];

                [arrAcceptedAppointments addObject:dictData];
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [self checkIfLiveAppointment];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getLiveAppointment];
            }
            else
            {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)checkIfLiveAppointment
{
    BOOL isAppointmentLive = NO;
    for (int i=0; i<arrAcceptedAppointments.count; i++)
    {
        NSDictionary *dictAppointment = [arrAcceptedAppointments objectAtIndex:i];
        
        //from here the app will navigate to the live
        isAppointmentLive = [self checkIfTheAppointmentIsLive:dictAppointment];
        
        if(isAppointmentLive)
        {
            break;
        }
    }
    
    if(isAppointmentLive==NO)
    {
        lblNoAppointment.hidden = NO;

        [arrOldAppointmentPendingRatting removeAllObjects];
        if(arrPendingRatting && arrPendingRatting.count>0)
        {
            for (int i=0; i<arrPendingRatting.count; i++) {
                
                NSDictionary *dictQ = [arrPendingRatting objectAtIndex:i];
                [arrOldAppointmentPendingRatting addObject:dictQ];
            }
        }
        
        if(arrOldAppointmentPendingRatting.count>0)
        {
            isCommingFromRatting = YES;
            AppCounsellingRattingViewController *objRattingVC = [[AppCounsellingRattingViewController alloc] init];
            objRattingVC.arrRattingQuestions = arrOldAppointmentPendingRatting;
            objRattingVC.dictAppointment = nil;
            if(self.navigationController)
                [self.navigationController pushViewController:objRattingVC animated:YES];
            else
                [appDelegate.navControl pushViewController:objRattingVC animated:YES];
            objRattingVC = nil;
        }
    }
}

- (BOOL)checkIfTheAppointmentIsLive:(NSDictionary *)dictAppointment
{
    BOOL isAppointmentLive = NO;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatte setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:formatServer];
    
    NSString *strAppointmentDate = [dictAppointment objectForKey:@"apntmnt_date"];

    NSDate *appointmentDate = [dateFormatter dateFromString:strAppointmentDate];
        
    NSDate *currDate;
    
    if(appDelegate.dateServer)
        currDate = appDelegate.dateServer;
    else
        currDate = [NSDate date];
    
    NSTimeInterval distanceBetweenDates = [appointmentDate timeIntervalSinceDate:currDate];
    
    long seconds = lroundf(distanceBetweenDates);
    int hours = (seconds / 3600);
    int mins = (seconds % 3600) / 60;
    int secs = seconds % 60;
    
    int intTimeLeft = secs+(60*mins);
    
    NSString *strStatus = [dictAppointment objectForKey:@"status"];
    
    int intTimeDuration = 60*appDelegate.timeDuration;
    NSLog(@"intTimeDuration = %i", intTimeDuration);
    
    if(intTimeLeft<300 && [strStatus isEqualToString:@"Accepted"])
    {
        if(intTimeLeft>0 && hours==0)
        {
            isAppointmentLive = YES;
            [self gotoLiveCounsellingTimer:dictAppointment];
        }
        else if(intTimeLeft>-intTimeDuration && hours==0)
        {
            isAppointmentLive = YES;
            [self gotoCounsellingMode:dictAppointment];
        }
        else
        {
            //Do nothing
        }
    }
    else
    {
        //[self designAlreadyBooked];
    }
    
    return isAppointmentLive;
}

#pragma mark - Parser : Update Cousellor Time

- (void)getAvailableSlots
{
//        {
//            "requestData":
//            {
//                "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//                "requestType":"getCounsellorAvailableSlots",
//                "data":{
//                    "agency_unq_id":"xc3bOnXPRB3UTaLe02PH1Q==1492843622744"
//                    "counc_unq_id":"xc3bOnXPRB3UTaLe02PH1Q==1492843622744"
//                }
//            }
//        }

    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:[appDelegate.dictProfile objectForKey:@"agencyId"] forKey:@"agency_unq_id"];
    [data setObject:[appDelegate.dictProfile objectForKey:@"counsellorid"] forKey:@"counc_unq_id"];
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getCounsellorAvailableSlots", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"dictParameter = %@", dictParameter);
    
    [appCounsellingLoginParser sharedManager].strMethod = @"getCounsellorForAgency";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            NSArray *arrDaysReceived = (NSArray *)responseDict;
            
            
            
            for (int i=0; i<arrDaysReceived.count; i++) {

                NSDictionary *dictDataDay = [arrDaysReceived objectAtIndex:i];

                if(i==0)
                {
                    strType = [dictDataDay objectForKey:@"available_type"];
                    strFrom7Days = [dictDataDay objectForKey:@"from"];
                    strTo7Days = [dictDataDay objectForKey:@"to"];
                }
                
                NSString *strFrom = [dictDataDay objectForKey:@"from"];
                NSString *strTo = [dictDataDay objectForKey:@"to"];
                NSString *strDay = [dictDataDay objectForKey:@"day"];

                if([strFrom isEqualToString:@"always"])
                {
                    if ([arrTimeSlots containsObject: strDay]) // YES
                    {
                        [arrTimeSlots replaceObjectAtIndex:[arrTimeSlots indexOfObject:strDay] withObject:@"always"];
                    }
                    else{

                    }
                }
                
                else if([strFrom isEqualToString:@"not"])
                {
                    [arrTimeSlots replaceObjectAtIndex:[arrTimeSlots indexOfObject:strDay] withObject:@"not"];
                }
                else
                {
                    NSString *strTimeSlot = [NSString stringWithFormat:@"%@ to %@", strFrom, strTo];
                    [arrTimeSlots replaceObjectAtIndex:[arrTimeSlots indexOfObject:strDay] withObject:strTimeSlot];
                }
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [tblDays reloadData];
            
            viewSetTime.hidden = YES;

            if([strType isEqualToString:@"always"])
            {
                intSelectedOption = 0;
            }
            else if([strType isEqualToString:@"not"])
            {
                intSelectedOption = 1;
            }
            else if([strType isEqualToString:@"7 days"])
            {
                intSelectedOption = 2;
                
                [btnFrom setTitle:strFrom7Days forState:UIControlStateNormal];
                [btnTo setTitle:strTo7Days forState:UIControlStateNormal];
                
                viewSetTime.hidden = NO;
                btnSubmit.hidden = YES;
                pickerTo.hidden = YES;
                pickerFrom.hidden = YES;
            }
            else if([strType isEqualToString:@"per day"])
            {
                intSelectedOption = 3;

                viewSetTime.hidden = NO;
                tblDays.hidden = NO;
                btnSubmit.hidden = YES;
                pickerTo.hidden = YES;
                pickerFrom.hidden = YES;
            }
            [tblOption reloadData];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getAvailableSlots];
            }
            else
            {
                [appDelegate removeChargementLoader];
            }
        });
    }];

}

- (void)updateCounsellorAvailableTime
{
    NSString *strFrom = [btnFrom titleForState:UIControlStateNormal];
    NSString *strTo = [btnTo titleForState:UIControlStateNormal];
    
    NSMutableArray *arrData = [[NSMutableArray alloc] init];

    for (int i=0; i<arrDays.count; i++) {
        
        NSString *strDay = [arrDays objectAtIndex:i];
        strDay = [strDay substringToIndex:3];
        
        NSMutableDictionary *dictTime = [[NSMutableDictionary alloc] init];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"agencyId"] forKey:@"agency_unq_id"];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"username"] forKey:@"clcnslrun01"];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"counsellorid"] forKey:@"counc_unq_id"];
        [dictTime setObject:strDay forKey:@"day"];
        [dictTime setObject:strFrom forKey:@"from"];
        [dictTime setObject:strTo forKey:@"to"];
        [dictTime setObject:@"7 days" forKey:@"available_type"];
        [dictTime setObject:appDelegate.strFirstname forKey:@"counce_firstname"];
        
        [arrData addObject:dictTime];
    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"updateCounsellorTime", arrData, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"dictParameter = %@", dictParameter);

    [appCounsellingLoginParser sharedManager].strMethod = @"updateCounsellorAvailableTime";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            NSLog(@"Request sent");
        }
        [arrTimeSlots removeAllObjects];
        [arrTimeSlots addObject:[NSString stringWithFormat:@"%@ to %@", strFrom, strTo]];
        [arrTimeSlots addObject:[NSString stringWithFormat:@"%@ to %@", strFrom, strTo]];
        [arrTimeSlots addObject:[NSString stringWithFormat:@"%@ to %@", strFrom, strTo]];
        [arrTimeSlots addObject:[NSString stringWithFormat:@"%@ to %@", strFrom, strTo]];
        [arrTimeSlots addObject:[NSString stringWithFormat:@"%@ to %@", strFrom, strTo]];
        [arrTimeSlots addObject:[NSString stringWithFormat:@"%@ to %@", strFrom, strTo]];
        [arrTimeSlots addObject:[NSString stringWithFormat:@"%@ to %@", strFrom, strTo]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            viewSetTime.hidden = NO;
            btnSubmit.hidden = YES;
            pickerTo.hidden = YES;
            pickerFrom.hidden = YES;

        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self updateCounsellorAvailableTime];
            }
            else
            {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)updateCounsellorAvailableTimeAlwaysAvailable
{
    
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    for (int i=0; i<arrDays.count; i++) {
        
        NSString *strDay = [arrDays objectAtIndex:i];
        strDay = [strDay substringToIndex:3];
        
        NSMutableDictionary *dictTime = [[NSMutableDictionary alloc] init];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"agencyId"] forKey:@"agency_unq_id"];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"username"] forKey:@"clcnslrun01"];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"counsellorid"] forKey:@"counc_unq_id"];
        [dictTime setObject:strDay forKey:@"day"];
        [dictTime setObject:@"always" forKey:@"from"];
        [dictTime setObject:@"always" forKey:@"to"];
        [dictTime setObject:@"always" forKey:@"available_type"];
        [dictTime setObject:appDelegate.strFirstname forKey:@"counce_firstname"];

        [arrData addObject:dictTime];
    }

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"updateCounsellorTime", arrData, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"dictParameter = %@", dictParameter);
    
    [appCounsellingLoginParser sharedManager].strMethod = @"updateCounsellorAvailableTime";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            NSLog(@"Request sent");
        }
        [arrTimeSlots removeAllObjects];
        [arrTimeSlots addObject:@"always"];
        [arrTimeSlots addObject:@"always"];
        [arrTimeSlots addObject:@"always"];
        [arrTimeSlots addObject:@"always"];
        [arrTimeSlots addObject:@"always"];
        [arrTimeSlots addObject:@"always"];
        [arrTimeSlots addObject:@"always"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self updateCounsellorAvailableTime];
            }
            else
            {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)updateCounsellorAvailableTimeNotAvailable
{
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    for (int i=0; i<arrDays.count; i++) {
        
        NSString *strDay = [arrDays objectAtIndex:i];
        strDay = [strDay substringToIndex:3];
        
        NSMutableDictionary *dictTime = [[NSMutableDictionary alloc] init];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"agencyId"] forKey:@"agency_unq_id"];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"username"] forKey:@"clcnslrun01"];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"counsellorid"] forKey:@"counc_unq_id"];
        [dictTime setObject:strDay forKey:@"day"];
        [dictTime setObject:@"not" forKey:@"from"];
        [dictTime setObject:@"not" forKey:@"to"];
        [dictTime setObject:@"not" forKey:@"available_type"];
        [dictTime setObject:appDelegate.strFirstname forKey:@"counce_firstname"];

        [arrData addObject:dictTime];
    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"updateCounsellorTime", arrData, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"dictParameter = %@", dictParameter);
    
    [appCounsellingLoginParser sharedManager].strMethod = @"updateCounsellorAvailableTime";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            NSLog(@"Request sent");
        }
        
        [arrTimeSlots removeAllObjects];
        [arrTimeSlots addObject:@"not"];
        [arrTimeSlots addObject:@"not"];
        [arrTimeSlots addObject:@"not"];
        [arrTimeSlots addObject:@"not"];
        [arrTimeSlots addObject:@"not"];
        [arrTimeSlots addObject:@"not"];
        [arrTimeSlots addObject:@"not"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self updateCounsellorAvailableTime];
            }
            else
            {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)gotoRatting:(NSDictionary *)dictAppointment
{
    isCommingFromRatting = YES;
    AppCounsellingRattingViewController *objRattingVC = [[AppCounsellingRattingViewController alloc] init];
    objRattingVC.arrRattingQuestions = arrPendingRatting;
    objRattingVC.dictAppointment = dictAppointment;
    if(self.navigationController)
        [self.navigationController pushViewController:objRattingVC animated:YES];
    else
        [appDelegate.navControl pushViewController:objRattingVC animated:YES];
    objRattingVC = nil;
    
}
#pragma mark -GO TO Live
/*
 {
 appointmentid = zombie1483423083018;
 comment = "<null>";
 counsellorid = LxyllWw9Xf;
 createdAt =             {
 date = "2017-01-03 06:11:07.064000";
 timezone = Z;
 "timezone_type" = 2;
 };
 objectid = 2zu4etivgy;
 questionid = 7oJfHJgUC5;
 questiontext = "Do you feel this session was helpful to the young person around issues presented?";
 "rated_by" = Counselor;
 rattingcount = 2;
 status = Pending;
 userid = "<null>";
 
 */

- (void)gotoLiveCounsellingTimer:(NSDictionary *)dictAppointment
{
    isCommingFromCounselling = YES;
    
    NSString *strLiveAppointmentID = [dictAppointment objectForKey:@"apntmnt_id"];
    
    [arrOldAppointmentPendingRatting removeAllObjects];
    if(arrPendingRatting && arrPendingRatting.count>0)
    {
        for (int i=0; i<arrPendingRatting.count; i++) {
            
            NSDictionary *dictQ = [arrPendingRatting objectAtIndex:i];
            NSString *strAppointmentID = [dictQ objectForKey:@"apntmnt_id"];
            
            if(![strLiveAppointmentID isEqualToString:strAppointmentID])
            {
                [arrOldAppointmentPendingRatting addObject:dictQ];
            }
        }
    }
    
    if(arrOldAppointmentPendingRatting.count>0)
    {
        isCommingFromRatting = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"is_shown_popup"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        AppCounsellingRattingViewController *objRattingVC = [[AppCounsellingRattingViewController alloc] init];
        objRattingVC.arrRattingQuestions = arrOldAppointmentPendingRatting;
        objRattingVC.dictAppointment = nil;
        if(self.navigationController)
            [self.navigationController pushViewController:objRattingVC animated:YES];
        else
            [appDelegate.navControl pushViewController:objRattingVC animated:YES];
        objRattingVC = nil;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"is_shown_popup"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        AppCounselllingLiveTimerViewController *appCounsellingVC = [[AppCounselllingLiveTimerViewController alloc] init];
        appCounsellingVC.dictAppointment = dictAppointment;
        [appDelegate.navControl pushViewController:appCounsellingVC animated:NO];
        appCounsellingVC = nil;
    }
}
- (void)gotoCounsellingMode:(NSDictionary *)dictAppointment
{
    isCommingFromCounselling = YES;
    
    NSString *strLiveAppointmentID = [dictAppointment objectForKey:@"apntmnt_id"];
    
    [arrOldAppointmentPendingRatting removeAllObjects];
    if(arrPendingRatting && arrPendingRatting.count>0)
    {
        for (int i=0; i<arrPendingRatting.count; i++) {
            
            NSDictionary *dictQ = [arrPendingRatting objectAtIndex:i];
            NSString *strAppointmentID = [dictQ objectForKey:@"apntmnt_id"];
            
            if(![strLiveAppointmentID isEqualToString:strAppointmentID])
            {
                [arrOldAppointmentPendingRatting addObject:dictQ];
            }
        }
    }
    
    if(arrOldAppointmentPendingRatting.count>0)
    {
        isCommingFromRatting = YES;
        AppCounsellingRattingViewController *objRattingVC = [[AppCounsellingRattingViewController alloc] init];
        objRattingVC.arrRattingQuestions = arrOldAppointmentPendingRatting;
        objRattingVC.dictAppointment = nil;
        if(self.navigationController)
            [self.navigationController pushViewController:objRattingVC animated:YES];
        else
            [appDelegate.navControl pushViewController:objRattingVC animated:YES];
        objRattingVC = nil;
    }
    else
    {
        NSString *strMode = [dictAppointment objectForKey:@"mode"];
        strMode = strMode.lowercaseString;
        
        if([strMode isEqualToString:@"chat"])
        {
            AppCounselllingLiveChatViewController *objChatVC = [[AppCounselllingLiveChatViewController alloc] init];
            objChatVC.dictAppointment = dictAppointment;
            [appDelegate.navControl pushViewController:objChatVC animated:NO];
            objChatVC = nil;
        }
        else if([strMode isEqualToString:@"audio"] || [strMode isEqualToString:@"video"])
        {
            AppCounselllingLiveChatViewController *objChatVC = [[AppCounselllingLiveChatViewController alloc] init];
            objChatVC.dictAppointment = dictAppointment;
            [appDelegate.navControl pushViewController:objChatVC animated:NO];
            objChatVC = nil;
        }
    }
}

#pragma mark - UIPickerView delegate and datasource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 1)
    {
        return 1;
    }
    return 70;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 1)
    {
        return @"to";
    }
    else
    {
        NSString *strTitle = [NSString stringWithFormat:@"%li", row+11];
        return strTitle;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
        strFromAge = [NSString stringWithFormat:@"%li", row+11];
        
        if(strFromAge.integerValue > strToAge.integerValue)
        {
            [pickerAgeRange selectRow:strToAge.integerValue-11 inComponent:0 animated:YES];
            strFromAge = strToAge;//[NSString stringWithFormat:@"%li", strFromAge.integerValue-11];
        }
    }
    else if(component == 2)
    {
        strToAge = [NSString stringWithFormat:@"%li", row+11];
        
        if(strFromAge.integerValue > strToAge.integerValue)
        {
            [pickerAgeRange selectRow:strFromAge.integerValue-11 inComponent:2 animated:YES];
            strToAge = strFromAge;//[NSString stringWithFormat:@"%li", strToAge.integerValue-11];
        }
    }
    
    txtFieldAgeRange.text = [NSString stringWithFormat:@"client age range : %@ to %@", strFromAge, strToAge];
}

- (void)btnDoneAgeRangeClicked
{
    [txtFieldAgeRange resignFirstResponder];
    [appDelegate addChargementLoader];
    [self updateAgeRange];
}

- (void)updateAgeRange
{
//    {
//        "requestData" :     {
//            "apikey" : "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data" :         {
//                "counc_unq_id" : "MifMgqCUxzc0f35bscTYcA==1513073339600",
//                "age_range_from" : "11",
//                "age_range_to" : "22"
//
//            },
//            "requestType" : "updateAgeRange"
//        }
//    }

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], strFromAge, strToAge, nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01", @"age_range_from", @"age_range_to", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"updateAgeRange", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"dictParameter = %@", dictParameter);
    
    [appCounsellingLoginParser sharedManager].strMethod = @"updateAgeRange";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        NSLog(@"responseDict = %@", responseDict);
//        if([responseDict isKindOfClass:[NSArray class]])
//        {
//            for (NSDictionary *dictData in responseDict)
//            {
//                [arrAppointment addObject:dictData];
//            }
//            NSLog(@"Request sent");
//        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self updateAgeRange];
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
