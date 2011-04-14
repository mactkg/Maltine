//
//  PlayerViewController.m
//  Maltine
//
//  Created by viriviri on 10/08/20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"
#import "UIAlertView+TextField.h"

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
@synthesize isShufflePlayer;
@synthesize isSearchPlayer;
@synthesize streamer;
@synthesize stopPlayerWhenViewWillAppear;
@synthesize twitterEngine;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
#pragma mark -
#pragma mark view lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
	[volumeSlider addSubview:volumeView];
	[volumeView sizeToFit];
	
	
	UIBarButtonItem* btnFav = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																			target:self
																			action:@selector(btnFavClicked)];			
	self.navigationItem.rightBarButtonItem = btnFav;
	
	[btnFav release];
	
	srand((unsigned) time(NULL));
	
	self.twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
	self.twitterEngine.consumerKey = kOAuthConsumerKey;
	self.twitterEngine.consumerSecret = kOAuthConsumerSecret;
}

- (void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];

		
	if (self.stopPlayerWhenViewWillAppear) {
		[self destroyStreamer];		

		if (isShufflePlayer) {
			[self shuffle];
		}		
		
		//Title
		[self setMultilineTitleView];
		
		//Image
		self.imageView.image = nil;
		
		//indicator
		[indicator startAnimating];
		
		//slideBar
		progressSlider.value = 0;
		
		//Stream
		[self createStreamerWithUrlString:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Url"]];
		[self.streamer start];
	}
	
	self.stopPlayerWhenViewWillAppear = NO;
	
	if (self.imageView.image == nil) {
		[self.imageView loadImage:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Image"]];	
	}
	
	
}	

#pragma mark -
#pragma mark button events

- (IBAction) btnPauseClicked{
	if ([streamer isIdle]) {
		
	}else if ([streamer isPlaying]||[streamer isPaused]) {
		[streamer pause];
	}
}

- (IBAction) btnPrevClicked{
	
	if (streamer.progress > 4.0) {
		[streamer seekToTime:0];
	}else {
		[self playPrevOrNext:NO];
	}
	
}

- (IBAction) btnNextClicked{
	
	[self playPrevOrNext:YES];
}

- (void) btnFavClicked{
	
	UIActionSheet* actionSheet;
	if (isFavolitesPlayer) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil
												  delegate:self
										 cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
									destructiveButtonTitle:nil
										 otherButtonTitles:NSLocalizedString(@"Tweet",nil),nil];
	}else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil
												  delegate:self
										 cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
									destructiveButtonTitle:nil
										 otherButtonTitles:NSLocalizedString(@"Add to Favolites",nil),NSLocalizedString(@"Tweet",nil),NSLocalizedString(@"Tweet with comment", nil),nil];
	}

	
	[actionSheet showInView:self.tabBarController.view];
	[actionSheet release];
	
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if (isFavolitesPlayer) {
		if (buttonIndex == 0) {
			[self tweet];
		}
	}else {
		//add to favolites
		if (buttonIndex == 0) {
			
			MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
			[delegate.favoliteList addObject:[self.playList objectAtIndex:self.trackKey]];
			
		}
		
		//Tweet
		if (buttonIndex == 1) {
            [self tweet];
		}
        if (buttonIndex == 2) {
            NSInteger count = [[self buildTwitterMessage:@""] length];
            TweetCommentViewController* controller = [[[TweetCommentViewController alloc] initWithDelegate:self textCount:count] autorelease];
            [self.navigationController presentModalViewController:controller animated:YES];            
        }
	}
	
}

#pragma mark -
#pragma mark TweetCommentViewControllerDelegate
-(void)didFinishedTweetCommentViewController:(TweetCommentViewController *)controller withComment:(NSString *)comment
{
    [controller dismissModalViewControllerAnimated:YES];
    [self tweetWithComment:comment];
}
-(void)didCanceledTweetCommentViewController:(TweetCommentViewController *)controller
{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark utility

- (void) shuffle {
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
	
	NSUInteger randomIndex = rand() % [delegate.releaseList count];
	self.playList = [[delegate.releaseList objectAtIndex:randomIndex] valueForKey:@"PlayList"];
	
	self.trackKey = rand() % [self.playList count];
	
}

- (void) playPrevOrNext:(BOOL)isNext {
	
	if ([streamer isPlaying]||[streamer isPaused]) {
		[self destroyStreamer];
	}
	
	int currentKey = self.trackKey;
	
	if (isShufflePlayer) {
		[self shuffle];
	}else {
		
		//favolites編集で個数が変わった場合
		if (currentKey >= [self.playList count]) {
			if (isNext) {
				//playListの最初に戻る
				self.trackKey = 0;
			}else {
				//playListの最後に戻る
				self.trackKey = [self.playList count] - 1;
			}

		}else {
			for (int i = 0; i <[self.playList count]; i++ ) {
				
				if (i == currentKey) {
					if (isNext) {
						if (i != [self.playList count] - 1) {
							self.trackKey = i + 1;
						}else {
							self.trackKey = 0;				
						}
					}else {
						if (i == 0) {
							//playListの最後に戻る
							self.trackKey = [self.playList count] - 1;
						}else {
							self.trackKey = i - 1;
						}
					}

				}
			}	
		}
	}
	
	//slideBar
	progressSlider.value = 0;
	
	//title
	[self setMultilineTitleView];
	
	//image
	if (isShufflePlayer) {
		self.imageView.image = nil;		
		[self.imageView loadImage:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Image"]];	
	}else {
		NSString* beforeImageUrl = [[self.playList objectAtIndex:currentKey] valueForKey:@"Image"];
		NSString* nextImageUrl = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Image"];
		
		if (![nextImageUrl isEqualToString:beforeImageUrl]) {
			self.imageView.image = nil;		
			[self.imageView loadImage:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Image"]];			
		}
	}
	
	//Stream
	[self createStreamerWithUrlString:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Url"]];
	[self.streamer start];
	
	
	
}

- (void) setMultilineTitleView{
	
	//Title
	MultilineTitleView* multiTitleView = [[MultilineTitleView alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
	
	multiTitleView.topText.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"AlbumTitle"];
	multiTitleView.middleText.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Title"];
	multiTitleView.bottomText.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Artist"];
	self.navigationItem.titleView = multiTitleView;
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

- (NSString *) buildTwitterMessage: (NSString *) comment  {
    NSString* artist = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Artist"];
    NSString* trackName = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Title"];
    
    NSString* trackInfo = [NSString stringWithFormat:@"%@ - \"%@\"", artist, trackName];
    NSString* message = [NSString stringWithFormat:@"%@ Now playing: %@ #MaltineApp",comment,trackInfo];
    return message;
}

-(void)tweetWithComment:(NSString*)comment{
    
	if ([self.twitterEngine isAuthorized]) {
        [MaltineAppDelegate lock];
        NSString *message = [self buildTwitterMessage: comment];

		//NSLog(@"%@",message);
		[self.twitterEngine sendUpdate:message];
	}else{
		
		UIAlertViewQuick(NSLocalizedString(@"Error", nil), NSLocalizedString(@"Please sign in to Twitter from About Tab.", nil),@"OK");
		
	}
    
}
-(void)tweet{
	
    [self tweetWithComment:@""];
    
}


#pragma mark -
#pragma mark twitter delegate
- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username;
{
	NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedXAuthAccessTokenStringKey];	
	NSLog(@"About to return access token string: %@", accessTokenString);	
	return accessTokenString;
}

- (void)requestSucceeded:(NSString *)connectionIdentifier
{
    [MaltineAppDelegate unlock];
    UIAlertViewQuick(nil, NSLocalizedString(@"Tweet succeeded!", nil),@"OK");
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    [MaltineAppDelegate unlock];
    UIAlertViewQuick(NSLocalizedString(@"Error", nil), NSLocalizedString(@"Tweet failed!", nil),@"OK");
}


#pragma mark -
#pragma mark streamer

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
		[self playPrevOrNext:YES];
		
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

#pragma mark -
#pragma mark memory management

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
