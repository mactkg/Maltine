//
//  InputStringCell.m
//  Maltine
//
//  Created by viriviri on 10/08/26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InputStringCell.h"


@implementation InputStringCell

@synthesize label, textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 6, 190, 30)] autorelease];
		label.font = [UIFont boldSystemFontOfSize:16];
		textField = [[[UITextField alloc] initWithFrame:CGRectMake(200, 10, 100, 30)] autorelease];
		textField.autoresizingMask = UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleRightMargin;
		textField.autoresizesSubviews = YES;
		textField.textAlignment = UITextAlignmentRight;
		[self addSubview:label];
		[self addSubview:textField];
	}
    return self;
}

- (void)textFieldWidth:(CGFloat)width
{
	textField.frame = CGRectMake(300-width, 10, width, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
