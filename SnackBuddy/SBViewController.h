//
//  SBViewController.h
//  SnackBuddy
//
//  Created by David Switzer on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableView;
    UIButton *orderBtn;
}

@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) IBOutlet UIButton *orderBtn;
-(IBAction)orderSnack:(id)sender;

@end
