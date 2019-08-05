//
//  MenuView.m
//  HumbleBabies
//
//  Created by MindCrew Technologies on 04/12/16.
//  Copyright © 2016 iLabours. All rights reserved.
//

#import "MenuView.h"
#import "AppDelegate.h"
#import "MenuTableViewCell.h"

#import "LiveViewController.h"
#import "CalendarViewController.h"
#import "CounsellingViewController.h"
#import "RescheduleViewController.h"
#import "CounsellorAppointmentViewController.h"

#import "AssessmentForm_VC.h"

//#define colorViewBg [UIColor colorWithRed:26/255.0f green:52/255.0f blue:64/255.0f alpha:1.0]

@implementation MenuView

@synthesize delegate;
@synthesize tblMenuPanal;

- (void)clearMemory
{
    arrMenuAgent = nil;
    arrMenu = nil;
    tblMenuPanal.delegate = nil;
    tblMenuPanal = nil;
    
    btnProfile = nil;
    lblName = nil;
    lblMood = nil;
    
    _thread1 = nil;
    indicator1 = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideMenuPanal];
}
- (void)hideMenuPanal
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:0];
    
    if(self.frame.origin.x == 0)
    {
        self.frame = CGRectMake(-appDelegate.screenWidth, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    }
    
    [UIView commitAnimations];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
     
        
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        arrMenu = [NSArray arrayWithObjects:@"Live", @"Calendar", @"Counselling", @"Reschedule", @"Previous Appointment", @"Delete me", @"Download data", @"Logout", nil];

        arrMenuAgent = [NSArray arrayWithObjects:@"Agent", @"Counsellings", @"Logout", nil];

        tblMenuPanal = [[UITableView alloc] init];
        tblMenuPanal.frame = CGRectMake(0, 0, 240, appDelegate.screenHeight);
        tblMenuPanal.backgroundColor = colorViewBg;
        tblMenuPanal.delegate = self;
        tblMenuPanal.dataSource = self;
        tblMenuPanal.bounces = NO;
        tblMenuPanal.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tblMenuPanal.separatorColor = [UIColor grayColor];
        [self addSubview:tblMenuPanal];

    }
    return self;
}

- (void)callwebServiceForProfileDetails
{

    [appDelegate removeChargementLoader];
}

- (void)setProfileParameter
{
    if(appDelegate.dictProfile)
    {
        lblName.text = [[[appDelegate.dictProfile objectForKey:@"username"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "] uppercaseString];
        NSString *strQuote = [[appDelegate.dictProfile objectForKey:@"email"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "]?[[appDelegate.dictProfile objectForKey:@"email"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "]:@"";
        lblMood.text = strQuote.uppercaseString;
        [self showImage:[appDelegate.dictProfile objectForKey:@"profile_image"]];
    }
}
#pragma mark - UITAbleView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1001)
        return arrMenuAgent.count;
    else
        return [arrMenu count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
//    return 160.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc] init];
    //viewHeader.frame = CGRectMake(0, 0, appDelegate.screenWidth, 160);
    viewHeader.backgroundColor = colorHeader;
    viewHeader.frame = CGRectMake(0, 0, appDelegate.screenWidth, 60);
    
    UILabel *lblMenu = [[UILabel alloc] init];
    lblMenu.frame = CGRectMake(20, 20, 160, 40);
    lblMenu.text = @"Menu";
    lblMenu.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    lblMenu.textAlignment = NSTextAlignmentCenter;
    lblMenu.textColor = [UIColor whiteColor];
    [viewHeader addSubview:lblMenu];

    return viewHeader;
    
    if(btnProfile==nil)
    {
        btnProfile = [[UIButton alloc] init];
        btnProfile.backgroundColor = [UIColor clearColor];
        btnProfile.clipsToBounds = YES;
        btnProfile.layer.cornerRadius = 35;
        btnProfile.layer.borderColor = [UIColor whiteColor].CGColor;
        btnProfile.layer.borderWidth = 1.5;
        btnProfile.frame = CGRectMake(85, 30, 70, 70);
        [btnProfile addTarget:self action:@selector(btnProfileClicked) forControlEvents:UIControlEventTouchUpInside];
        //[btnMenu setTitle:@"=" forState:UIControlStateNormal];
        [viewHeader addSubview:btnProfile];
        
        indicator1=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator1.hidesWhenStopped=YES;
        indicator1.center = btnProfile.center;
        [viewHeader addSubview:indicator1];
        [indicator1 startAnimating];

        lblName = [[UILabel alloc] init];
        lblName.frame = CGRectMake(20, 100, 200, 20);
        lblName.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.textColor = [UIColor whiteColor];
        [viewHeader addSubview:lblName];
        
        lblMood = [[UILabel alloc] init];
        lblMood.frame = CGRectMake(20, 120, 200, 30);
        lblMood.numberOfLines = 2;
        lblMood.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        lblMood.textAlignment = NSTextAlignmentCenter;
        lblMood.textColor = [UIColor whiteColor];
        [viewHeader addSubview:lblMood];
    }
    
    if(appDelegate.dictProfile)
    {
        lblName.text = [appDelegate.dictProfile objectForKey:@"username"];
        lblMood.text = [[appDelegate.dictProfile objectForKey:@"email"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "]?[[appDelegate.dictProfile objectForKey:@"email"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "]:@"";
        [self showImage:[appDelegate.dictProfile objectForKey:@"profile_image"]];
    }
    else
    {
        lblName.text = @"YOUR NAME";
        lblMood.text = @"YOUR EMAIL";
        [btnProfile setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profilepic_place_holder" ofType:@"png"]] forState:UIControlStateNormal];
    }
    return viewHeader;
}
- (void)btnProfileClicked
{
//    ProfileViewController *objProfileVC = [[ProfileViewController alloc] init];
//    [appDelegate.naveControl pushViewController:objProfileVC animated:YES];
//    objProfileVC = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1001)
    {
        static NSString *CellIdentifier = @"Menu";
        MenuTableViewCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = (MenuTableViewCell *)[[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = colorViewBg;
        cell.textLabel.textColor = colorWhiteOrBlack;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        NSString *strPageName = [arrMenuAgent objectAtIndex:indexPath.row];
        
        cell.imgMenuTitle.hidden = YES;

        if([strPageName isEqualToString:@"Agent"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"counselling" ofType:@"png"]];
        }
        else if([strPageName isEqualToString:@"Counsellings"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"reschedule" ofType:@"png"]];
        }
        else if([strPageName isEqualToString:@"Logout"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logout" ofType:@"png"]];
        }
        
        cell.textLabel.text = [arrMenuAgent objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        
        UIView *viewSelected = [[UIView alloc] init];
        viewSelected.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        cell.selectedBackgroundView = viewSelected;
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Menu";
        MenuTableViewCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = (MenuTableViewCell *)[[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = colorViewBg;
        cell.textLabel.textColor = colorWhiteOrBlack;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        NSString *strPageName = [arrMenu objectAtIndex:indexPath.row];
        
        cell.imgMenuTitle.hidden = YES;
        
        if([strPageName isEqualToString:@"Live"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"live" ofType:@"png"]];
        }
        else if([strPageName isEqualToString:@"Calendar"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"calendar" ofType:@"png"]];
        }
        else if([strPageName isEqualToString:@"Counselling"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"counselling" ofType:@"png"]];
        }
        else if([strPageName isEqualToString:@"Reschedule"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"reschedule" ofType:@"png"]];
        }
        else if([strPageName isEqualToString:@"Previous Appointment"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"old_counselling" ofType:@"png"]];
        }
        
        else if([strPageName isEqualToString:@"Delete me"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shield" ofType:@"png"]];
        }
        else if([strPageName isEqualToString:@"Download data"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dounload_gdpr" ofType:@"png"]];
        }
        
        else if([strPageName isEqualToString:@"Logout"])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logout" ofType:@"png"]];
        }
        cell.textLabel.text = [arrMenu objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        
        UIView *viewSelected = [[UIView alloc] init];
        viewSelected.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        cell.selectedBackgroundView = viewSelected;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *strPageName;
    if(tableView.tag == 1001)
    {
        strPageName = [arrMenuAgent objectAtIndex:indexPath.row];
    }
    else
    {
        strPageName = [arrMenu objectAtIndex:indexPath.row];
         NSLog(@"--Font name--  %@", strPageName);
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showThePage:)])
    {
        if ([strPageName isEqualToString:@"Download data"])
        {
          //[self.delegate showdownlodedata:strPageName];
            // Do stuff...
            
           NSLog(@"--Font name--  %@", strPageName);
            
            [self.delegate TestDemo:@"asd"];
            
        }else {
             [self.delegate showThePage:strPageName];
        }
       
       
    }
}

- (void)gotoPage:(NSString *)strPageName
{
    if([strPageName isEqualToString:@"Live"])
    {
        LiveViewController *objLiveVC = [[LiveViewController alloc] init];
        objLiveVC.strTitle = strPageName;
        [appDelegate.navControl pushViewController:objLiveVC animated:YES];
        objLiveVC = nil;
    }
    else if([strPageName isEqualToString:@"Calendar"])
    {
        CalendarViewController *objCalendarVC = [[CalendarViewController alloc] init];
        objCalendarVC.strTitle = strPageName;
        [appDelegate.navControl pushViewController:objCalendarVC animated:YES];
        objCalendarVC = nil;
    }
    else if([strPageName isEqualToString:@"Counselling"])
    {
        CounsellingViewController *objCounselling = [[CounsellingViewController alloc] init];
        objCounselling.strTitle = strPageName;
        [appDelegate.navControl pushViewController:objCounselling animated:YES];
        objCounselling = nil;
    }
    else if([strPageName isEqualToString:@"Reschedule"])
    {
        RescheduleViewController *objRescheduleVC = [[RescheduleViewController alloc] init];
        objRescheduleVC.strTitle = strPageName;
        [appDelegate.navControl pushViewController:objRescheduleVC animated:YES];
        objRescheduleVC = nil;
    }
    else if([strPageName isEqualToString:@"Previous Appointment"])
    {
        CounsellorAppointmentViewController *objRescheduleVC = [[CounsellorAppointmentViewController alloc] init];
        objRescheduleVC.strTitle = strPageName;
        [appDelegate.navControl pushViewController:objRescheduleVC animated:YES];
        objRescheduleVC = nil;
    }
    else if([strPageName isEqualToString:@"Delete me"])
    {
        // [self DeleteMeAPI];
    }
    else if([strPageName isEqualToString:@"Logout"])
    {
//        appDelegate.isLogoutAction = YES;

        [appDelegate.navControl popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutCenter" object:nil];
    }
}

    
#pragma mark - Image Loading
- (void)showImage:(NSString *)strImageURL
{
    strImageURL = [strImageURL stringByReplacingOccurrencesOfString:@"\\" withString:@"%5C"];   //Replace \ by %5C
    NSLog(@"strImageURL = %@", strImageURL);
    
    if([strImageURL length]>5 && [[strImageURL substringToIndex:4] isEqualToString:@"http"])
    {
        if(![indicator1 isAnimating])
            [indicator1 startAnimating];
        
        @synchronized(self) {
            if ([[NSThread currentThread] isCancelled]) return;
            
            [_thread1 cancel];	//Cell! Stop what you were doing!
            _thread1 = nil;
            //            imgViewFile.image = nil;
            
            // We need to download the image, get it in a seperate thread!
            _thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(downloadImage:) object:strImageURL];
            [_thread1 start];
        }
    }
    else
    {
//        if(imgViewFile.image == nil)
        {
            [btnProfile setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profilepic_place_holder" ofType:@"png"]] forState:UIControlStateNormal];
        }
        [indicator1 stopAnimating];
    }
}

- (void)downloadImage:(NSString *)strImageURL
{
    strImageURL = [strImageURL stringByReplacingOccurrencesOfString:@"\\" withString:@"%5C"];   //Replace \ by %5C
    
    [NSThread sleepForTimeInterval:0.2]; // Why sleep? Because if we are scrolling fast the thread will be canceled and we don't want to start downloading.
    
    if (![[NSThread currentThread] isCancelled])
    {
        NSString *strImgURL = strImageURL;
        
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:strImgURL];
        UIImage *img;
        if(url)
        {
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:url options:3 error:&error];
            if(!error){
                img = [UIImage imageWithData:imageData];
                if(img)
                    [btnProfile setImage:img forState:UIControlStateNormal];
                else
                    [btnProfile setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profilepic_place_holder" ofType:@"png"]] forState:UIControlStateNormal];
            }
            else {
                [btnProfile setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profilepic_place_holder" ofType:@"png"]] forState:UIControlStateNormal];
            }
            imageData = nil;
            url = nil;
        }
        else {
            [btnProfile setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profilepic_place_holder" ofType:@"png"]] forState:UIControlStateNormal];
        }
        @synchronized(self) {
            if (![[NSThread currentThread] isCancelled]) {
                if(img)
                    [btnProfile setImage:img forState:UIControlStateNormal];
                [indicator1 stopAnimating];
            }
        }
        img = nil;
        strImgURL = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
