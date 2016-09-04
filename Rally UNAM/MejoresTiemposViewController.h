//
//  MejoresTiemposViewController.h
//  Rally UNAM
//
//  Created by Oscar Belman on 11/28/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MejoresTiemposViewController : UIViewController

@property(nonatomic, retain) NSIndexPath *indexPath;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameCollection;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *timeCollection;
- (IBAction)back:(id)sender;

@end
