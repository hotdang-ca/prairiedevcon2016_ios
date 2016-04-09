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
#import "ContainerCollectionViewCell.h"

#import "Session.h"
#import "Room.h"
#import "Timeslot.h"
#import "Speaker.h"

#import "HeaderCell.h"

@interface SessionsViewController ()
@property (strong, nonatomic) SessionsDataSource *dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *sessionsCollectionView;
@end

@implementation SessionsViewController {
    UICollectionViewFlowLayout *collectionViewLayout;
    NSArray *modifiedDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [SessionsDataSource sharedDataSource];
    [_dataSource addObserver:self forKeyPath:@"sessions" options:0 context:NULL];
    
    modifiedDataSource = [[NSArray alloc] init];
    
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
    
    NSArray *sortedMondayArray = [mondayByTimeSlot sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSArray *mondayTimeOrdering = @[
                                        @"7:30 - 8:30",
                                        @"8:30 - 9:30",
                                        @"9:45 - 10:45",
                                        @"11:00 - 12:00",
                                        @"12:00 - 1:00",
                                        @"1:00 - 2:00",
                                        @"2:00 - 2:15",
                                        @"2:15 - 3:15",
                                        @"3:30 - 4:30",
                                        ];
        NSArray *aArray = (NSArray *)obj1;
        NSArray *bArray = (NSArray *)obj2;
        
        // they should all be grouped by timeslot, so i'm only interested in the first object.
        Session *a = (Session *)aArray[0];
        Session *b = (Session *)bArray[0];
        
        NSInteger aTimeSlotIndex = [mondayTimeOrdering indexOfObject:a.timeslot.timeRange];
        NSInteger bTimeSlotIndex = [mondayTimeOrdering indexOfObject:b.timeslot.timeRange];
        
        return aTimeSlotIndex > bTimeSlotIndex;
    }];
    
    NSArray *sortedTuesdayArray = [tuesdayByTimeSlot sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSArray *tuesdayTimeOrdering = @[
                                         @"7:30 - 8:30",
                                         @"8:30 - 9:30",
                                         @"9:45 - 10:45",
                                         @"10:45 - 11:00",
                                         @"11:00 - 12:00",
                                         @"12:00 - 1:00",
                                         @"1:00 - 2:00",
                                         @"2:00 - 2:15",
                                         @"2:15 - 3:15",
                                         @"3:30 - 4:30"];
        NSArray *aArray = (NSArray *)obj1;
        NSArray *bArray = (NSArray *)obj2;
        
        // they should all be grouped by timeslot, so i'm only interested in the first object.
        Session *a = (Session *)aArray[0];
        Session *b = (Session *)bArray[0];
        
        NSInteger aTimeSlotIndex = [tuesdayTimeOrdering indexOfObject:a.timeslot.timeRange];
        NSInteger bTimeSlotIndex = [tuesdayTimeOrdering indexOfObject:b.timeslot.timeRange];
        
        return aTimeSlotIndex > bTimeSlotIndex;
    }];
    
    
    // now i have two arrays, monday and tuesday.
    NSArray *allEvents = @[sortedMondayArray, sortedTuesdayArray];
    
    modifiedDataSource = [[NSArray alloc] initWithArray:allEvents];
    
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
    
    UINib *nib = [UINib nibWithNibName:@"ContainerCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [self.sessionsCollectionView registerNib:nib forCellWithReuseIdentifier:@"ContainerCell"];
    
    UINib *headerNib = [UINib nibWithNibName:@"SessionHeaderCell" bundle:[NSBundle mainBundle]];
    [self.sessionsCollectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCell"];
    [collectionViewLayout setHeaderReferenceSize:CGSizeMake(250, 30)];
    
    [self.sessionsCollectionView setCollectionViewLayout:collectionViewLayout];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [modifiedDataSource count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (modifiedDataSource.count >= section) {
        return [modifiedDataSource[section] count];
    }
    return 0;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HeaderCell *headerCell = [self.sessionsCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
    
    headerCell.headerTitleLabel.text = indexPath.section == 0 ? @"Monday" : @"Tuesday";
    return headerCell;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ContainerCollectionViewCell *containerCell = [self.sessionsCollectionView dequeueReusableCellWithReuseIdentifier:@"ContainerCell" forIndexPath:indexPath];
    
    NSArray *sessions;
    if (modifiedDataSource.count >= indexPath.section) {
        if ([modifiedDataSource[indexPath.section] count] >= indexPath.row) {
            sessions = modifiedDataSource[indexPath.section][indexPath.row];
        }
    }
    // what's returned is an array ... lets build a UIView thinger.
    UIScrollView *scrollView = containerCell.containingScrollView;
    
    // this cell might be recycled; remove subviews
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label = containerCell.timeslotLabel;
    Session *anySession = sessions[0];
    label.text = anySession.timeslot.timeRange;
    
    scrollView.contentSize = CGSizeMake((containerCell.frame.size.width + 4) * sessions.count, containerCell.frame.size.height - label.frame.size.height - 8);
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.directionalLockEnabled = YES;

    if (sessions) {

        int iterator = 0;
        CGFloat const spacing = 2.0;
        
        for (Session *session in sessions) {
            CGRect viewRect = CGRectMake(
                       iterator * scrollView.frame.size.width + spacing,
                       0,
                       scrollView.frame.size.width - spacing,
                       scrollView.frame.size.height);
            
            SessionCollectionViewCell *sessionCell = [[[NSBundle mainBundle] loadNibNamed:@"SessionCollectionViewCell" owner:self options:nil] firstObject];
            sessionCell.frame = viewRect;
            
            sessionCell.layer.borderWidth = 4;
            sessionCell.layer.borderColor = [UIColor blackColor].CGColor;
            sessionCell.layer.cornerRadius = 8.0;
            
            sessionCell.backgroundColor = [UIColor greenColor];
            
            [sessionCell configureWithSession:session];
            
            [scrollView addSubview:sessionCell];
            iterator++;
        }
        
    }
    
//    [containerCell addSubview:scrollView];
    
    return containerCell;
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
