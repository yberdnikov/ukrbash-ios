//
//  Quote.h
//  ukrbash
//
//  Created by Yuriy Berdnikov on 21/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Quote : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * add_date;
@property (nonatomic, retain) NSDate * pub_date;
@property (nonatomic, retain) NSNumber * author_id;
@property (nonatomic, retain) NSNumber * rating;

@end
