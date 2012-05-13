//
//  NetworkProvider.m
//  ukrbash
//
//  Created by Yuriy Berdnikov on 12/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkProvider.h"
#import "Constants.h"

@implementation NetworkProvider

- (void)createConnection:(NSMutableURLRequest *)request requestName:(NSString *)name userInfo:(NSDictionary *)userInfo
{
    LogInfo(@"Create connection for name %@", name);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSError *jsonError= nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (jsonError)
        { 
            //TODO: handle error
            LogError(@"Error... %@", [jsonError localizedDescription]);
        }
        LogTrace(@"JSON: %@", json);                                                                       
    }];
}

- (NSString *)getRequestNameForCategory:(QuotesCategory)category
{
    switch (category) {
        case LatestQuotesCategory:
            return HTTP_REQUEST_LATEST_QUOTES;
        case NotPublishedQuotesCategory:
            return HTTP_REQUEST_NOT_PULBISHED_QUOTES;
        case BestQuotesCategory:
            return HTTP_REQUEST_BEST_QUOTES;
        default:
            LogError(@"Unknown quotes category %d", category);
            return nil;
    }
}

- (void)requestQuotes:(QuotesCategory)category
{
    //TODO:
    NSString *url = [NSString stringWithFormat:UKRBASH_HTTP_REQUEST_URL,
                     [self getRequestNameForCategory:category], CLIENT_KEY, 50];
    LogTrace(@"Request URL - %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self createConnection:request requestName:nil userInfo:nil];
}

@end
