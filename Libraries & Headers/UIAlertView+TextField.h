//
//  UIAlertView_Extended.h
//  iAnnoted
//
//  Created by viriviri on 11/02/16.
//  Copyright 2011 FEAC International. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UITextField, UILabel;
@interface UIAlertView (TextField)
- (UITextField*)addTextFieldWithValue:(NSString*)value label:(NSString*)label;
- (UITextField*)textFieldAtIndex:(NSUInteger)index;
- (NSUInteger)textFieldCount;
- (UITextField*)textField;
@end
