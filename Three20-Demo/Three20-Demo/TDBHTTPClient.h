//
//  TDBHTTPClient.h
//  Three20-Demo
//
//  Created by haoyu on 13-1-20.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import "AFHTTPClient.h"

@interface TDBHTTPClient : AFHTTPClient

+ (TDBHTTPClient *)sharedClient;

- (UIImage *) validateCodeImage;
@end
