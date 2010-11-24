//
//  MaltineAppDelegate.m
//  Maltine
//
//  Created by viriviri on 10/08/18.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MaltineAppDelegate.h"
#define URL_RELEASE @"http://maltine.b11.coreserver.jp/iphone/ReleaseList.plist"
#define URL_NEWS @"http://maltine.b11.coreserver.jp/iphone/News.plist"

@implementation MaltineAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize releaseList;
@synthesize news;
@synthesize player;
@synthesize favoliteList;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	
	self.releaseList = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:URL_RELEASE]];
		
	self.news = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:URL_NEWS]];
	
	
	PlayerViewController* controller =  [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
	self.player = controller;
	[controller release];
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	self.favoliteList = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favolites"]];
	//favが存在しない場合
	if (self.favoliteList == nil) {
		self.favoliteList = [[NSMutableArray alloc] init];		
	}
	
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.favoliteList forKey:@"favolites"];
	[defaults synchronize];
	
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
		
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
	
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
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


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

