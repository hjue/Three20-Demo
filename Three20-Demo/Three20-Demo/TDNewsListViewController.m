//
//  TDNewsListViewController.m
//  Three20-Demo
//
//  Created by haoyu on 13-1-13.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import "TDNewsListViewController.h"
#import "TFHpple.h"
#import "TDNewsModel.h"


@interface TDNewsListViewController ()
{
    NSMutableArray *news_objects_;
}

@end

@implementation TDNewsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableViewStyle = UITableViewStylePlain;
        self.title = @"Parse HTML";
        self.variableHeightRows = YES;
        news_objects_ = [[NSMutableArray alloc]init];
        [self loadNews:@"http://mobile.csdn.net/"];

    }
    return self;
}

- (void)loadNews:(NSString *)url
{
//    news_objects_ = [NSMutableArray array];
    NSURL *newsUrl = [NSURL URLWithString:url];
    NSData *htmlData = [NSData dataWithContentsOfURL:newsUrl];
    
    TFHpple *newsParser = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *newsList = [newsParser searchWithXPathQuery:@"//div[@class='unit']"];
    for (TFHppleElement *element in newsList) {
        TDNewsModel *newsModel = [[TDNewsModel alloc]init];
        newsModel.title = [[[element firstChildWithTagName:@"h1"]firstChildWithTagName:@"a"].firstChild content];
        newsModel.description = [[[element firstChildWithTagName:@"dl"]firstChildWithTagName:@"dd"].firstChild content];
        NSString *dateString = [[[element firstChildWithTagName:@"h4"]firstChildWithClassName:@"ago"].firstChild content];
        NSString *imageUrl = [[[[[element firstChildWithTagName:@"dl"]firstChildWithTagName:@"dt"]firstChildWithTagName:@"a"]firstChildWithTagName:@"img"] objectForKey:@"src"];
        newsModel.image_url = imageUrl;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        NSDate *date = [formatter dateFromString:dateString];
        if (date==nil) {
            date = [NSDate date];
        }
        newsModel.publish_date = date;
        [news_objects_ addObject:newsModel];
        
    }
    newsParser = nil;
    newsList = nil;
    NSMutableArray *tableItems = [NSMutableArray array];
    for (TDNewsModel *item in news_objects_) {
        TTTableMessageItem *tableItem = [TTTableMessageItem itemWithTitle:item.title caption:@" " text:item.description timestamp:item.publish_date imageURL:item.image_url URL:nil];
        [tableItems addObject:tableItem];
    }
    self.dataSource = [ TTListDataSource dataSourceWithItems:tableItems];

}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    int max = [[self tableView]numberOfRowsInSection:indexPath.section];
    [self loadNews:@"http://news.csdn.net/"];
    [[self tableView]scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:max inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end
