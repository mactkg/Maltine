//
//  UIAsyncImageViewForPlayer.m
//  Maltine
//
//  Created by viriviri on 10/08/22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIAsyncImageViewForPlayer.h"


@implementation UIAsyncImageViewForPlayer
@synthesize player;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


- (void) singleTap{	
	if (tapCount==1) {
		[player enterOrExitFullScreen];
	}
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch* touch = [touches anyObject];
	
	tapCount = touch.tapCount;
	
	switch (tapCount) {
		case 1:
			[self performSelector:@selector(singleTap) withObject:nil afterDelay:0.4f];			
			break;
	}
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
