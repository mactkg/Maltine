//
//  AboutViewController.h
//  Maltine
//
//  Created by viriviri on 10/08/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController {

	IBOutlet UILabel* lblVersion;
	IBOutlet UIButton* btnTomad;
	
}

@property (nonatomic, retain) IBOutlet UILabel* lblVersion;
@property (nonatomic, retain) IBOutlet UIButton* btnTomad;


- (IBAction) btnItunesClicked;
- (IBAction) btnInfoClicked;
- (IBAction) btnTomadClicked;

@end
