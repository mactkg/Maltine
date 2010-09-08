//
//  MaltineAppDelegate.h
//  Maltine
//
//  Created by viriviri on 10/08/18.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioStreamer.h"
#import "PlayerViewController.h"
#import "MultilineTitleView.h"

@class PlayerViewController;

@interface MaltineAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	NSArray *releaseList;
	NSDictionary *news;
	PlayerViewController* player;
	NSMutableArray *favoliteList;
	//NSArray *favoliteList;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSArray *releaseList;
@property (nonatomic, retain) NSDictionary *news;
@property (nonatomic, retain) PlayerViewController* player;
@property (retain) NSMutableArray* favoliteList;
//@property (nonatomic, retain) NSArray* favoliteList;
@end
