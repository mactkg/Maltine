//
//  AlbumTableViewCell.m
//  Maltine
//
//  Created by viriviri on 10/08/26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlbumTableViewCell.h"


@implementation AlbumTableViewCell
@synthesize lblMaru;
@synthesize lblAlbumTitle;
@synthesize lblAlbumArtist;
@synthesize albumImage;
@synthesize btnAddFavolites;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
