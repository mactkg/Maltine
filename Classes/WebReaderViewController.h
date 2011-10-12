//
//  WebReaderViewController.h
//  Maltine
//
//  Created by viriviri on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebReaderViewController : UIViewController<UIWebViewDelegate> {
    
    IBOutlet UIWebView* webView;
    
    NSString* urlString;
}

@property (nonatomic, retain) NSString* urlString;

@end
