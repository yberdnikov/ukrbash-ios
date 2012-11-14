//
//  QuoteViewCell.h
//  ukrbash
//
//  Created by Yuriy Berdnikov on 11/14/12.
//
//

#import <UIKit/UIKit.h>

@interface QuoteViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *quoteID;
@property(nonatomic, weak) IBOutlet UILabel *quoteText;

@end
