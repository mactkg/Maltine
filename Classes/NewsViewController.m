//
//  NewsViewController.m
//  Maltine
//
//  Created by viriviri on 10/08/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"


@implementation NewsViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
	news = delegate.news;
	UILabel* titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.numberOfLines = 0;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.text = [news valueForKey:@"Title"];
	titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
	navigationTitle.titleView = titleLabel;
	
	//navigationTitle.title = [news valueForKey:@"Title"];
	newsContents.text = [news valueForKey:@"Contents"];
	newsContents.font = [UIFont systemFontOfSize:12.0];
	
	[newsImage loadImage:[news valueForKey:@"ImageUrl"]];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
