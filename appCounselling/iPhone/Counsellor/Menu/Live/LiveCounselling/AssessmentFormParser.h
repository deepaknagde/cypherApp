//
//  AssessmentFormParser.h
//  appCounselling
//
//  Created by MindCrew Technologies on 21/12/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AssessmentFormParserDelegate;
@interface AssessmentFormParser : NSObject
{
    
}

@property(nonatomic, strong) NSString *strMethod;

+(AssessmentFormParser *)sharedManager;
-(void)callWebServiceWithData:(NSDictionary *)data success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;

@property(nonatomic,assign)__unsafe_unretained id <AssessmentFormParserDelegate>callBack;


@end

@protocol AssessmentFormParserDelegate <NSObject>

@optional
- (void)parsingFinished:(NSDictionary *)arrData;
@optional
- (void)errorInParseing:(NSError *)error;

@end

