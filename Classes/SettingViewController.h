//
//  SettingViewController.h
//  Maltine
//
//  Created by viriviri on 10/11/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAuthTwitterEngine.h"
#import "UIAlertView+Helper.h"

#define kOAuthConsumerKey @"IERBJS05LakdQD9eKCg"
#define kOAuthConsumerSecret @"p81vkvtQpBAi8QDq5Vrn3BYsEeVMdf9IQm631L7qZQ"
#define kCachedXAuthAccessTokenStringKey	@"cachedXAuthAccessTokenKey"

#define kTwitterIdStringKey @"twitteId"
#define kTwitterPasswordStringKey @"twittePassword"


@interface SettingViewController : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate> {

	NSArray* titles;
	XAuthTwitterEngine* twitterEngine;
	UITextField* activeField;
}
@property (nonatomic, retain) XAuthTwitterEngine* twitterEngine;
@property (nonatomic, retain) NSArray* titles;

- (void)configureInputStringCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
@end
