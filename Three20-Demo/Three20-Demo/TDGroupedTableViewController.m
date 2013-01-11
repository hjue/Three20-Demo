//
//  TDGroupedTableViewController.m
//  Three20-Demo
//
//  Created by haoyu on 13-1-11.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import "TDGroupedTableViewController.h"

@interface TDGroupedTableViewController ()
{
    UILabel * _questionTitleView ;
    UIImageView *_questionImageView;
}
@end

@implementation TDGroupedTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        self.title = @"Grouped Table";
        self.tableViewStyle = UITableViewStyleGrouped;
        self.variableHeightRows = NO;
        self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                           [TTTableSection sectionWithHeaderTitle:@"" footerTitle:@"Group A Footer" ],
                           [TTTableTextItem itemWithText:@"Question A"],
                           [TTTableTextItem itemWithText:@"Question B"],
                           [TTTableTextItem itemWithText:@"Question C"],
                           [TTTableTextItem itemWithText:@"Question D"],
                           nil];
    }
    return self;
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[TTTableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
        _tableView.rowHeight = 50;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        
        if (_tableViewStyle == UITableViewStyleGrouped) {
            _tableView.backgroundColor = [UIColor clearColor];
            [self.tableView setSeparatorColor:[UIColor orangeColor]];  
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"photoDefault"]]];

            TTImageView *image = [[TTImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
            image.urlPath = @"bundle://Three20.bundle/images/photoDefault.png";
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
            [header addSubview:image];
//            header.backgroundColor = [UIColor blueColor];
            
            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
//            [sectionView setBackgroundColor:[UIColor brownColor]];
            
            //add UILabel for Question Title
            CGFloat marginLeft = 10;
            _questionTitleView = [[UILabel alloc] initWithFrame:CGRectMake(marginLeft, 20, self.tableView.bounds.size.width - 2*marginLeft, 40)];
            _questionTitleView.numberOfLines = 2;
            [_questionTitleView setTextColor:[UIColor blackColor]];
            [_questionTitleView setBackgroundColor:[UIColor clearColor]];
            [_questionTitleView setText:@"                                            " ];
            [_questionTitleView setFont:[UIFont boldSystemFontOfSize:16.0]];
            [_questionTitleView sizeToFit];
            
            [sectionView addSubview:_questionTitleView];
            

            self.tableView.tableHeaderView = sectionView;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [ self.tableView cellForRowAtIndexPath:indexPath];

    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [_questionTitleView setText:((TTTableTextItem *)object).text];
    
    for (int row=0; row < [self.tableView numberOfRowsInSection:indexPath.section]; row++) {
        if (row == indexPath.row) {
            continue;
        }
        UITableViewCell *other_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
        other_cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
	CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5f ;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
	animation.endProgress = 1;
	animation.removedOnCompletion = NO;
	animation.type = @"pageCurl";//101
	[self.view.layer addAnimation:animation forKey:@"animation"];
    
	lastAnimation = animation;
	[self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
}

- (void)viewDidLoad
{
    CGRect frame = self.tableView.frame;
    self.tableView.frame = frame;
//    self.tableView.sectionHeaderHeight = 100;
}
@end
