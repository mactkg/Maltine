    //
//  MultilineTitleView.m
//  Maltine
//
//  Created by viriviri on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MultilineTitleView.h"


@implementation MultilineTitleView
@synthesize topText;
@synthesize middleText;
@synthesize bottomText;

- (id)initWithFrame:(CGRect)frame{
	if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		topText    = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 13)];
		middleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, frame.size.width, 16)];
		bottomText = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, frame.size.width, 13)];
		
		topText.font    = [UIFont fontWithName:@"Helvetica" size:10.0];
		middleText.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
		bottomText.font = [UIFont fontWithName:@"Helvetica-Oblique" size:10.0];
		
		topText.textColor    = [UIColor lightGrayColor];
		middleText.textColor = [UIColor whiteColor];
		bottomText.textColor = [UIColor lightGrayColor];
		
		topText.textAlignment = UITextAlignmentCenter;
		middleText.textAlignment = UITextAlignmentCenter;
		bottomText.textAlignment = UITextAlignmentCenter;

		topText.backgroundColor = [UIColor clearColor];
		middleText.backgroundColor = [UIColor clearColor];
		bottomText.backgroundColor = [UIColor clearColor];
		
		[self addSubview:topText];
		[self addSubview:middleText];
		[self addSubview:bottomText];
		
    }
    return self;	
}



@end
