//
//  GetMessageParser.h
//  appCounselling
//
//  Created by MindCrew Technologies on 31/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetMessageParserDelegate;
@interface GetMessageParser : NSObject <NSURLSessionDelegate>
{
//This is using only for get messgae 
}

+(GetMessageParser *)sharedManager;
-(void)callWebServiceWithData:(NSDictionary *)data success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;

@property(nonatomic,assign)__unsafe_unretained id <GetMessageParserDelegate>callBack;

@end

@protocol GetMessageParserDelegate <NSObject>

@optional
- (void)parsingFinished:(NSDictionary *)arrData;
@optional
- (void)errorInParseing:(NSError *)error;

@end
