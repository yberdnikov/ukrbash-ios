//
//  Quote.h
//  ukrbash
//
//  Created by Yuriy Berdnikov on 12/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Quote : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * pubDate;
@property (nonatomic, retain) NSString * text;

@end
