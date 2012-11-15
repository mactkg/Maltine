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

@property (nonatomic, strong) IBOutlet RCUIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) NSArray *releaseList;
@property (nonatomic, strong) NSDictionary *news;
@property (nonatomic, strong) NSArray *textList;
@property (nonatomic, strong) PlayerViewController* player;
@property (strong) NSMutableArray* favoliteList;
@property (nonatomic, strong) IBOutlet UIView *lockView;
@property (nonatomic) BOOL uiIsVisible;

+ (MaltineAppDelegate *)sharedDelegate;
+ (void)lock;
+ (void)unlock;

@end
