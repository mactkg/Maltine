//
//  MultilineTitleView.h
//  Maltine
//
//  Created by viriviri on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MultilineTitleView : UIViewController {

	IBOutlet UILabel* topText;
	IBOutlet UILabel* middleText;
	IBOutlet UILabel* bottomText;
}

@property (nonatomic, retain) IBOutlet UILabel* topText;
@property (nonatomic, retain) IBOutlet UILabel* middleText;
@property (nonatomic, retain) IBOutlet UILabel* bottomText;
@end
