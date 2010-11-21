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
	NSArray* releaseList;
	
}
@property (nonatomic,retain) NSArray* releaseList;
- (void) btnPlayingClicked;
- (void) btnShuffleClicked;
@end
