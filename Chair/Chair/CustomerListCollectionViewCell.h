//
//  CustomerListCollectionViewCell.h
//  Chair
//
//  Created by 최원영 on 2017. 3. 29..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicButton.h"

@interface CustomerListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *customerImageView;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerGenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerPlaceLabel;
@property (weak, nonatomic) IBOutlet BasicButton *messageButton;
@property (weak, nonatomic) IBOutlet UIView *messageCircleView;

@end
