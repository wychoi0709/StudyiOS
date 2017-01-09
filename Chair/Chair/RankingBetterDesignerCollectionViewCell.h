//
//  RankingBetterDesignerCollectionViewCell.h
//  Chair
//
//  Created by 최원영 on 2017. 1. 5..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingBetterDesignerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *betterDesignerImage;
@property (weak, nonatomic) IBOutlet UILabel *betterDesignerName;
@property (weak, nonatomic) IBOutlet UILabel *betterDesignerPosition;
@property (weak, nonatomic) IBOutlet UILabel *betterDesignerCustomerNumber;
@property (weak, nonatomic) IBOutlet UIImageView *betterDesignerHairShopImage;
@property (weak, nonatomic) IBOutlet UILabel *betterDesignerHairShopName;
@property (weak, nonatomic) IBOutlet UILabel *betterDesignerClosedDay;
@property (weak, nonatomic) IBOutlet UILabel *betterDesignerRankingNumber;
@property (weak, nonatomic) IBOutlet UIButton *myDesignerButton;
@property (weak, nonatomic) IBOutlet UIButton *notMyDesignerButton;

@end
