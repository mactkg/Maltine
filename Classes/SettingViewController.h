//
//  SettingViewController.h
//  Maltine
//
//  Created by viriviri on 10/11/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGTwitterEngine.h"
#import "UIAlertView+Helper.h"



@interface SettingViewController : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate,MGTwitterEngineDelegate> {

	NSArray* titles;
	MGTwitterEngine* twitterEngine;
	UITextField* activeField;
}
@property (nonatomic, retain) MGTwitterEngine* twitterEngine;
@property (nonatomic, retain) NSArray* titles;

@end
