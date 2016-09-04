//
//  MapaViewController.h
//  Rally UNAM
//
//  Created by Oscar Belman on 11/28/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapaViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *stopwatchLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) NSDate *startDate;


- (IBAction)buttonAction:(id)sender;
- (IBAction)back:(id)sender;

@end