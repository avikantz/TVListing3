//
//  DetailViewController.m
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = self.Show.Title;
	
	self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", self.Show.Title]];
	
	if (self.imageView.image == nil) {
		self.imageView.image = [UIImage imageNamed:@"TVIcon.png"];
	}
	
	_DetailLabel.text = self.Show.Detail;
	
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
