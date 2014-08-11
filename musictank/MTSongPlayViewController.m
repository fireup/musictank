//
//  MTSongPlayViewController.m
//  musictank
//
//  Created by ZBN on 14-8-7.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTSongPlayViewController.h"


@interface MTSongPlayViewController () <MTArtistProfileDelegate, MTImageHandlerDelegate> {
    MTArtist *_tempArtist;
    MTImageHandler *_imageHandler;
}
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) MTArtist *artist;
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UILabel *lyricsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;


@end

@implementation MTSongPlayViewController

- (void)updateArtistInfoForSong:(MTSong *)song
{
    if (song.artistID) {
        
        if (([MTDataHandler sharedData].artistData)[song.artistID]) {
            self.artist = ([MTDataHandler sharedData].artistData)[song.artistID];
        } else {
            _tempArtist = [[MTArtist alloc] init];
            _tempArtist.artistID = song.artistID;
            _tempArtist.profileDelegate = self;
            [_tempArtist downloadProfile];
        }
    }
}

- (void)didDownloadProfileForArtist:(NSString *)artistID
{
    if ([_tempArtist.artistID isEqualToString:artistID]) {
        ([MTDataHandler sharedData].artistData)[artistID] = _tempArtist;
        self.artist = _tempArtist;
        _tempArtist = nil;
    }
}

- (void)failedDownloadProfileForArtist:(NSString *)artistID
{
    
}

- (void)didDownloadImage:(UIImage *)image forURL:(NSString *)URLString
{
    _imageHandler = nil;
    NSString *imageURL = self.artist.sliderImageURLs[0];
    if ([imageURL isEqualToString:URLString]) {
        self.artistImage.image = [MTImageHandler resizeImageFromImage:image forFrame:self.artistImage.bounds];
    }
}

- (void)setArtist:(MTArtist *)artist
{
    _artist = artist;
    self.songLabel.text = [[self.songLabel.text stringByAppendingString:@"---"] stringByAppendingString:artist.name];
    NSString *imageURL = artist.sliderImageURLs[0];
    _imageHandler = [[MTImageHandler alloc] init];
    _imageHandler.delegate = self;
    [_imageHandler downloadImageForURL:imageURL];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([MTDataHandler sharedData].currentPlaying ) {
        return;
    }
    // Do any additional setup after loading the view.
    MTSong *song = [self.songs objectAtIndex:self.index];
    self.songLabel.text = song.name;
    self.lyricsLabel.text = song.lyrics ? song.lyrics : @"";
    self.lengthLabel.text = song.length;
    
    [self updateArtistInfoForSong:song];
    
//    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:song.streamURL]];
//    [player play];
    
    [[AFSoundManager sharedManager] startStreamingRemoteAudioFromURL:[[song.streamURL stringByAppendingString:@"/"] stringByAppendingString:[MTDataHandler sharedData].sessionID]
                                                            andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
                                                                if (!error) {
                                                                    [MTDataHandler sharedData].currentPlaying = self;
                                                                }
                                                                
                                                            }];
    
   
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
