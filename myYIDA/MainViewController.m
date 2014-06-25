//
//  MainViewController.m
//  SideBarDemo
//
//  Created by xiaojia on 4/4/14.
//  Copyright (c) 2014 sirius. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "MenuTableViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"main didload");
	// Do any additional setup after loading the view, typically from a nib.
    
    //_sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
