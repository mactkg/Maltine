//
//  AboutViewController.m
//  Maltine
//
//  Created by viriviri on 10/08/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

@synthesize lblVersion;
@synthesize btnTomad;


- (IBAction) btnItunesClicked{

	NSString *stringURL = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewAlbum?id=383575862";
	NSURL *url = [NSURL URLWithString:stringURL];
	[[UIApplication sharedApplication] openURL:url];
	
}

- (IBAction) btnInfoClicked{
	
	NSString *stringURL = @"http://maltinerecords.cs8.biz/index.html";
	NSURL *url = [NSURL URLWithString:stringURL];
	[[UIApplication sharedApplication] openURL:url];
	
}

- (IBAction) btnTomadClicked{
	
	[avap play];	
	[self.btnTomad.imageView startAnimating];
	
}

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
	
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	self.lblVersion.text = version;
	
	NSBundle* bundle = [NSBundle mainBundle];
	NSString* path = [bundle pathForResource:@"epoch" ofType:@"caf"];
	
	NSURL* url = [NSURL fileURLWithPath:path];
	avap = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	avap.delegate = self;
	[avap prepareToPlay];	
	
	NSArray* images = [NSArray arrayWithObjects:
					   [UIImage imageNamed:@"tomad_01.png"],
					   [UIImage imageNamed:@"tomad_02.png"],
					   nil
					   ];
	self.btnTomad.imageView.animationImages = images;
	self.btnTomad.imageView.animationDuration = 0.2f;
	self.btnTomad.imageView.animationRepeatCount = 8;
	//[images release];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
