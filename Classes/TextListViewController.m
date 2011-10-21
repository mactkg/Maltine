//
//  SpecialViewController.m
//  Maltine
//
//  Created by viriviri on 11/07/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextListViewController.h"
#import "MaltineAppDelegate.h"

@implementation TextListViewController
@synthesize imageData;
@synthesize titleImageView;
@synthesize currentTextInfoDictionary;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[MaltineAppDelegate sharedDelegate].textList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[[[MaltineAppDelegate sharedDelegate].textList objectAtIndex:indexPath.row] objectForKey:@"Title"],
                                                                [[[MaltineAppDelegate sharedDelegate].textList objectAtIndex:indexPath.row] objectForKey:@"SubTitle"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@",[[[MaltineAppDelegate sharedDelegate].textList objectAtIndex:indexPath.row] objectForKey:@"Number"],
                                                                    [[[MaltineAppDelegate sharedDelegate].textList objectAtIndex:indexPath.row] objectForKey:@"Author"]];
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MaltineAppDelegate lock];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.imageData = [[[NSMutableData alloc] init] autorelease];
    self.currentTextInfoDictionary = [[MaltineAppDelegate sharedDelegate].textList objectAtIndex:indexPath.row];
    
    NSURLConnection* connection = [[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:
                                                                             [NSURL URLWithString:[self.currentTextInfoDictionary objectForKey:@"Image"]]]
                                                                   delegate:self]
                                   autorelease];
    [connection start];
    
}

#pragma mark - performSelector
- (void)executeAfterImageShow
{
    NSString* subTitleString = [NSString stringWithFormat:@"%@ を読む",[self.currentTextInfoDictionary objectForKey:@"SubTitle"]];
    
    UIActionSheet* actionSheet = [[[UIActionSheet alloc] initWithTitle:@"選択して下さい"
                                                              delegate:self
                                                     cancelButtonTitle:@"キャンセル"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:subTitleString, @"目次へ", nil] autorelease];
    [actionSheet showInView:self.titleImageView];
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WebReaderViewController* controller = [[[WebReaderViewController alloc] initWithNibName:@"WebReaderViewController" bundle:nil] autorelease];
    controller.textInfoDictionary = self.currentTextInfoDictionary;
    
    switch (buttonIndex) {
        case 0:
        {
            controller.loadIndex = NO;
            [self.navigationController pushViewController:controller animated:NO];
            
            break;
        }
        case 1:
        {
            controller.loadIndex = YES;
            [self.navigationController pushViewController:controller animated:NO];
            
            break;
        }
        case 2:
        {
            break;
        }
        default:
            break;
    }
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.titleImageView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self.titleImageView removeFromSuperview];
                     }
     ];
    
}

#pragma mark - NSURLConnectionDelegate, NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MaltineAppDelegate unlock];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.imageData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MaltineAppDelegate unlock];
    self.titleImageView.image = [UIImage imageWithData:self.imageData];
    self.titleImageView.alpha = 0;
    
    
    [[MaltineAppDelegate sharedDelegate].window addSubview:self.titleImageView];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.titleImageView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         [self performSelector:@selector(executeAfterImageShow) withObject:nil afterDelay:2];
                     }
     ];
}

@end
