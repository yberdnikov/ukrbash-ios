//
//  BaseViewController.h
//  ukrbash
//
//  Created by Yuriy Berdnikov on 12/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "EGORefreshTableHeaderView.h"
#import "Quote.h"

@interface BaseViewController : UITableViewController <EGORefreshTableHeaderDelegate,
UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloadingTableView;
}

@property(nonatomic, copy) NSArray *data;
@property(nonatomic, copy) NSString *resourcePath;
@property(nonatomic, copy) NSString *quoteFilterType;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)loadObjectsFromDataStore;
- (void)loadData;
- (void)reloadTableViewDataSource;

@end
