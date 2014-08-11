//
//  MTArtistHomeViewController.m
//  musictank
//
//  Created by ZBN on 14-8-6.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTArtistHomeViewController.h"
#import "MTArtistWorkTableViewCell.h"
#import "MTArtistSongTableViewCell.h"
#import "MTSongPlayViewController.h"
#import "MTWorkShowVC.h"
#import "MTWork.h"
#import "MTSong.h"

@interface MTArtistHomeViewController () <UITableViewDataSource, UITableViewDelegate> {
    UIView *_cover;
    UIActivityIndicatorView *_iView;
    //flag switch: 0-noworks nosongs, 1-songs noworks, 2-works nosongs, 3-works and songs
    int _sectionFlag;
}

@property (strong, nonatomic) MTArtist *artist;

@property (weak, nonatomic) IBOutlet UIView *sliderImageArea;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *redDivider;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) ASScroll *asScroll;
@property (copy, nonatomic) NSMutableArray *sliderImages;

@end

@implementation MTArtistHomeViewController

- (void)updateArtistInfo
{
    _cover = [[UIView alloc] initWithFrame:self.view.bounds];
    _cover.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_cover];
    
    if (self.artistID) {

        //对应此artistID没有artist数据，则取回数据，写入datahandler，再重新update。
        if (!([MTDataHandler sharedData].artistData)[self.artistID]) {
            
            _iView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x-10, 120, 20, 20)];
            _iView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [_cover addSubview:_iView];
            [_iView startAnimating];

            self.artist.artistID = self.artistID;
            self.artist.profileDelegate = self;
            [self.artist downloadProfile];
            
        //有artist profile数据，则更新界面数据
        } else {
            [UIView animateWithDuration:0.5 animations:^{_cover.alpha = 0.0;}];
            _cover = nil;
            
            self.artist = ([MTDataHandler sharedData].artistData)[self.artistID];
            self.nameLabel.text = self.artist.name;
            self.introLabel.text = self.artist.intro ? self.artist.intro : @"";
            
            int songsFlag = [self.artist.songs count]>0 ? 1 : 0;
            int worksFlag = [self.artist.works count]>0 ? 2 : 0;
            _sectionFlag = songsFlag | worksFlag;
            
            [self.tableView reloadData];
            
            [self.scrollView setContentSize:CGSizeMake(320, self.tableView.frame.size.height+310)];
            
            //更新slider images；
            NSArray *imagesURLs = self.artist.sliderImageURLs;
            NSLog(@"%@",self.artist.sliderImageURLs);
            for (int i=0; i<[imagesURLs count]; i++) {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imagesURLs[i]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
                AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                op.responseSerializer = [AFImageResponseSerializer serializer];
                [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self.sliderImages addObject:responseObject];
#warning 未使用queue，如果中间某个image download失败，则可能全部不显示；
                    if (self.sliderImages.count == imagesURLs.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.asScroll setArrOfImages:self.sliderImages];
                        });
                    }
#warning 失败情况下的处理
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                }];
                [op start];
            }
        }
    //无aritstID，提示错误。
    } else {
        [_iView stopAnimating];
        _iView = nil;
        [MTDataHandler popArtistFailAlert];
    }
}

- (void)didDownloadProfileForArtist:(NSString *)artistID
{
    if ([artistID isEqualToString:self.artistID]) {
        [_iView stopAnimating];
        _iView = nil;
        [UIView animateWithDuration:1.5 animations:^{_cover.alpha = 0.0;}];
        _cover = nil;
        NSMutableDictionary *artistData = [MTDataHandler sharedData].artistData;
        artistData[artistID] = self.artist;
        [self updateArtistInfo];
    }
}

- (void)failedDownloadProfileForArtist:(NSString *)artistID
{
    [_iView stopAnimating];
    _iView = nil;
    [MTDataHandler popNetworkFailAlert];
}


#pragma mark - Tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[MTArtistSongTableViewCell class]]) {
        
        [self performSegueWithIdentifier:@"SongPlaySegue" sender:indexPath];
        
    } else if ([cell isKindOfClass:[MTArtistWorkTableViewCell class]]) {
        [self performSegueWithIdentifier:@"SegueToWorkShowVC" sender:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    MTArtistWorkTableViewCell *workCell;
    MTArtistSongTableViewCell *songCell;
    if (indexPath.section == 0) {
        if (_sectionFlag == 2) {
            workCell = (MTArtistWorkTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ArtistWorkCell" forIndexPath:indexPath];
            MTWork *work = self.artist.works[indexPath.row];
            workCell.workName.text = work.name;
            workCell.workNumber.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
            workCell.workLiked.text = work.liked;
            workCell.workPlayed.text = work.played;
            cell = workCell;
            
        } else {
            songCell = (MTArtistSongTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ArtistSongCell" forIndexPath:indexPath];
            MTSong *song = [self.artist.songs objectAtIndex:indexPath.row];
            songCell.songName.text = song.name;
            songCell.songNumber.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
            songCell.songCreatedTime.text = song.createTime;
            songCell.songLength.text = song.length;
            cell = songCell;
        }
    } else {
        workCell = (MTArtistWorkTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ArtistWorkCell" forIndexPath:indexPath];
        MTWork *work = self.artist.works[indexPath.row];
        workCell.workName.text = work.name;
        workCell.workNumber.text = [NSString stringWithFormat:@"%d",indexPath.row];
        workCell.workLiked.text = work.liked;
        workCell.workPlayed.text = work.played;
        cell = workCell;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int number;
    switch (_sectionFlag) {
        case 0:
            number = 0;
            break;
        case 1:
        case 2:
            number = 1;
            break;
        case 3:
            number = 2;
            break;
        default:
            break;
    }
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number;
    if (section == 0) {
        if (_sectionFlag == 2) {
            number = [self.artist.works count];
        } else {
            number = [self.artist.songs count];
        }
    } else if (section == 1) {
        number = [self.artist.works count];
    }
    return number;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}



#pragma mark - init

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.redDivider.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.3];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"MTArtistWorkTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ArtistWorkCell"];
    UINib *nib2 = [UINib nibWithNibName:@"MTArtistSongTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"ArtistSongCell"];
}

- (void)presentCurrentPlayingVC
{
    if ([MTDataHandler sharedData].currentPlaying) {
        [self.navigationController pushViewController:[MTDataHandler sharedData].currentPlaying animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([MTDataHandler sharedData].currentPlaying) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(presentCurrentPlayingVC)];
        self.navigationItem.rightBarButtonItem = barButton;
    }
    [self updateArtistInfo];
}

- (MTArtist *)artist
{
    if (!_artist) {
        _artist = [[MTArtist alloc] init];
    }
    return _artist;
}

- (ASScroll *)asScroll
{
    if (!_asScroll) {
        _asScroll = [[ASScroll alloc] initWithFrame:self.sliderImageArea.bounds];
        [self.sliderImageArea addSubview:_asScroll];
    }
    return _asScroll;
}

- (NSMutableArray *)sliderImages
{
    if (!_sliderImages) {
        _sliderImages = [[NSMutableArray alloc] init];
    }
    return _sliderImages;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SongPlaySegue"] && [segue.destinationViewController isKindOfClass:[MTSongPlayViewController class]]) {
        MTSongPlayViewController *svc = (MTSongPlayViewController *)segue.destinationViewController;
        svc.songs = self.artist.songs;
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *path = sender;
            svc.index = path.row;
        }
    }
    if ([segue.identifier isEqualToString:@"SegueToWorkShowVC"] && [segue.destinationViewController isKindOfClass:[MTWorkShowVC class]]) {
        MTWorkShowVC *wsvc = segue.destinationViewController;
        wsvc.works = self.artist.works;
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *path = sender;
            wsvc.index = path.row;
        }
    }
}

@end
