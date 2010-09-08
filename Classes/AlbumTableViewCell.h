//
//  AlbumTableViewCell.h
//  Maltine
//
//  Created by viriviri on 10/08/26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"

@interface AlbumTableViewCell : UITableViewCell {

	IBOutlet UILabel* lblMaru;
	IBOutlet UILabel* lblAlbumTitle;
	IBOutlet UILabel* lblAlbumArtist;
	IBOutlet UIAsyncImageView* albumImage;
}

@property (nonatomic,retain) IBOutlet UILabel* lblMaru;
@property (nonatomic,retain) IBOutlet UILabel* lblAlbumTitle;
@property (nonatomic,retain) IBOutlet UILabel* lblAlbumArtist;
@property (nonatomic,retain) IBOutlet UIAsyncImageView* albumImage;

@end
