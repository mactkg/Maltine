//
//  ReleaseViewController.h
//  Maltine
//
//  Created by viriviri on 10/08/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MaltineAppDelegate.h"
#import "AlbumViewController.h"

@interface ReleaseViewController : UITableViewController {
	NSArray*	releaseList;
	NSMutableArray* filteredReleaseList;
	NSMutableArray*	allMusicList;
	
	
	NSString*	savedSearchTerm;
    NSInteger	savedScopeButtonIndex;
    BOOL		searchWasActive;
	
}
@property (nonatomic,retain) NSArray* releaseList;
@property (nonatomic,retain) NSMutableArray* filteredReleaseList;
@property (nonatomic,retain) NSMutableArray* allMusicList;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;


- (void) btnPlayingClicked;
- (void) btnShuffleClicked;
- (void)loadImageForCell:(UITableViewCell*)cell mode:(NSInteger)mode indexPath:(NSIndexPath*)indexPath;

@end
