//
//  Quote.h
//  ukrbash
//
//  Created by Yuriy Berdnikov on 11/2/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Quote : NSManagedObject

@property (nonatomic, retain) NSDate * add_date;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * author_id;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * pub_date;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * kind;

@end
