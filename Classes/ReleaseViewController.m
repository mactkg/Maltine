//
//  ReleaseViewController.m
//  Maltine
//
//  Created by viriviri on 10/08/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ReleaseViewController.h"
#define MAL_LIST_RELEASE 0
#define MAL_SEARCH_ALBUM 1
#define MAL_SEARCH_MUSIC 2

@implementation ReleaseViewController
@synthesize releaseList, filteredReleaseList, allMusicList, savedSearchTerm, savedScopeButtonIndex, searchWasActive;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.releaseList = [MaltineAppDelegate sharedDelegate].releaseList;
	self.allMusicList = [[[NSMutableArray alloc] init] autorelease];
	
	for (NSDictionary* album in self.releaseList) {
		for (NSDictionary* track in [album objectForKey:@"PlayList"]) {
			[self.allMusicList addObject:track];
		}
	}
	
	if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:self.savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
	
	
	UIBarButtonItem* btnShuffle = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ipod_shuffle_right_white.png"]
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(btnShuffleClicked)];
	self.navigationItem.leftBarButtonItem = btnShuffle;
	[btnShuffle release];
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];	
	if (![delegate.player isTextPlayer] && [delegate.player.streamer isPlaying]) {
		UIBarButtonItem* btnPlaying = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Now Playing",nil)
																	   style:UIBarButtonItemStyleBordered
																	  target:self
																	  action:@selector(btnPlayingClicked)];			
		self.navigationItem.rightBarButtonItem = btnPlaying;		
		[btnPlaying release];
		
	}
	[self.tableView reloadData];
	
}

#pragma mark -
#pragma mark button events
- (void) btnPlayingClicked{
	
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
	[self.navigationController pushViewController:delegate.player animated:YES];	
	
}

-(void) btnShuffleClicked{
	
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.player.currentPlayerType = ShufflePlayer;
	delegate.player.stopPlayerWhenViewWillAppear = YES;
	delegate.player.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:delegate.player animated:YES];
	
}

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


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
	
}

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
	if (self.searchDisplayController.active){
		return [self.filteredReleaseList count];		
	}else {
		return [self.releaseList count];
	}


}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

	NSArray* targetList;

	if (self.searchDisplayController.active) {
		targetList = self.filteredReleaseList;
	}else {
		targetList = self.releaseList;
	}	

	NSString *CellIdentifier = [NSString stringWithFormat:@"ReleaseCell_%d_%d_%d",self.searchDisplayController.active,self.searchDisplayController.searchBar.selectedScopeButtonIndex,indexPath.row];

	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	
        if (!self.searchDisplayController.active||(self.searchDisplayController.active && self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0)) {
			//dummyを置かないと画像分の枠を用意してくれない
			cell.imageView.image = [UIImage imageNamed:@"dummy.png"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

			UIAsyncImageView* albumImageView = [[UIAsyncImageView alloc] initWithFrame:CGRectMake(4, 1, 39, 39)];
			albumImageView.layer.masksToBounds = YES;
			albumImageView.layer.cornerRadius = 8.0f;
			
			[cell.imageView addSubview:albumImageView];	
			[albumImageView release];
			
			if (!self.searchDisplayController.active) {
				[self loadImageForCell:cell indexPath:indexPath];
			}
		}
	}

	if (!self.searchDisplayController.active||(self.searchDisplayController.active && self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0)) {
		NSString* albumNumber = [[[targetList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"] valueForKey:@"Number"];
		NSString* albumTitle =  [[[targetList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"] valueForKey:@"Title"];
		NSString* albumArtist = [[[targetList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"] valueForKey:@"Artist"];
		
		cell.textLabel.text = [NSString stringWithFormat:@"%@", albumTitle];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@", albumNumber,albumArtist];
		
		if (self.searchDisplayController.active && self.searchDisplayController.searchBar.selectedScopeButtonIndex == 0) {
			[self loadImageForCell:cell indexPath:indexPath];
		}
	}else {
		//MAL_SEARCH_MUSIC
		cell.textLabel.text = [[targetList objectAtIndex:indexPath.row] valueForKey:@"Title"];
		cell.detailTextLabel.text = [[targetList objectAtIndex:indexPath.row] valueForKey:@"Artist"];
	}


	
    return cell;
}

- (void)loadImageForCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath{

	NSArray* targetList;
	if (self.searchDisplayController.active) {
		targetList = self.filteredReleaseList;
	}else {
		targetList = self.releaseList;
	}
	
	for (UIView* subView in [cell.imageView subviews]) {
		if ([subView class] == [UIAsyncImageView class]) {
			[(UIAsyncImageView*)subView loadImage:[[[targetList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"] valueForKey:@"Image"]];
		}
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
	
	
	if (self.searchDisplayController.active && self.searchDisplayController.searchBar.selectedScopeButtonIndex == 1) {
		PlayerViewController* player = [MaltineAppDelegate sharedDelegate].player;
        player.currentPlayerType = SearchPlayer;
		player.stopPlayerWhenViewWillAppear = YES;
		player.playList = [NSArray arrayWithArray:self.filteredReleaseList];
		player.trackKey = indexPath.row;
		[self.navigationController pushViewController:player animated:YES];
		
	}else {
		AlbumViewController *controller = [[[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil] autorelease];
		
		if (self.searchDisplayController.active){
			//AlbumInfo
			controller.albumInfo = [[[self.filteredReleaseList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"] mutableCopy];
			//PlayList
			controller.playList = [[[self.filteredReleaseList objectAtIndex:indexPath.row] valueForKey:@"PlayList"] mutableCopy];
			
		}else {
			//AlbumInfo
			controller.albumInfo = [[[self.releaseList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"] mutableCopy];
			//PlayList
			controller.playList = [[[self.releaseList objectAtIndex:indexPath.row] valueForKey:@"PlayList"] mutableCopy];
		}
		
		
		[self.navigationController pushViewController:controller animated:YES];
	}
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{	
	
	[self.filteredReleaseList removeAllObjects]; // First clear the filtered array.
	
	switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
		case 0:
		{
			NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(AlbumInfo.Title CONTAINS[cd] %@) OR (AlbumInfo.Artist CONTAINS[cd] %@)",searchText,searchText];
			self.filteredReleaseList = [NSMutableArray arrayWithArray:[self.releaseList filteredArrayUsingPredicate:predicate]];
			break;
		}
		case 1:
		{
			NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(Title CONTAINS[cd] %@) OR (Artist CONTAINS[cd] %@)",searchText,searchText];
			self.filteredReleaseList = [NSMutableArray arrayWithArray:[self.allMusicList filteredArrayUsingPredicate:predicate]];			
			break;
		}
	}	
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
 
    self.filteredReleaseList = nil;
    [self.tableView reloadData];
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
	self.filteredReleaseList = nil;
}


- (void)dealloc {
    [super dealloc];
	[releaseList release];
	[filteredReleaseList release];
}


@end

