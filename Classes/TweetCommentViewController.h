//
//  TweetCommentViewController.h
//  Maltine
//
//  Created by viriviri on 11/04/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TweetCommentViewControllerDelegate;

@interface TweetCommentViewController : UIViewController<UITextViewDelegate> {
    
    id<TweetCommentViewControllerDelegate> __unsafe_unretained delegate_;
    IBOutlet UITextView *commentTextView;
    IBOutlet UIToolbar* toolBar;
    IBOutlet UIBarButtonItem* btnDone;
    IBOutlet UIBarButtonItem* btnCounter;
    IBOutlet UINavigationItem* navBarTitle;
    
    NSInteger textCount;
}

@property(nonatomic, unsafe_unretained) id<TweetCommentViewControllerDelegate> delegate;

-(id)initWithDelegate:(id)delegate textCount:(NSInteger)count;
-(IBAction)btnDoneClicked;
-(IBAction)btnCancelClicked;

@end

@protocol TweetCommentViewControllerDelegate

-(void)didFinishedTweetCommentViewController:(TweetCommentViewController*)controller withComment:(NSString*)comment;
-(void)didCanceledTweetCommentViewController:(TweetCommentViewController*)controller;

@end

