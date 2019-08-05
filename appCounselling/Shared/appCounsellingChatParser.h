//
//  appCounsellingChatParser.h
//  appCounselling
//
//  Created by MindCrew Technologies on 29/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol appCounsellingChatParserDelegate;
@interface appCounsellingChatParser : NSObject <NSURLSessionDelegate>
{
/*
 This parser is used by AppCounsellingChatBL, 
 AppCounsellingLiveChatViewController(MoodGraph),
 AppCounsellingLiveTimerViewController(MoodGraph),
 */
}

@property(nonatomic, strong) NSString *strMethod;

+(appCounsellingChatParser *)sharedManager;
-(void)callWebServiceWithData:(NSDictionary *)data success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;

@property(nonatomic,assign)__unsafe_unretained id <appCounsellingChatParserDelegate>callBack;

@end

@protocol appCounsellingChatParserDelegate <NSObject>

@optional
- (void)parsingFinished:(NSDictionary *)arrData;
@optional
- (void)errorInParseing:(NSError *)error;

@end
