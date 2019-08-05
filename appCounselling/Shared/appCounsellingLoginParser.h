//
//  appCounsellingLoginParser.h
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol appCounsellingLoginParserDelegate;
@interface appCounsellingLoginParser : NSObject <NSURLSessionDelegate>
{
}

@property(nonatomic, strong) NSString *strMethod;

+(appCounsellingLoginParser *)sharedManager;
-(void)callWebServiceWithData:(NSDictionary *)data success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;

-(void)callWebServiceWithDictData:(NSDictionary *)data success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;


@property(nonatomic,assign)__unsafe_unretained id <appCounsellingLoginParserDelegate>callBack;

@end

@protocol appCounsellingLoginParserDelegate <NSObject>

@optional
- (void)parsingFinished:(NSDictionary *)arrData;
@optional
- (void)errorInParseing:(NSError *)error;

@end
