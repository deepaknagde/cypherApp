//
//  SetAvailabilityViewController.m
//  appCounselling
//
//  Created by MindCrew Technologies on 14/06/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import "SetAvailabilityViewController.h"
#import "appCounsellingLoginParser.h"

@interface SetAvailabilityViewController ()

@end

@implementation SetAvailabilityViewController

@synthesize arrTimeSlots;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = colorViewBg;
    [self designTopBar];
    [self showBackButton];
    self.lblTitle.text = @"Available Time";

    intSelectedOption = 0;
    
    arrDays = [[NSMutableArray alloc] init];
    [arrDays addObject:@"Monday"];
    [arrDays addObject:@"Tuesday"];
    [arrDays addObject:@"Wednesday"];
    [arrDays addObject:@"Thursday"];
    [arrDays addObject:@"Friday"];
    [arrDays addObject:@"Saturday"];
    [arrDays addObject:@"Sunday"];
    
//    [arrDays addObject:@"Sun"];
    
    
    [self screenDesigning];

}

#pragma mark - 

- (void)screenDesigning
{
    tblDays = [[UITableView alloc] init];
    tblDays.frame = CGRectMake(0, 64, appDelegate.screenWidth, 231);
    tblDays.backgroundColor = colorHeader;
    tblDays.delegate = self;
    tblDays.dataSource = self;
    tblDays.bounces = NO;
    tblDays.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tblDays.separatorColor = [UIColor grayColor];
    [self.view addSubview:tblDays];
    
}

- (void)showTimeView
{
    if(viewSetTime != nil)
    {
        [btnFrom setTitle:@"00:00" forState:UIControlStateNormal];
        [btnTo setTitle:@"00:00" forState:UIControlStateNormal];
        viewSetTime.hidden = NO;
        
        [btnSave setTitle:[NSString stringWithFormat:@"Save for %@", [arrDays objectAtIndex:intSelectedOption]] forState:UIControlStateNormal];
        return;
    }
    
        
    viewSetTime = [[UIView alloc] initWithFrame:CGRectMake(0, 221+44, appDelegate.screenWidth, appDelegate.screenHeight-150)];
    viewSetTime.backgroundColor = colorViewBg;
    [self.view addSubview:viewSetTime];
    viewSetTime.hidden = YES;

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
    
    [btnFrom setTitle:@"00:00" forState:UIControlStateNormal];
    [btnTo setTitle:@"00:00" forState:UIControlStateNormal];
    
    
    [self showFromTime];
    [self showToTime];
    
    btnSave = [[UIButton alloc] init];
    btnSave.frame = CGRectMake(20, 330, appDelegate.screenWidth-40, 40);
    btnSave.layer.cornerRadius = 10.0;
    btnSave.clipsToBounds = YES;
    btnSave.backgroundColor = colorHeader;
    [btnSave setTitle:[NSString stringWithFormat:@"Save for %@", [arrDays objectAtIndex:intSelectedOption]] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(saveTime) forControlEvents:UIControlEventTouchUpInside];
    [viewSetTime addSubview:btnSave];
    
    if(appDelegate.screenHeight<(595))
    {
        btnSave.frame = CGRectMake(20, appDelegate.screenHeight-265-50, appDelegate.screenWidth-40, 40);
    }

}

- (void)saveTime
{
    viewSetTime.hidden = YES;
    
    NSString *strFrom = [btnFrom titleForState:UIControlStateNormal];
    NSString *strTo = [btnTo titleForState:UIControlStateNormal];
    
    [arrTimeSlots replaceObjectAtIndex:intSelectedOption withObject:[NSString stringWithFormat:@"%@ to %@", strFrom, strTo]];
    [tblDays reloadData];
    
    [appDelegate addChargementLoader];
    [self updateCounsellorAvailableTime];

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
    
    pickerFrom.frame = CGRectMake(0, 80, appDelegate.screenWidth/2.0, 256);
    
    if(appDelegate.screenHeight<=(568))
    {
        pickerFrom.frame = CGRectMake(0, 70, appDelegate.screenWidth/2.0, 220);
    }
    
    viewSetTime.hidden = NO;
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
    
    if(appDelegate.screenHeight<=(568))
    {
        pickerTo.frame = CGRectMake(appDelegate.screenWidth/2.0, 70, appDelegate.screenWidth/2.0, 220);
    }

    viewSetTime.hidden = NO;
    pickerTo.hidden = NO;
    pickerFrom.hidden = NO;
    
}

- (void)setFromTime
{
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

//    [appDelegate addChargementLoader];
//    [self updateCounsellorAvailableTime];
}

#pragma mark - UITAbleView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrDays count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc] init];
    return viewHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    
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

    cell.selected = NO;
    cell.backgroundColor = colorViewBg;
    
    UIView *viewSelected = [[UIView alloc] init];
    viewSelected.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    cell.selectedBackgroundView = viewSelected;
    
    if(intSelectedOption==indexPath.row)
        cell.backgroundColor = [UIColor colorWithWhite:0.84 alpha:1.0];
    else
        cell.backgroundColor = colorViewBg;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    intSelectedOption = (int) indexPath.row;
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@"Set your availibility."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* notButton = [UIAlertAction
                                actionWithTitle:@"Not available"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                    viewSetTime.hidden = YES;
                                    
                                    [arrTimeSlots replaceObjectAtIndex:intSelectedOption withObject:@"not"];
                                    [tblDays reloadData];
                                    
                                    [appDelegate addChargementLoader];
                                    [self updateCounsellorAvailableTime];
                                }];
    [alert addAction:notButton];

    UIAlertAction* alwaysButton = [UIAlertAction
                                actionWithTitle:@"Always available"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {

                                    viewSetTime.hidden = YES;
                                    
                                    [arrTimeSlots replaceObjectAtIndex:intSelectedOption withObject:@"always"];
                                    [tblDays reloadData];
                                    
                                    [appDelegate addChargementLoader];
                                    [self updateCounsellorAvailableTime];
                                }];
    [alert addAction:alwaysButton];

    UIAlertAction* setButton = [UIAlertAction
                                actionWithTitle:@"Set your available time"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                    [self showTimeView];
                                    [tblDays reloadData];
                                }];
    [alert addAction:setButton];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Parser 

- (void)updateCounsellorAvailableTime
{
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    for (int i=0; i<arrDays.count; i++) {
        
        NSString *strDay = [arrDays objectAtIndex:i];
        strDay = [strDay substringToIndex:3];
        
        NSString *strFromTo = [arrTimeSlots objectAtIndex:i];
        NSArray *arrSlot = [strFromTo componentsSeparatedByString:@" to "];
        
        NSString *strFrom = @"";
        NSString *strTo = @"";
        
        if(arrSlot.count >= 2)
        {
            strFrom = [arrSlot objectAtIndex:0];
            strTo = [arrSlot objectAtIndex:1];
        }
        else {
            strFrom = strFromTo;
            strTo = strFromTo;
        }
        
        NSArray *arrDayTemp = [[NSArray alloc] initWithObjects:@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", nil];

        if([arrDayTemp containsObject:strFrom] || [arrDayTemp containsObject:strTo])
        {
        
        }
            
        
        NSMutableDictionary *dictTime = [[NSMutableDictionary alloc] init];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"agencyId"] forKey:@"agency_unq_id"];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"username"] forKey:@"clcnslrun01"];
        [dictTime setObject:[appDelegate.dictProfile objectForKey:@"counsellorid"] forKey:@"counc_unq_id"];
        [dictTime setObject:strDay forKey:@"day"];
        [dictTime setObject:strFrom forKey:@"from"];
        [dictTime setObject:strTo forKey:@"to"];
        [dictTime setObject:@"per day" forKey:@"available_type"];
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
//            viewSetTime.hidden = NO;
//            btnSubmit.hidden = YES;
//            pickerTo.hidden = YES;
//            pickerFrom.hidden = YES;
            
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
