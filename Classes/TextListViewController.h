//
//  TextListViewController.h
//  Maltine
//
//  Created by viriviri on 11/07/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebReaderViewController.h"

@interface TextListViewController : UITableViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIActionSheetDelegate>
{
    NSMutableData* imageData;
    IBOutlet UIImageView* titleImageView;
    NSDictionary* currentTextInfoDictionary;
}
@property (nonatomic, retain) NSMutableData* imageData;
@property (nonatomic, retain) UIImageView* titleImageView;
@property (nonatomic, retain) NSDictionary* currentTextInfoDictionary;

@end
