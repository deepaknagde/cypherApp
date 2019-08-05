//
//  AppCounsellingChatBL.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 30/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "appCounsellingChatParser.h"

#import "AppDelegate.h"

@protocol AppCounsellingChatBLDelegate;
@class AppDelegate;
@interface AppCounsellingChatBL : NSObject <appCounsellingChatParserDelegate>
{
    AppDelegate *appDelegate;
    
    NSDictionary *dictRattedQuestion;
}

@property(nonatomic,assign)id <AppCounsellingChatBLDelegate>callBack;

- (void)sendMessage:(NSString *)strUserID messageUerID:(NSString *)strMessageUserID andMessage:(NSString *)strMessage forAppointment:(NSString *)strAppointmentID;

- (void)getMessageWith:(NSString *)strUserID andDate:(NSString *)strDate forAppointment:(NSString *)strAppointmentId;

- (void)makeReadMessage:(NSDictionary *)dictMessage forAppointment:(NSString *)strAppointmentID;
- (void)session:(NSDictionary *)dictMessage forIcrementSesstion:(NSString *)strIcreametID;


//RATTING
- (void)setRattingQuestionsToUpdate:(NSDictionary *)dictAppointment;
- (void)getRattingQuestionsToUpdate:(NSDictionary *)dictAppointment;
- (void)rateTheQuestion:(NSDictionary *)dictQuestion withRatting:(NSNumber *)rattingCount;
- (void)commentTheQuestion:(NSDictionary *)dictQuestion withRatting:(NSString *)strComment;

@end

@protocol AppCounsellingChatBLDelegate <NSObject>

@optional
- (void)sendMessageParserFinished:(NSDictionary *)dictMessage;
@optional
- (void)getMessageParserFinished:(NSMutableArray *)arrMessage appointmentStatus:(NSString *)strStatus;
@optional
- (void)makeReadMessageParserFinished:(NSDictionary *)dictMessage;

//RATTING
@optional
- (void)getRattingQuestionsToUpdateFinished:(NSArray *)arrQuestion;
@optional
- (void)rateTheQuestionFinished:(NSNumber *)rattingCount;
@optional
- (void)commentTheQuestionFinished:(NSString *)strComment;

@optional
- (void)errorOccured:(NSError *)error;

@end
