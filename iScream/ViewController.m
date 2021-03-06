//
//  ViewController.m
//  iScream
//
//  Created by Thomas Crawford on 6/7/15.
//  Copyright (c) 2015 VizNetwork. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Flavors.h"
#import "InventoryItems.h"
#import "DetailViewController.h"

@interface ViewController ()

@property (nonatomic, strong)               AppDelegate             *appDelegate;
@property (nonatomic, strong)               NSManagedObjectContext  *managedObjectContext;
@property (nonatomic, strong)               NSArray                 *flavorsArray;
@property (nonatomic, weak)     IBOutlet    UITableView             *flavorsTable;

//1 above prop added

@end

@implementation ViewController

#pragma mark - Core Methods



- (NSArray *)fetchFlavors {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Flavors" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"flavorName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchResults = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];

    return [NSMutableArray arrayWithArray:fetchResults];
}

- (float)totalInventoryForFlavor:(Flavors *)flavor {
    float totalInGallons = 0.0;
    NSArray *flavorInventoryArray = [[flavor relationshipFlavorInventoryItems] allObjects];
    for (InventoryItems *inventoryItem in flavorInventoryArray) {
        totalInGallons = totalInGallons + [[inventoryItem sizeInGallons] floatValue];
    }
    return totalInGallons;
}

//this bit is added, direct copy-paste from in class with name changes
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _flavorsArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *iCell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Flavors *currentFlavor = _flavorsArray[indexPath.row];
    iCell.textLabel.text =  [currentFlavor flavorName];
    iCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f gallons",[self totalInventoryForFlavor:currentFlavor]];
//    NSString *flavorPicName = [NSString stringWithFormat:@"%@", [currentFlavor flavorName]];
//    flavorPicName = [flavorPicName stringByReplacingOccurrencesOfString:@" " withString:@""];
    iCell.imageView.image = [UIImage imageNamed:currentFlavor.flavorImage];
    
    return iCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *destController = [segue destinationViewController];
    NSIndexPath *indexPath = [_flavorsTable indexPathForSelectedRow];
    destController.currentFlavor = _flavorsArray[indexPath.row];
}

//end added bits


#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = _appDelegate.managedObjectContext;
    _flavorsArray = [self fetchFlavors];
    for (Flavors *flavor in _flavorsArray) {
        NSLog(@"image:%@",flavor.flavorImage);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
