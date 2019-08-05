//
//  DownlodedataViewController.m
//  appCounselling
//
//  Created by Apple on 17/10/18.
//  Copyright © 2018 MindcrewTechnology. All rights reserved.
//

#import "DownlodedataViewController.h"

@interface DownlodedataViewController ()

@end

@implementation DownlodedataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_loader_browsing setHidden:NO];
    
    [_loader_browsing startAnimating];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *filePath = [userDefault objectForKey:@"filePath"];

    
[self.webview_showCSV loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
    

}
    
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish");
    [_loader_browsing stopAnimating];
    [_loader_browsing setHidden:YES];
}
    
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

- (IBAction)Actiononback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)action_share:(id)sender {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *filePath = [userDefault objectForKey:@"filePath"];

    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    NSString *emailTitle =  @"GDPR Data";
    
    NSString *messageBody = @"Hi ! \n Below atteched I send you ";
    
    NSArray *toRecipents = [NSArray arrayWithObject:@"m1891@gmail.com"];
    
    NSData *myData = [NSData dataWithContentsOfFile: filePath];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc addAttachmentData:myData mimeType:@"application/pdf" fileName:@"GDPR.csv"];
    
    [mc setToRecipients:toRecipents];
    
    [self presentViewController:mc animated:YES completion:NULL];
    }
    else{
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"You Must be logged in to email client for sharing data."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       }
                                   ];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    //if result is possible
    if(result == MFMailComposeResultSent || result == MFMailComposeResultSaved || result == MFMailComposeResultCancelled){
        
        //test result and show alert
        switch (result) {
            case MFMailComposeResultCancelled:
               // [self makeAlert:@"Result Cancelled"];
                NSLog(@"--Result Cancelled--");

                break;
            case MFMailComposeResultSaved:
                //[self makeAlert:@"Result saved"];
                NSLog(@"--Result saved--");

                break;
                //message was sent
            case MFMailComposeResultSent:
               // [self makeAlert:@"Result Sent"];
                NSLog(@"--Result Sent--");

                break;
            case MFMailComposeResultFailed:
              //  [self makeAlert:@"Result Failed"];
                NSLog(@"--Result Failed--");

                break;
            default:
                break;
        }
    }
    //else exists error
    else if(error != nil){
        //show error
        //[self makeAlert:[error localizedDescription]];
    }
    
    //dismiss view
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
