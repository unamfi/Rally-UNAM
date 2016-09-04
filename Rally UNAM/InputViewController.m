//
//  InputViewController.m
//  Rally UNAM
//
//  Created by Oscar Belman on 11/28/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import "InputViewController.h"
#import "SharedData.h"
@interface InputViewController ()

@end

@implementation InputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_textField becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePlayerName:(id)sender
{
    NSString *playerName = _textField.text;
    NSArray *selfArray = @[playerName, _time];
    NSMutableArray *list = [SharedData loadData:_name];
    [list addObject:selfArray];
    [list sortUsingComparator: ^(id a, id b) {
        if ( [[a objectAtIndex:1] doubleValue] < [[b objectAtIndex:1] doubleValue])
        {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( [[a objectAtIndex:1] doubleValue] > [[b objectAtIndex:1] doubleValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    int rangelimit = 5;
    if(rangelimit > list.count)
    {
        rangelimit = (int)list.count;
    }
    if (list.count > 5) {
        rangelimit = 5;
    }
    list = (NSMutableArray *)[list subarrayWithRange:NSMakeRange(0, rangelimit)];
    [SharedData saveData:list name:_name];
    
    NSLog(@"list %@", list);
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
