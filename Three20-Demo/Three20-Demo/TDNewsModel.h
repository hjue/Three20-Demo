//
//  TDNewsModel.h
//  Three20-Demo
//
//  Created by haoyu on 13-1-13.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDNewsModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *description;
@property (nonatomic,strong) NSDate *publish_date;
@property (nonatomic,strong) NSString *image_url;
@end
