//
//  BaseViewController.h
//  ukrbash
//
//  Created by Yuriy Berdnikov on 12/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface BaseViewController : UITableViewController <EGORefreshTableHeaderDelegate,
UITableViewDataSource, UITableViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloadingTableView;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
