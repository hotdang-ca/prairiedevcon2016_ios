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
#import "SessionDetailsViewController.h"

#import "Session.h"
#import "Room.h"
#import "Timeslot.h"
#import "Speaker.h"

#import "HeaderCell.h"

#import "PDCFavoritesRepository.h"
#import <BlocksKit+UIKit.h>

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @try {
        [[PDCFavoritesRepository sharedRepository] removeObserver:self forKeyPath:@"listOfFavorites"];
    } @catch (NSException *exception) {
        // why crash for such a thing?
    } @finally {
    }
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
    return [_dataSource.sortedSessionsByTimeslot count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataSource.sortedSessionsByTimeslot.count >= section) {
        return [_dataSource.sortedSessionsByTimeslot[section] count];
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
    if (_dataSource.sortedSessionsByTimeslot.count >= indexPath.section) {
        if ([_dataSource.sortedSessionsByTimeslot[indexPath.section] count] >= indexPath.row) {
            sessions = _dataSource.sortedSessionsByTimeslot[indexPath.section][indexPath.row];
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
        CGRect favoriteRect = CGRectNull;
        
        for (Session *session in sessions) {
            CGRect viewRect = CGRectMake(
                       iterator * scrollView.frame.size.width + spacing,
                       0,
                       scrollView.frame.size.width - spacing,
                       scrollView.frame.size.height);
            
            SessionCollectionViewCell *sessionCell = [[[NSBundle mainBundle] loadNibNamed:@"SessionCollectionViewCell" owner:self options:nil] firstObject];
            sessionCell.frame = viewRect;
            [sessionCell configureWithSession:session];
            
            [sessionCell addGestureRecognizer:[UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
                
                SessionDetailsViewController *detailsController = [[SessionDetailsViewController alloc] initWithNibName:@"SessionDetailsViewController" bundle:[NSBundle mainBundle]];
                detailsController.session = session;
                [self.navigationController pushViewController:detailsController animated:YES];
                
                [[PDCFavoritesRepository sharedRepository] addObserver:self forKeyPath:@"listOfFavorites" options:0 context:NULL];
            }]];
            
            [scrollView addSubview:sessionCell];
            
            if (sessionCell.selected) {
                favoriteRect = viewRect;
            }
            
            iterator++;
        }
        
        if (! CGRectIsNull(favoriteRect)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [scrollView scrollRectToVisible:favoriteRect animated:YES];
            });
        }
    }
    
    [scrollView layoutIfNeeded];
    
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
