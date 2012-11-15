//
//  MultilineTitleView.h
//  Maltine
//
//  Created by viriviri on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MultilineTitleView : UIView {

	UILabel* topText;
	UILabel* middleText;
	UILabel* bottomText;
}

@property (nonatomic, strong) UILabel* topText;
@property (nonatomic, strong) UILabel* middleText;
@property (nonatomic, strong) UILabel* bottomText;
@end
