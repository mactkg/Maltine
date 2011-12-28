//
//  TweetCommentViewController.m
//  Maltine
//
//  Created by viriviri on 11/04/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TweetCommentViewController.h"


@implementation TweetCommentViewController

@synthesize delegate = delegate_;

-(id)initWithDelegate:(id)delegate textCount:(NSInteger)count
{
    self = [super initWithNibName:@"TweetCommentViewController" bundle:nil];
    if (self) {
        self.delegate = delegate;
        textCount = count;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    navBarTitle.title = NSLocalizedString(@"comment (option)", nil);
    btnCounter.title = [NSString stringWithFormat:@"%d",140 - textCount];
    commentTextView.inputAccessoryView = toolBar;
    commentTextView.delegate = self;
    [commentTextView becomeFirstResponder];
 
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - textViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger currentCount = 140 - textCount - [textView.text length];
    btnCounter.title = [NSString stringWithFormat:@"%d",currentCount];
    
    if (currentCount < 0) 
    {
        btnDone.enabled = NO;
    }else{
        btnDone.enabled = YES;
    }
        
}

#pragma mark - action
-(IBAction)btnDoneClicked
{
    [self.delegate didFinishedTweetCommentViewController:self withComment:commentTextView.text];
}

-(IBAction)btnCancelClicked
{
    [self.delegate didCanceledTweetCommentViewController:self];    
}

@end
