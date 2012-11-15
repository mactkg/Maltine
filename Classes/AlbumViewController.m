//
//  AlbumViewController.m
//  Maltine
//
//  Created by viriviri on 10/08/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlbumViewController.h"
#import "PlayerViewController.h"

@implementation AlbumViewController
@synthesize albumInfo;
@synthesize playList;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
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
		
	}else{
        self.navigationItem.rightBarButtonItem = nil;
    }

    
    multiTitleView = [[MultilineTitleView alloc] init];
	multiTitleView.topText.text = [NSString stringWithFormat:@"[%@]", [self.albumInfo valueForKey:@"Number"]];
	multiTitleView.middleText.text = [self.albumInfo valueForKey:@"Title"];
	multiTitleView.bottomText.text = [self.albumInfo valueForKey:@"Artist"];
	self.navigationItem.titleView = multiTitleView;

    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        //landscape
        
        multiTitleView.frame = CGRectMake(0, 0, 220, 32);
        multiTitleView.topText.frame = CGRectMake(0, 0, 220, 13);
        multiTitleView.middleText.frame = CGRectMake(0, 9, 220, 16);
        multiTitleView.bottomText.frame = CGRectMake(0, 21, 220, 13);
        
    }else{
        //portrait
        multiTitleView.frame = CGRectMake(0, 0, 180, 40);
        multiTitleView.topText.frame = CGRectMake(0, 0, 180, 13);
        multiTitleView.middleText.frame = CGRectMake(0, 12, 180, 16);
        multiTitleView.bottomText.frame = CGRectMake(0, 27, 180, 13);
        
    }
	
}

#pragma mark -
#pragma mark button events
- (void) btnPlayingClicked{
	MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
	[self.navigationController pushViewController:delegate.player animated:YES];	
}

- (void) btnAddFavolitesClicked{
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
											   destructiveButtonTitle:nil
													otherButtonTitles:NSLocalizedString(@"Add to Favolites",nil),nil];
	
	[actionSheet showInView:self.tabBarController.view];
	
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	//add to favolites
	if (buttonIndex == 0) {
		
		MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];

		for (int i = 0; i < [self.playList count]; i++) {
			[delegate.favoliteList addObject:[self.playList objectAtIndex:i]];
		}
		
	}
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
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        //landscpae
        multiTitleView.frame = CGRectMake(0, 0, 220, 32);
        multiTitleView.topText.frame = CGRectMake(0, 0, 220, 13);
        multiTitleView.middleText.frame = CGRectMake(0, 9, 220, 16);
        multiTitleView.bottomText.frame = CGRectMake(0, 21, 220, 13);

    }else{
        //portrait
        multiTitleView.frame = CGRectMake(0, 0, 180, 40);
        multiTitleView.topText.frame = CGRectMake(0, 0, 180, 13);
        multiTitleView.middleText.frame = CGRectMake(0, 12, 180, 16);
        multiTitleView.bottomText.frame = CGRectMake(0, 27, 180, 13);
        
    }

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 1) {
		return [playList count];
	}else {
		return 1;
	}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *CellIdentifier = @"TrackCell";
	static NSString *AlbumCellIdentifier = @"AlbumCell";	
	NSString *CellIdentifier = [NSString stringWithFormat:@"TrackCell_%d_%d",indexPath.section,indexPath.row];
	
	if (indexPath.section == 0 && indexPath.row == 0) {
		UIViewController *controller = [[UIViewController alloc] initWithNibName:@"AlbumTableViewCell" bundle:nil];
		
		AlbumTableViewCell *cell = (AlbumTableViewCell*)[tableView dequeueReusableCellWithIdentifier:AlbumCellIdentifier];
		if (cell == nil) {
			cell = (AlbumTableViewCell*)controller.view;
			cell.lblMaru.text = [NSString stringWithFormat:@"[%@]", [self.albumInfo valueForKey:@"Number"]];
			cell.lblAlbumTitle.text = [self.albumInfo valueForKey:@"Title"];
			cell.lblAlbumArtist.text = [self.albumInfo valueForKey:@"Artist"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[cell.albumImage loadImage:[self.albumInfo valueForKey:@"Image"]];
			[cell.btnAddFavolites addTarget:self action:@selector(btnAddFavolitesClicked) forControlEvents:UIControlEventTouchUpInside];
		}
		return cell;
		

	}else {
		if (indexPath.section == 1) {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
				cell.textLabel.text = [[self.playList objectAtIndex:indexPath.row] valueForKey:@"Title"];
				cell.detailTextLabel.text = [[self.playList objectAtIndex:indexPath.row] valueForKey:@"Artist"];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				
			}
			return cell;
		}
	}
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

	if (indexPath.section == 0 && indexPath.row == 0) {
		return 132.0;
	}
    return 44.0;
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

	if (indexPath.section == 1) {
		MaltineAppDelegate* delegate = (MaltineAppDelegate*)[[UIApplication sharedApplication]delegate];
		
		delegate.player.playList = self.playList;
		delegate.player.trackKey = indexPath.row;
        delegate.player.currentPlayerType = AlbumPlayer;
		delegate.player.stopPlayerWhenViewWillAppear = YES;
		delegate.player.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:delegate.player animated:YES];
	}
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




@end

