//
//  PlayerViewController.m
//  Maltine
//
//  Created by viriviri on 10/08/20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"


@implementation PlayerViewController
@synthesize playList;
@synthesize trackKey;
@synthesize imageView;
@synthesize btnPause;
@synthesize btnPrev;
@synthesize btnNext;
@synthesize controllerView;
@synthesize informationView;
@synthesize volumeSlider;
@synthesize isFavolitesPlayer;
@synthesize streamer;
@synthesize stopPlayerWhenViewWillAppear;

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
	
	MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
	[volumeSlider addSubview:volumeView];
	[volumeView sizeToFit];
	
	
	UIBarButtonItem* btnFav = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			target:self
																			action:@selector(btnFavClicked)];			
	self.navigationItem.rightBarButtonItem = btnFav;
	
	[btnFav release];
	
	
}

- (void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];

	
	//Fav
	if (isFavolitesPlayer) {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}else {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}

	//Title
	[self setMultilineTitleView];
	
	
	if (self.stopPlayerWhenViewWillAppear) {
		[self destroyStreamer];		
		
		//Image
		self.imageView.image = nil;		
		[self.imageView loadImage:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Image"]];	
		
		
		//indicator
		[indicator startAnimating];
		
		//slideBar
		progressSlider.value = 0;
		
		//Stream
		[self createStreamerWithUrlString:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Url"]];
		[self.streamer start];
	}
	self.stopPlayerWhenViewWillAppear = NO;
	
	
}	


- (IBAction) btnPauseClicked{
	if ([streamer isIdle]) {
		
	}else if ([streamer isPlaying]||[streamer isPaused]) {
		[streamer pause];
	}
}

- (IBAction) btnPrevClicked{
	
	if ([streamer isPlaying]||[streamer isPaused]) {
		[self destroyStreamer];
	}
	
	int currentKey = self.trackKey;

	for (int i = 0; i <[self.playList count]; i++ ) {
		
		if (i == currentKey) {
			if (i == 0) {
				//playListの最後に戻る
				self.trackKey = [self.playList count] - 1;
			}else {
				self.trackKey = i - 1;
			}

		}
	}
	//slideBar
	progressSlider.value = 0;
	
	//title
	[self setMultilineTitleView];
	
	//image
	if (isFavolitesPlayer) {		
		self.imageView.image = nil;		
		[self.imageView loadImage:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Image"]];	
	}
	
	//Stream
	[self createStreamerWithUrlString:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Url"]];
	[self.streamer start];
	
	
}

- (void) playNext {

	int currentKey = self.trackKey;

	for (int i = 0; i <[self.playList count]; i++ ) {
		
		if (i == currentKey) {
			if (i != [self.playList count] - 1) {
				self.trackKey = i + 1;
			}else {
				self.trackKey = 0;				
			}
		}
	}	
	//slideBar
	progressSlider.value = 0;
	
	//title
	[self setMultilineTitleView];
	
	//image
	if (isFavolitesPlayer) {		
		self.imageView.image = nil;		
		[self.imageView loadImage:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Image"]];	
	}
	
	
	//Stream
	[self createStreamerWithUrlString:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Url"]];
	[self.streamer start];

}
- (IBAction) btnNextClicked{
	
	if ([streamer isPlaying]||[streamer isPaused]) {
		[self destroyStreamer];
	}
	
	[self playNext];

	
}

- (void) btnFavClicked{
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
											   destructiveButtonTitle:nil
													otherButtonTitles:NSLocalizedString(@"Add to Favolites",nil),nil];
	
	[actionSheet showInView:self.tabBarController.view];
	[actionSheet release];
	
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

	//add to favolites
	if (buttonIndex == 0) {
		
		MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
		[delegate.favoliteList addObject:[self.playList objectAtIndex:self.trackKey]];

		
		/*
		 NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		 NSMutableArray* favolites = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favolites"]];
		 
		 //favが存在しない場合
		 if (favolites == nil) {
			 favolites = [[NSMutableArray alloc] init];		
		 }
		 
		[favolites addObject:[self.playList objectAtIndex:self.trackKey]];
		[defaults setObject:favolites forKey:@"favolites"];
		//[defaults synchronize];
		*/
	}

}

- (void) setMultilineTitleView{
	
	//Title
	MultilineTitleView* multiTitleView = [[MultilineTitleView alloc] initWithNibName:@"MultilineTitleView" bundle:nil];
	
	[multiTitleView loadView];
	multiTitleView.topText.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"AlbumTitle"];
	multiTitleView.middleText.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Title"];
	multiTitleView.bottomText.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Artist"];
	self.navigationItem.titleView = multiTitleView.view;
	[multiTitleView release];
}

- (void) enterOrExitFullScreen{
	
	[UIView setAnimationsEnabled:YES];
	
	[UIView beginAnimations:@"FullScreen" context:nil];
	
	CGPoint center1 = controllerView.center;
	CGPoint center2 = informaitonView.center;
	CGPoint center3 = volumeSlider.center;
	CGPoint center4 = self.navigationController.navigationBar.center;
	
	
	CGRect frame1 = controllerView.frame;
	CGRect frame2 = informaitonView.frame;
	CGRect frame3 = volumeSlider.frame;
	CGRect frame4 = self.navigationController.navigationBar.frame;
	
	CGFloat height1 = CGRectGetHeight(frame1);
	CGFloat height2 = CGRectGetHeight(frame2);
	CGFloat height3 = CGRectGetHeight(frame3);
	CGFloat height4 = CGRectGetHeight(frame4);
	
	if (controllerView.alpha==0.5f) {
		controllerView.alpha = 0.0f;
		center1.y += height1;
	}else {
		controllerView.alpha=0.5f;
		center1.y -= height1;
	}
	if (informaitonView.alpha==0.5f) {
		informaitonView.alpha = 0.0f;
		center2.y -= height2;
	}else {
		informaitonView.alpha=0.5f;
		center2.y += height2;
	}

	if (volumeSlider.alpha == 0.5f) {
		volumeSlider.alpha = 0.0f;
		center3.y += height3;
	}else {
		volumeSlider.alpha = 0.5f;
		center3.y -= height3;
	}

	if (self.navigationController.navigationBar.alpha == 1.0f) {
		self.navigationController.navigationBar.alpha = 0.0f;
		center4.y -= height4;
	}else {
		self.navigationController.navigationBar.alpha = 1.0f;
		center4.y += height4;
	}
	
	controllerView.center = center1;
	informaitonView.center = center2;
	volumeSlider.center = center3;
	self.navigationController.navigationBar.center = center4;
	
	UIApplication* app = [UIApplication sharedApplication];
	app.statusBarHidden = !app.statusBarHidden;
	
	
	[UIView commitAnimations];
	
}


- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
		 removeObserver:self
		 name:ASStatusChangedNotification
		 object:streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

- (void)createStreamerWithUrlString:(NSString*)urlString
{
	if (streamer)
	{
		return;
	}
	
	[self destroyStreamer];
	
	NSString *escapedValue =
	[(NSString *)CFURLCreateStringByAddingPercentEscapes(
														 nil,
														 (CFStringRef)urlString,
														 NULL,
														 NULL,
														 kCFStringEncodingUTF8)
	 autorelease];
	
	NSURL *url = [NSURL URLWithString:escapedValue];
	
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
														   target:self
														 selector:@selector(updateProgress:)
														 userInfo:nil
														  repeats:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playbackStateChanged:)
												 name:ASStatusChangedNotification
											   object:streamer];
}

//
// sliderMoved:
//
// Invoked when the user moves the slider
//
// Parameters:
//    aSlider - the slider (assumed to be the progress slider)
//
- (IBAction)sliderMoved:(UISlider *)aSlider
{
	if (streamer.duration)
	{
		double newSeekTime = (aSlider.value / 100.0) * streamer.duration;
		[streamer seekToTime:newSeekTime];
	}
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		[indicator startAnimating];
		[self hideOrAppearControllerButtons:YES];
	}
	else if ([streamer isPlaying])
	{
		[indicator stopAnimating];
		[self hideOrAppearControllerButtons:NO];
		[self.btnPause setImage:[UIImage imageNamed:@"playback_pause.png"] forState:UIControlStateNormal];
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		//[self.btnPause setImage:[UIImage imageNamed:@"playback_play.png"] forState:UIControlStateNormal];
		[self playNext];
		
	}
	else if ([streamer isPaused]) {
		[self.btnPause setImage:[UIImage imageNamed:@"playback_play.png"] forState:UIControlStateNormal];
	}

}

- (void) hideOrAppearControllerButtons:(BOOL)hide{
	
	self.btnPause.hidden = hide;
	self.btnPrev.hidden = hide;
	self.btnNext.hidden = hide;
	
}


//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateProgress:(NSTimer *)updatedTimer
{
	if (streamer.bitRate != 0.0)
	{
		double progress = streamer.progress;
		double duration = streamer.duration;
		
		if (duration > 0)
		{
			[positionLabel setText:
			 [NSString stringWithFormat:@"%.1f/%.1f",
			  progress,
			  duration]];
			[progressSlider setEnabled:YES];
			[progressSlider setValue:100 * progress / duration];
		}
		else
		{
			[progressSlider setEnabled:NO];
		}
	}
	else
	{
		positionLabel.text = @"";
	}
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
	[self destroyStreamer];
	if (progressUpdateTimer)
	{
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}	
    [super dealloc];
}


@end
