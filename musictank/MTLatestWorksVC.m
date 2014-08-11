//
//  MTLatestWorksVC.m
//  musictank
//
//  Created by ZBN on 14-8-8.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTLatestWorksVC.h"
//override to set the pagesize needed.
static const int pageSize = 5;

@interface MTLatestWorksVC ()

@property (strong, nonatomic) NSArray *works;

@end

@implementation MTLatestWorksVC
@synthesize works = _works;

- (void)loadOneMorePage
{
//    [self.refreshControl beginRefreshing];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    int pageNumber = [self.works count] / pageSize;
    NSDictionary *para = @{@"session_id": [MTDataHandler sharedData].sessionID,
                           @"page_number": @(pageNumber)};
    [manager POST:LATESTWORKSURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            NSArray *worksDics = responseObject[@"works"];
            NSMutableArray *tempWorks = [[NSMutableArray alloc] init];
            for (NSDictionary *workDic in worksDics) {
                MTWork *work = [[MTWork alloc] init];
                work.workID = workDic[@"id"];
                work.name = workDic[@"name"];
                work.liked = workDic[@"liked"];
                work.played = workDic[@"played"];
                work.URL = workDic[@"url"];
                work.createdTime = workDic[@"created_at"];
                [tempWorks addObject:work];
            }
            self.works = [self.works arrayByAddingObjectsFromArray:tempWorks];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![MTDataHandler sharedData].sessionID) {
        [MTDataHandler popArtistFailAlert];
    }
    
    UINib *nib = [UINib nibWithNibName:@"MTLatestWorksCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LatestWorksCell"];
    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(loadOneMorePage) forControlEvents:UIControlEventValueChanged];
//    self.refreshControl.tintColor = [UIColor lightGrayColor];
    
    
    [self loadOneMorePage];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSArray *)works
{
    if (!_works) {
        _works = [[NSArray alloc] init];
    }
    return _works;
}

- (void)setWorks:(NSArray *)works
{
    _works = works;
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
    return [self.works count];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0 && [self.works count] % pageSize == 0) {
        [self loadOneMorePage];
        //[self methodThatAddsDataAndReloadsTableView];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTLatestWorksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LatestWorksCell" forIndexPath:indexPath];
    cell.artistAvatar.image = [MTImageHandler getDefaultAvatarForFrame:cell.artistAvatar.bounds];
    
    MTWork *work = [self.works objectAtIndex:indexPath.row];
    cell.workName.text = work.name;
    
    
//    MTArtist *artist = ([MTDataHandler sharedData].artistData) objectForKey:<#(id)#>
//    if ([MTDataHandler sharedData]) {
//        <#statements#>
//    }
    
    return cell;
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
