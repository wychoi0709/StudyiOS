//
//  TakenMessgaeCollectionViewCell.h
//  Chair
//
//  Created by 최원영 on 2017. 2. 28..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakenMessgaeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureOfTakenPerson;
@property (weak, nonatomic) IBOutlet UILabel *takenMessageLabel;

@end
