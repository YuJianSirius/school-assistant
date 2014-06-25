//
//  ClassViewController.m
//  A3GridTableViewSample
//
//  Created by Botond Kis on 28.09.12.
//  Copyright (c) 2012 AllAboutApps. All rights reserved.
//

#import "ClassViewController.h"
#import "SWRevealViewController.h"
#import "WebManager.h"

@interface ClassViewController ()<UITextViewDelegate>
{
    NSMutableArray *numberOfRowsInSection;
    CGFloat dayheight;
}
@property (nonatomic) UIImage    *normalImage;
@property (nonatomic) UIImage    *selectedImage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) NSArray    *WeekList;
@property (nonatomic, strong) NSArray    *ClassList;
@property (nonatomic, strong) NSArray    *TimeList;
@property (strong, nonatomic) WebManager *webmanager;


@end

#define ITEMS 8

@implementation ClassViewController

-(WebManager *)webmanager{
    if (!_webmanager) {
        _webmanager = [[WebManager alloc] init];
        NSLog(@"webmanger alloc");
        [_webmanager GetClass];
    }
    return _webmanager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"classvIEWdidLoad");
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    self.navigationController.navigationBar.translucent = NO;
    
    _WeekList = [NSArray arrayWithObjects: @"",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日",nil];
    _TimeList = [NSArray arrayWithObjects: @"第一大节", @"第二大节", @"第三大节", @"第四大节", @"第五大节",nil];
    
    
    _ClassList = self.webmanager.classList;
    
    for (NSString *class in _ClassList) {
        NSLog(@"%@",class);
        NSLog(@"=====");
    }
    
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    // initialize Random Data
    numberOfRowsInSection = [[NSMutableArray alloc] init];
    for (int i = 0; i < ITEMS; i++) {
        [numberOfRowsInSection addObject:[NSNumber numberWithInt: arc4random()%60+1]];
    }
    
    dayheight = 10000.0f;
    
    // Initialize Grid View
    gridTableView = [[A3GridTableView alloc] initWithFrame:self.view.bounds];
    gridTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // images
    self.normalImage = [UIImage imageNamed:@"cellBG-normal.png"];
    self.normalImage = [self.normalImage  resizableImageWithCapInsets:UIEdgeInsetsMake(14, 16, 18, 16)];
    self.selectedImage = [UIImage imageNamed:@"cellBG-highlighted"];
    self.selectedImage = [self.selectedImage  resizableImageWithCapInsets:UIEdgeInsetsMake(14, 16, 18, 16)];
    
    // set datasource and delegate
    gridTableView.dataSource = self;
    gridTableView.delegate = self;
    
    // set paging
    gridTableView.pagingPosition = A3GridTableViewCellAlignmentCenter;
    gridTableView.gridTableViewPagingEnabled = YES;
    gridTableView.backgroundColor = [UIColor lightGrayColor];
    
    // scrolling
    gridTableView.directionalLockEnabled = YES;
    
    // add as subview
    [self.view addSubview:gridTableView];
    [self.view sendSubviewToBack:gridTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setButtonReload:nil];
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

//===========================================================================================
#pragma mark - DataSource

// Data handling
- (NSInteger)numberOfSectionsInA3GridTableView:(A3GridTableView *)aGridTableView{
    return ITEMS;
}

- (NSInteger)A3GridTableView:(A3GridTableView *) aGridTableView numberOfRowsInSection:(NSInteger) section{
    NSNumber *n = [numberOfRowsInSection objectAtIndex:section];
    return 5;
}

// header handling
- (A3GridTableViewCell *)A3GridTableView:(A3GridTableView *)aGridTableView headerForSection:(NSInteger)section{
    A3GridTableViewCell *headerCell;
    
    headerCell = [aGridTableView dequeueReusableHeaderWithIdentifier:@"headerID"];
    
    if (!headerCell) {
        headerCell = [[A3GridTableViewCell alloc] initWithReuseIdentifier:@"headerID"];
        UIImageView *normalBG = [[UIImageView alloc] initWithImage:self.normalImage];
        UIImageView *selectedBG = [[UIImageView alloc] initWithImage:self.selectedImage];
        headerCell.backgroundView = normalBG;
        headerCell.highlightedBackgroundView = selectedBG;
        
        headerCell.titleLabel.textAlignment = UITextAlignmentCenter;
        headerCell.backgroundView.backgroundColor = [UIColor clearColor];
    }

    //headerCell.titleLabel.text = [NSString stringWithFormat:@"Header: %d", section];
    headerCell.titleLabel.text = [_WeekList objectAtIndex:section];
    
    return headerCell;
}

- (CGFloat)heightForHeadersInA3GridTableView:(A3GridTableView *)aGridTableView{
    return 80.0f;
}

- (CGFloat)A3GridTableView:(A3GridTableView *)aGridTableView widthForSection:(NSInteger)section{
    return 80;
}



// Cell handling
- (A3GridTableViewCell *)A3GridTableView:(A3GridTableView *)aGridTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    A3GridTableViewCell *cell;
    cell = [aGridTableView dequeueReusableCellWithIdentifier:@"cellID"];
    UIImageView *normalBG = [[UIImageView alloc] initWithImage:self.normalImage];
    UIImageView *selectedBG = [[UIImageView alloc] initWithImage:self.selectedImage];
    
    if (!cell) {
        cell = [[A3GridTableViewCell alloc] initWithReuseIdentifier:@"cellID"];
        //cell.backgroundColor = [UIColor clearColor];
     
        cell.backgroundView = normalBG;
        //cell.highlightedBackgroundView = selectedBG;
        [cell.titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:10]];
       
    
        }
    if(indexPath.section > 0){
        //cell.titleLabel.text = [_ClassList objectAtIndex:(indexPath.section - 1 + indexPath.row*8)];
        //cell.titleLabel.text = [NSString stringWithFormat:@"%d,%d",indexPath.section,indexPath.row];
        //NSLog(@"%d,%d",indexPath.section,indexPath.row);
        
        //[textview setBackgroundColor:[UIColor redColor]];
       
        //selectedBG.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [textview setText:[_ClassList objectAtIndex:(indexPath.section - 1 + indexPath.row*8)]];
        textview.delegate = self;
        //textview.backgroundColor = [UIColor grayColor];
        //selectedBG.frame = textview.bounds;
        //[textview addSubview:selectedBG];
        [[cell contentView] addSubview:textview];
    }else{
        cell.titleLabel.text = [_TimeList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (CGFloat)A3GridTableView:(A3GridTableView *)aGridTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *n = [numberOfRowsInSection objectAtIndex:indexPath.section];
    return 80;
}


//===========================================================================================
#pragma mark - Button Actions

- (IBAction)buttonReloadTouchUpInside:(id)sender {
    // Randomize height and reload Table    
    dayheight = (arc4random()%10+2)*1000;
    [gridTableView reloadCellsWithViewAnimation:YES];
}

#pragma mark - UITextView delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
