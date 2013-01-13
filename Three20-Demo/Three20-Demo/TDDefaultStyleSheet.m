//
//  TDDefaultCSSStyleSheet.m
//  Three20-Demo
//
//  Created by haoyu on 13-1-13.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import "TDDefaultStyleSheet.h"

@implementation TDDefaultStyleSheet

- (UIFont*)tableFont {
    return [UIFont boldSystemFontOfSize:17];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableSmallFont {
    return [UIFont boldSystemFontOfSize:15];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableTitleFont {
    return [UIFont boldSystemFontOfSize:13];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableTimestampFont {
    return [UIFont systemFontOfSize:12];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableButtonFont {
    return [UIFont boldSystemFontOfSize:13];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableSummaryFont {
    return [UIFont systemFontOfSize:17];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableHeaderPlainFont {
    return [UIFont boldSystemFontOfSize:16];
}

@end
