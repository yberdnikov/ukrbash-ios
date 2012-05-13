//
//  NetworkProvider.h
//  ukrbash
//
//  Created by Yuriy Berdnikov on 12/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UnknownQuotesCategory = 0,
    LatestQuotesCategory,
    BestQuotesCategory,
    NotPublishedQuotesCategory
} QuotesCategory;

@interface NetworkProvider : NSObject

- (void)requestQuotes:(QuotesCategory)category;

@end
