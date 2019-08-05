//
//  AgentParser.h
//  appCounselling
//
//  Created by MindCrew Technologies on 30/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AgentParserDelegate;
@interface AgentParser : NSObject
{
//Using this parser seperate for Agent Login.
}

@property(nonatomic, strong) NSString *strMethod;

+(AgentParser *)sharedManager;
-(void)callWebServiceWithData:(NSDictionary *)data success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;

@property(nonatomic,assign)__unsafe_unretained id <AgentParserDelegate>callBack;

@end

@protocol AgentParserDelegate <NSObject>

@optional
- (void)parsingFinished:(NSDictionary *)arrData;
@optional
- (void)errorInParseing:(NSError *)error;

@end
