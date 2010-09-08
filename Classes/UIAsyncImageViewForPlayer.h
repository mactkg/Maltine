//
//  UIAsyncImageViewForPlayer.h
//  Maltine
//
//  Created by viriviri on 10/08/22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"
#import "PlayerViewController.h"

@interface UIAsyncImageViewForPlayer : UIAsyncImageView {
	NSUInteger tapCount;
	IBOutlet PlayerViewController* player;
}
@property (nonatomic, retain) IBOutlet PlayerViewController* player;

-(void)singleTap;
@end
