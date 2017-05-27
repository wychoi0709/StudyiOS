//
//  DetailDesignerInfoViewController.h
//  Chair
//
//  Created by 최원영 on 2017. 1. 12..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailDesignerInfoViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property NSDictionary *designerInfo;

//자신이 등록된 디자이너일 경우
@property Boolean amIDesigner;

@end
