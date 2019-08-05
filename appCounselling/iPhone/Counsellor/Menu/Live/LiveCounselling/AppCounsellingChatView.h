//
//  AppCounsellingChatView.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 30/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCounsellingChatBL.h"
#import "AppDelegate.h"

@protocol AppCounsellingChatViewDelegate <NSObject>

@optional
-(void)showAlert:(UIAlertController *)alert;
@optional
-(void)sendMoodGraphToCounsellor;
@optional
-(void)counsellingTimeOver;
@optional
- (void)shouldShowTheCancelOption;
@optional
- (void)uploadRattingQuestions;

@end

@interface AppCounsellingChatView : UIView<UITextViewDelegate, AppCounsellingChatBLDelegate>
{
    AppDelegate *appDelegate;
    AppCounsellingChatBL *objChatBL;
    
    long seconds;
    
    UILabel *lblTitle;
    UILabel *lblWaterMark;
    UILabel *lbl10MinsHeight;
    
    UIScrollView *scrlViewMessage;
    UITextView *txtFieldMessage;
    UIButton *btnSend;
    
    float yRefM;
    BOOL isFromRefresh;
    BOOL isParseCalled;
    
    UIImage *imgLoggedInUser;
    
    NSTimer *timer;
    
    UIView *viewFooter;
    UIView *viewURL;
    
    UIButton *btnShareMoodGraph;
    NSArray *arrEmosions;
    
    UIView *viewTimer;
    UILabel *lblMins;
    UILabel *lblSecs;
    int intTimeLeft;
    BOOL isQuestionUploaded;
    BOOL shouldUploadQuestion;
    
    NSString *strLiveAppointmentStatus;
    
    NSDate *lastUpdateDate;
}
@property(nonatomic) long seconds;
@property(nonatomic) BOOL isQuestionUploaded;
@property(nonatomic) BOOL shouldUploadQuestion;

@property (strong, nonatomic) UIButton *btnShareMoodGraph;
@property (strong, nonatomic) UITextView *txtFieldMessage;
@property (strong, nonatomic) NSMutableDictionary *dictAppointment;
@property (nonatomic, assign) id <AppCounsellingChatViewDelegate> delegate;

@property(nonatomic) NSMutableArray *arrMessages;
@property(nonatomic) NSMutableArray *arrMessagesAudioVideo;
@property(nonatomic) UIImage *imgChatWith;
@property(nonatomic) NSString *strMessageUserID;

@property (strong, nonatomic) UIWebView *webView;

- (void)viewDesigning;

- (void)showMessageDetails:(NSMutableArray *)arrMessage;
- (void)getMessageWith:(NSString *)strUserID andDate:(NSString *)strDate;// showLoading:(BOOL)isLoader;
- (void)clearMemory;
- (void)hideKeyboard;

- (void)sendMessageForCallingAction;
//- (void)sendCallInitiatedMessage;
//- (void)sendCallInitiatedMessage;

@end

