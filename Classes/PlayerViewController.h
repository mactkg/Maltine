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


@class AudioStreamer;
@interface PlayerViewController : UIViewController<UIActionSheetDelegate> {
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
	BOOL isFavolitesPlayer;
	BOOL isShufflePlayer;
	BOOL stopPlayerWhenViewWillAppear;
	
}
@property (nonatomic, retain) NSArray* playList;
@property (nonatomic) int trackKey;
@property (nonatomic, retain) UIAsyncImageView* imageView;
@property (nonatomic, retain) UIButton* btnPause;
@property (nonatomic, retain) UIButton* btnPrev;
@property (nonatomic, retain) UIButton* btnNext;
@property (nonatomic, retain) UIView* controllerView;
@property (nonatomic, retain) UIView* informationView;
@property (nonatomic, retain) UIView* volumeSlider;
@property (nonatomic, retain) AudioStreamer* streamer;
@property BOOL isFavolitesPlayer;
@property BOOL isShufflePlayer;
@property BOOL stopPlayerWhenViewWillAppear;

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
- (void) playNext;
- (void) shuffle;

@end
