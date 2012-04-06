//
//  WebReaderViewController.h
//  Maltine
//
//  Created by viriviri on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebReaderViewControllerDelegate;
@interface WebReaderViewController : UIViewController<UIWebViewDelegate> {
    
    IBOutlet UIWebView* webView;
    NSDictionary* textInfoDictionary;
    BOOL loadIndex;
    
    UIPinchGestureRecognizer* pinchGesture;
    UISegmentedControl* segTextSize;
    int textSize;
    
    BOOL heightChanged;
}

@property (nonatomic, retain) NSDictionary* textInfoDictionary;
@property BOOL loadIndex;
@end