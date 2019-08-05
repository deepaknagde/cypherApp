//
//  MenuView.h
//  HumbleBabies
//
//  Created by MindCrew Technologies on 04/12/16.
//  Copyright © 2016 iLabours. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appCounsellingLoginParser.h"
#import "BaseViewController.h"

@protocol MenuViewDelegate;
    
@class AppDelegate;
@interface MenuView : UIView <UITableViewDelegate, UITableViewDataSource,appCounsellingLoginParserDelegate>
{
    NSArray *arrMenu;
    NSArray *arrMenuAgent;
    AppDelegate *appDelegate;
    
    UITableView *tblMenuPanal;
    
    UIButton *btnProfile;
    UILabel *lblName;
    UILabel *lblMood;

    NSThread *_thread1;
    UIActivityIndicatorView *indicator1;

}

@property(nonatomic,assign)__unsafe_unretained id <MenuViewDelegate>delegate;
@property(nonatomic, strong) UITableView *tblMenuPanal;

- (void)callwebServiceForProfileDetails;
- (void)setProfileParameter;

@end

@protocol MenuViewDelegate <NSObject>

@optional
- (void)showThePage:(NSString *)strpageName;
- (void)TestDemo:(NSString *)strpageName;
@end
