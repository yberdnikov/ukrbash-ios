//
//  NetworkProvider.h
//  ukrbash
//
//  Created by Yuriy Berdnikov on 12/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkProvider : NSObject

- (void)requestLatestQuotes;
- (void)requestBestQuotes;
- (void)requestNotPublishedQuotes;

@end
