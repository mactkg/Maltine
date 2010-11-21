//
//  ReleaseViewController.m
//  Maltine
//
//  Created by viriviri on 10/08/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ReleaseViewController.h"


@implementation ReleaseViewController
@synthesize releaseList;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
	self.releaseList = delegate.releaseList;

	UIBarButtonItem* btnShuffle = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Shuffle",nil)
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(btnShuffleClicked)];			
	self.navigationItem.leftBarButtonItem = btnShuffle;		
	[btnShuffle release];
	
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

#pragma mark -
#pragma mark button events
- (void) btnPlayingClicked{
	
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
	[self.navigationController pushViewController:delegate.player animated:YES];	
	
}

-(void) btnShuffleClicked{
	
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
	delegate.player.isShufflePlayer = YES;
	delegate.player.isFavolitesPlayer = NO;
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
    return [releaseList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *CellIdentifier = @"ReleaseCell";
	NSString *CellIdentifier = [NSString stringWithFormat:@"ReleaseCell_%d_%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		NSString* albumNumber = [[[releaseList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"] valueForKey:@"Number"];
		NSString* albumTitle = [[[releaseList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"] valueForKey:@"Title"];
		NSString* albumArtist = [[[releaseList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"] valueForKey:@"Artist"];
		
		cell.textLabel.text = [NSString stringWithFormat:@"[%@] %@", albumNumber, albumTitle];
		cell.detailTextLabel.text = albumArtist;
				
		//dummyを置かないと画像分の枠を用意してくれない
		cell.imageView.image = [UIImage imageNamed:@"dummy.png"];

		CGRect frame;
		frame.size.width = 39;
		frame.size.height = 39;
		frame.origin.x = 4;
		frame.origin.y = 1;		
		UIAsyncImageView* albumImageView = [[UIAsyncImageView alloc] initWithFrame:frame];
		[albumImageView loadImage:[[[releaseList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"] valueForKey:@"Image"]];

		CALayer *layer = albumImageView.layer;
		layer.masksToBounds = YES;
		layer.cornerRadius = 8.0f;
		
		
		[cell.imageView addSubview:albumImageView];
		
		[albumImageView release];
		
    }
    
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
	
	AlbumViewController *controller = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
	
	//AlbumInfo
	controller.albumInfo = [[releaseList objectAtIndex:indexPath.row] valueForKey:@"AlbumInfo"];
	
	//PlayList
	controller.playList = [[releaseList objectAtIndex:indexPath.row] valueForKey:@"PlayList"];
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	
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

