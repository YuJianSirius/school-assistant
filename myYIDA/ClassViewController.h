//
//  ClassViewController.h
//  A3GridTableViewSample
//
//  Created by Botond Kis on 28.09.12.
//  Copyright (c) 2012 AllAboutApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A3GridTableView.h"

@interface ClassViewController : UIViewController <A3GridTableViewDataSource, A3GridTableViewDelegate>{
    // the Gride Table View
    A3GridTableView *gridTableView;
}

// reaload button
@property (retain, nonatomic) IBOutlet UIButton *buttonReload;
- (IBAction)buttonReloadTouchUpInside:(id)sender;

@end
