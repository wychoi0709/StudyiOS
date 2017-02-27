//
//  DetailPriceDesignerCollectionReusableView.h
//  Chair
//
//  Created by 최원영 on 2017. 2. 27..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPriceDesignerCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *priceTextEnglishLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTextKoreanLabel;

@end
