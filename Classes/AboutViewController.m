//
//  AboutViewController.m
//  Maltine
//
//  Created by viriviri on 10/08/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#define MAL_TRANSITION_DURATION 2
#define MAL_NEXT_TRANS_DURATION 4

@implementation AboutViewController

@synthesize lblVersion;
@synthesize btnTomad;
@synthesize stickerArray;

#pragma mark -
#pragma mark button action

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

- (void)btnTwitterSettingClicked{
	
	SettingViewController* controller = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
	UINavigationController* nvc = [[UINavigationController alloc]initWithRootViewController:controller];
	nvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:nvc animated:YES];
	[controller release];
	[nvc release];
	
}

#pragma mark -
#pragma mark Image Transition

- (void)startTransition{
	
	stickerIndex = (stickerIndex + 1) % [self.stickerArray count];
	stickerImageView2.image = [self.stickerArray objectAtIndex:stickerIndex];
	
	CATransition *animation = [CATransition animation];
	
	// アニメーションのタイプ
	animation.type = kCATransitionFade;
	animation.subtype = kCATransitionFromBottom;
	
	// アニメーションの長さ
	animation.duration = MAL_TRANSITION_DURATION;
	
	// アニメーションのタイミング
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	
	// 終了時のイベントを受け取る
	//animation.delegate = self;
	
	// アニメーションを登録する。forKeyはアニメの識別子
	[[stickerBaseView layer] addAnimation:animation forKey:@"transitionViewAnimation"];	
	
	//描画処理
	stickerImageView1.hidden = YES;
	stickerImageView2.hidden = NO;
	UIImageView* tmp = stickerImageView2;
	stickerImageView2 = stickerImageView1;
	stickerImageView1 = tmp;
	
	
}

#pragma mark -
#pragma mark view lifecycle
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
	
	stickerIndex = 0;
	
	UIBarButtonItem* btnTwitterSetting = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil)
																		  style:UIBarButtonItemStyleBordered
																		 target:self
																		 action:@selector(btnTwitterSettingClicked)] autorelease];
	
	self.navigationItem.rightBarButtonItem = btnTwitterSetting;
	
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

	self.stickerArray = [NSArray arrayWithObjects:
					[UIImage imageNamed:@"mp3.png"],
					[UIImage imageNamed:@"seal_fix01.png"],
					[UIImage imageNamed:@"seal_fix02.png"],
					[UIImage imageNamed:@"seal_fix03.png"],
					[UIImage imageNamed:@"seal_fix04.png"],
					[UIImage imageNamed:@"seal_fix05.png"],
//					[UIImage imageNamed:@"seal_fix06.png"],
					[UIImage imageNamed:@"seal_fix07.png"],
					[UIImage imageNamed:@"seal_fix08.png"],
					[UIImage imageNamed:@"seal_fix09.png"],
					[UIImage imageNamed:@"seal_fix10.png"],
					[UIImage imageNamed:@"seal_fix11.png"],
					[UIImage imageNamed:@"seal_fix12.png"],
					[UIImage imageNamed:@"seal_fix13.png"],
					[UIImage imageNamed:@"seal_fix14.png"],
					nil
					];


	timer = [NSTimer scheduledTimerWithTimeInterval:MAL_NEXT_TRANS_DURATION
											 target:self
										   selector:@selector(startTransition)
										   userInfo:nil
											repeats:YES];
	
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {

        //landscape
        lblVersionStr.alpha = 0;
        btnInfo.alpha = 0;
        malLogoImageView.alpha = 0;
        
        stickerBaseView.frame = CGRectMake(0, 0, 480, 217);

    }else{
        //portrait
        lblVersionStr.alpha = 1;
        btnInfo.alpha = 1;
        malLogoImageView.alpha = 1;
        
        stickerBaseView.frame = CGRectMake(0, 60, 320, 197);
        
    }
    
}

#pragma mark - rotation
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [UIView animateWithDuration:0.2 animations:^(void){
    
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            //portrait -> landscape
            lblVersionStr.alpha = 0;
            btnInfo.alpha = 0;
            malLogoImageView.alpha = 0;
            
            stickerBaseView.frame = CGRectMake(0, 0, 480, 217);
            
        }else{
            //landscape -> portrait
            lblVersionStr.alpha = 1;
            btnInfo.alpha = 1;
            malLogoImageView.alpha = 1;
            
            stickerBaseView.frame = CGRectMake(0, 60, 320, 197);
        }
    
    }];
    
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
