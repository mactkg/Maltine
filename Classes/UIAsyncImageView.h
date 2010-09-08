//
//  UIAsyncImageView.h
//  Maltine
//
//  Created by viriviri on 10/08/20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIAsyncImageView : UIImageView {
	NSURLConnection *conn;
	NSMutableData *data;
	UIActivityIndicatorView *indicator;	
}

-(void)loadImage:(NSString *)url;
-(void)abort;
@end
