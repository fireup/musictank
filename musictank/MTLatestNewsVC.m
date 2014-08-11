//
//  MTLatestNewsVC.m
//  musictank
//
//  Created by ZBN on 14-8-9.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTLatestNewsVC.h"
#import "MTLatestNewsCell.h"
#import "MTNewsDetailVC.h"

static const int pageSize = 10;

@interface MTLatestNewsVC () <MTImageHandlerDelegate>
@property (copy, nonatomic) NSArray *news;
@property (strong, nonatomic) MTImageHandler *imageHandler;

@end

@implementation MTLatestNewsVC
@synthesize news = _news;

- (void)loadOneMorePage
{
    //    [self.refreshControl beginRefreshing];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    int pageNumber = [self.news count] / pageSize;
    NSDictionary *para = @{@"session_id": [MTDataHandler sharedData].sessionID,
                           @"page_number": @(pageNumber)};
    [manager POST:LATESTNEWSURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            self.news = responseObject[@"news"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.205441 green:0.217103 blue:0.267187 alpha:1.0];
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithRed:0.205441 green:0.217103 blue:0.267187 alpha:1.0];
    
    UINib *nib = [UINib nibWithNibName:@"MTLatestNewsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LatestNewsCell"];
    
    [self loadOneMorePage];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSArray *)news
{
    if (!_news) {
        _news = [[NSArray alloc] init];
    }
    return _news;
}

- (void)setNews:(NSArray *)news
{
    _news = news;
    [self.tableView reloadData];
}

- (MTImageHandler *)imageHandler
{
    if (!_imageHandler) {
        _imageHandler = [[MTImageHandler alloc] init];
        _imageHandler.delegate = self;
    }
    return _imageHandler;
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
    return [self.news count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTLatestNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LatestNewsCell" forIndexPath:indexPath];
    
    NSDictionary *news = [self.news objectAtIndex:indexPath.row];
    cell.newsTitleLabel.text = news[@"title"];
    cell.newsBriefLabel.text = news[@"brief"];
    cell.newsTimeLabel.text = news[@"created_at"];
    cell.newsImageView.image = [MTImageHandler resizeImageFromImage:[UIImage imageNamed:@"defaultNewsImage"] forFrame:cell.newsImageView.bounds];
    [self.imageHandler downloadImageForURL:news[@"image"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueToNewsDetailVC" sender:indexPath];
}

#pragma mark - MTImageHandler Delegate

- (void)didDownloadImage:(UIImage *)image forURL:(NSString *)URLString
{
    for (NSDictionary *news in self.news) {
        if ([news[@"image"] isEqualToString:URLString]) {
            NSInteger row = [self.news indexOfObject:news];
            MTLatestNewsCell *cell = (MTLatestNewsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            cell.newsImageView.image = [MTImageHandler resizeImageFromImage:image forFrame:cell.newsImageView.bounds];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToNewsDetailVC"] && [segue.destinationViewController isKindOfClass:[MTNewsDetailVC class]]) {
        MTNewsDetailVC *ndvc = segue.destinationViewController;
        NSIndexPath *path = (NSIndexPath *)sender;
        NSDictionary *news = [self.news objectAtIndex:path.row];
        ndvc.news = news;
    }
}


@end
