//
//  MTTableViewController.m
//  musictank
//
//  Created by ZBN on 14-8-11.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTTableViewController.h"

static const int pageSize = 5;

@interface MTTableViewController ()

@property (strong, nonatomic) NSArray *dataDownloaded;

@end

@implementation MTTableViewController
@synthesize dataToDisplay = _dataToDisplay;

- (void)loadOneMorePage
{
    //    [self.refreshControl beginRefreshing];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    int pageNumber = [self.dataToDisplay count] / pageSize;
    NSDictionary *para = @{@"session_id": [MTDataHandler sharedData].sessionID,
                           @"page_number": @(pageNumber)};
    [manager POST:self.url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            self.dataDownloaded = responseObject[self.responseTitle];
            [self translateDownloadToDisplay];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)translateDownloadToDisplay
{
    //根据接收的数据类型，set dataToDisplay，以正确显示。
    //数据转换；
//    NSArray *convertedArray;
//    self.dataToDisplay = [self.dataToDisplay arrayByAddingObjectsFromArray:convertedArray];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //register cell NIB
    //init self.url, self.responseIdentifier;
    //loadOneMorePage;
}

- (NSArray *)dataToDisplay
{
    if (!_dataToDisplay) {
        _dataToDisplay = [[NSArray alloc] init];
    }
    return _dataToDisplay;
}

- (void)setDataToDisplay:(NSArray *)dataToDisplay
{
    _dataToDisplay = dataToDisplay;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataToDisplay count];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0 && [self.dataToDisplay count] % pageSize == 0) {
        [self loadOneMorePage];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
