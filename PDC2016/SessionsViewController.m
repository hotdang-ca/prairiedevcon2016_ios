//
//  SessionsViewController.m
//  PDC2016
//
//  Created by James Perih on 2016-03-31.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "SessionsViewController.h"
#import "SessionsDataSource.h"
#import "SessionCollectionViewCell.h"

#import "Session.h"
#import "Room.h"
#import "Timeslot.h"
#import "Speaker.h"

@interface SessionsViewController ()
@property (strong, nonatomic) SessionsDataSource *dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *sessionsCollectionView;
@end

@implementation SessionsViewController {
    UICollectionViewFlowLayout *collectionViewLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [SessionsDataSource sharedDataSource];
    [_dataSource addObserver:self forKeyPath:@"sessions" options:0 context:NULL];
    
    [self setupCollectionViewCell];
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
    
    NSArray *uniqueTimeDateSlots = [_dataSource.sessions valueForKeyPath:@"@distinctUnionOfObjects.timeslot.timeRange"];

    NSMutableArray *mondayEvents = [NSMutableArray array];
    NSMutableArray *tuesdayEvents = [NSMutableArray array];
    
    for (Session *session in _dataSource.sessions) {
        if ([session.timeslot.day isEqualToString:@"Monday"]) {
            [mondayEvents addObject:session];
        } else if ([session.timeslot.day isEqualToString:@"Tuesday"]) {
            [tuesdayEvents addObject:session];
        }
    }
    
    NSArray *mondayTimeSlots = [mondayEvents valueForKeyPath:@"@distinctUnionOfObjects.timeslot.timeRange"];
    NSArray *tuesdayTimeSlots = [tuesdayEvents valueForKeyPath:@"@distinctUnionOfObjects.timeslot.timeRange"];
    
    NSMutableArray *mondayByTimeSlot = [NSMutableArray arrayWithCapacity:mondayTimeSlots.count];
    NSMutableArray *tuesdayByTimeSlot = [NSMutableArray arrayWithCapacity:tuesdayTimeSlots.count];
    
    for (int i = 0; i < mondayTimeSlots.count; i++) {
        [mondayByTimeSlot addObject:[NSMutableArray array]];
    }
    for (int i = 0; i < tuesdayTimeSlots.count; i++) {
        [tuesdayByTimeSlot addObject:[NSMutableArray array]];
    }
    
    for (Session *session in mondayEvents) {
        NSInteger indexOfThisSessionTimeslot = [mondayTimeSlots indexOfObject:session.timeslot.timeRange];
        
        if (indexOfThisSessionTimeslot != NSNotFound) {
            [mondayByTimeSlot[indexOfThisSessionTimeslot] addObject:session];
        }
    }
    
    for (Session *session in tuesdayEvents) {
        NSInteger indexOfThisSessionTimeSlot = [tuesdayTimeSlots indexOfObject:session.timeslot.timeRange];
        
        if (indexOfThisSessionTimeSlot != NSNotFound) {
            [tuesdayByTimeSlot[indexOfThisSessionTimeSlot] addObject:session];
        }
    }
    
    NSLog(@"%@ %@", mondayByTimeSlot, tuesdayByTimeSlot);
    
    // now i have two arrays, monday and tuesday.
    NSArray *allEvents = @[mondayByTimeSlot, tuesdayByTimeSlot];
    
    NSLog(@"All events: %@", allEvents);
    
    
    [_sessionsCollectionView reloadData];
}

#pragma mark - Collection View Data Source
-(void)setupCollectionViewCell {
    collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setItemSize:CGSizeMake(self.view.frame.size.width-4, 200)];
    [collectionViewLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionViewLayout.minimumLineSpacing = 8;
    collectionViewLayout.minimumInteritemSpacing = 8;
    [self.sessionsCollectionView setCollectionViewLayout:collectionViewLayout];
    
    UINib *nib = [UINib nibWithNibName:@"SessionCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [self.sessionsCollectionView registerNib:nib forCellWithReuseIdentifier:kSessionReuseIdentifier];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.sessions.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SessionCollectionViewCell *sessionCell = [self.sessionsCollectionView dequeueReusableCellWithReuseIdentifier:kSessionReuseIdentifier forIndexPath:indexPath];
    Session *session = [_dataSource.sessions objectAtIndex:indexPath.row];
    
    if (sessionCell && session) {
        [sessionCell configureWithSession:session];
    }
    
    return sessionCell;
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
