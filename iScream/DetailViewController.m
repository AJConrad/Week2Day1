//
//  DetailViewController.m
//  iScream
//
//  Created by Andrew Conrad on 4/18/16.
//  Copyright © 2016 VizNetwork. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, weak)         IBOutlet UILabel                *flavorDetailLabel;
@property (nonatomic, weak)         IBOutlet UIImageView            *iceCreamImageView;
@property (nonatomic, weak)         IBOutlet UITextView             *iceCreamDescription;
@end

@implementation DetailViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _flavorDetailLabel.text = _currentFlavor.flavorName;
    NSLog(@"%@", _currentFlavor.flavorDescription);
    [_iceCreamImageView setImage:[UIImage imageNamed:_currentFlavor.flavorImage]];
    _iceCreamDescription.text = _currentFlavor.flavorDescription;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
