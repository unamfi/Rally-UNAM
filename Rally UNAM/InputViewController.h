//
//  InputViewController.h
//  Rally UNAM
//
//  Created by Oscar Belman on 11/28/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSNumber *time;
- (IBAction)savePlayerName:(id)sender;

@end
