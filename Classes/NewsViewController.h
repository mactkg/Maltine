//
//  NewsViewController.h
//  Maltine
//
//  Created by viriviri on 10/08/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaltineAppDelegate.h"
#import "UIAsyncImageView.h"

@interface NewsViewController : UIViewController {

	NSDictionary* news;
	IBOutlet UITextView* newsContents;
	IBOutlet UIAsyncImageView* newsImage;
	IBOutlet UINavigationBar* navigationBar;
	IBOutlet UINavigationItem* navigationTitle;

}
@end
