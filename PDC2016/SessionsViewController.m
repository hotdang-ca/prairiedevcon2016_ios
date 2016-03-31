//
//  SessionsViewController.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "SessionsViewController.h"
#import "SessionsDataSource.h"

@interface SessionsViewController ()
@property (strong, nonatomic) SessionsDataSource *dataSource;
@end

@implementation SessionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [SessionsDataSource sharedDataSource];
    [_dataSource addObserver:self forKeyPath:@"sessions" options:0 context:NULL];
    [_dataSource reloadSessions];
    
    if (self.navigationController) {
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadList:)];
        self.navigationItem.rightBarButtonItem = refreshButton;
    }
    
    // Do any additional setup after loading the view.
}

- (void)reloadList:(id)sender {
    [_dataSource reloadSessions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DataSource Changes
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    NSLog(@"Items: %@", _dataSource.sessions);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
