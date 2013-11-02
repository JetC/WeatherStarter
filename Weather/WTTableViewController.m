//
//  WTTableViewController.m
//  Weather
//
//  Created by Scott on 26/01/2013.
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "WTTableViewController.h"
#import "WeatherAnimationViewController.h"
#import "NSDictionary+weather.h"
#import "NSDictionary+weather_package.h"

static NSString *const BaseURLString = @"http://news.ziqiang.net/api/article/?n=15&s=%E5%85%A8%E9%83%A8&p=1";

    //http://news.ziqiang.net/api/article/?n=15&s=%E5%85%A8%E9%83%A8&p=1
    //encodedString	%E5%85%A8%E9%83%A8
@interface WTTableViewController ()

@property(strong) NSDictionary *weather;

@end

@implementation WTTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"WeatherDetailSegue"]){
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        WeatherAnimationViewController *wac = (WeatherAnimationViewController *)segue.destinationViewController;
        
        NSDictionary *w;
        switch (indexPath.section) {
            case 0:{
                w = self.weather.currentCondition;
                break;
            }
            case 1:{
                w = [[self.weather upcomingWeather] objectAtIndex:indexPath.row];
                break;
            }
            default:{
                break;
            }
        }
        
        wac.weatherDictionary = w;
    }
}

#pragma mark Actions

- (IBAction)clear:(id)sender {
    self.title = @"";
    self.weather = nil;
    [self.tableView reloadData];
}

- (IBAction)jsonTapped:(id)sender {
        // 1
    NSString *weatherUrl = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    NSURL *url = [NSURL URLWithString:weatherUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

        // 2
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
     // 3
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        self.weather  = (NSDictionary *)JSON;
                                                        self.title = @"JSON Retrieved";
                                                        [self.tableView reloadData];
                                                    }
     // 4
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                                                    delegate:nil
                                                                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                        [av show];
                                                    }];
    
        // 5
    [operation start];
}

- (IBAction)plistTapped:(id)sender
{
}

- (IBAction)xmlTapped:(id)sender
{
}

- (IBAction)httpClientTapped:(id)sender
{
}

- (IBAction)apiTapped:(id)sender
{
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        // Return the number of rows in the section.

    if(!self.weather)
        return 0;

    switch (section) {
        case 0:{
            return 1;
        }
        case 1:{
            NSArray *upcomingWeather = [self.weather upcomingWeather];
            return [upcomingWeather count];
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeatherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
}

@end
