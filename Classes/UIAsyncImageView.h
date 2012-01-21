//
//  UIAsyncImageView.h
//  Maltine
//
//  Created by viriviri on 10/08/20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIAsyncImageViewDelegate <NSObject>

@optional
-(void)didFinishedLoadImage;
-(void)didFailedLoadImage;

@end

@interface UIAsyncImageView : UIImageView {
	NSURLConnection *conn;
	NSMutableData *data;
	UIActivityIndicatorView *indicator;
    id<UIAsyncImageViewDelegate> delegate;
}

@property(nonatomic,assign) id<UIAsyncImageViewDelegate> delegate;

-(void)loadImage:(NSString *)url;
-(void)abort;
@end
