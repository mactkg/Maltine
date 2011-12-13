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
#import "RCUIWindow.h"

@class PlayerViewController;

@interface MaltineAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    RCUIWindow *window;
    UITabBarController *tabBarController;
	NSArray *releaseList;
	NSDictionary *news;
    NSArray *textList;
	PlayerViewController* player;
	NSMutableArray *favoliteList;
    
    UIView *lockView;
	BOOL uiIsVisible;
}

@property (nonatomic, retain) IBOutlet RCUIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSArray *releaseList;
@property (nonatomic, retain) NSDictionary *news;
@property (nonatomic, retain) NSArray *textList;
@property (nonatomic, retain) PlayerViewController* player;
@property (retain) NSMutableArray* favoliteList;
@property (nonatomic, retain) IBOutlet UIView *lockView;
@property (nonatomic) BOOL uiIsVisible;

+ (MaltineAppDelegate *)sharedDelegate;
+ (void)lock;
+ (void)unlock;

@end
