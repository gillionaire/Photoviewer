//
//  ListViewController.h
//  Photoviewer
//
//  Created by Group10 on 11/23/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *photos;

@property (nonatomic, copy) void (^dataBlock)(NSData *data, NSURLResponse *response, NSError *error);

@end
