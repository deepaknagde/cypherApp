//
//  appCounsellingLoginParser.m
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "appCounsellingLoginParser.h"
#import "AppDelegate.h"

@implementation appCounsellingLoginParser

@synthesize strMethod;
@synthesize callBack;

-(id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

+(appCounsellingLoginParser *)sharedManager
{
    static appCounsellingLoginParser *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

-(void)callWebServiceWithData:(NSDictionary *)dictData success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure
{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *strURL = appDelegate.strServer;
//    NSString *strURL = @"http://192.169.142.91/~silentsecret/pushnotification/api.php";

    NSLog(@"strURL = %@", strURL);
    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    NSLog(@"strURL = %@", strURL);
    strURL = [strURL stringByReplacingOccurrencesOfString:@"(" withString:@""];
    strURL = [strURL stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    if (dictData != nil) {
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictData options:0 error:&error];
        [request setHTTPBody:postData];
    }
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if (data){
                                                  
                                                  //NSJSONReadingMutableContainers
                                                  //NSJSONReadingMutableLeaves
                                                  NSError* error = nil;
                                                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; // Try to convert your data
                                                  NSLog(@"LoginParser error: %@", error); // Log the decoded object, and the error if any

//                                                  NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                  
                                                  NSLog(@"json = %@", json);
                                                  
                                                  if ([json isKindOfClass:[NSDictionary class]])
                                                  {
                                                      
                                                      if([json objectForKey:@"data"] && ![[json objectForKey:@"status"] isEqual:[NSNull null]] && [[json objectForKey:@"status"] isEqualToString:@"true"])
                                                      {
                                                          if([strMethod isEqualToString:@"AcceptFriend"] || [strMethod isEqualToString:@"SendFriendRequest"])
                                                              success(json);
                                                          else
                                                              success([json objectForKey:@"data"]);
                                                      }
                                                      else if([strMethod isEqualToString:@"appointmentAction"] && ![[json objectForKey:@"status"] isEqual:[NSNull null]] && [[json objectForKey:@"status"] isEqualToString:@"true"])
                                                      {
                                                              success(json);
                                                      }
                                                      else if([strMethod isEqualToString:@"suggestionAction"] && ![[json objectForKey:@"status"] isEqual:[NSNull null]] && [[json objectForKey:@"status"] isEqualToString:@"true"])
                                                      {
                                                          success(json);
                                                      }
                                                      else if(![[json objectForKey:@"status"] isEqual:[NSNull null]] && [[json objectForKey:@"status"] isEqualToString:@"true"])
                                                      {
                                                          success(json);
                                                      }
                                                      else if([self.strMethod isEqualToString:@"appointmentAction"] || [self.strMethod isEqualToString:@"userCounsellorAppointmnetCount"])
                                                      {
                                                          success(json);
                                                      }
                                                      else if([[json objectForKey:@"status"] isEqualToString:@"false"])
                                                      {
                                                          success(json);
                                                      }
                                                      else
                                                      {
                                                          failure(error);
                                                      }
                                                  }
                                                  else
                                                  {
                                                      failure(error);
                                                  }
                                              }
                                              else
                                              {
                                                  failure(error);
                                              }
                                          }];
    
    [postDataTask resume];
}


- (void)errorInParseing:(NSError *)error
{
    if(self.callBack!=nil && [(id)[self callBack] respondsToSelector:@selector(errorInParseing:)])
    {
        [(id)[self callBack] errorInParseing:error];
    }
}

- (void)parserFinished:(id)data
{
    NSDictionary *dict = (NSDictionary *)data;
    if(self.callBack && [self.callBack respondsToSelector:@selector(parsingFinished:)])
    {
        [self.callBack parsingFinished:dict];
    }
}

#pragma mark - Pool Parser

-(void)callWebServiceWithDictData:(NSDictionary *)data success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure
{
    //    NSString *urlStr = [NSString stringWithFormat:@"http://192.169.180.117/api/Service/%@", methodName];
//    NSString *urlStr = [NSString stringWithFormat:@"http://192.169.180.117/Site/BusinessApp/api/Service/%@", methodName];
    
    NSString *urlStr = @"http://192.169.142.91/~silentsecret/pushnotification/api.php";

    NSLog(@"%@", urlStr);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
    [request setHTTPMethod:@"POST"];
    
    if (data != nil) {
        NSError *error;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        
        
        //        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        //        NSLog(@"%@", jsonString);
        
        [request setHTTPBody:postData];
    }
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if (data){
                                                  //                                                  NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  //                                                  NSLog(@"%@", jsonString);
                                                  
                                                  NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                                                    NSLog(@"%@",json);
                                                  
                                                  if ([json isKindOfClass:[NSDictionary class]])
                                                  {
                                                      if([json objectForKey:@"data"] && ![[json objectForKey:@"status"] isEqual:[NSNull null]] && [[json objectForKey:@"status"] isEqualToString:@"true"])
                                                      {
                                                          success([json objectForKey:@"data"]);
                                                      }
                                                      else
                                                      {
                                                          failure(error);
                                                      }
                                                  }
                                                  else
                                                  {
                                                      failure(error);
                                                  }
                                              }
                                              else
                                              {
                                                  failure(error);
                                              }
                                              
                                          }];
    
    [postDataTask resume];
}

@end
