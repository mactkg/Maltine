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

- (void)handlePinchGesture:(id)sender
{
    
    if (pinchGesture.state == UIGestureRecognizerStateChanged) {
        
        if (pinchGesture.scale >= 0.4 && pinchGesture.scale <= 1.5) {
            //heightChanged = YES;
            textSize = (int)(pinchGesture.scale * 100);
            NSString *jsString = [[[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", (int)(pinchGesture.scale * 100)] autorelease];
            [webView stringByEvaluatingJavaScriptFromString:jsString];
            
        }
    }
}

- (void)textSizeChanged:(id)sender
{
    if (segTextSize.selectedSegmentIndex == 0) {
        if (textSize >= 40) {
            textSize -= 10;
        }
    }
    if (segTextSize.selectedSegmentIndex == 1) {
        if (textSize <= 150) {
            textSize += 10;            
        }
    }
    if (textSize >= 40 && textSize <=150) {
        
        //heightChanged = YES;
        //[webView.scrollView removeObserver:self forKeyPath:@"contentSize"context:nil];
        //[webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];

        NSString *jsString = [[[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", textSize] autorelease];
        [webView stringByEvaluatingJavaScriptFromString:jsString];
        
    }
}

/*
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (heightChanged) {
        
        NSLog(@"%@",[change description]);
        
        NSValue* oldValue = [change objectForKey:@"old"];
        NSValue* newValue = [change objectForKey:@"new"];
        
        CGSize oldSize;
        CGSize newSize;
        [oldValue getValue:&oldSize];
        [newValue getValue:&newSize];
        
        CGFloat heightDiff = newSize.height - oldSize.height;
        NSLog(@"heightDiff:%f",heightDiff);
        
        CGPoint scrollPoint = webView.scrollView.contentOffset;
        NSLog(@"beforeContentOffset:%f",scrollPoint.y);
        
        scrollPoint.y += heightDiff;
        
        [webView.scrollView setContentOffset:scrollPoint animated:NO];
        
        heightChanged = NO;
    }
}
*/
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [self.textInfoDictionary objectForKey:@"Title"];
    textSize = 100;
    
    pinchGesture = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)] autorelease];
    segTextSize = [[[UISegmentedControl alloc] initWithItems:nil] autorelease];
    [segTextSize insertSegmentWithImage:[UIImage imageNamed:@"icon3030_22"] atIndex:0 animated:NO];
    [segTextSize insertSegmentWithImage:[UIImage imageNamed:@"icon3030_21"] atIndex:1 animated:NO];
    segTextSize.segmentedControlStyle = UISegmentedControlStyleBar;
    [segTextSize setMomentary:YES];
    [segTextSize addTarget:self action:@selector(textSizeChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segTextSize;
    
    [webView addGestureRecognizer:pinchGesture];

    //heightChanged = NO;
    //[webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    if (self.loadIndex) {
        NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.textInfoDictionary objectForKey:@"IndexUrl"]]];
        [webView loadRequest:req];

    }else{
        NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.textInfoDictionary objectForKey:@"Url"]]];
        [webView loadRequest:req];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([[MaltineAppDelegate sharedDelegate].player isTextPlayer] && [[MaltineAppDelegate sharedDelegate].player.streamer isPlaying]) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(btnPlayForText)] autorelease];    
        
    }else{
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(btnPlayForText)] autorelease]; 
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    if (!self.loadIndex) {
        
        CGPoint currentPoint = webView.scrollView.contentOffset;
        
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary* textSave = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"textSave"]];
        
        if (!textSave) {
            textSave = [[[NSMutableDictionary alloc] init] autorelease];
        }
        NSMutableDictionary* saveInfo = [[[NSMutableDictionary alloc] init] autorelease];
        
        [saveInfo setObject:[NSNumber numberWithFloat:currentPoint.y] forKey:@"Point"];
        [saveInfo setObject:[NSNumber numberWithInt:textSize] forKey:@"TextSize"];
        [textSave setObject:saveInfo forKey:[self.textInfoDictionary objectForKey:@"Url"]];
        
        //[textSave setObject:[NSNumber numberWithFloat:currentPoint.y] forKey:[self.textInfoDictionary objectForKey:@"Url"]];
        
        [defaults setObject:textSave forKey:@"textSave"];
        //[defaults synchronize];
        
        [super viewWillDisappear:animated];
    }
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MaltineAppDelegate lock];    
}

-(void)webViewDidFinishLoad:(UIWebView *)_webView
{
    if (!self.loadIndex) {
        NSDictionary* textSave = [[NSUserDefaults standardUserDefaults] objectForKey:@"textSave"];
        
        if (textSave) {
            if ([[textSave allKeys] containsObject:[self.textInfoDictionary objectForKey:@"Url"]]) {
                
                NSDictionary* saveInfo = [textSave objectForKey:[self.textInfoDictionary objectForKey:@"Url"]];
                NSNumber* savedPoint = [saveInfo objectForKey:@"Point"];
                NSNumber* savedTextSize = [saveInfo objectForKey:@"TextSize"];
                textSize = [savedTextSize intValue];
                
                NSString *jsString = [[[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", [savedTextSize intValue]] autorelease];
                [webView stringByEvaluatingJavaScriptFromString:jsString];

                [webView.scrollView setContentOffset:CGPointMake(0, [savedPoint floatValue]) animated:NO];
            }
        }
    }
    

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
    [webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
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
