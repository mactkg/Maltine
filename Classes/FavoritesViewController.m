//
//  FavoritesViewController.m
//  Maltine
//
//  Created by viriviri on 10/08/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"


@implementation FavoritesViewController
//@synthesize isReload;
//@synthesize playList;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	//self.isReload = NO;

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	[self.tableView reloadData];

	
	//NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	//self.playList = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favolites"]];
	//self.playList = delegate.favoliteList;
	
	//[self.tableView reloadData];

	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];	
	
	if ([delegate.player.streamer isPlaying]) {
		UIBarButtonItem* btnPlaying = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Now Playing",nil)
																	   style:UIBarButtonItemStyleBordered
																	  target:self
																	  action:@selector(btnPlayingClicked)];			
		self.navigationItem.rightBarButtonItem = btnPlaying;		
		[btnPlaying release];
		
	}
	
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void) btnPlayingClicked{

	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
	[self.navigationController pushViewController:delegate.player animated:YES];	

}

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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
	return [delegate.favoliteList count];
    //return [self.playList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *CellIdentifier = @"FavolitesCell";
    
	NSString *CellIdentifier = [NSString stringWithFormat:@"FavolitesCell_%d_%d",indexPath.section,indexPath.row];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	//削除や並び替えを即時反映させるためにセルを再利用しないで必ず作り直す
    //if (cell == nil) {
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];	

	cell.textLabel.text = [[delegate.favoliteList objectAtIndex:indexPath.row] valueForKey:@"Title"];
	cell.detailTextLabel.text = [[delegate.favoliteList objectAtIndex:indexPath.row] valueForKey:@"Artist"];

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	//NSLog(@"rowsCount:%d indexpath.row:%d Title:%@",[delegate.favoliteList count],indexPath.row,[[delegate.favoliteList objectAtIndex:indexPath.row] valueForKey:@"Title"]);
    //}
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source

		//[self.playList removeObjectAtIndex:indexPath.row];
		MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];	
		[delegate.favoliteList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

		//NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		//[defaults setObject:delegate.favoliteList forKey:@"favolites"];
		//[defaults setObject:self.playList forKey:@"favolites"];
		//[defaults synchronize];
		
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];	

	if (fromIndexPath.section == toIndexPath.section) {
		if (toIndexPath.row < [delegate.favoliteList count]) {
			id item = [[delegate.favoliteList objectAtIndex:fromIndexPath.row] retain];
			[delegate.favoliteList removeObject:item];
			[delegate.favoliteList insertObject:item atIndex:toIndexPath.row];
			[item release];
			//favolitesに保存
			//NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
			//[defaults setObject:delegate.favoliteList forKey:@"favolites"];
			//[defaults synchronize];
			
		}
	}
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
	delegate.player.trackKey = indexPath.row;
	delegate.player.playList = delegate.favoliteList;
	delegate.player.isFavolitesPlayer = YES;
	delegate.player.stopPlayerWhenViewWillAppear = YES;
	delegate.player.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:delegate.player animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

