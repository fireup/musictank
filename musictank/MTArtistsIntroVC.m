//
//  MTArtistsIntroVC.m
//  musictank
//
//  Created by ZBN on 14-8-8.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTArtistsIntroVC.h"
#import "MTArtistsIntroCell.h"
#import "MTArtistHomeViewController.h"
static const int pageSize = 10;

@interface MTArtistsIntroVC () <MTImageHandlerDelegate>

@property (copy,nonatomic) NSArray *intros;
@property (strong, nonatomic) MTImageHandler *imageHandler;

@end

@implementation MTArtistsIntroVC
@synthesize intros = _intros;

- (void)loadOneMorePage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    int pageNumber = [self.intros count] / pageSize;
    NSDictionary *para = @{@"session_id": [MTDataHandler sharedData].sessionID,
                           @"page_number": @(pageNumber)};
    [manager POST:ARTISTSINTROURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            self.intros = responseObject[@"artists"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"MTArtistsIntroCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ArtistsIntroCell"];
    
    //    self.refreshControl = [[UIRefreshControl alloc] init];
    //    [self.refreshControl addTarget:self action:@selector(loadOneMorePage) forControlEvents:UIControlEventValueChanged];
    //    self.refreshControl.tintColor = [UIColor lightGrayColor];
    
    [self loadOneMorePage];

}

- (NSArray *)intros
{
    if (!_intros) {
        _intros = [[NSArray alloc] init];
    }
    return _intros;
}

- (void)setIntros:(NSArray *)intros
{
    _intros = intros;
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
    return [self.intros count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTArtistsIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistsIntroCell" forIndexPath:indexPath];
    NSDictionary *intro = [self.intros objectAtIndex:indexPath.row];
    if (indexPath.row % 2 == 0) {
        cell.leftNameLabel.text = intro[@"name"];
    } else {
        cell.rightNameLabel.text = intro[@"name"];
    }
    
    cell.artistImageView.image = [MTImageHandler resizeImageFromImage:[UIImage imageNamed:@"homePic"] forFrame:cell.artistImageView.bounds];
    [self.imageHandler downloadImageForURL:intro[@"image"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueToArtistHome" sender:indexPath];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - MTImageHandler Delegate

- (void)didDownloadImage:(UIImage *)image forURL:(NSString *)URLString
{
    for (NSDictionary *intro in self.intros) {
        if ([intro[@"image"] isEqualToString:URLString]) {
            NSInteger row = [self.intros indexOfObject:intro];
            MTArtistsIntroCell *cell = (MTArtistsIntroCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            cell.artistImageView.image = [MTImageHandler resizeImageFromImage:image forFrame:cell.artistImageView.bounds];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToArtistHome"] && [segue.destinationViewController isKindOfClass:[MTArtistHomeViewController class]]) {
        MTArtistHomeViewController *ahvc = segue.destinationViewController;
        NSIndexPath *path = (NSIndexPath *)sender;
        NSDictionary *intro = [self.intros objectAtIndex:path.row];
        ahvc.artistID = intro[@"id"];
    }
    
    
}


@end
