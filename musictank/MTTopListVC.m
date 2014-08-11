//
//  MTTopListVC.m
//  musictank
//
//  Created by ZBN on 14-8-9.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTTopListVC.h"
#import "KxMenu.h"
#import "MTSong.h"
#import "MTLatestSongsCell.h"
#import "MTLatestWorksCell.h"
#import "MTWork.h"
#import "MTArtist.h"
#import "MTSongPlayViewController.h"
#import "MTWorkShowVC.h"
#import "MTArtistHomeViewController.h"

@interface MTTopListVC ()


@property (strong, nonatomic) NSArray *dataToDisplay;
@property (strong, nonatomic) NSArray *songs;
@property (strong, nonatomic) NSArray *works;
@property (strong, nonatomic) NSArray *male;
@property (strong, nonatomic) NSArray *female;

@end

@implementation MTTopListVC

@synthesize dataToDisplay = _dataToDisplay;

- (void)changeToTopSongs
{
    [self updateTableViewWith:self.songs for:@"songs"];
}

- (void)changeToTopWorks
{
    [self updateTableViewWith:self.works for:@"works"];
    
}

- (void)changeToPopularMale
{
    [self updateTableViewWith:self.male for:@"male"];
}

- (void)changeToPopularFemale
{
    [self updateTableViewWith:self.female for:@"female"];
}


- (IBAction)showMenu:(UIBarButtonItem *)sender
{
    UIView *startPoint = [[UIView alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.bounds.size.width - 30, 0, 1, 1)];
    [self.navigationController.navigationBar addSubview:startPoint];
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:NSLocalizedString(@"TOPSONGSBUTTON", nil)
                     image:nil
                    target:self
                    action:@selector(changeToTopSongs)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"TOPWORKSBUTTON", nil)
                     image:nil
                    target:self
                    action:@selector(changeToTopWorks)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"POPULARMALEBUTTON", nil)
                     image:nil
                    target:self
                    action:@selector(changeToPopularMale)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"POPULARFEMALEBUTTON", nil)
                     image:nil
                    target:self
                    action:@selector(changeToPopularFemale)],
      ];
    
//    KxMenuItem *first = nil;
//    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
//    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.tableView
                  fromRect:startPoint.frame
                 menuItems:menuItems];
}


- (void)updateTableViewWith:(NSArray *)data for:(NSString *)type
{
    if ([data count]) {
        self.dataToDisplay = data;
        return;
    }
    
    NSString *url;
    if ([type isEqualToString:@"songs"]) {
        url = TOPSONGSURL;
    } else if ([type isEqualToString:@"works"]) {
        url = TOPWORKSURL;
    } else if ([type isEqualToString:@"male"]) {
        url = POPULARMALEURL;
    } else if ([type isEqualToString:@"female"]) {
        url = POPULARFEMALEURL;
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *para = @{@"": @""};
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            if ([url isEqualToString:TOPSONGSURL]) {
                NSArray *songsDics = responseObject[@"works"];
                NSMutableArray *tempSongs = [[NSMutableArray alloc] init];
                for (NSDictionary *songDic in songsDics) {
                    MTSong *song = [[MTSong alloc] init];
                    song.songID = [songDic[@"id"] stringValue];
                    song.name = songDic[@"name"];
                    song.streamURL = songDic[@"url"];
//                    song.liked = songDic[@"liked"];
                    song.played = [songDic[@"played"] stringValue];
                    [tempSongs addObject:song];
                }
                self.songs = [self.songs arrayByAddingObjectsFromArray:tempSongs];
                self.dataToDisplay = self.songs;
                
            } else if ([url isEqualToString:TOPWORKSURL]) {
                
                NSArray *worksDics = responseObject[@"works"];
                NSMutableArray *tempWorks = [[NSMutableArray alloc] init];
                for (NSDictionary *workDic in worksDics) {
                    MTWork *work = [[MTWork alloc] init];
                    work.workID = [workDic[@"id"] stringValue];
                    work.name = workDic[@"name"];
//                    work.liked = workDic[@"liked"];
                    work.played = [workDic[@"played"] stringValue];
                    work.URL = workDic[@"url"];
//                    work.createdTime = workDic[@"created_at"];
                    [tempWorks addObject:work];
                }
                self.works = [self.works arrayByAddingObjectsFromArray:tempWorks];
                self.dataToDisplay = self.works;
            
            } else if ([url isEqualToString:POPULARMALEURL] || [url isEqualToString:POPULARFEMALEURL]) {
                
                NSArray *artistsDics = responseObject[@"singers"];
                NSMutableArray *tempArtists = [[NSMutableArray alloc] init];
                for (NSDictionary *artistDic in artistsDics) {
                    MTArtist *artist = [[MTArtist alloc] init];
                    artist.artistID = [artistDic[@"id"] stringValue];
                    artist.name = artistDic[@"name"];
                    artist.totalPlayedTimes = artistDic[@"played"];
                    [tempArtists addObject:artist];
                }
                
                if ([url isEqualToString:POPULARMALEURL]) {
                    self.male = tempArtists;
                    self.dataToDisplay = self.male;
                } else {
                    self.female = tempArtists;
                    self.dataToDisplay = self.female;
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //for 歌曲排行
    UINib *nib = [UINib nibWithNibName:@"MTLatestSongsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LatestSongsCell"];
    //for 曲谱排行 and 歌手排行
    UINib *nib2 = [UINib nibWithNibName:@"MTLatestWorksCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"LatestWorksCell"];

    [self changeToTopSongs];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([self.dataToDisplay[0] isKindOfClass:[MTSong class]]) {
        MTLatestSongsCell *songCell = (MTLatestSongsCell *)[tableView dequeueReusableCellWithIdentifier:@"LatestSongsCell" forIndexPath:indexPath];
        MTSong *song = [self.dataToDisplay objectAtIndex:indexPath.row];
        
#warning avatar not updated yet
        songCell.artistAvatar.image = [MTImageHandler getDefaultAvatarForFrame:songCell.artistAvatar.bounds];
        songCell.songName.text = song.name;
        songCell.songLiked.text = song.played;
        cell = songCell;
        
    } else if ([self.dataToDisplay[0] isKindOfClass:[MTWork class]]) {
        MTLatestWorksCell *workCell = (MTLatestWorksCell *)[tableView dequeueReusableCellWithIdentifier:@"LatestWorksCell" forIndexPath:indexPath];
        MTWork *work = [self.dataToDisplay objectAtIndex:indexPath.row];
#warning avatar not updated yet
        workCell.artistAvatar.image = [MTImageHandler getDefaultAvatarForFrame:workCell.artistAvatar.bounds];
        workCell.workName.text = work.name;
        workCell.workLiked.text = work.liked;
        cell = workCell;
    
    } else if ([self.dataToDisplay[0] isKindOfClass:[MTArtist class]]) {
        MTLatestWorksCell *singerCell = (MTLatestWorksCell *)[tableView dequeueReusableCellWithIdentifier:@"LatestWorksCell" forIndexPath:indexPath];
        MTArtist *artist = [self.dataToDisplay objectAtIndex:indexPath.row];
#warning avatar not updated yet
        singerCell.artistAvatar.image = [MTImageHandler getDefaultAvatarForFrame:singerCell.artistAvatar.bounds];
        singerCell.workName.text = artist.name;
        singerCell.workLiked.text = artist.totalPlayedTimes;
        cell = singerCell;
    }
    
    return cell;
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

- (NSArray *)songs
{
    if (!_songs) {
        _songs = [[NSArray alloc] init];
    }
    return _songs;
}


- (NSArray *)works
{
    if (!_works) {
        _works = [[NSArray alloc] init];
    }
    return _works;
}

- (NSArray *)male
{
    if (!_male) {
        _male = [[NSArray alloc] init];
    }
    return _male;
}

- (NSArray *)female
{
    if (!_female) {
        _female = [[NSArray alloc] init];
    }
    return _female;
}





#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"SegueToSongPlayVCFromTopList"] && [self.dataToDisplay[0] isKindOfClass:[MTSong class]]) {
        if ([MTDataHandler sharedData].currentPlaying) {
            MTSongPlayViewController *spvc = (MTSongPlayViewController *)[MTDataHandler sharedData].currentPlaying;
            spvc.songs = self.dataToDisplay;
            NSIndexPath *path = (NSIndexPath *)sender;
            spvc.index = path.row;
            [self.navigationController pushViewController:spvc animated:YES];
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    
    
}


@end
