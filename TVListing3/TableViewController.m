//
//  TableViewController.m
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import "TableViewController.h"
#import "TVShow.h"
#import "TableViewCell.h"
#import "topView.h"

@interface TableViewController (){
	NSMutableArray *FullList;

	NSMutableArray *SearchResults;
	
	NSMutableArray *ShowList;
	
	BOOL isAlphabetical;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *filepath = [self documentsPathForFileName:[NSString stringWithFormat:@"FullList.json"]];
	if (![NSData dataWithContentsOfFile:filepath]) {
		NSLog(@"Original Store");
		FullList = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"TVList" ofType:@"json"]] options:kNilOptions error:nil];
		[[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"TVList" ofType:@"json"]] writeToFile:filepath atomically:YES];
		[[NSUserDefaults standardUserDefaults] setObject:filepath forKey:@"DownloadedListPath"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else {
		FullList = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filepath] options:kNilOptions error:nil];
		NSLog(@"Documents Data");
	}
	
	ShowList = [[NSMutableArray alloc] init];
	
	for(int i=0; i<[FullList count]; ++i){
		// Add a 'TVShow: NSObject' object
		TVShow *show = [TVShow new];
		
		// Add Details to the object
		show.Title = [NSString stringWithFormat:@"%@", [[FullList objectAtIndex:i] objectForKey:@"Title"]];
		show.Detail = [NSString stringWithFormat:@"%@",[[FullList objectAtIndex:i] objectForKey:@"Detail"]];
		
		// Add the object to the 'ShowList' Array
		[ShowList addObject:show];
	}
	
	// Add the topView 'XIB' with the number of shows and images...
	topView *topV = [[[NSBundle mainBundle] loadNibNamed:@"topView" owner:self options:nil] objectAtIndex:0];
	[topV setFrame:CGRectMake(0, -(self.view.frame.size.height), self.view.frame.size.width, self.view.frame.size.height)];
	topV.topLabel.text = [NSString stringWithFormat:@"%li SHOWS", (long)[ShowList count]];
	[self.tableView addSubview:topV];
	
	[self.tableView reloadData];
	
	// Adding the bar button items...
	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: _EditButton, nil];
	self.navigationController.toolbarHidden = YES;

	_SortButton.title = @"Alphabetical";
	_SortButton.enabled = NO;
	[_SortButton setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:20.0]}
							   forState:UIControlStateNormal];
	[_EditButton setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:20.0]}
							   forState:UIControlStateNormal];
	[_AddButton setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:20.0]}
							  forState:UIControlStateNormal];
	
	[[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil]];
	
	isAlphabetical = NO;
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor blackColor];
	self.searchDisplayController.searchResultsTableView.backgroundView.backgroundColor = [UIColor blackColor];
	self.searchDisplayController.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search display results

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	// Predicate from the 'Detail' key from 'TVShow' Object array 'ShowList'
	NSPredicate *resultPredicate = [NSPredicate
									predicateWithFormat:@"Detail contains[cd] %@",
									searchText];
	
	SearchResults = [[NSMutableArray alloc]initWithArray:[ShowList filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[self filterContentForSearchText:searchString
							   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
									  objectAtIndex:[self.searchDisplayController.searchBar
													 selectedScopeButtonIndex]]];
	return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return [SearchResults count];
		
	else
		return [ShowList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TableViewCell *cell = (TableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"CID"];
	
	// Configuring the cell
	if(cell == nil){
		cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CID"];
	}
	
	// Display the show information in the table cell
	TVShow *show = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		show = [SearchResults objectAtIndex:indexPath.row];
		cell.titleLabel.text = [NSString stringWithFormat:@"    %@", show.Title];
		cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"%@.jpg", show.Title]];
	}
	else {
		show = [ShowList objectAtIndex:indexPath.row];
		cell.titleLabel.text = [NSString stringWithFormat:@"    %li. %@", (long)indexPath.row + 1, show.Title];
		cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"%@.jpg", show.Title]];
	}
	
	if (cell.imageView.image == nil) {
		cell.imageView.image = [UIImage imageNamed:@"TVIcon.png"];
	}
	
	cell.textLabel.text = cell.titleLabel.text;
	cell.textLabel.alpha = 0;
	
	// Customizing the cell for SwipeCellView Methods
	// Adding utitlity buttons
	
	NSMutableArray *leftUtilityButtons = [NSMutableArray new];
	
	[leftUtilityButtons sw_addUtilityButtonWithColor: [UIColor blackColor] icon:[UIImage imageNamed:@"save.png"]];
	[leftUtilityButtons sw_addUtilityButtonWithColor: [UIColor blackColor] icon:[UIImage imageNamed:@"message.png"]];
	[leftUtilityButtons sw_addUtilityButtonWithColor: [UIColor blackColor] icon:[UIImage imageNamed:@"facebook.png"]];
	[leftUtilityButtons sw_addUtilityButtonWithColor: [UIColor blackColor] icon:[UIImage imageNamed:@"twitter.png"]];
	
	cell.leftUtilityButtons = leftUtilityButtons;
	cell.delegate = self;
	
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"SID"]) {
		NSIndexPath *indexPath = nil;
		TVShow *show = nil;
		
		if(self.searchDisplayController.active){
			indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
			show = [SearchResults objectAtIndex:indexPath.row];
		}
		else{
			indexPath = [self.tableView indexPathForSelectedRow];
			show = [ShowList objectAtIndex:indexPath.row];
		}
		
		DetailViewController *dvc = segue.destinationViewController;
		dvc.Show = show;
	}
}

#pragma mark - Deselect row at index path

// Deselection of a selected row at index path
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[UIView animateWithDuration:5.0 animations:^{
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}];
}

#pragma mark - SWTableViewCellDelegate Methods

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
	NSString *showName;
	if (self.searchDisplayController.isActive)
		showName = [cell.textLabel.text substringFromIndex:4];
	else
		showName = [cell.textLabel.text componentsSeparatedByString:@". "][1];
	switch (index) {
		case 0: {
			UIImageWriteToSavedPhotosAlbum(cell.imageView.image, nil, nil, nil);
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Saved to Camera Roll successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alertView show];
			break;
		}
		case 1: {
			[self showEmail: [NSString stringWithFormat:@"%@.jpg", showName] :[NSString stringWithFormat: @"Check out %@", showName] : [NSString stringWithFormat:@"You really should watch %@. I'm hooked!", showName]];
			break;
		}
		case 2: {
			if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
				SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
				
				[controller setInitialText:[NSString stringWithFormat:@"Watching %@ and enjoying!", showName]];
				[controller addImage:cell.imageView.image];
				[self presentViewController:controller animated:YES completion:Nil];
			}
			else {
				printf("Facebook unavailable!\n");
			}
			break;
		}
		case 3: {
			if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
			{
				SLComposeViewController *tweetSheet = [SLComposeViewController
													   composeViewControllerForServiceType:SLServiceTypeTwitter];
				[tweetSheet setInitialText:[NSString stringWithFormat:@"Watching %@ and enjoying!", showName]];
				[tweetSheet addImage:cell.imageView.image];
				[self presentViewController:tweetSheet animated:YES completion:nil];
			}
			else {
				printf("Twitter unavailable!\n");
			}
			break;
		}
		default:
			break;
	}
}

#pragma mark - Mail composer delegate

- (void)showEmail:(NSString*)file :(NSString *)title :(NSString *)body{
	
	NSString *emailTitle = title;
	NSString *messageBody = body;
	
	MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
	mc.mailComposeDelegate = self;
	[mc setSubject:emailTitle];
	[mc setMessageBody:messageBody isHTML:NO];
	
	// Determine the file name and extension
	NSArray *filepart = [file componentsSeparatedByString:@"."];
	NSString *filename = [filepart objectAtIndex:0];
	NSString *extension = [filepart objectAtIndex:1];
	
	// Get the resource path and read the file using NSData
	NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
	NSData *fileData = [NSData dataWithContentsOfFile:filePath];
	
	// Determine the MIME type
	NSString *mimeType;
	if ([extension isEqualToString:@"jpg"]) {
		mimeType = @"image/jpeg";
	} else if ([extension isEqualToString:@"png"]) {
		mimeType = @"image/png";
	} else if ([extension isEqualToString:@"doc"]) {
		mimeType = @"application/msword";
	} else if ([extension isEqualToString:@"ppt"]) {
		mimeType = @"application/vnd.ms-powerpoint";
	} else if ([extension isEqualToString:@"html"]) {
		mimeType = @"text/html";
	} else if ([extension isEqualToString:@"pdf"]) {
		mimeType = @"application/pdf";
	}
	
	// Add attachment
	[mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
	
	// Present mail view controller on screen
	[self presentViewController:mc animated:YES completion:NULL];
	
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	switch (result){
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail sent failure: %@", [error localizedDescription]);
			break;
		default:
			break;
	}
	
	// Close the Mail Interface
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Sort, Add, and Edit Actions

- (IBAction)SortAction:(id)sender {
	if (isAlphabetical == NO) {
		isAlphabetical = YES;
		_SortButton.title = @"Rank Wise";
		NSArray *sortedArray = [ShowList sortedArrayUsingComparator:^(TVShow *a, TVShow *b) {
			return [a.Title caseInsensitiveCompare:b.Title];
		}];
		ShowList = [[NSMutableArray alloc] initWithArray:sortedArray];
		
		NSArray *fullSortedArray = [FullList sortedArrayUsingComparator:^(NSDictionary *obj1, NSDictionary *obj2) {
			return [[obj1 objectForKey:@"Title"] caseInsensitiveCompare:[obj2 objectForKey:@"Title"]];
		}];
		FullList = [NSMutableArray arrayWithArray:fullSortedArray];
		
		[self writeToDocuments];
		
		[self.tableView reloadData];
	}
	else {
		[self viewDidLoad];
	}
}

- (IBAction)EditAction:(id)sender {
	if (self.editing) {
		self.editing = NO;
		[_EditButton setTitle:@"Edit"];
		[self.tableView reloadData];
	}
	else{
		self.editing = YES;
		[_EditButton setTitle:@"Done"];
		[self.tableView reloadData];
	}
}

-(void)writeToDocuments {
	NSData *data = [NSJSONSerialization dataWithJSONObject:FullList options:kNilOptions error:nil];
	NSString *filepath = [self documentsPathForFileName:[NSString stringWithFormat:@"FullList.json"]];
	[data writeToFile:filepath atomically:YES];
	[[NSUserDefaults standardUserDefaults] setObject:filepath forKey:@"DownloadedListPath"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

//- (IBAction)AddAction:(id)sender {
//	AddViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
//	avc.delegate = self;
//	[[self navigationController] pushViewController:avc animated:YES];
//}
//
//-(void)addItemViewController:(AddViewController *)controller didFinishEntereingShow:(TVShow *)show withImage:(UIImage *)image{
//	NSLog(@"Added Show's : %@", show.Title);
//	[ShowList insertObject:show atIndex:[ShowList count]];
//	[self.tableView reloadData];
//}

#pragma mark - Tableview Editing Delegates

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
	if (isAlphabetical){
		return NO;
	}
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
	TVShow *showObjectToMove = [ShowList objectAtIndex:sourceIndexPath.row];
	[ShowList removeObjectAtIndex:sourceIndexPath.row];
	[ShowList insertObject:showObjectToMove atIndex:destinationIndexPath.row];
	
	NSMutableArray *array = [[NSMutableArray alloc] initWithArray:FullList];
	NSDictionary *toMove = [array objectAtIndex:sourceIndexPath.row];
	[array removeObjectAtIndex:sourceIndexPath.row];
	[array insertObject:toMove atIndex:destinationIndexPath.row];
	FullList = array;
	
	[self writeToDocuments];
}

 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	 if (self.searchDisplayController.isActive){
		 return NO;
	 }
	 // Selective Editing
//	 TVShow *show = [ShowList objectAtIndex:indexPath.row];
//	 if ([show.Title isEqualToString: @"Breaking Bad"] ||
//		 [show.Title isEqualToString: @"Firefly"] ||
//		 [show.Title isEqualToString: @"Game of Thrones"] ||
//		 [show.Title isEqualToString: @"House of Cards"] ||
//		 [show.Title isEqualToString: @"Doctor Who"] ||
//		 [show.Title isEqualToString: @"Sherlock"]) {
//		return NO;
//	 }
	 return YES;
 }

 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	 if (editingStyle == UITableViewCellEditingStyleDelete) {
		 [ShowList removeObjectAtIndex:indexPath.row];
		 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		 [self.tableView reloadData];
	 }
 }

- (NSString *)documentsPathForFileName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:name];
}

@end
