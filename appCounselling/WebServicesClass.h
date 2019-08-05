//
//  WebServicesClass.h
//  HumbleBabies
//
//  Created by MindCrew Technologies on 30/11/16.
//  Copyright © 2016 iLabours. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
@interface WebServicesClass : NSObject
{

}

+(WebServicesClass *)sharedManager;
-(void)callWebService:(NSDictionary *)data withURLString:(NSString *)strURL success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;
-(void)callWebServiceoder:(NSDictionary *)data withURLString:(NSString *)strURL success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;
-(void)callWebServiceoderChat:(NSDictionary *)data withURLString:(NSString *)strURL success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;

-(void)callWebServiceoderGetHistory:(NSDictionary *)data withURLString:(NSString *)strURL success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
-(void)callWebServiceLatlobg:(NSDictionary *)data withURLString:(NSString *)strURL success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
@end
