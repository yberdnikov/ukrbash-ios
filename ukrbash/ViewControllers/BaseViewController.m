//
//  BaseViewController.m
//  ukrbash
//
//  Created by Yuriy Berdnikov on 12/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "Constants.h"
#import "Quote.h"

@implementation BaseViewController

@synthesize data;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _reloadingTableView = NO;
    }
    return self;
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

    if (_refreshHeaderView == nil) {
        CGRect frame = CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height,
                                  self.view.frame.size.width,
                                  self.tableView.bounds.size.height);
        
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc]
                                           initWithFrame:frame];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadObjectsFromDataStore];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _refreshHeaderView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        cell.textLabel.numberOfLines = 0;
    }
    
    // Configure the cell...
    Quote *quote = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = quote.text;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
	CGSize labelSize = [[[self.data objectAtIndex:indexPath.row] text] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:14] constrainedToSize:constraintSize];
    
	return labelSize.height;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)reloadTableViewDataSource
{
    [self loadData];
}

- (void)doneLoadingTableViewData
{	
	//  model should call this when its done loading
	_reloadingTableView = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{		
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];	
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{	
	_reloadingTableView = YES;
    
    [self reloadTableViewDataSource];
    
    [self performSelector:@selector(doneLoadingTableViewData)
               withObject:nil
               afterDelay:REFRESH_TABLE_DELAY];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{	
	return _reloadingTableView; // should return if data source model is reloading	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{	
	return [NSDate date]; // should return date data source was last changed	
}

- (void)loadObjectsFromDataStore
{
    NSFetchRequest *request = [Quote fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kind like %@", self.quoteFilterType];
    [request setPredicate:predicate];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"pub_date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    self.data = [Quote objectsWithFetchRequest:request];
}

- (void)loadData
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?client=0d940253d19a2fdc", self.resourcePath] delegate:self];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Hit error: %@", error);
}


@end
