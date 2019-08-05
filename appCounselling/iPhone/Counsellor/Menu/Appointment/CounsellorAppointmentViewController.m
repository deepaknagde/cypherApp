//
//  CounsellorAppointmentViewController.m
//  appCounselling
//
//  Created by MindCrew Technologies on 06/12/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import "CounsellorAppointmentViewController.h"
#import "CounsellorAppointmentCell.h"
#import "appCounsellingLoginParser.h"

@interface CounsellorAppointmentViewController ()

@end

@implementation CounsellorAppointmentViewController

@synthesize strTitle;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    arrAppointment = [[NSMutableArray alloc] init];
    arrRating = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = colorViewBg;
    
    [self designTopBar];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [appDelegate addChargementLoader];
    
    [self getCounsellorAllAppointments];
    [tblAppointments reloadData];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCounsellorAllAppointments) name:@"getallapoiment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tablerelod) name:@"tablereloda" object:nil];
}

- (void)tablerelod{
    dispatch_async(dispatch_get_main_queue(), ^{
        //            [appDelegate removeChargementLoader];
         [tblAppointments reloadData];
    });
    
}
- (void)showAppointment
{
    if(tblAppointments==nil)
    {
        tblAppointments = [[UITableView alloc] init];
        tblAppointments.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight-64);
        tblAppointments.backgroundColor = colorViewBg;
        tblAppointments.delegate = self;
        tblAppointments.dataSource = self;
        tblAppointments.bounces = YES;
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

#pragma mark - Appointment UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arrAppointmentRating = [[NSMutableArray alloc] init];
    NSMutableDictionary *dictAppointment = [arrAppointment objectAtIndex:indexPath.row];
    
    NSString *strAppointmentID = [dictAppointment objectForKey:@"apntmnt_id"];

    NSLog(@"strAppointmentID = %@", strAppointmentID);
    
    for (int i=0; i<arrRating.count; i++)
    {
        NSDictionary *dictRating = [arrRating objectAtIndex:i];
        NSString *strAppointmentId = [dictRating objectForKey:@"apntmnt_id"];
        NSLog(@"Id to match = %@", strAppointmentId);
        if([strAppointmentID isEqualToString:strAppointmentId])
        {
            [arrAppointmentRating addObject:dictRating];
        }
    }

    float diffHeight = 0;

    if(arrAppointmentRating.count > 0)
    {
        CGFloat screenWidth = appDelegate.screenWidth-150;
        float xRef = 145;
        
        for (int i=0; i<arrAppointmentRating.count; i++)
        {
            NSDictionary *dictRating = [arrAppointmentRating objectAtIndex:i];
            
            NSString *strStatus = [dictRating objectForKey:@"status"];//Done
            NSString *strQuestionID = [dictRating objectForKey:@"questionid"];
            NSNumber *numRatingCount = [dictRating objectForKey:@"rattingcount"];
            NSString *strComment = [dictRating objectForKey:@"comment"];//Done
            NSString *strQuestion = [dictRating objectForKey:@"questiontext"];//Done
            strQuestion = [self getDycryptString:strQuestion];
            
            UIColor *colorBG = [UIColor clearColor]; //colorHeader;
            
            if([strStatus isEqualToString:@"Done"])
            {
                if([strQuestionID isEqualToString:@"7"])//User Overall
                {
                }
                else if([strQuestionID isEqualToString:@"1"])//Counselor
                {
                    
                    UILabel *lblRatingComment = [[UILabel alloc] init];
                    lblRatingComment.frame = CGRectMake(xRef, 330+80, screenWidth-50, 30);
                    lblRatingComment.numberOfLines = 0;
//                    strComment = @"I have cancelled all public show for dec n jan due to my ill health and other important commitments.";
                    lblRatingComment.text = strComment;
                    
                    CGSize size = [strComment sizeWithFont:lblRatingComment.font constrainedToSize:CGSizeMake(screenWidth-50, 1000) lineBreakMode:NSLineBreakByCharWrapping];
                    
                    if(size.height > 30)
                        diffHeight = diffHeight+(size.height-20);
                }
                else if([strQuestionID isEqualToString:@"3"])//Counselor
                {
                    UILabel *lblRatingComment = [[UILabel alloc] init];
                    lblRatingComment.frame = CGRectMake(xRef, 330+80, screenWidth-30, 30);
                    lblRatingComment.numberOfLines = 0;
                    //strComment = @"As I have already mentioned in my youtube live earlier on 1st dec.";
                    lblRatingComment.text = strComment;
                    
                    CGSize size = [strComment sizeWithFont:lblRatingComment.font constrainedToSize:CGSizeMake(screenWidth-50, 1000) lineBreakMode:NSLineBreakByCharWrapping];
                    
                    if(size.height > 30)
                        diffHeight = diffHeight+(size.height-20);
                }
            }
        }
    }
    return 490+diffHeight;//180
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrAppointment count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dictAppointment = [arrAppointment objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [dictAppointment objectForKey:@"apntmnt_id"];
    CounsellorAppointmentCell *cell;
    

    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = (CounsellorAppointmentCell *)[[CounsellorAppointmentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell showAppointments:dictAppointment];
    [cell showRatingOfAppointment:arrRating];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSMutableArray *localArr = [[NSMutableArray alloc] init];
//    NSLog(@"strAppointmentID = %@", strAppointmentID);
    
    NSMutableArray *arrAppointmentRating = [[NSMutableArray alloc] init];
    NSMutableDictionary *dictAppointment = [arrAppointment objectAtIndex:indexPath.row];
    
    NSString *strAppointment_ID = [dictAppointment objectForKey:@"apntmnt_id"];
    
    for (int i=0; i<arrRating.count; i++)
    {
        NSDictionary *dictRating = [arrRating objectAtIndex:i];
        NSString *strAppointmentId = [dictRating objectForKey:@"apntmnt_id"];
        NSLog(@"Id to match = %@", strAppointmentId);
        if([strAppointment_ID isEqualToString:strAppointmentId])
        {
            [localArr addObject:dictRating];
        }
    }
    if(localArr.count > 0)
    {
        for (int i=0; i<localArr.count; i++)
        {
            NSDictionary *dictRating = [localArr objectAtIndex:i];
            
            NSString *strStatus = [dictRating objectForKey:@"status"];//Done
            NSString *strQuestionID = [dictRating objectForKey:@"questionid"];
            NSNumber *numRatingCount = [dictRating objectForKey:@"rattingcount"];
            NSString *strComment = [dictRating objectForKey:@"comment"];//Done
            
            NSLog(@"--strComment--%@", dictRating);
            NSLog(@"--strQuestionID--%@", strQuestionID);
        }
    }
    
   
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK:- Parser
-(void)getCounsellorAllAppointments
{
//    {
//        "requestData":{
//
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data":{
//
//                "clcnslrun01":"\/RUeqJqQcOi6nx4lmyYPVw=="
//            },
//            "requestType":"getCounsellorAllAppointments"
//        }
//    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getCounsellorAllAppointments", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"dictParameter = %@", dictParameter);
    
    [appCounsellingLoginParser sharedManager].strMethod = @"getCounsellorAllAppointments";
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
//            [appDelegate removeChargementLoader];
            [self getCounsellorAllRatting];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getCounsellorAllAppointments];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)getCounsellorAllRatting
{
//    {
//        "requestData":{
//
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data":{
//
//                "clcnslrun01":"\/RUeqJqQcOi6nx4lmyYPVw=="
//            },
//            "requestType":"getCounsellorAllRatting"
//        }
//    }

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getCounsellorAllRatting", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"dictParameter = %@", dictParameter);
    
    [appCounsellingLoginParser sharedManager].strMethod = @"getCounsellorAllRatting";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            [arrRating removeAllObjects];
            for (NSDictionary *dictData in responseDict)
            {
                [arrRating addObject:dictData];
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
                [self getCounsellorAllRatting];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}


- (void)getRatingForAppointment:(NSString *)strAppointmentID
{
    
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
