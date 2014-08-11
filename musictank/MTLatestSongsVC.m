//
//  MTLatestSongsVC.m
//  musictank
//
//  Created by ZBN on 14-8-8.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTLatestSongsVC.h"

static const int pageSize = 10;

@interface MTLatestSongsVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *songs;

@end

@implementation MTLatestSongsVC
@synthesize songs = _songs;

- (void)loadOneMorePage
{
    //    [self.refreshControl beginRefreshing];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    int pageNumber = [self.songs count] / pageSize;
    NSDictionary *para = @{@"session_id": [MTDataHandler sharedData].sessionID,
                           @"page_number": @(pageNumber)};
    [manager POST:LATESTSONGSURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            NSArray *songsDics = responseObject[@"works"];
            NSMutableArray *tempSongs = [[NSMutableArray alloc] init];
            for (NSDictionary *songDic in songsDics) {
                MTSong *song = [[MTSong alloc] init];
                song.songID = songDic[@"id"];
                song.name = songDic[@"name"];
                song.streamURL = songDic[@"url"];
                song.liked = songDic[@"liked"];
                song.played = songDic[@"played"];
                [tempSongs addObject:song];

            }
            self.songs = [self.songs arrayByAddingObjectsFromArray:tempSongs];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:@"MTLatestSongsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LatestSongsCell"];
    
    [self loadOneMorePage];
}

- (NSArray *)songs
{
    if (!_songs) {
        _songs = [[NSArray alloc] init];
    }
    return _songs;
}

- (void)setSongs:(NSArray *)songs
{
    _songs = songs;
    [self.tableView reloadData];
}

#pragma mark - tableview delegate and datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTLatestSongsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LatestSongsCell" forIndexPath:indexPath];
    cell.artistAvatar.image = [MTImageHandler getDefaultAvatarForFrame:cell.artistAvatar.bounds];
    MTSong *song = [self.songs objectAtIndex:indexPath.row];
    cell.songName.text = song.name;
    cell.songLength.text = song.length;
    cell.songLiked.text = song.liked;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    header.backgroundColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    label.text = NSLocalizedString(@"TOPSONGS", nil);
    [header addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.bounds.size.width - 40, 10, 20, 20)];
    
    UIImage *image = [UIImage imageNamed:@"refresh"];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:tableView action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:button];
    
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.songs count];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0 && [self.songs count] % pageSize == 0) {
        [self loadOneMorePage];
        //[self methodThatAddsDataAndReloadsTableView];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueToArtistHome"] && [segue.destinationViewController isKindOfClass:[MTArtistHomeViewController class]]) {
        MTArtistHomeViewController *ahvc = (MTArtistHomeViewController *)segue.destinationViewController;
        ahvc.artistID = [MTDataHandler sharedData].myArtistID;
    }
}


@end
