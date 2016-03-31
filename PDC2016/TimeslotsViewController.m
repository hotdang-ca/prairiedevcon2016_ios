//
//  TimeslotsViewController.m
//  
//
//  Created by James Perih on 2016-03-31.
//
//

#import "TimeslotsViewController.h"
#import "TimeslotsDataSource.h"
#import "Timeslot.h"
#import "TimeSlotCollectionViewCell.h"

@interface TimeslotsViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *timeslotsCollectionView;
@property (strong, nonatomic) TimeslotsDataSource *dataSource;
@end

@implementation TimeslotsViewController {
    UICollectionViewFlowLayout *collectionViewLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [TimeslotsDataSource sharedDataSource];
    [_dataSource addObserver:self forKeyPath:@"timeslots" options:0 context:NULL];

    [self setupCollectionViewCell];
    
    [_dataSource reloadTimeslots];
    // Do any additional setup after loading the view.
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
    NSLog(@"Items: %@", _dataSource.timeslots);
    [self.timeslotsCollectionView reloadData];
}

#pragma mark - Collection View Data Source
-(void)setupCollectionViewCell {
    collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setItemSize:CGSizeMake(320, 116)];
    [collectionViewLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionViewLayout.minimumLineSpacing = 8;
    collectionViewLayout.minimumInteritemSpacing = 8;
    [self.timeslotsCollectionView setCollectionViewLayout:collectionViewLayout];
    
    UINib *nib = [UINib nibWithNibName:@"TimeSlotCollectionViewCell"
                                bundle:[NSBundle mainBundle]];
    [self.timeslotsCollectionView registerNib:nib forCellWithReuseIdentifier:kTimeSlotReuseIdentifier];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.timeslots.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TimeSlotCollectionViewCell *timeslotCell = [self.timeslotsCollectionView dequeueReusableCellWithReuseIdentifier:kTimeSlotReuseIdentifier forIndexPath:indexPath];
    Timeslot *timeslot = [_dataSource.timeslots objectAtIndex:indexPath.row];
    if (timeslotCell && timeslot) {
        [timeslotCell configureWithTimeSlot:timeslot];
    }
    
    return timeslotCell;
}
@end
