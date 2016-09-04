//
//  AventuraViewController.m
//  Rally UNAM
//
//  Created by Oscar Belman on 11/27/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import "AventuraViewController.h"
#import "SharedData.h"

#import "MapaViewController.h"
#import "MejoresTiemposViewController.h"

@interface AventuraViewController ()

@end

@implementation AventuraViewController

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
    NSString *description = [adventure objectForKey:@"desc"];
    _titleLabel.text = name;
    _descriptionTextView.text = description;
    [_descriptionTextView setSelectable:NO];
    NSLog(@"Aventura %@", adventure);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushMapa:(id)sender
{
    [self performSegueWithIdentifier:@"Mapa" sender:self.indexPath];
}

- (IBAction)pushMejoresTiempos:(id)sender {
    [self performSegueWithIdentifier:@"MejoresTiempos" sender:self.indexPath];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    if([segue.identifier isEqual: @"Mapa"])
    {
        MapaViewController *mapaViewController = (MapaViewController *)segue.destinationViewController;
        [mapaViewController setIndexPath:indexPath];
    }
    if([segue.identifier isEqual: @"MejoresTiempos"])
    {
        MejoresTiemposViewController *mejorestiemposViewController = (MejoresTiemposViewController *)segue.destinationViewController;
        [mejorestiemposViewController setIndexPath:indexPath];
    }
}
@end
