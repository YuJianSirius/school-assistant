//
//  MenuTableViewController.m
//  SideBarDemo
//
//  Created by xiaojia on 4/4/14.
//  Copyright (c) 2014 sirius. All rights reserved.
//

#import "MenuTableViewController.h"
#import "LabelViewController.h"
#import "SWRevealViewController.h"
#import "ClassViewController.h"

@interface MenuTableViewController ()

@property  (nonatomic, strong)   NSArray      *Item;
@property  (nonatomic, strong)   NSMutableDictionary *cellCache;

@end


@implementation MenuTableViewController

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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.8f];
    
    
    _Item = [[NSArray alloc] initWithObjects:@"title",@"index",@"class",@"score",nil];
    _cellCache = [[NSMutableDictionary alloc] init];
    // Uncommnt the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_Item count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self getcellAtIndexPath:indexPath];

    [_cellCache setObject:cell forKey:@(indexPath.row)];
    
    return cell.bounds.size.height;
}

#pragma mark - TableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cachecell = [[UITableViewCell alloc] init];
    
    Cachecell = [_cellCache objectForKey:@(indexPath.row)];
    
    if(!Cachecell){
        
        UITableViewCell *Cachecell = [self getcellAtIndexPath:indexPath];
        return Cachecell;
    }
    
    //cell.textLabel.text = [_Item objectAtIndex:indexPath.row];
    return Cachecell;
}

-(UITableViewCell *)getcellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[_Item objectAtIndex:indexPath.row]];
    
    if(!cell){
        cell = [[UITableViewCell alloc] init];
    }
    NSLog(@"TEST");
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
   
    
    if(indexPath.row == 0){
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }else{
        
        
    }
    
    return cell;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
    NSLog(@"indexpath.row%d",indexpath.row);
    
    //UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    //destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    if(!(indexpath.row == 2)){  NSLog(@"row != 2") ;
        
    if ( [segue.destinationViewController isKindOfClass: [LabelViewController class]] &&
        [sender isKindOfClass:[UITableViewCell class]] )
    {
        //UILabel* c = [(SWUITableViewCell *)sender label];
        LabelViewController *lvc = (LabelViewController *)segue.destinationViewController;
        NSLog(@"segue.labelView");
        lvc.nametext = [_Item objectAtIndex:indexpath.row];
        
        /*
        lvc.color = c.textColor;
        lvc.text = c.text;*/
    }
        
    }else{
    
        NSLog(@"segue,%@",segue.identifier);
        
        if ([segue.identifier isEqualToString:@"Show Class"]){
        
        ClassViewController *classVC = (ClassViewController *)segue.destinationViewController;
        //[classVC viewDidLoad];
        
        NSLog(@"got it");
    }
    
    }
    

    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        SWRevealViewController* rvc = self.revealViewController;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            //[self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];  //直接推回去
            [rvc pushFrontViewController:navController animated:YES];                                 //有弹跳效果
        };
        
    }
    
}


@end
