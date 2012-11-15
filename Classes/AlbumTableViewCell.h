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
	IBOutlet UIButton* btnAddFavolites;
	IBOutlet UIAsyncImageView* albumImage;
}

@property (nonatomic,strong) IBOutlet UILabel* lblMaru;
@property (nonatomic,strong) IBOutlet UILabel* lblAlbumTitle;
@property (nonatomic,strong) IBOutlet UILabel* lblAlbumArtist;
@property (nonatomic,strong) IBOutlet UIAsyncImageView* albumImage;
@property (nonatomic,strong) IBOutlet UIButton* btnAddFavolites;

@end
