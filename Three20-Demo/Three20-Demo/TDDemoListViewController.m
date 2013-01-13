//
//  TDDemoListViewController.m
//  Three20-Demo
//
//  Created by haoyu on 13-1-13.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import "TDDemoListViewController.h"

@interface TDDemoListViewController ()

@end

@implementation TDDemoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Three20 Demo";
        self.tableViewStyle = UITableViewStylePlain;
        self.dataSource = [TTListDataSource dataSourceWithObjects:
                           [TTTableLink itemWithText:@"Parse HTML" URL:@"tt://html-parser"],
                           [TTTableLink itemWithText:@"Grouped Table" URL:@"tt://grouped-table"],                            
                            nil];
    }
    return self;
}



@end
