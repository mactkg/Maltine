//
//  RCUIWindow.m
//  Maltine
//
//  Created by 宮近 雄宇 on 11/12/03.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RCUIWindow.h"
#import "MaltineAppDelegate.h"

@implementation RCUIWindow

- (void) remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
            [[MaltineAppDelegate sharedDelegate].player.streamer pause];
			break;
		case UIEventSubtypeRemoteControlPlay:
            [[MaltineAppDelegate sharedDelegate].player.streamer start];
			break;
		case UIEventSubtypeRemoteControlPause:
            [[MaltineAppDelegate sharedDelegate].player.streamer pause];
			break;
		case UIEventSubtypeRemoteControlStop:
            [[MaltineAppDelegate sharedDelegate].player.streamer stop];
			break;
        case UIEventSubtypeRemoteControlNextTrack:
            if (![[MaltineAppDelegate sharedDelegate].player isTextPlayer]) {
                [[MaltineAppDelegate sharedDelegate].player playPrevOrNext:YES];
            }
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            if (![[MaltineAppDelegate sharedDelegate].player isTextPlayer]) {
                [[MaltineAppDelegate sharedDelegate].player playPrevOrNext:NO];
            }
		default:
			break;
	}

}

@end
