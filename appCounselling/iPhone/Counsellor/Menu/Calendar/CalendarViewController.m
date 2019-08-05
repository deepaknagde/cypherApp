//
//  CalendarViewController.m
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "CalendarViewController.h"
#import "appCounsellingLoginParser.h"
#import "AppointmentDetailView.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

@synthesize strTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self designTopBar];
//    [self showBackButton];
    
    if(appDelegate.dateServer)
        selectedDate = appDelegate.dateServer;
    else
        selectedDate = [NSDate date];

    selectedDate = [NSDate date];
    
    arrAppointment = [[NSMutableArray alloc] init];
    arrAppointmentKey = [[NSMutableArray alloc] init];
    arrDateAppointment = [[NSMutableArray alloc] init];
    dictAllAppointments = [[NSMutableDictionary alloc] init];
    
    self.view.backgroundColor = colorViewBg;

    [self screenDesign];
    
    [appDelegate addChargementLoader];
    [self getAcceptedAppointmentOfCounsellor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(viewCalender)
    {
        [viewCalender setTodayDateToCalender];
    }
}

- (void)setTodayDateToCalender
{
    [viewCalender setTodayDateToCalender];
}

- (void)screenDesign
{
    viewCalender = [[CalenderView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenWidth)];    
    viewCalender.delegate = self;
    viewCalender.backgroundColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    viewCalender.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewCalender];
    
    tblAppointment = [[UITableView alloc] init];
    tblAppointment.frame = CGRectMake(0, appDelegate.screenWidth, appDelegate.screenWidth, appDelegate.screenHeight-appDelegate.screenWidth);
    tblAppointment.bounces = NO;
    tblAppointment.delegate = self;
    tblAppointment.dataSource = self;
    tblAppointment.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tblAppointment];
}

- (void)calenderMonthChanged:(NSDate *)calDate
{
    selectedDate = calDate;
    [self showAppointmentsOfTheDay];
}
- (void)calenderDateChanged:(NSDate *)calDate
{
    selectedDate = calDate;
    [self showAppointmentsOfTheDay];
}

- (void)getAcceptedAppointmentOfCounsellor
{
    //    {
    //        "requestData": {
    //            "apikey": "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //            "requestType": "getAppointment",
    //            "counsellorid": "LxyllWw9Xf",
    //            "status": "All"
    //        }
    //    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], @"Accepted", nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01", @"status", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointment", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    [appCounsellingLoginParser sharedManager].strMethod = @"getAppointment";
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
            [self filterAppointments];
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

- (void)filterAppointments
{
    for (int i=0; i<arrAppointment.count; i++)
    {
        NSDictionary *dictAppointment = [arrAppointment objectAtIndex:i];
        NSString *strDate = [dictAppointment objectForKey:@"apntmnt_date"];
        NSArray *arrDateTime = [strDate componentsSeparatedByString:@" "];
        
        NSString *strKey = @"";
        
        if(arrDateTime.count>=2)
            strKey = [arrDateTime objectAtIndex:0];
        else
            strKey = strDate;
        
        NSMutableArray *arrTemp = [dictAllAppointments objectForKey:strKey];
        if(!arrTemp)
        {
            arrTemp = [[NSMutableArray alloc] init];
            [arrTemp addObject:dictAppointment];
            [dictAllAppointments setObject:arrTemp forKey:strKey];
        }
        else
        {
            [arrTemp addObject:dictAppointment];
            [dictAllAppointments setObject:arrTemp forKey:strKey];
        }
    }
    
    [arrAppointmentKey removeAllObjects];
    [arrAppointmentKey addObjectsFromArray:[dictAllAppointments allKeys]];
    
    [self showAppointmentsOfTheDay];
    [self showAppointmentHighlightsOnCalendar];
}

- (void)showAppointmentHighlightsOnCalendar
{
    if(viewCalender!=nil)
    {
        [viewCalender clearMemory];
        [viewCalender removeFromSuperview];
        viewCalender = nil;
    }
    
    viewCalender = [[CalenderView alloc] init];
    viewCalender.arrAppointmentKey = arrAppointmentKey;
    viewCalender.delegate = self;
    viewCalender.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenWidth);
    viewCalender.backgroundColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1.0];
    viewCalender.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewCalender];
}

- (void)showAppointmentsOfTheDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    //[dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *strDateKey = [dateFormatter stringFromDate:selectedDate];
    
    NSMutableArray *arrApp = [dictAllAppointments objectForKey:strDateKey];
    
    [arrDateAppointment removeAllObjects];

    if(arrApp && arrApp.count)
    {
        [arrDateAppointment addObjectsFromArray:arrApp];
    }
    else
    {
    
    }
    [tblAppointment reloadData];
}

#pragma mark - UITAbleView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrDateAppointment count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Calendar";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = (UITableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.imageView.image = [UIImage imageNamed:@"btnRadioCalendar.png"];
    
    NSDictionary *dictAppointment = [arrDateAppointment objectAtIndex:indexPath.row];
    NSString *strDate = [dictAppointment objectForKey:@"apntmnt_date"];
    NSArray *arrDateTime = [strDate componentsSeparatedByString:@" "];
    
    NSNumber *numSL = [dictAppointment objectForKey:@"session_left"];
    
    if(arrDateTime.count>=2)
    {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@  Session Left: %i", [arrDateTime objectAtIndex:1], numSL.intValue];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@  Session Left: %i", strDate, numSL.intValue];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictAppointment = [arrDateAppointment objectAtIndex:indexPath.row];

    [self showAppointmentDetailPopUp:dictAppointment];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)showAppointmentDetailPopUp:(NSDictionary *)dictAppointment
{
    AppointmentDetailView *viewDetails = [[AppointmentDetailView alloc] init];
    viewDetails.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    viewDetails.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    [viewDetails setParameter:dictAppointment];
    [self.view addSubview:viewDetails];

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
