//
//  ContainerCollectionViewCell.h
//  PDC2016
//
//  Created by James Perih on 2016-04-09.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *containingScrollView;
@property (weak, nonatomic) IBOutlet UILabel *timeslotLabel;

@end
