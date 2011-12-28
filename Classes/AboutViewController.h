//
//  AboutViewController.h
//  Maltine
//
//  Created by viriviri on 10/08/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingViewController.h"

@interface AboutViewController : UIViewController<AVAudioPlayerDelegate> {

    IBOutlet UIImageView* malLogoImageView;
    IBOutlet UILabel* lblVersionStr;
	IBOutlet UILabel* lblVersion;
    IBOutlet UIButton* btnInfo;
	IBOutlet UIButton* btnTomad;
	AVAudioPlayer* avap;
	
	NSInteger stickerIndex;
	IBOutlet UIView* stickerBaseView;
	IBOutlet UIImageView* stickerImageView1;
	IBOutlet UIImageView* stickerImageView2;
	NSArray* stickerArray;
	NSTimer* timer;
    
}

@property (nonatomic, retain) IBOutlet UILabel* lblVersion;
@property (nonatomic, retain) IBOutlet UIButton* btnTomad;
@property (nonatomic, retain) NSArray* stickerArray;

- (IBAction) btnItunesClicked;
- (IBAction) btnInfoClicked;
- (IBAction) btnTomadClicked;

@end
