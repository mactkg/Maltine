//
//  MaltineAppDelegate.m
//  Maltine
//
//  Created by viriviri on 10/08/18.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MaltineAppDelegate.h"
//#import <dispatch/dispatch.h>

#define URL_RELEASE @"http://www23168u.sakura.ne.jp/maltine/plist/ReleaseList.plist"
#define URL_NEWS @"http://www23168u.sakura.ne.jp/maltine/plist/News.plist"
#define URL_TEXT @"http://www23168u.sakura.ne.jp/maltine/plist/TextList.plist"
@implementation MaltineAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize releaseList;
@synthesize news;
@synthesize textList;
@synthesize player;
@synthesize favoliteList;
@synthesize lockView;

@synthesize uiIsVisible;

#pragma mark -
#pragma mark Application lifecycle

+ (MaltineAppDelegate *)sharedDelegate
{
	return (MaltineAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (void)lock
{
	[[MaltineAppDelegate sharedDelegate].window addSubview:[MaltineAppDelegate sharedDelegate].lockView];
}

+ (void)unlock
{
	[[MaltineAppDelegate sharedDelegate].lockView removeFromSuperview];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    self.uiIsVisible = YES;

	self.releaseList = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:URL_RELEASE]];
	self.news = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:URL_NEWS]];
    self.textList = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:URL_TEXT]];
	
	PlayerViewController* controller =  [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
	self.player = controller;
    
    [self.player createTimers:YES];
    [self.player forceUIUpdate];
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	self.favoliteList = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favolites"]];
	//favが存在しない場合
	if (self.favoliteList == nil) {
		self.favoliteList = [[NSMutableArray alloc] init];
	}
	
    //Twitter Token移行(1.3 -> 2.0)
    NSString *tokenString = [defaults objectForKey:kCachedXAuthAccessTokenStringKey];
    
    if (tokenString) {
        OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:tokenString];
        NSLog(@"%@",token);
        
        [defaults setObject:token.key forKey:kOATokenKey];
        [defaults setObject:token.secret forKey:kOATokenSecret];
        [defaults removeObjectForKey:kCachedXAuthAccessTokenStringKey];
    }
    
    NSString *twitterPassword = [defaults objectForKey:kTwitterPasswordStringKey];
    if (twitterPassword) {
        [defaults removeObjectForKey:kTwitterPasswordStringKey];
    }
    
    [window addSubview:tabBarController.view];
    self.window.rootViewController = tabBarController;
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    self.uiIsVisible = NO;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.favoliteList forKey:@"favolites"];
	[defaults synchronize];
	
    self.uiIsVisible = NO;
	[self.player createTimers:NO];

    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    self.uiIsVisible = YES;
	[self.player createTimers:YES];
	[self.player forceUIUpdate];
    		
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    self.uiIsVisible = YES;

}


- (void)applicationWillTerminate:(UIApplication *)application {
	
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    self.uiIsVisible = NO;
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}



@end

