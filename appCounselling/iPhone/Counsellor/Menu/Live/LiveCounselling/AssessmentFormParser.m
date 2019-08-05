//
//  AssessmentFormParser.m
//  appCounselling
//
//  Created by MindCrew Technologies on 21/12/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import "AssessmentFormParser.h"
#import "AppDelegate.h"

@implementation AssessmentFormParser

@synthesize callBack, strMethod;

-(id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

+(AssessmentFormParser *)sharedManager
{
    static AssessmentFormParser *shared = nil;
    
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
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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
