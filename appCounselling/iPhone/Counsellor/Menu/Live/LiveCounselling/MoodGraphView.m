//
//  MoodGraphView.m
//  appCounselling
//
//  Created by MindCrew Technologies on 29/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "MoodGraphView.h"
#import "AppDelegate.h"

@implementation MoodGraphView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewDesigning];
    }
    return self;
}
- (void)viewDesigning
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    viewMoodGraph = [[UIView alloc] init];
    viewMoodGraph.frame = CGRectMake(20, 30, self.frame.size.width-40, self.frame.size.height-80);
    viewMoodGraph.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewMoodGraph];
    
    lblSubTitle = [[UILabel alloc] init];
    lblSubTitle.frame = CGRectMake(0, 5, viewMoodGraph.frame.size.width, 40);
    lblSubTitle.numberOfLines = 2;
    lblSubTitle.textAlignment = NSTextAlignmentCenter;
    lblSubTitle.textColor = [UIColor blackColor];
    lblSubTitle.text = @"Start time :";
    lblSubTitle.font = [UIFont boldSystemFontOfSize:14.0];
    [viewMoodGraph addSubview:lblSubTitle];
    
    UILabel *lbl7Days = [[UILabel alloc] init];
    lbl7Days.frame = CGRectMake(40, 45, viewMoodGraph.frame.size.width-80, 20);
    lbl7Days.textAlignment = NSTextAlignmentCenter;
    lbl7Days.textColor = [UIColor blackColor];
    lbl7Days.font = [UIFont systemFontOfSize:14.0];
    lbl7Days.text = @"User's last 7 days mood graph";
    [viewMoodGraph addSubview:lbl7Days];

    imgViewMoodGraph = [[UIImageView alloc] init];
    imgViewMoodGraph.frame = CGRectMake(10, 70, viewMoodGraph.frame.size.width-20, viewMoodGraph.frame.size.height-80);
    imgViewMoodGraph.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [viewMoodGraph addSubview:imgViewMoodGraph];
    
    indicator1=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator1.hidesWhenStopped=YES;
    indicator1.center = imgViewMoodGraph.center;
    [viewMoodGraph addSubview:indicator1];
    [indicator1 startAnimating];

    btnStart = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-280)/2.0, self.frame.size.height-45, 280, 35)];
    btnStart.layer.cornerRadius  = 5.0;
    btnStart.backgroundColor = [UIColor colorWithRed:35/255 green:150.0/255 blue:230.0/255 alpha:1.0];
    btnStart.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [btnStart addTarget:self action:@selector(btnStartClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnStart setTitle:@"OK" forState:UIControlStateNormal];
    [self addSubview:btnStart];
}

- (void)setParameter:(NSDictionary *)dictAppointment
{
    NSString *strDate = [dictAppointment objectForKey:@"apntmnt_date"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatServer];
    NSDate *dateServer = [formatter dateFromString:strDate];
    
    [formatter setDateFormat:formatToShowWithTime];
    NSString *strDateToShow = [formatter stringFromDate:dateServer];

    lblSubTitle.text = [NSString stringWithFormat:@"Start time : %@ \n Mode : %@", strDateToShow, [dictAppointment objectForKey:@"mode"]];
    
}
- (void)btnStartClicked
{
    [self removeFromSuperview];
}

- (void)closeButtonClicked
{
    [self removeFromSuperview];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark - Image Loading
- (void)showImage:(NSString *)strImageURL
{
    imgViewMoodGraph.image = [self decodeBase64ToImage:strImageURL];
    [indicator1 stopAnimating];
    return;
    strImageURL = [strImageURL stringByReplacingOccurrencesOfString:@"\\" withString:@"%5C"];   //Replace \ by %5C
    NSLog(@"strImageURL = %@", strImageURL);

    
    if([strImageURL length]>5)
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
            imgViewMoodGraph.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profilepic_place_holder" ofType:@"png"]];
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
                    imgViewMoodGraph.image = img;
                else
                    imgViewMoodGraph.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profilepic_place_holder" ofType:@"png"]];
            }
            else {
                imgViewMoodGraph.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profilepic_place_holder" ofType:@"png"]];
            }
            imageData = nil;
            url = nil;
        }
        else {
            imgViewMoodGraph.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profilepic_place_holder" ofType:@"png"]];
        }
        @synchronized(self) {
            if (![[NSThread currentThread] isCancelled]) {
                if(img)
                    imgViewMoodGraph.image = img;
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
