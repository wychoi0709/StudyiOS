//
//  RankingNormalDesignerCollectionViewCell.h
//  Chair
//
//  Created by 최원영 on 2017. 1. 5..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingNormalDesignerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *normalDesignerImage;
@property (weak, nonatomic) IBOutlet UILabel *normalDesignerPosition;
@property (weak, nonatomic) IBOutlet UILabel *normalDesignerName;
@property (weak, nonatomic) IBOutlet UIImageView *normalDesignerHairShopImage;
@property (weak, nonatomic) IBOutlet UILabel *normalDesignerHairShopName;
@property (weak, nonatomic) IBOutlet UILabel *normalDesignerClosedDay;
@property (weak, nonatomic) IBOutlet UILabel *normalDesignerCustomerNumber;
@property (weak, nonatomic) IBOutlet UIButton *myDesignerButton;
@property (weak, nonatomic) IBOutlet UIButton *notMyDesignerButton;

@end
