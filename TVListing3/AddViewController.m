//
//  AddViewController.m
//  TVListing3
//
//  Created by Avikant Saini on 1/11/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[_titleField setDelegate:self];
	[_detailField setDelegate:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[_titleField resignFirstResponder];
	[_detailField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField == _titleField) {
		[_titleField resignFirstResponder];
		[_detailField becomeFirstResponder];
	}
	else if (textField == _detailField){
		[_detailField resignFirstResponder];
	}
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddAction:(id)sender{
	UIImagePickerController *pick = [[UIImagePickerController alloc] init];
	pick.delegate = self;
	pick.allowsEditing = YES;
	pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentViewController:pick animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)pick didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *img = info[UIImagePickerControllerEditedImage];
	_imageView.image = img;
	[pick dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pick {
	[pick dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)titleFieldAction:(id)sender{
}

- (IBAction)detailFieldAction:(id)sender{
	TVShow *show = [[TVShow alloc] init];
	show.Title = _titleField.text;
	show.Detail = _detailField.text;
	[self.delegate addItemViewController:self didFinishEntereingShow:show withImage:_imageView.image];
//	[self dismissViewControllerAnimated:YES completion:Nil];
	[self.navigationController popToRootViewControllerAnimated:YES];
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
