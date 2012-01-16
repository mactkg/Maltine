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
@synthesize currentPlayerType;
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
-(void)handleTapGesture:(UITapGestureRecognizer*)sender
{
    [self performSelector:@selector(enterOrExitFullScreen) withObject:nil afterDelay:0.4f];			

}

#pragma mark -
#pragma mark view lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    multiTitleView = [[[MultilineTitleView alloc] initWithFrame:CGRectMake(0, 0, 180, 40)] autorelease];
	self.navigationItem.titleView = multiTitleView;

	
	MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
	[volumeSlider addSubview:volumeView];
    volumeView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
	[volumeView sizeToFit];
	
	
	UIBarButtonItem* btnFav = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																			target:self
																			action:@selector(btnFavClicked)] autorelease];			
	self.navigationItem.rightBarButtonItem = btnFav;
	
	srand((unsigned) time(NULL));
	
	self.twitterEngine = [[[XAuthTwitterEngine alloc] initXAuthWithDelegate:self] autorelease];
	self.twitterEngine.consumerKey = kOAuthConsumerKey;
	self.twitterEngine.consumerSecret = kOAuthConsumerSecret;
    
    UITapGestureRecognizer* recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)] autorelease];
    [self.imageView addGestureRecognizer:recognizer];
    self.imageView.delegate = self;
    
    
}

- (void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];

    
    
    UIApplication *application = [UIApplication sharedApplication];
	if([application respondsToSelector:@selector(beginReceivingRemoteControlEvents)]){
		[application beginReceivingRemoteControlEvents];
    }
	[self becomeFirstResponder]; // this enables listening for events
    
	// update the UI in case we were in the background
	NSNotification *notification = [NSNotification notificationWithName:ASStatusChangedNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
    
		
	if (self.stopPlayerWhenViewWillAppear) {
		[self destroyStreamer];		

		if ([self isShufflePlayer]) {
			[self shuffle];
		}		
		
		//Title
		[self setMultilineTitleView];
		
		//Image
		self.imageView.image = nil;
		
		//indicator
		[indicator startAnimating];
        [indicatorLS startAnimating];
		
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
    
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        //landscape
        self.navigationController.navigationBarHidden = YES;
        self.imageView.frame = CGRectMake(80, 0, 320, 320);
        controllerView.alpha = 0;
        controllerLSView.alpha = 0.5;
        volumeSlider.alpha = 0;
        [UIApplication sharedApplication].statusBarHidden = YES;
        
    }else{
        //portrait
        self.navigationController.navigationBarHidden = NO;
        self.imageView.frame = CGRectMake(0, 24, 320, 320);
        controllerView.alpha = 0.5;
        controllerLSView.alpha = 0;
        volumeSlider.alpha = 0.5;
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
	
	
}	
/*
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];  
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];  
    [self resignFirstResponder];
}
*/
- (BOOL)canBecomeFirstResponder {
	return YES;
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
	if ([self isFavolitesPlayer]) {
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
	
	if ([self isFavolitesPlayer]) {
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
	
	if ([self isShufflePlayer]) {
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
    
    //Items
    NSString* number = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Number"];
    NSString* artist = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Artist"];
    NSString* title = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Title"];
    NSString* imageUrl = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Image"];
    
    
    //Notification
    UILocalNotification* notification = [[[UILocalNotification alloc] init] autorelease];
    if (notification) {
        notification.hasAction = NO;
        notification.alertBody = [NSString stringWithFormat:@"[%@] %@ - %@", number, artist, title];
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
	
    
	//image
	if ([self isShufflePlayer]) {
		self.imageView.image = nil;		
		[self.imageView loadImage:imageUrl];	
	}else {
		NSString* beforeImageUrl = [[self.playList objectAtIndex:currentKey] valueForKey:@"Image"];
		NSString* nextImageUrl = imageUrl;
		
		if (![nextImageUrl isEqualToString:beforeImageUrl]) {
			self.imageView.image = nil;		
			[self.imageView loadImage:imageUrl];
		}else{
            [self didFinishedLoadImage];
        }
	}


    
	//Stream
	[self createStreamerWithUrlString:[[self.playList objectAtIndex:self.trackKey] valueForKey:@"Url"]];
	[self.streamer start];
	
}

- (void)playForText:(NSString*)musicUrl{
    
    if ([streamer isPlaying]||[streamer isPaused]) {
		[self destroyStreamer];
	}
	//Stream
	[self createStreamerWithUrlString:musicUrl];
	[self.streamer start];

}

- (void) setMultilineTitleView{
	
	//Title
	
	multiTitleView.topText.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"AlbumTitle"];
	multiTitleView.middleText.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Title"];
	multiTitleView.bottomText.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Artist"];
    
    lblAlbumLS.text = [NSString stringWithFormat:@"[%@] %@",
                       [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Number"],
                       [[self.playList objectAtIndex:self.trackKey] valueForKey:@"AlbumTitle"]];
    lblTrackLS.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Title"];
    lblArtistLS.text = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Artist"];
}

- (void) enterOrExitFullScreen{
	
    [UIView animateWithDuration:0.2 animations:^(void){
        CGPoint center1 = controllerView.center;
        CGPoint center2 = informaitonView.center;
        CGPoint center3 = volumeSlider.center;
        CGPoint center4 = self.navigationController.navigationBar.center;
        CGPoint center5 = controllerLSView.center;
        
        
        CGRect frame1 = controllerView.frame;
        CGRect frame2 = informaitonView.frame;
        CGRect frame3 = volumeSlider.frame;
        CGRect frame4 = self.navigationController.navigationBar.frame;
        CGRect frame5 = controllerLSView.frame;
        
        CGFloat height1 = CGRectGetHeight(frame1);
        CGFloat height2 = CGRectGetHeight(frame2);
        CGFloat height3 = CGRectGetHeight(frame3);
        CGFloat height4 = CGRectGetHeight(frame4);
        CGFloat height5 = CGRectGetHeight(frame5);
    
        if (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
            if (controllerView.alpha==0.5f) {
                controllerView.alpha = 0.0f;
                center1.y += height1;
            }else {
                controllerView.alpha=0.5f;
                center1.y -= height1;
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
            volumeSlider.center = center3;
            self.navigationController.navigationBar.center = center4;
            [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].statusBarHidden;
            
        }else{
            if (controllerLSView.alpha == 0.5f) {
                controllerLSView.alpha = 0.0f;
                center5.y += height5;
            }else{
                controllerLSView.alpha = 0.5f;
                center5.y -= height5;
            }
            controllerLSView.center = center5;
        }
        
        if (informaitonView.alpha==0.5f) {
            informaitonView.alpha = 0.0f;
            center2.y -= height2;
        }else {
            informaitonView.alpha=0.5f;
            center2.y += height2;
        }
        informaitonView.center = center2;
    
    }];
    
    	
	
}

- (NSString *) buildTwitterMessage: (NSString *) comment  {
    NSString* catNum = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Number"];
    NSString* artist = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Artist"];
    NSString* trackName = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Title"];
    NSString* releaseUrl = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"ReleaseUrl"]; 
    
    NSString* trackInfo = [NSString stringWithFormat:@"[%@] %@ - %@ %@", catNum, artist, trackName, releaseUrl];
    NSString* message = [NSString stringWithFormat:@"%@ Maltine Records %@ #MaltineApp",comment,trackInfo];
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

#pragma mark - is*Player
-(BOOL)isFavolitesPlayer{
    if (self.currentPlayerType == FavolitesPlayer) {
        return YES;
    }
    return NO;
}
-(BOOL)isShufflePlayer{
    if (self.currentPlayerType == ShufflePlayer) {
        return YES;
    }
    return NO;
}
-(BOOL)isSearchPlayer{
    if (self.currentPlayerType == SearchPlayer) {
        return YES;
    }
    return NO;
}
-(BOOL)isTextPlayer{
    if (self.currentPlayerType == TextPlayer) {
        return YES;
    }
    return NO;    
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
    [self createTimers:YES];

    
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
    MaltineAppDelegate* appDelegate = [MaltineAppDelegate sharedDelegate]; 
	
    if ([streamer isWaiting])
	{
        if (appDelegate.uiIsVisible) {
            [indicator startAnimating];
            [indicatorLS startAnimating];
            [self hideOrAppearControllerButtons:YES];
        }
	}
	else if ([streamer isPlaying])
	{
        if (appDelegate.uiIsVisible) {
            [indicator stopAnimating];
            [indicatorLS stopAnimating];
            [self hideOrAppearControllerButtons:NO];
            [self.btnPause setImage:[UIImage imageNamed:@"playback_pause.png"] forState:UIControlStateNormal];
            [btnPauseLS setImage:[UIImage imageNamed:@"playback_pause.png"] forState:UIControlStateNormal];
        }
	}
	else if ([streamer isIdle])
	{
        if ([self isTextPlayer]) {
            [self.streamer start];
        }else{
            [self destroyStreamer];
            [self playPrevOrNext:YES];
        }
	}
	else if ([streamer isPaused]) {
        if (appDelegate.uiIsVisible) {
            [self.btnPause setImage:[UIImage imageNamed:@"playback_play.png"] forState:UIControlStateNormal];
            [btnPauseLS setImage:[UIImage imageNamed:@"playback_play.png"] forState:UIControlStateNormal];
        }
	}

}

- (void) hideOrAppearControllerButtons:(BOOL)hide{
	
	self.btnPause.hidden = hide;
	self.btnPrev.hidden = hide;
	self.btnNext.hidden = hide;
    
	btnPauseLS.hidden = hide;
    btnPrevLS.hidden = hide;
    btnNextLS.hidden = hide;
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

#pragma mark - background
//
// forceUIUpdate
//
// When foregrounded force UI update since we didn't update in the background
//
-(void)forceUIUpdate {
    
    if (self.playList) {
        [self setMultilineTitleView];
    }
    if (streamer) {
        [self playbackStateChanged:nil];
    }
}


//
// createTimers
//
// Creates or destoys the timers
//
-(void)createTimers:(BOOL)create {
	if (create) {
		if (streamer) {
            [self createTimers:NO];
            progressUpdateTimer =
            [NSTimer
             scheduledTimerWithTimeInterval:0.1
             target:self
             selector:@selector(updateProgress:)
             userInfo:nil
             repeats:YES];
		}
	}
	else {
		if (progressUpdateTimer)
		{
			[progressUpdateTimer invalidate];
			progressUpdateTimer = nil;
		}
	}
}

#pragma mark - UIAsyncImageViewDelegate
-(void)didFinishedLoadImage{
    
    //Now Playing Info (Background)
    if ([MPNowPlayingInfoCenter class]) {
        /* we're on iOS 5, so set up the now playing center */
        NSString* number = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Number"];
        NSString* albumTitle = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"AlbumTitle"];
        NSString* num_alTitle = [NSString stringWithFormat:@"[%@] %@",number,albumTitle];
        NSString* artist = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Artist"];
        NSString* title = [[self.playList objectAtIndex:self.trackKey] valueForKey:@"Title"];
        
        MPMediaItemArtwork* artWork = [[[MPMediaItemArtwork alloc] initWithImage:self.imageView.image] autorelease];
        
        NSDictionary* currentPlayingTrackInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:artist, title,num_alTitle,artWork, nil]
                                                                            forKeys:[NSArray arrayWithObjects:MPMediaItemPropertyArtist,MPMediaItemPropertyTitle,MPMediaItemPropertyAlbumTitle,MPMediaItemPropertyArtwork, nil]
                                                 ];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = currentPlayingTrackInfo;
    }
    
}

#pragma mark - Remote Control Events
/* The iPod controls will send these events when the app is in the background */
/*
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //handle in RCUIWindow
    
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlPlay:
			[streamer start];
			break;
		case UIEventSubtypeRemoteControlPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlStop:
			[streamer stop];
			break;
        case UIEventSubtypeRemoteControlNextTrack:
            if (![self isTextPlayer]) {
                [self playPrevOrNext:YES];
            }
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            if (![self isTextPlayer]) {
                [self playPrevOrNext:NO];
            }
		default:
			break;
	}
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        //portrait -> landscape
        self.navigationController.navigationBarHidden = YES;
        controllerView.alpha = 0;
        controllerLSView.alpha = 0.5;
        volumeSlider.alpha = 0;
        [UIApplication sharedApplication].statusBarHidden = YES;
        
    }else{
        //landscape -> portrait
        self.navigationController.navigationBarHidden = NO;
        controllerView.alpha = 0.5;
        controllerLSView.alpha = 0;
        volumeSlider.alpha = 0.5;
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        //portrait -> landscape
        
        [UIView animateWithDuration:0.2 animations:^(void){
            self.imageView.frame = CGRectMake(80, 0, 320, 320);
        }];
        
    }else{
        //landscape -> portrait
        [UIView animateWithDuration:0.2 animations:^(void){
            self.imageView.frame = CGRectMake(0, 24, 320, 320);
        }];
    }
    
}


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
