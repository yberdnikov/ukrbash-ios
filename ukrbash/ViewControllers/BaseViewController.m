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
#import "QuoteViewCell.h"

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
    
    self.tableView.sectionHeaderHeight = 10.0f;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QuoteCellView" bundle:nil] forCellReuseIdentifier:@"QuoteCell"];
    
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
    [self reloadTableViewDataSource];
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

- (UIView *)tableView:(UITableView *)tbl viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tbl.bounds.size.width, 10)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuoteCell";
    QuoteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[QuoteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Quote *quote = [data objectAtIndex:indexPath.section];
    
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize textSize = [quote.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f] constrainedToSize:constraintSize];
    CGSize idSize = [quote.id.stringValue sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f] constrainedToSize:constraintSize];
    
    cell.quoteText.frame = CGRectMake(cell.quoteText.frame.origin.x, cell.quoteText.frame.origin.y, textSize.width, textSize.height);
    cell.quoteText.text = quote.text;
    
    cell.quoteID.frame = CGRectMake(280 - idSize.width, CGRectGetMaxY(cell.quoteText.frame), idSize.width, idSize.height);
    cell.quoteID.text = quote.id.stringValue;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    Quote *quote = [data objectAtIndex:indexPath.section];
    
	CGSize textSize = [quote.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f] constrainedToSize:constraintSize];
    CGSize idSize = [quote.id.stringValue sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f] constrainedToSize:constraintSize];
    
	return textSize.height + idSize.height;
}

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
