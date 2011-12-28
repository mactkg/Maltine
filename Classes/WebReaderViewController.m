//
//  WebReaderViewController.m
//  Maltine
//
//  Created by viriviri on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebReaderViewController.h"
#import "MaltineAppDelegate.h"
#import "UIAlertView+Helper.h"
@implementation WebReaderViewController
@synthesize textInfoDictionary;
@synthesize loadIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

-(void)btnPlayForText{
    
    if (![[MaltineAppDelegate sharedDelegate].player isTextPlayer] || ![[MaltineAppDelegate sharedDelegate].player.streamer isPlaying]) {
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(btnPlayForText)] autorelease];
        [MaltineAppDelegate sharedDelegate].player.currentPlayerType = TextPlayer;
        [[MaltineAppDelegate sharedDelegate].player playForText:[self.textInfoDictionary objectForKey:@"MusicUrl"]];

        
    }else{
        [[MaltineAppDelegate sharedDelegate].player destroyStreamer];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(btnPlayForText)] autorelease];        
    }
    
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([[MaltineAppDelegate sharedDelegate].player isTextPlayer] && [[MaltineAppDelegate sharedDelegate].player.streamer isPlaying]) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(btnPlayForText)] autorelease];    

    }else{
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(btnPlayForText)] autorelease]; 
    }
    self.title = [self.textInfoDictionary objectForKey:@"Title"];
    
    if (self.loadIndex) {
        NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.textInfoDictionary objectForKey:@"IndexUrl"]]];
        [webView loadRequest:req];

    }else{
        NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.textInfoDictionary objectForKey:@"Url"]]];
        [webView loadRequest:req];
        
    }
    
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MaltineAppDelegate lock];    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [MaltineAppDelegate unlock];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [MaltineAppDelegate unlock];
    UIAlertViewQuick(@"エラー", @"読み込みに失敗しました。", @"OK");
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

@end
