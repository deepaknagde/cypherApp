//
//  appCounsellingChatParser.m
//  appCounselling
//
//  Created by MindCrew Technologies on 29/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "appCounsellingChatParser.h"
#import "AppDelegate.h"
#import "JsonEncoder.h"

@implementation appCounsellingChatParser

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

+(appCounsellingChatParser *)sharedManager
{
    static appCounsellingChatParser *shared = nil;
    
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
    [request setHTTPMethod:@"POST"];
    
    if (dictData != nil) {
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictData options:0 error:&error];
        [request setHTTPBody:postData];
    }
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if (data){
                                                  
                                                  NSError* error = nil;
                                                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; // Try to convert your data
                                                  NSLog(@"ChatParser error : %@", error); // Log the decoded object, and the error if any
                                                  
                                                  NSLog(@"json = %@", json);
                                                  
                                                  if(json==nil){
                                                      
                                                      NSArray *arrTemp = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                      
                                                      if(arrTemp != nil && arrTemp.count>0)
                                                      {
                                                          json = arrTemp.lastObject;
                                                      }
                                                  }
                                                  
                                                  if ([json isKindOfClass:[NSDictionary class]])
                                                  {
                                                      
                                                      if([json objectForKey:@"data"] && ![[json objectForKey:@"status"] isEqual:[NSNull null]] && [[json objectForKey:@"status"] isEqualToString:@"true"])
                                                      {
                                                          success([json objectForKey:@"data"]);
                                                      }
                                                      else if([json objectForKey:@"data"] && ![[json objectForKey:@"status"] isEqual:[NSNull null]] && [[json objectForKey:@"status"] isEqualToString:@"Fail"])
                                                      {
                                                          if(json)
                                                              success([json objectForKey:@"data"]);
                                                          else
                                                              failure(error);
                                                      }
                                                      else if([json objectForKey:@"data"] && ![[json objectForKey:@"status"] isEqual:[NSNull null]] && [[json objectForKey:@"status"] isEqualToString:@"Fail"])
                                                      {
                                                          if(json)
                                                              success(json);
                                                      }
                                                      else if(json != nil && ![[json objectForKey:@"status"] isEqual:[NSNull null]] && [[json objectForKey:@"status"] isEqualToString:@"true"])
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

@end
