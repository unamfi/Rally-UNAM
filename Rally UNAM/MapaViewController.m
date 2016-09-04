//
//  MapaViewController.m
//  Rally UNAM
//
//  Created by Oscar Belman on 11/28/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import "MapaViewController.h"
#import "SharedData.h"
#import <CoreLocation/CoreLocation.h>
#import "InputViewController.h"

@interface MapaViewController ()
{
    CLLocationManager *locationManager;
    NSTimeInterval timeInterval;
}
@end

@implementation MapaViewController

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
    // Do any additional setup after loading the view.
    
    //SetupMap
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 100, 100);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    
    
    //Aventura
    NSDictionary *adventure = [[[[SharedData getSharedJSONDictionary]  objectForKey:@"result"] objectForKey:@"adventure"] objectAtIndex:_indexPath.row];
    
    //SetupLabel
     NSString *name = [adventure objectForKey:@"name"];
    _nameLabel.text = name;
    
    
    //Run Chronometer
    self.startDate = [NSDate date];
    
    // Create the stop watch timer that fires every 100 ms
    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                           target:self
                                                         selector:@selector(updateTimer)
                                                         userInfo:nil
                                                          repeats:YES];

    //Start Updating Location.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
}

- (void)updateTimer
{
    // Create date from the elapsed time
    NSDate *currentDate = [NSDate date];
    timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    // Format the elapsed time and set it to the label
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    self.stopwatchLabel.text = timeString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map View

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

#pragma mark - DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:101];

    //Aventura
    NSDictionary *adventure = [[[[SharedData getSharedJSONDictionary]  objectForKey:@"result"] objectForKey:@"adventure"] objectAtIndex:_indexPath.row];
    NSArray *pois = [[adventure objectForKey:@"pois"] objectForKey:@"poi"];
    
    
    //Muestra Pista
    if (indexPath.row < [pois count])
    {
        NSString *clue = [[pois objectAtIndex:indexPath.row] objectForKey:@"clue"];
        label.text = clue;
        
        int wallpapernumber = indexPath.row % 2  + 1;
        NSString *wallpapernumberString = [NSString stringWithFormat:@"%d", wallpapernumber];
        NSString *imageName = [[@"background" stringByAppendingString:wallpapernumberString] stringByAppendingString:@".jpg"];
        
        imageView.image = [UIImage imageNamed:imageName];
        
    }
    //Muestra Mensaje
    else
    {
        UILabel *label = (UILabel *)[cell viewWithTag:100];
        label.text = @"¡Felicidades haz terminado el Rally!";
        imageView.image = [UIImage imageNamed:@"background3.jpg"];
        [[cell viewWithTag:300] setAlpha:0.0];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *adventure = [[[[SharedData getSharedJSONDictionary]  objectForKey:@"result"] objectForKey:@"adventure"] objectAtIndex:_indexPath.row];
    NSArray *pois = [[adventure objectForKey:@"pois"] objectForKey:@"poi"];
    return [pois count] + 1;
}

#pragma mark - Actions

- (IBAction)buttonAction:(id)sender
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        //Show a UIAlertView with whatever message
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Ooops!"
                                                        message: @"Necesito que me des permisos de localización."
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIButton *button = (UIButton *)sender;
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSDictionary *adventure = [[[[SharedData getSharedJSONDictionary]  objectForKey:@"result"] objectForKey:@"adventure"] objectAtIndex:_indexPath.row];
    NSArray *pois = [[adventure objectForKey:@"pois"] objectForKey:@"poi"];
    
    //Si me encuentro cerca del rally y no soy el fin
    if (indexPath.row < [pois count])
    {
        NSDictionary *poi = [pois objectAtIndex:indexPath.row];
        NSLog(@"poi %@", poi );
        
         
         float distancia_en_metros = [locationManager.location distanceFromLocation:[[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake([[poi objectForKey:@"lat"] doubleValue],
         [[poi objectForKey:@"long"] doubleValue])
         altitude:0.0
         horizontalAccuracy:0.0
         verticalAccuracy:0.0
         course:0.0
         speed:0.0
         timestamp:nil]];
         
        /*
        float distancia_en_metros = [locationManager.location distanceFromLocation:[[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude)
                                                                                                                 altitude:0.0
                                                                                                       horizontalAccuracy:0.0
                                                                                                         verticalAccuracy:0.0
                                                                                                                   course:0.0
                                                                                                                    speed:0.0
                                                                                                                timestamp:nil]];
        */
        if (distancia_en_metros > 100)
        {
            NSLog(@"Te encuentras muy lejos");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Frio"
                                                            message: @"Aún te encuentras muy lejos de la solución"
                                                           delegate: nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        if (distancia_en_metros > 10 && distancia_en_metros <= 100)
        {
            NSLog(@"Te encuentras muy cerca");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Caliente"
                                                            message: @"¡Te encuentras muy cerca!"
                                                           delegate: nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        if (distancia_en_metros <= 10)
        {
            [_tableView setContentOffset:CGPointMake(0.0, _tableView.contentOffset.y + 202) animated:YES];
            if (indexPath.row == [pois count] - 1) {
                [self.stopWatchTimer invalidate];
                self.stopWatchTimer = nil;
                [self updateTimer];
            }
        }
    }
    // Fin del rally.
    else
    {
        NSLog(@"Rally terminado");

    
        //load nsstring with name
        NSDictionary *adventure = [[[[SharedData getSharedJSONDictionary]  objectForKey:@"result"] objectForKey:@"adventure"] objectAtIndex:_indexPath.row];
        NSString *name = [adventure objectForKey:@"name"];
        
        //borrar tdodo
        //[SharedData removeData:name];
        //
        NSArray *mejoresTiempos = [SharedData loadData:name];
        if (mejoresTiempos != nil)
        {
            NSLog(@"tiempo %f", timeInterval);
            if([mejoresTiempos count] < 5)
            {
                [self performSegueWithIdentifier:@"Input" sender:@[name, [NSNumber numberWithDouble:timeInterval]]];
                return;
            }
            for (NSArray *array in mejoresTiempos)
            {
                if (timeInterval < [[array objectAtIndex:1] doubleValue])
                {
                    //segue para pedir datos
                    [self performSegueWithIdentifier:@"Input" sender:@[name, [NSNumber numberWithDouble:timeInterval]]];
                    return;
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [SharedData saveData:[[NSMutableArray alloc] init] name:name];
            [self performSegueWithIdentifier:@"Input" sender:@[name, [NSNumber numberWithDouble:timeInterval]]];
        }
        
    }
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Input"])
    {
        NSArray *array = (NSArray *)sender;
        InputViewController *inputViewController = segue.destinationViewController;
        [inputViewController setName:[array objectAtIndex:0]];
        [inputViewController setTime:[array objectAtIndex:1]];
    }
}

@end
