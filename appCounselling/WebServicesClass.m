//
//  WebServicesClass.m
//  HumbleBabies
//
//  Created by MindCrew Technologies on 30/11/16.
//  Copyright © 2016 iLabours. All rights reserved.
//

#import "WebServicesClass.h"
#import "AppDelegate.h"
#import "Reachability.h"
@implementation WebServicesClass

-(id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

+(WebServicesClass *)sharedManager
{
    static WebServicesClass *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}


//-(void)callWebService:(NSDictionary *)data withURLString:(NSString *)strURL success : (void (^)(NSDionary *responseDict))success failure:(void(^)(NSError* error))failure
-(void)callWebService:(NSDictionary *)data withURLString:(NSString *)strURL success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure

{
    
    
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please check network connection." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
 
    [self showLoader];
    NSLog(@"strURL = %@", strURL);
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"strURL = %@", strURL);
    strURL = [strURL stringByReplacingOccurrencesOfString:@"(" withString:@""];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    if (data != nil) {
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        [request setHTTPBody:postData];
    }
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error)
                                          {
                                              if (response){
                                                  
                                                  NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];                                                  NSLog(@"json = %@", json);
                                                  
                                                  if ([json isKindOfClass:[NSDictionary class]])
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self hideLoader];
                                                        });
                                                      //if([json objectForKey:@"data"])
                                                      //success([json objectForKey:@"data"]);
                                                      success (json);
                                                  }
                                                  else
                                                  {
                                                      failure(error);
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self hideLoader];
                                                      });                                                  }
                                              }
                                              else
                                              {
                                                  failure(error);
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self hideLoader];
                                                  });;
                                              }
                                              
                }];
    
    [postDataTask resume];
       
}
}
-(void)callWebServiceoder:(NSDictionary *)data withURLString:(NSString *)strURL success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure

{
    
    

    
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please check network connection." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self showLoader];
        NSLog(@"strURL = %@", strURL);
        strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"strURL = %@", strURL);
        strURL = [strURL stringByReplacingOccurrencesOfString:@"(" withString:@""];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:120.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        
        if (data != nil) {
            
            NSError *error;
            NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
            [request setHTTPBody:postData];
        }
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error)
                                              {
                                                  if (response){
                                                    
                                                      NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];                                                  //NSLog(@"json = %@", json);
                                                      
                                                      if ([json isKindOfClass:[NSDictionary class]])
                                                      {
                                                          
                                                          NSLog(@"json = %@", json);
                                                          success (json);
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self hideLoader];
                                                          });
                                                      }
                                                      else
                                                      {
                                                          failure(error);
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self hideLoader];
                                                          });
                                                      }
                                                  }
                                                  else
                                                  {
                                                      failure(error);
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self hideLoader];
                                                      });
                                                  }
                                                  
                                              }];
        
        [postDataTask resume];
        
    }
}

-(void)callWebServiceoderChat:(NSDictionary *)data withURLString:(NSString *)strURL success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure

{
    
    
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please check network connection." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
      //  [self showLoader];
        NSLog(@"strURL = %@", strURL);
        strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"strURL = %@", strURL);
        strURL = [strURL stringByReplacingOccurrencesOfString:@"(" withString:@""];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:120.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        
        if (data != nil) {
            
            NSError *error;
            NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
            [request setHTTPBody:postData];
        }
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error)
                                              {
                                                  if (response){
                                                      
                                                      NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];                                                  //NSLog(@"json = %@", json);
                                                      
                                                      if ([json isKindOfClass:[NSDictionary class]])
                                                      {
                                                          
                                                          NSLog(@"json = %@", json);
                                                          success (json);
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self hideLoader];
                                                          });
                                                      }
                                                      else
                                                      {
                                                          failure(error);
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self hideLoader];
                                                          });
                                                      }
                                                  }
                                                  else
                                                  {
                                                      failure(error);
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self hideLoader];
                                                      });
                                                  }
                                                  
                                              }];
        
        [postDataTask resume];
        
    }
}


-(void)callWebServiceLatlobg:(NSDictionary *)data withURLString:(NSString *)strURL success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure

{
    
    
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please check network connection." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //[self showLoader];
        NSLog(@"strURL = %@", strURL);
        strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"strURL = %@", strURL);
        strURL = [strURL stringByReplacingOccurrencesOfString:@"(" withString:@""];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:120.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        
        if (data != nil) {
            
            NSError *error;
            NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
            [request setHTTPBody:postData];
        }
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error)
                                              {
                                                  if (response){
                                                      
                                                      NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];                                                  //NSLog(@"json = %@", json);
                                                      
                                                      if ([json isKindOfClass:[NSDictionary class]])
                                                      {
                                                          
                                                          NSLog(@"json = %@", json);
                                                          success (json);
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self hideLoader];
                                                          });
                                                      }
                                                      else
                                                      {
                                                          failure(error);
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              //[self hideLoader];
                                                          });
                                                      }
                                                  }
                                                  else
                                                  {
                                                      failure(error);
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                         // [self hideLoader];
                                                      });
                                                  }
                                                  
                                              }];
        
        [postDataTask resume];
        
    }
}

-(void)showLoader{
    
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = @"Loading....";
    
}
-(void)hideLoader{
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    [MBProgressHUD hideHUDForView:window animated:YES];
}

@end
