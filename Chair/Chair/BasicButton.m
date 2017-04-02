//
//  BasicButton.m
//  Chair
//
//  Created by 최원영 on 2017. 3. 25..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "BasicButton.h"

@implementation BasicButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius = self.layer.frame.size.height / 2;
    self.clipsToBounds = true;
}

@end
