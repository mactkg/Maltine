//
//  UIAsyncImageView.m
//  Maltine
//
//  Created by viriviri on 10/08/20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIAsyncImageView.h"


@implementation UIAsyncImageView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(void)loadImage:(NSString *)url{
	[self abort];
	if (!indicator) {
		indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
		indicator.frame = self.bounds;
		indicator.hidesWhenStopped = YES;
		indicator.contentMode = UIViewContentModeCenter;
		[self addSubview:indicator];
	}
	
	[indicator startAnimating];
	
	self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	data = [[NSMutableData alloc] initWithCapacity:0];
	
	NSString *escapedValue =
	[(NSString *)CFURLCreateStringByAddingPercentEscapes(
														 nil,
														 (CFStringRef)url,
														 NULL,
														 NULL,
														 kCFStringEncodingUTF8)
	 autorelease];
	
	NSURLRequest *req = [NSURLRequest 
						 requestWithURL:[NSURL URLWithString:escapedValue]
						 cachePolicy:NSURLRequestUseProtocolCachePolicy
						 timeoutInterval:30.0];
	conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nsdata{
	[data appendData:nsdata];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[self abort];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	self.image = [UIImage imageWithData:data];
	self.contentMode = UIViewContentModeScaleAspectFit;
	self.autoresizingMask = UIViewAutoresizingNone;
	[indicator stopAnimating];
	[self abort];
}

-(void)abort{
	if(conn != nil){
		[conn cancel];
		[conn release];
		conn = nil;
	}
	if(data != nil){
		[data release];
		data = nil;
	}
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[conn cancel];
	[conn release];
	[data release];
	
    [super dealloc];
}


@end
