//
//  MTArtist.m
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTArtist.h"
#import "MTWork.h"
#import "MTSong.h"

@interface MTArtist () <MTImageHandlerDelegate> {
    MTImageHandler *_imageHandler;
}

@end

@implementation MTArtist

- (void)downloadProfile
{
    if (!self.artistID) {
        [MTDataHandler popArtistFailAlert];
        
    } else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        NSDictionary *para = @{@"session_id": [MTDataHandler sharedData].sessionID,
                               @"artist_id": self.artistID};
        
        [manager POST:PROFILEURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                
                NSDictionary *profile = responseObject[@"profile"];
                self.name = profile[@"name"];
                self.intro = profile[@"my_introduction"];
                self.totalPlayedTimes = profile[@"total_played_time_of_my_work"];
                self.totalLikeFromArtist = profile[@"total_artists_number_who_like_me"];
                self.totalLikeFromProducer = profile[@"total_producer_number_who_like_me"];
                
                for (NSDictionary *songDic in profile[@"songs"]) {
                    MTSong *song = [[MTSong alloc] init];
                    song.streamURL = songDic[@"src"];
                    song.songID = songDic[@"song_id"];
                    song.artistID = songDic[@"artist_id"];
                    song.name = songDic[@"name"];
                    song.style = songDic[@"style"];
                    song.played = songDic[@"played"];
                    song.liked = songDic[@"liked"];
                    song.lyrics = songDic[@"lyrics"];
                    song.createTime = songDic[@"created_at"] ? [[songDic[@"created_at"] componentsSeparatedByString:@" "] objectAtIndex:0] : @"";
                    song.length = songDic[@"duration"] ? songDic[@"duration"] : @"";
                    self.songs = [self.songs arrayByAddingObject:song];
                }
                
                for (NSDictionary *workDic in profile[@"works"]) {
                    MTWork *work = [[MTWork alloc] init];
                    work.workID = workDic[@"id"];
                    work.name = workDic[@"name"];
                    work.liked = workDic[@"liked"];
                    work.played = workDic[@"played"];
                    work.URL = workDic[@"url"];
                    self.works = [self.works arrayByAddingObject:work];
                }
                
                
                for (NSDictionary *image in profile[@"images"]) {
                    self.sliderImageURLs = [self.sliderImageURLs arrayByAddingObject:image[@"src"]];
                }
                NSLog(@"%@: %@", NSStringFromSelector(_cmd), self.songs);
                
                [self.profileDelegate didDownloadProfileForArtist:self.artistID];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self.profileDelegate failedDownloadProfileForArtist:self.artistID];
        }];    
    }
}

- (void)setAvatarURL:(NSString *)avatarURL
{
    _avatarURL = avatarURL;
    if (!avatarURL) {
        self.avatarImage = [UIImage imageNamed:@"defaultAvatar"];
        [self.imageDelegate didDownloadAvatarImageForArtist:self.artistID];
        return;
    }
    _imageHandler = [[MTImageHandler alloc] init];
    _imageHandler.delegate = self;
    [_imageHandler downloadImageForURL:avatarURL];
}

- (NSArray *)sliderImageURLs
{
    if (!_sliderImageURLs) {
        _sliderImageURLs = [[NSArray alloc] init];
    }
    return _sliderImageURLs;
}

- (NSArray *)works
{
    if (!_works) {
        _works = [[NSArray alloc] init];
    }
    return _works;
}

- (NSArray *)songs
{
    if (!_songs) {
        _songs = [[NSArray alloc] init];
    }
    return _songs;
}

#pragma mark - MTImageHandler delegate

- (void)didDownloadImage:(UIImage *)image forURL:(NSString *)URLString
{
    self.avatarImage = image;
    _imageHandler = nil;
    [self.imageDelegate didDownloadAvatarImageForArtist:self.artistID];
}

- (void)didFailDownloadImageForURL:(NSString *)URLString
{
    self.avatarImage = [UIImage imageNamed:@"defaultAvatar"];
    _imageHandler = nil;
    [self.imageDelegate didDownloadAvatarImageForArtist:self.artistID];
}

@end
