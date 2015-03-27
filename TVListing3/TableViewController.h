//
//  TableViewController.h
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "DetailViewController.h"
#import "SWTableViewCell.h"
#import "AddViewController.h"

@interface TableViewController : UITableViewController <SWTableViewCellDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *SortButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *EditButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddButton;

- (IBAction)SortAction:(id)sender;
- (IBAction)EditAction:(id)sender;
//- (IBAction)AddAction:(id)sender;





@end
