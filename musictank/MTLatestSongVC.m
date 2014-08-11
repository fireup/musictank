//
//  MTLatestSongVC.m
//  musictank
//
//  Created by ZBN on 14-8-11.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTLatestSongVC.h"
#import "MTSong.h"
#import "MTLatestSongsCell.h"

@interface MTLatestSongVC ()

@end

@implementation MTLatestSongVC

- (void)translateDownloadToDisplay
{
    NSLog(@"%@", self.dataDownloaded);
    NSMutableArray *tempSongs = [[NSMutableArray alloc] init];
    for (NSDictionary *songDic in self.dataDownloaded) {
        MTSong *song = [[MTSong alloc] init];
        song.songID = songDic[@"id"];
        song.name = songDic[@"name"];
        song.streamURL = songDic[@"url"];
        song.liked = songDic[@"liked"];
        song.played = songDic[@"played"];
        [tempSongs addObject:song];
    }
    self.dataToDisplay = [self.dataToDisplay arrayByAddingObjectsFromArray:tempSongs];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:@"MTLatestSongsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LatestSongsCell"];
    
    self.url = LATESTSONGSURL;
    self.responseTitle = @"songs";
    [self loadOneMorePage];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTLatestSongsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LatestSongsCell" forIndexPath:indexPath];
    cell.artistAvatar.image = [MTImageHandler getDefaultAvatarForFrame:cell.artistAvatar.bounds];
    MTSong *song = [self.dataToDisplay objectAtIndex:indexPath.row];
    cell.songName.text = song.name;
    cell.songLength.text = song.length;
    cell.songLiked.text = song.liked;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
