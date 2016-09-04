//
//  MejoresTiemposViewController.m
//  Rally UNAM
//
//  Created by Oscar Belman on 11/28/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import "MejoresTiemposViewController.h"
#import "SharedData.h"
@interface MejoresTiemposViewController ()

@end

@implementation MejoresTiemposViewController

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
    
    NSDictionary *adventure = [[[[SharedData getSharedJSONDictionary]  objectForKey:@"result"] objectForKey:@"adventure"] objectAtIndex:_indexPath.row];
    NSString *name = [adventure objectForKey:@"name"];
    NSArray *array = [SharedData loadData:name];
    for (int i = 0 ; i < array.count; i++ )
    {
        NSString *nombre = [[array objectAtIndex:i] objectAtIndex:0];
        NSNumber *number = [[array objectAtIndex:i] objectAtIndex:1];
        [((UILabel *)[_nameCollection objectAtIndex:i]) setText:nombre];
        
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:[number floatValue]];
        
        // Create a date formatter
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        
        // Format the elapsed time and set it to the label
        NSString *timeString = [dateFormatter stringFromDate:timerDate];
        [((UILabel *)[_timeCollection objectAtIndex:i]) setText:timeString];
        
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
