//
//  LocationSelectModalViewController.h
//  Chair
//
//  Created by 최원영 on 2016. 12. 21..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <UIKit/UIKit.h>

//화면에 뿌리는건 ViewDataSource, 인터렉션(애니메이션 등)은 ViewDelegate
@interface LocationSelectModalViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@end
