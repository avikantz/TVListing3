//
//  AddViewController.h
//  TVListing3
//
//  Created by Avikant Saini on 1/11/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVShow.h"

@class AddViewController;

@protocol AddViewControllerDelegate <NSObject>
- (void)addItemViewController:(AddViewController *)controller didFinishEntereingShow:(TVShow *)show withImage:(UIImage *)image;
@end

@interface AddViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *AddButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *detailField;

@property (nonatomic, weak) id <AddViewControllerDelegate> delegate;

- (IBAction)AddAction:(id)sender;

- (IBAction)titleFieldAction:(id)sender;
- (IBAction)detailFieldAction:(id)sender;

@end
