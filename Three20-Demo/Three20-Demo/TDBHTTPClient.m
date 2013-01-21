//
//  TDBHTTPClient.m
//  Three20-Demo
//
//  Created by haoyu on 13-1-20.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import "TDBHTTPClient.h"
#import "AFHTTPRequestOperation.h"


@implementation TDBHTTPClient

#define kWBAPIURL @"https://dynamic.12306.cn/"

+ (TDBHTTPClient *)sharedClient
{
#warning read and understand the following code
    /*
     static WBKHTTPClient *sharedClient;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
     sharedClient = [[WBKHTTPClient alloc] init];
     });
     */
    static TDBHTTPClient *sharedClient;
    sharedClient = [[TDBHTTPClient alloc]init];
    return sharedClient;
}

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:kWBAPIURL]];
//    if (self) {
//        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];        
//    }
    
    return self;
}

- (UIImage *)validateCodeImage
{    
//    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"/otsweb/passCodeAction.do?rand=sjrand" parameters:nil];
//    NSError *error;
//    NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error ];
//    NSLog(@"err:%@",error);

    
    __block NSData *imageData;
    __block int status = 0;
    [self getPath:@"/otsweb/passCodeAction.do?rand=sjrand" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
   
        status = 1;
        imageData = operation.responseData;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        status = -1;
        
    }];
    [[self operationQueue]waitUntilAllOperationsAreFinished];
    while (status == 0)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate date]];
    }
    UIImage *image = [[UIImage alloc]initWithData:imageData];
    return image;
    
}
/*

//for unsigned cert
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    AFHTTPRequestOperation *operation = [super HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
    
    [operation setAuthenticationAgainstProtectionSpaceBlock:^BOOL(NSURLConnection *connection, NSURLProtectionSpace *protectionSpace) {
        return YES;
    }];

    [operation setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    }];

    return operation;
}
*/

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    [request setHTTPShouldHandleCookies:YES];
    return request;
}

@end
