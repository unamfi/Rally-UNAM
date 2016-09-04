//
//  AventurasViewController.h
//  Rally UNAM
//
//  Created by Oscar Belman on 11/26/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AventurasViewController : UIViewController <NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImageView;
@property (strong, nonatomic) IBOutlet UILabel *tutorialLabel;
@property (strong, nonatomic) IBOutlet UILabel *interwebsLabel;

@end
