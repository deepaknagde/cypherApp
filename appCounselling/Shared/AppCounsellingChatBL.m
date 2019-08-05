//
//  AppCounsellingChatBL.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 30/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import "AppCounsellingChatBL.h"
#import "appCounsellingChatParser.h"
#import "GetMessageParser.h"

#define appCounsellingChattingClassName @"CounsellorChat"
#define strKeyWebService @"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R"

@implementation AppCounsellingChatBL

@synthesize callBack;

- (void)clearMemory
{

}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)sendMessage:(NSString *)strUserID messageUerID:(NSString *)strMessageUserID andMessage:(NSString *)strMessage forAppointment:(NSString *)strAppointmentID
{
    
    //        {
    //            "requestData":{
    //                "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //                "data":{
    //                    "appointmentid":"qMTrir5/a7Nota+tQwdxTA\u003d\u003d1493960001737",
    //                    "message":"fZhsMfJwgo1Vgl2Pk0aeCQ\u003d\u003d",
    //                    "read":false,
    //                    "receiver":"qMTrir5/a7Nota+tQwdxTA\u003d\u003d",
    //                    "sender":"pyAtscTYswMf7aatrZ+gLQ\u003d\u003d",
    //                    "unique_id":"pyAtscTYswMf7aatrZ+gLQ\u003d\u003d1493972239749"
    //                    "user_type":"user"
    //                },
    //                "requestType":"sendMessage"
    //            }
    //        }

    long long timeInMilisInt64 = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSString *unique_id = [NSString stringWithFormat:@"%@%lld", strUserID, timeInMilisInt64];
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strAppointmentID, strMessage, @"false", strMessageUserID,  strUserID, unique_id, @"user", nil] forKeys:[NSArray arrayWithObjects:@"appointmentid", @"message", @"read", @"receiver", @"sender", @"unique_id", @"user_type", nil]];

    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"sendMessage", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];

    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"dictParameter = %@", dictParameter);
    
    [appCounsellingChatParser sharedManager].strMethod = @"sendMessage";
    [[appCounsellingChatParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {

        
        NSLog(@"sendmsgpavan%@", responseDict);
//        dispatch_async(dispatch_get_main_queue(), ^{
        
            if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(sendMessageParserFinished:)])
            {
                [(id)[self callBack] performSelectorOnMainThread:@selector(sendMessageParserFinished:) withObject:responseDict waitUntilDone:NO];
            }
//        });
    } failure:^(NSError *error) {
        
//        dispatch_async(dispatch_get_main_queue(), ^{
        
        if(appDelegate.isServerswitched == NO){
            [appDelegate switchServer];
            [self sendMessage:strUserID messageUerID:strMessageUserID andMessage:strMessage forAppointment:strAppointmentID];
        }
        else {
            if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(errorOccured:)])
            {
                [(id)[self callBack] performSelectorOnMainThread:@selector(errorOccured:) withObject:error waitUntilDone:NO];
            }
        }
//        });
    }];
}

//Using this method Only
- (void)getMessageWith:(NSString *)strUserID andDate:(NSString *)strUpdatedDate forAppointment:(NSString *)strAppointmentId
{
    if(strUpdatedDate==nil)
        strUpdatedDate = @"";
//        strUpdatedDate = @"2014-01-01 12:00:00.000";
    
    //        {
    //            "requestData":{
    //                "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //                "data":{
    //                    "appointmentid":"qMTrir5/a7Nota+tQwdxTA\u003d\u003d1493960001737",
    //                    "lastUpdatedDate":""
    //                    "receiver":"username"
    //                },
    //                "requestType":"getMessage"
    //            }
    //        }
    
    NSString *strReceiver = [appDelegate.dictProfile objectForKey:@"username"];
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strAppointmentId, strUpdatedDate, strReceiver, nil] forKeys:[NSArray arrayWithObjects:@"appointmentid", @"lastUpdatedDate", @"reciever", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getMessage", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    NSLog(@"dictParameter = %@",dictParameter);
    
    
    [[GetMessageParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *dictOriginal) {
        
        NSDictionary *responseDict = [dictOriginal objectForKey:@"data"];
        NSString *strAppintmentStatus = [dictOriginal objectForKey:@"appoinment_status"];
        NSString *currenttime = [dictOriginal objectForKey:@"currenttime"];
        NSString *updatedcounselling_time = [dictOriginal objectForKey:@"updatedcounselling_time"];
        
        NSLog(@"new change pavan updatedcounselling_time%@", updatedcounselling_time);
        
        if ([updatedcounselling_time  isEqual: @"false"]){
           // appDelegate.timeIncressfalse = false;
            
            [[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:@"ForbuttonHide10min"];
        }else{
             [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"ForbuttonHide10min"];
           
            // appDelegate.timeIncressfalse = true;
        }
        
        NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc]init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];//2017-05-05T15:27:51.038Z
        NSDate *currentDate = [dateFormatter dateFromString:currenttime];

        NSLog(@"String = %@, Date = %@", currenttime, currentDate);
        
        NSLog(@"pavanmsgget%@", responseDict);
        

        NSMutableArray *arrMessage = [[NSMutableArray alloc] init];
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dictData in responseDict)
            {
                [arrMessage addObject:dictData];
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            //CRASHING ON APPOINTMENT TIME FINISH
            if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(getMessageParserFinished:appointmentStatus:)])
            {
                [self.callBack getMessageParserFinished:arrMessage appointmentStatus:strAppintmentStatus];
            }
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getMessageWith:strUserID andDate:strUpdatedDate forAppointment:strAppointmentId];
            }
            else
            {
                if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(errorOccured:)])
                {
                    [(id)[self callBack] performSelectorOnMainThread:@selector(errorOccured:) withObject:error waitUntilDone:NO];
                }
            }
        });
    }];
}

- (void)makeReadMessage:(NSDictionary *)dictMessage forAppointment:(NSString *)strAppointmentID
{
    //{"requestData":{"apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R","requestType":"setRead","appointmentid":"glimpse1482838680384", "messageid":"EdHRbEx6uk"}}
    
    //apikey, requestType, appointmentid, messageid
    
    NSString *strMessageID = [dictMessage objectForKey:@"messageid"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSDictionary *dictdata = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"setRead", strAppointmentID, strMessageID, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"appointmentid", @"messageid", nil]];
    
    [params setObject:dictdata forKey:@"requestData"];
    
    [appCounsellingChatParser sharedManager].strMethod = @"setRead";
    [[appCounsellingChatParser sharedManager] callWebServiceWithData:params success:^(NSDictionary *responseDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(makeReadMessageParserFinished:)])
            {
                [(id)[self callBack] performSelectorOnMainThread:@selector(makeReadMessageParserFinished:) withObject:responseDict waitUntilDone:NO];
            }
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self makeReadMessage:dictMessage forAppointment:strAppointmentID];
            }
            else {
                if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(errorOccured:)])
                {
                    [(id)[self callBack] performSelectorOnMainThread:@selector(errorOccured:) withObject:error waitUntilDone:NO];
                }
            }
        });
    }];
}


#pragma mark - RATTING 

- (void)getRattingQuestionsToUpdate:(NSDictionary *)dictAppointment
{

}

- (void)setRattingQuestionsToUpdate:(NSDictionary *)dictAppointment
{
    
    NSString *strAppointmentID = [dictAppointment objectForKey:@"apntmnt_id"];
    NSString *strCounsellorID = [dictAppointment objectForKey:@"clcnslrun01"];
    NSString *strUserID = [dictAppointment objectForKey:@"clun01"];
    
//    {
//        "requestData":{
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data":{
//                "appointmentid":"test123456789",
//                "counsellorid":"rizwan1",
//                "userid":"W8hNrRAQQIEPXuBy3FJ0ww==",
//                "rated_by":"Counsellor"
//                "overallrating":false,
//            },
//            "requestType":"setRattingQuestions"
//        }
//    }
//    {
//        "requestData":{
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data":{
//                "appointmentid":"qMTrir5/a7Nota+tQwdxTA\u003d\u003d1494046211442",
//                "counsellorid":"pyAtscTYswMf7aatrZ+gLQ\u003d\u003d",
//                "overallrating":false,
//                "rated_by":"User",
//                "userid":"qMTrir5/a7Nota+tQwdxTA\u003d\u003d"
//            },
//            "requestType":"setRattingQuestions"
//        }
//    }
    //Need to tset
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strAppointmentID, strCounsellorID, strUserID, @"Counsellor", @"false", nil] forKeys:[NSArray arrayWithObjects:@"appointmentid", @"counsellorid", @"userid", @"rated_by", @"overallrating", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"setRattingQuestions", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    NSLog(@"dictParameter = %@",dictParameter);
    
    [appCounsellingChatParser sharedManager].strMethod = @"setRattingQuestions";
    [[appCounsellingChatParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

//            if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(getRattingQuestionsToUpdateFinished:)])
//            {
//                [(id)[self callBack] performSelectorOnMainThread:@selector(getRattingQuestionsToUpdateFinished:) withObject:responseDict waitUntilDone:NO];
//            }
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self setRattingQuestionsToUpdate:dictAppointment];
            }
            else {
                if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(errorOccured:)])
                {
                    [(id)[self callBack] performSelectorOnMainThread:@selector(errorOccured:) withObject:error waitUntilDone:NO];
                }
            }
        });
    }];
}

- (void)rateTheQuestion:(NSDictionary *)dictQuestion withRatting:(NSNumber *)rattingCount
{
//    {
//        "requestData":{
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data":{
//                "appointmentid":"qMTrir5/a7Nota+tQwdxTA==1493785804878",
//                "comment":"",
//                "counsellorid":"pyAtscTYswMf7aatrZ+gLQ==1492842697109",
//                "questionid":"3",
//                "rated_by":"Counselor",
//                "ratting":5,
//                "status":"Done",
//                "usertype":"Counsellor"
//            },
//            "requestType":"setRattingFeedback"
//        }
//    }
    
    NSString *strAppointmentID = [dictQuestion objectForKey:@"apntmnt_id"]?[dictQuestion objectForKey:@"apntmnt_id"]:@"";
    NSString *strCounsellorID = [dictQuestion objectForKey:@"clcnslrun01"]?[dictQuestion objectForKey:@"clcnslrun01"]:@"";
    NSString *strQuestionID = [dictQuestion objectForKey:@"questionid"]?[dictQuestion objectForKey:@"questionid"]:@"";
    NSString *strStatus = [dictQuestion objectForKey:@"status"]?[dictQuestion objectForKey:@"status"]:@"";
    NSString *strComment = [dictQuestion objectForKey:@"comment"]?[dictQuestion objectForKey:@"comment"]:@"";

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strAppointmentID, @"", strCounsellorID, strQuestionID, @"Counsellor", rattingCount, @"Pending", @"Counsellor", nil] forKeys:[NSArray arrayWithObjects:@"appointmentid", @"comment", @"counsellorid", @"questionid", @"rated_by", @"ratting", @"status", @"usertype", nil]];
    
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"setRattingFeedback", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    NSLog(@"dictParameter = %@",dictParameter);
    
    [appCounsellingChatParser sharedManager].strMethod = @"setRattingFeedback";
    [[appCounsellingChatParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(rateTheQuestionFinished:)])
            {
                [(id)[self callBack] performSelectorOnMainThread:@selector(rateTheQuestionFinished:) withObject:rattingCount waitUntilDone:NO];
            }
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self rateTheQuestion:dictQuestion withRatting:rattingCount];
            }
            else {
                if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(errorOccured:)])
                {
                    [(id)[self callBack] performSelectorOnMainThread:@selector(errorOccured:) withObject:error waitUntilDone:NO];
                }
            }
        });
    }];
    
}


// create by pavan

- (void)sessionIncrement:(NSDictionary *)dictQuestion withRatting:(NSNumber *)rattingCount
{
    //    {
    //        "requestData":{
    //            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //            "data":{
    //                "appointmentid":"qMTrir5/a7Nota+tQwdxTA==1493785804878",
    //                "comment":"",
    //                "counsellorid":"pyAtscTYswMf7aatrZ+gLQ==1492842697109",
    //                "questionid":"3",
    //                "rated_by":"Counselor",
    //                "ratting":5,
    //                "status":"Done",
    //                "usertype":"Counsellor"
    //            },
    //            "requestType":"setRattingFeedback"
    //        }
    //    }
    
    NSString *strAppointmentID = [dictQuestion objectForKey:@"apntmnt_id"]?[dictQuestion objectForKey:@"apntmnt_id"]:@"";
    NSString *strCounsellorID = [dictQuestion objectForKey:@"clcnslrun01"]?[dictQuestion objectForKey:@"clcnslrun01"]:@"";
    NSString *strQuestionID = [dictQuestion objectForKey:@"questionid"]?[dictQuestion objectForKey:@"questionid"]:@"";
    NSString *strStatus = [dictQuestion objectForKey:@"status"]?[dictQuestion objectForKey:@"status"]:@"";
    NSString *strComment = [dictQuestion objectForKey:@"comment"]?[dictQuestion objectForKey:@"comment"]:@"";
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strAppointmentID, @"", strCounsellorID, strQuestionID, @"Counsellor", rattingCount, @"Pending", @"Counsellor", nil] forKeys:[NSArray arrayWithObjects:@"appointmentid", @"comment", @"counsellorid", @"questionid", @"rated_by", @"ratting", @"status", @"usertype", nil]];
    
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"setRattingFeedback", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    NSLog(@"dictParameter = %@",dictParameter);
    
    [appCounsellingChatParser sharedManager].strMethod = @"setRattingFeedback";
    [[appCounsellingChatParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(rateTheQuestionFinished:)])
            {
                [(id)[self callBack] performSelectorOnMainThread:@selector(rateTheQuestionFinished:) withObject:rattingCount waitUntilDone:NO];
            }
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self rateTheQuestion:dictQuestion withRatting:rattingCount];
            }
            else {
                if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(errorOccured:)])
                {
                    [(id)[self callBack] performSelectorOnMainThread:@selector(errorOccured:) withObject:error waitUntilDone:NO];
                }
            }
        });
    }];
    
}


#pragma mark - COMMENT

- (void)commentTheQuestion:(NSDictionary *)dictQuestion withRatting:(NSString *)strComment
{

    NSString *strAppointmentID = [dictQuestion objectForKey:@"apntmnt_id"]?[dictQuestion objectForKey:@"apntmnt_id"]:@"";
    NSString *strCounsellorID = [dictQuestion objectForKey:@"clcnslrun01"]?[dictQuestion objectForKey:@"clcnslrun01"]:@"";
    NSString *strQuestionID = [dictQuestion objectForKey:@"questionid"]?[dictQuestion objectForKey:@"questionid"]:@"";
    NSString *strStatus = [dictQuestion objectForKey:@"status"]?[dictQuestion objectForKey:@"status"]:@"";

    NSNumber *numRattingCount = [dictQuestion objectForKey:@"rattingcount"]?[dictQuestion objectForKey:@"rattingcount"]:[dictQuestion objectForKey:@"ratting"]?[dictQuestion objectForKey:@"ratting"]:[NSNumber numberWithInt:1];
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strAppointmentID, strComment, strCounsellorID, strQuestionID, @"Counsellor", numRattingCount, @"Done", @"Counsellor", nil] forKeys:[NSArray arrayWithObjects:@"appointmentid", @"comment", @"counsellorid", @"questionid", @"rated_by", @"ratting", @"status", @"usertype", nil]];
    
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"setRattingFeedback", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    NSLog(@"dictParameter = %@",dictParameter);
    
    NSLog(@"setRattingFeedback = %@", dictParameter);
    
    [appCounsellingChatParser sharedManager].strMethod = @"setRattingFeedback";
    [[appCounsellingChatParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(commentTheQuestionFinished:)])
            {
                [(id)[self callBack] performSelectorOnMainThread:@selector(commentTheQuestionFinished:) withObject:strComment waitUntilDone:NO];
            }
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self commentTheQuestion:dictQuestion withRatting:strComment];
            }
            else {
                if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(errorOccured:)])
                {
                    [(id)[self callBack] performSelectorOnMainThread:@selector(errorOccured:) withObject:error waitUntilDone:NO];
                }
            }
        });
    }];
}

@end
