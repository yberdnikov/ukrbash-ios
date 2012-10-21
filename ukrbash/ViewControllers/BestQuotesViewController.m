//
//  BestQuotesViewController.m
//  ukrbash
//
//  Created by Yuriy Berdnikov on 12/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BestQuotesViewController.h"
#import "Quote.h"

@interface BestQuotesViewController ()

- (void)loadObjectsFromDataStore;

@end

@implementation BestQuotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadObjectsFromDataStore];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadObjectsFromDataStore
{
    NSFetchRequest *request = [Quote fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"pub_date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    self.data = [Quote objectsWithFetchRequest:request];
}

- (void)loadData
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/quotes.getPublished.json?client=0d940253d19a2fdc" delegate:self];
}

- (void)reloadTableViewDataSource
{
    [self loadData];   
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"Loaded statuses: %@", objects);
    [self loadObjectsFromDataStore];
    [self.tableView reloadData];
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
