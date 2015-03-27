//
//  DetailViewController.h
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVShow.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *DetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) TVShow *Show;

@end
