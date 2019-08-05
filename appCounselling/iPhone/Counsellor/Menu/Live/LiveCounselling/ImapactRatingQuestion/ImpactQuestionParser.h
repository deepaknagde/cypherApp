//
//  ImpactQuestionParser.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 22/03/17.
//  Copyright © 2017 iDevz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImpactQuestionParserDelegate;
@interface ImpactQuestionParser : NSObject
{
    
}

@property(nonatomic, strong) NSString *strMethod;

+(ImpactQuestionParser *)sharedManager;
-(void)callWebServiceWithData:(NSDictionary *)data success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;

@property(nonatomic,assign)__unsafe_unretained id <ImpactQuestionParserDelegate>callBack;


@end

@protocol ImpactQuestionParserDelegate <NSObject>

@optional
- (void)parsingFinished:(NSDictionary *)arrData;
@optional
- (void)errorInParseing:(NSError *)error;

@end
