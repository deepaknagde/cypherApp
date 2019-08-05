//
//  AgentParser.m
//  appCounselling
//
//  Created by MindCrew Technologies on 30/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "AgentParser.h"
#import "AppDelegate.h"

@implementation AgentParser

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

+(AgentParser *)sharedManager
{
    static AgentParser *shared = nil;
    
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
    //NSString *strURL = @"http://192.169.142.91/~silentsecret/pushnotification/api.php";
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
                                                  
                                                  NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                  
                                                  NSLog(@"json = %@", json);
                                                  
                                                  if ([json isKindOfClass:[NSDictionary class]])
                                                  {
                                                      if(![[json objectForKey:@"status"] isEqual:[NSNull null]] && [[json objectForKey:@"status"] isEqualToString:@"true"])
                                                      {
                                                            success(json);
                                                      }
                                                      else if([json objectForKey:@"data"] && ![[json objectForKey:@"true"] isEqual:[NSNull null]] && [[json objectForKey:@"true"] isEqualToString:@"Fail"])
                                                      {
                                                            failure(error);
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
