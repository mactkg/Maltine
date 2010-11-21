//
//  AlbumViewController.h
//  Maltine
//
//  Created by viriviri on 10/08/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewController.h"
#import "MultilineTitleView.h"
#import "AlbumTableViewCell.h"

@interface AlbumViewController : UITableViewController<UIActionSheetDelegate> {

	NSDictionary* albumInfo; 
	NSArray* playList;
	
}

@property (nonatomic, retain) NSDictionary* albumInfo;
@property (nonatomic, retain) NSArray* playList;

@end
