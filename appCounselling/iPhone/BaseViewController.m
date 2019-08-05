//
//  BaseViewController.m
//  appCounselling
//
//  Created by MindCrew Technologies on 23/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "AppCounselllingLiveTimerViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize lblTitle;

- (BOOL)isiOS8OrAbove {
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0"
                                                                       options: NSNumericSearch];
    return (order == NSOrderedSame || order == NSOrderedDescending);
}

//- (NSUInteger) supportedInterfaceOrientations {
//    // Return a bitmask of supported orientations. If you need more,
//    // use bitwise or (see the commented return).
//    return UIInterfaceOrientationMaskPortrait;
//    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
//}
//
//- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
//    // Return the orientation you'd prefer - this is what it launches to. The
//    // user can still rotate. You don't have to implement this method, in which
//    // case it launches in the current orientation
//    return UIInterfaceOrientationPortrait;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isFromViewDidLoad = YES;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = colorViewBg;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    appDelegate.isServerswitched = NO;
    //appDelegate.webURLString = "https://dfjndkfjhdkjdkjfhdkjfsdk.svdjfhdkjfhskdj"
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [appDelegate updateCurrentTime];
//    isFromViewDidLoad = NO;
}
- (void)designTopBar
{
    if(self.navigationController)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        viewTopBar = [[UIView alloc] init];
        viewTopBar.frame = CGRectMake(0, 0, appDelegate.screenWidth, 64);
        viewTopBar.backgroundColor = colorHeader;
        [self.view addSubview:viewTopBar];
        
        //        UIImageView *imgViewNavBarBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, 64)];
        //        imgViewNavBarBG.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"navBarBG" ofType:@"png"]];
        //        [self.view addSubview:imgViewNavBarBG];
        //        imgViewNavBarBG = nil;
        
        btnMenu = [[UIButton alloc] init];
        btnMenu.backgroundColor = [UIColor clearColor];
        btnMenu.frame = CGRectMake(0, 20, 44, 44);
        [btnMenu addTarget:self action:@selector(btnMenuClicked) forControlEvents:UIControlEventTouchUpInside];
        [btnMenu setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btnMenu" ofType:@"png"]] forState:UIControlStateNormal];
        [viewTopBar addSubview:btnMenu];
        
        btnBack = [[UIButton alloc] init];
        btnBack.backgroundColor = [UIColor clearColor];
        btnBack.frame = CGRectMake(0, 20, 44, 44);
        [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
        [btnBack setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btnBack" ofType:@"png"]] forState:UIControlStateNormal];
        [self.view addSubview:btnBack];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.frame = CGRectMake(50, 20, appDelegate.screenWidth-100, 44);
        lblTitle.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:lblTitle];
        
        btnBack.hidden = YES;
        btnMenu.hidden = NO;
        
    }
    else
    {
        UIImageView *imgViewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight)];
        imgViewBG.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mainBG" ofType:@"png"]];
        [self.view addSubview:imgViewBG];
        imgViewBG = nil;
        
        btnMenu = [[UIButton alloc] init];
        btnMenu.backgroundColor = [UIColor clearColor];
        btnMenu.frame = CGRectMake(0, 20, 44, 44);
        [btnMenu addTarget:self action:@selector(btnMenuClicked) forControlEvents:UIControlEventTouchUpInside];
        //        [btnMenu setTitle:@"=" forState:UIControlStateNormal];
        [btnMenu setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btnMenu" ofType:@"png"]] forState:UIControlStateNormal];
        [self.view addSubview:btnMenu];
        
        btnBack = [[UIButton alloc] init];
        btnBack.backgroundColor = [UIColor clearColor];
        btnBack.frame = CGRectMake(0, 20, 44, 44);
        [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
        [btnBack setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btnBack" ofType:@"png"]] forState:UIControlStateNormal];
        [self.view addSubview:btnBack];
        
        btnMenu.hidden = YES;
        btnBack.hidden = YES;
        
    }
}
- (void)showBackButton
{
    btnBack.hidden = NO;
    btnMenu.hidden = YES;
}
- (void)showMenuButton
{
    btnBack.hidden = YES;
    btnMenu.hidden = NO;
}

- (void)showBackButtonNoBar
{
    btnBack.hidden = NO;
    btnMenu.hidden = YES;
}

- (void)btnBackClicked
{
    if(self.navigationController)
        [appDelegate.navControl popViewControllerAnimated:YES];
    else if(self.view.superview)
        [self.view removeFromSuperview];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showInternetErrorMessage
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Internet error!"
                                 message:@"Please try later."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertMessage:(NSString *)strMessage
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:strMessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 

-(NSString *)getEncryptedString:(NSString *)strString
{
//    let key: String = appDelegate.objEncrypter.sha256("newapp17mindcrew", length: 32)
//    let iv: String = "mindcrewnewapp17"
//    let encryptedData: Data = appDelegate.objEncrypter.encrypt(secret.data(using: String.Encoding.utf8), key: key, iv: iv)

    
    StringEncryption *objEncrypter = [[StringEncryption alloc] init];

    
//    -  (NSString*)sha256:(NSString *)key length:(NSInteger) length;
    
    NSString *key = [objEncrypter sha256:@"newapp17mindcrew" length:32];
    NSString *iv = @"mindcrewnewapp17";
    

    NSData * encryptedData = [objEncrypter encrypt:[strString dataUsingEncoding:NSUTF8StringEncoding] key:key iv:iv];
    
    //        print("Encrypted data ", encryptedData.base64EncodedString());
    
    return [encryptedData  base64EncodingWithLineLength:0];
}

- (NSString *)getDycryptString:(NSString *)secret  {
    
    NSString *key = [[[StringEncryption alloc] init] sha256:@"newapp17mindcrew" length:32];
    NSString *iv = @"mindcrewnewapp17";
    
    NSData * encryptedData = [NSData dataWithBase64EncodedString:secret];
    
    encryptedData = [[[StringEncryption alloc] init] decrypt:encryptedData key:key iv:iv];
    
    NSString * decryptedText = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    
    return decryptedText;
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
