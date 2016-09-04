//
//  AventurasViewController.m
//  Rally UNAM
//
//  Created by Oscar Belman on 11/26/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import "AventurasViewController.h"
#import "JSONDictionaryExtensions.h"
#import "SharedData.h"
#import "UIImage+animatedGIF.h"
#import "AventuraViewController.h"

@interface AventurasViewController ()
{
    NSString *JSONString;
}
@end

@implementation AventurasViewController

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
    [self makeConnection];
    [_tableView setPagingEnabled:YES];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [_tableView setBackgroundColor:[UIColor blackColor]];
    [_tableView setContentOffset:CGPointMake(0.0, 20.0)];

    NSURL *loadingURL = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    _loadingImageView.image = [UIImage animatedImageWithAnimatedGIFURL:loadingURL];
    
    _tutorialLabel.alpha = 0.0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeConnection
{
    //Inicializar JSONString.
    JSONString = @"";
    NSString *url =[NSString stringWithFormat:@"http://www.serverbpw.com/cm/aventuras.php?resp=json"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"GET"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    NSString *stringRecieved = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    JSONString = [JSONString stringByAppendingString:stringRecieved];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSData *data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSONDictionary = [NSDictionary dictionaryWithJSONData:data];
    if (JSONDictionary)
    {
        @try
        {
            for (int i = 0; i<[[[JSONDictionary objectForKey:@"result"] objectForKey:@"adventure"] count]; i++)
            {
                for (int j = 0; j< [[[[[[JSONDictionary objectForKey:@"result"] objectForKey:@"adventure"] objectAtIndex:i] objectForKey:@"pois"] objectForKey:@"poi"] count] ; j++) {
                    [[[[[[[JSONDictionary objectForKey:@"result"] objectForKey:@"adventure"] objectAtIndex:i] objectForKey:@"pois"] objectForKey:@"poi"] objectAtIndex:j] objectForKey:@"clue"];
                    [[[[[[[JSONDictionary objectForKey:@"result"] objectForKey:@"adventure"] objectAtIndex:i] objectForKey:@"pois"] objectForKey:@"poi"] objectAtIndex:j] objectForKey:@"lat"];
                    [[[[[[[JSONDictionary objectForKey:@"result"] objectForKey:@"adventure"] objectAtIndex:i] objectForKey:@"pois"] objectForKey:@"poi"] objectAtIndex:j] objectForKey:@"long"];
                }
            }
        }
        @catch (NSException *exception)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Ooops!"
                                                            message: @"Lo sentimos. Nuestros servicios no se encuentran en optimas condiciones."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK. Volveré luego."
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        [SharedData setSharedJSONDictionary:JSONDictionary];
        NSLog(@"JSON Shared");
        //Reload Data
        [_tableView reloadData];
        //Detiene Activity Indicator
        [_loadingImageView setImage:nil];
        [_interwebsLabel setAlpha:0.0];
        //muestra y deja de mostrar tutorial label.
        [UIView animateWithDuration:1.0 animations:^(void){
            _tutorialLabel.alpha = 1.0;
        }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [UIView animateWithDuration:5.0 animations:^(void)
                                  {
                                      _tutorialLabel.alpha = 0.0;
                                  }];
                             }
                         }];
    }
    else
    {
        NSLog(@"Parsing error.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Ooops!"
                                                        message: @"Lo sentimos. Nuestros servicios no se encuentran en optimas condiciones."
                                                       delegate:self
                                              cancelButtonTitle:@"OK. Volveré luego."
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}

#pragma mark - DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"PrototypeCell"];
    NSArray *aventuras = [[[SharedData getSharedJSONDictionary] objectForKey:@"result"] objectForKey:@"adventure"];
    
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:101];
    
    //Muestra Aventura
    if (indexPath.row < [aventuras count])
    {

        label.text = [[aventuras objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        int wallpapernumber = indexPath.row % 4  + 1;
        NSString *wallpapernumberString = [NSString stringWithFormat:@"%d", wallpapernumber];
        NSString *imageName = [[@"wallpaper" stringByAppendingString:wallpapernumberString] stringByAppendingString:@".jpg"];
        
        imageView.image = [UIImage imageNamed:imageName];
    }
    //Muestra Salida
    else
    {
        UILabel *label = (UILabel *)[cell viewWithTag:100];
        label.text = @"Salida";
        imageView.image = [UIImage imageNamed:@"exit.png"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *aventuras = [[[SharedData getSharedJSONDictionary] objectForKey:@"result"] objectForKey:@"adventure"];
    if ([aventuras count] == 0)
    {
        return 0;
    }
    return [aventuras count] + 1;
}

#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *aventuras = [[[SharedData getSharedJSONDictionary] objectForKey:@"result"] objectForKey:@"adventure"];
    if (indexPath.row < [aventuras count])
    {
         [self performSegueWithIdentifier:@"Aventura" sender:indexPath];
    }
    //Salida
    else
    {
        exit(0);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    AventuraViewController *aventuraViewController = (AventuraViewController *)segue.destinationViewController;
    [aventuraViewController setIndexPath:indexPath];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    exit(0);
}

@end
