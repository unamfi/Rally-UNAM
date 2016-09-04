//
//  AventuraViewController.h
//  Rally UNAM
//
//  Created by Oscar Belman on 11/27/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AventuraViewController : UIViewController

@property(nonatomic, retain) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
- (IBAction)pushMapa:(id)sender;
- (IBAction)pushMejoresTiempos:(id)sender;
- (IBAction)back:(id)sender;

@end
