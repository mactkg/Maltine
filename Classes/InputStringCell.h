//
//  InputStringCell.h
//  slotnavi
//
//  Created by viriviri on 10/08/26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InputStringCell : UITableViewCell {
	UILabel *label;
	UITextField *textField;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UITextField *textField;
- (void)textFieldWidth:(CGFloat)width;

@end
