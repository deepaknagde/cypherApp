//
//  DownlodedataViewController.h
//  appCounselling
//
//  Created by Apple on 17/10/18.
//  Copyright © 2018 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DownlodedataViewController : UIViewController
- (IBAction)Actiononback:(id)sender;
    @property (weak, nonatomic) IBOutlet UIWebView *webview_showCSV;
- (IBAction)action_share:(id)sender;
    @property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader_browsing;
    
@end
