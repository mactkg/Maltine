//
//  PlayerViewController.h
//  Maltine
//
//  Created by viriviri on 10/08/20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIAsyncImageView.h"
#import "MultilineTitleView.h"
#import "AudioStreamer.h"
#import "MaltineAppDelegate.h"
#import "MGTwitterEngine.h"
#import "UIAlertView+Helper.h"
#import "TweetCommentViewController.h"


#define kOAuthConsumerKey @"IERBJS05LakdQD9eKCg"
#define kOAuthConsumerSecret @"p81vkvtQpBAi8QDq5Vrn3BYsEeVMdf9IQm631L7qZQ"
#define kCachedXAuthAccessTokenStringKey	@"cachedXAuthAccessTokenKey"


@class AudioStreamer;
@interface PlayerViewController : UIViewController<UIActionSheetDelegate,MGTwitterEngineDelegate,TweetCommentViewControllerDelegate,UIAsyncImageViewDelegate> {
	NSArray* playList;
	int trackKey;
	IBOutlet UIAsyncImageView* imageView;
	IBOutlet UIButton* btnPause;
	IBOutlet UIButton* btnPrev;
	IBOutlet UIButton* btnNext;
	
	IBOutlet UIActivityIndicatorView* indicator;
	IBOutlet UIView* controllerView;
	IBOutlet UIView* informaitonView;
	IBOutlet UIView* volumeSlider;
	
	IBOutlet UILabel *positionLabel;
	IBOutlet UISlider *progressSlider;
	AudioStreamer *streamer;
	NSTimer *progressUpdateTimer;
    
    int currentPlayerType;
	BOOL stopPlayerWhenViewWillAppear;
	
	MGTwitterEngine* twitterEngine;
    
    MultilineTitleView* multiTitleView;
    
    IBOutlet UIView* controllerLSView;
    IBOutlet UIButton* btnPauseLS;
    IBOutlet UIButton* btnPrevLS;
    IBOutlet UIButton* btnNextLS;
    
    IBOutlet UILabel* lblAlbumLS;
    IBOutlet UILabel* lblTrackLS;
    IBOutlet UILabel* lblArtistLS;
    IBOutlet UIActivityIndicatorView* indicatorLS;
    
	
}
@property (nonatomic, strong) NSArray* playList;
@property (nonatomic) int trackKey;
@property (nonatomic, strong) UIAsyncImageView* imageView;
@property (nonatomic, strong) UIButton* btnPause;
@property (nonatomic, strong) UIButton* btnPrev;
@property (nonatomic, strong) UIButton* btnNext;
@property (nonatomic, strong) UIView* controllerView;
@property (nonatomic, strong) UIView* informationView;
@property (nonatomic, strong) UIView* volumeSlider;
@property (nonatomic, strong) AudioStreamer* streamer;
@property (nonatomic, assign) int currentPlayerType;
@property BOOL stopPlayerWhenViewWillAppear;
@property (nonatomic, strong) MGTwitterEngine* twitterEngine;

- (IBAction) btnPauseClicked;
- (IBAction) btnPrevClicked;
- (IBAction) btnNextClicked;
- (void) btnFavClicked;

- (void) enterOrExitFullScreen;
- (void) hideOrAppearControllerButtons:(BOOL)hide;

- (void) createStreamerWithUrlString:(NSString *)urlString;
- (void) updateProgress:(NSTimer *)aNotification;
- (IBAction) sliderMoved:(UISlider *)aSlider;
- (void) destroyStreamer;
- (void) setMultilineTitleView;
- (void) playPrevOrNext:(BOOL)isNext;
- (void) shuffle;
- (void) tweetWithComment:(NSString*)comment;
- (void) tweet;
- (NSString *) buildTwitterMessage: (NSString *) comment;

- (BOOL)isFavolitesPlayer;
- (BOOL)isShufflePlayer;
- (BOOL)isSearchPlayer;
- (BOOL)isTextPlayer;

- (void)playForText:(NSString*)musicUrl;

- (void)forceUIUpdate;
- (void)createTimers:(BOOL)create;



typedef enum{
    AlbumPlayer,
    ShufflePlayer,
    FavolitesPlayer,
    SearchPlayer,
    TextPlayer
}PlayerType;

@end
