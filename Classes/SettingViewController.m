//
//  SettingViewController.m
//  Maltine
//
//  Created by viriviri on 10/11/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "MaltineAppDelegate.h"

@implementation SettingViewController

@synthesize twitterEngine;
@synthesize titles;

#pragma mark -
#pragma mark button action

- (void)btnCancelClicked{
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)btnDoneClicked{

    [activeField resignFirstResponder];
    [MaltineAppDelegate lock];
    
	UITextField* usernameTextField =  (UITextField*)[self.view viewWithTag:1000];
	UITextField* passwordTextField =  (UITextField*)[self.view viewWithTag:1001];
    
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kCachedXAuthAccessTokenStringKey];

		
	NSString* username = usernameTextField.text;
	NSString* password = passwordTextField.text;
	[self.twitterEngine exchangeAccessTokenForUsername:username password:password];
}

#pragma mark -
#pragma mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{

	activeField = textField;
	
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
	
    if (textField.text != nil) {
        if (textField.tag == 1000) {
            [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:kTwitterIdStringKey];
        }
        if (textField.tag == 1001) {
            [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:kTwitterPasswordStringKey];
        }
    }
	
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{

	
	if (textField.tag == 1000) {
		UITextField* nextField = (UITextField*)[self.view viewWithTag:1001];
		[nextField becomeFirstResponder];
	}else {
		[self btnDoneClicked];
	}
	
	return YES;
	
}

#pragma mark -
#pragma mark twitter
- (void) storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username
{
	[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:kCachedXAuthAccessTokenStringKey];
	[MaltineAppDelegate unlock];
    UIAlertViewQuickDelegated(nil, NSLocalizedString(@"Succeeded in authorization.", nil), @"OK", self, 1);
}

- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username;
{
	NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedXAuthAccessTokenStringKey];	
	//NSLog(@"About to return access token string: %@", accessTokenString);	
	return accessTokenString;
}

- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error;
{
	[MaltineAppDelegate unlock];
    UIAlertViewQuickDelegated(NSLocalizedString(@"Error", nil), NSLocalizedString(@"Account authorization error.", nil), @"OK", self, -1);
	//UIAlertViewQuick(@"エラー", @"Twitterのログインに失敗しました。", @"OK");
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == -1) {
        [self.tableView reloadData];
    }
    
    if (alertView.tag == 1) {
        [self dismissModalViewControllerAnimated:YES];        
    }
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Settings",nil);
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						  target:self
																						  action:@selector(btnCancelClicked)] autorelease];
	
	self.titles = [NSArray arrayWithObjects:NSLocalizedString(@"username", nil),NSLocalizedString(@"password", nil),nil];
	
	self.twitterEngine = [[[XAuthTwitterEngine alloc] initXAuthWithDelegate:self] autorelease];
	self.twitterEngine.consumerKey = kOAuthConsumerKey;
	self.twitterEngine.consumerSecret = kOAuthConsumerSecret;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	switch (section) {
		case 0:
			return NSLocalizedString(@"Twitter Account", nil);
			break;
	}
	return nil;
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{

	switch (section) {
		case 0:
			
			if ([self.twitterEngine isAuthorized]) {
				return NSLocalizedString(@"Account is authorized.", nil);
			}else {
				return NSLocalizedString(@"Account is not authorized.", nil);
			}
			
			break;
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	[self configureInputStringCell:cell atIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}

- (void)configureInputStringCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    
    UITextField* field = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, cell.frame.size.height)] autorelease];
    field.textColor = [UIColor colorWithRed:59.0/255.0 green:85.0/255.0 blue:133.0/255.0 alpha:1.0];
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.textAlignment = UITextAlignmentLeft;
    field.delegate = self;
    field.tag = 1000 + indexPath.row;
    field.keyboardType = UIKeyboardTypeAlphabet;
    field.placeholder = [self.titles objectAtIndex:indexPath.row];
    
    cell.accessoryView = field;
	cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];

	switch (indexPath.row) {
		case 0:
			field.returnKeyType = UIReturnKeyNext;
			field.text = [[NSUserDefaults standardUserDefaults] stringForKey:kTwitterIdStringKey];
			break;
		case 1:			
			field.secureTextEntry = YES;
			field.returnKeyType = UIReturnKeyDone;
			field.text = [[NSUserDefaults standardUserDefaults] stringForKey:kTwitterPasswordStringKey];			
			break;
	}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

