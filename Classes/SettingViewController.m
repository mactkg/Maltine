//
//  SettingViewController.m
//  Maltine
//
//  Created by viriviri on 10/11/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"


@implementation SettingViewController

@synthesize twitterEngine;

#pragma mark -
#pragma mark button action

- (void)btnCancelClicked{
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)btnDoneClicked{

	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kCachedXAuthAccessTokenStringKey];

	connectingView.alpha = 0.5f;
	
	UITextField* usernameTextField =  (UITextField*)[self.view viewWithTag:1000];
	UITextField* passwordTextField =  (UITextField*)[self.view viewWithTag:1001];
	
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
	
	if (textField.tag == 1000) {
		[[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:kTwitterIdStringKey];
	}
	if (textField.tag == 1001) {
		[[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:kTwitterPasswordStringKey];
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
	connectingView.alpha = 0.0f;
	[self dismissModalViewControllerAnimated:YES];
}

- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username;
{
	NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedXAuthAccessTokenStringKey];	
	//NSLog(@"About to return access token string: %@", accessTokenString);	
	return accessTokenString;
}

- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error;
{
	NSLog(@"Error: %@", error);
	UIAlertViewQuick(@"エラー", @"Twitterのログインに失敗しました。", @"OK");
	connectingView.alpha = 0.0f;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Settings";
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						  target:self
																						  action:@selector(btnCancelClicked)];
	
	titles = [NSArray arrayWithObjects:@"username",@"password",nil];
	
	self.twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
	self.twitterEngine.consumerKey = kOAuthConsumerKey;
	self.twitterEngine.consumerSecret = kOAuthConsumerSecret;
	
	
	connectingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
	connectingView.backgroundColor = [UIColor blackColor];
	connectingView.alpha = 0.5f;
	connectingView.autoresizesSubviews = YES;
	
	UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[connectingView addSubview:indicatorView];
	[indicatorView release];
	indicatorView.center = connectingView.center;
	[indicatorView startAnimating];
	connectingView.alpha = 0.0f;
	
	[self.view addSubview:connectingView];
	[connectingView release];
	

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
			return @"Twitter Account";
			break;
	}
	return nil;
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{

	switch (section) {
		case 0:
			
			if ([self.twitterEngine isAuthorized]) {
				return @"Account is authorized.";
			}else {
				return @"Account is not authorized.";
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
    
    InputStringCell *cell = (InputStringCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[InputStringCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	[self configureInputStringCell:cell atIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}

- (void)configureInputStringCell:(InputStringCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
	cell.textField.tag = 1000 + indexPath.row;
	cell.label.text = [titles objectAtIndex:indexPath.row];
	cell.textField.keyboardType = UIKeyboardTypeAlphabet;
	cell.textField.delegate = self;
	switch (indexPath.row) {
		case 0:
			cell.textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kTwitterIdStringKey];
			cell.textField.returnKeyType = UIReturnKeyNext;
			break;
		case 1:			
			cell.textField.secureTextEntry = YES;
			cell.textField.returnKeyType = UIReturnKeyDone;
			cell.textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kTwitterPasswordStringKey];			
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

