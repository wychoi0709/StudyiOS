//
//  ViewController.m
//  W9Block
//
//  Created by 최원영 on 2016. 12. 14..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//First 버튼 속성
UIColor *firstColor;
CGRect firstRect;


/**
 *  버튼을 터치함
 */
- (IBAction)firstBtnTouched:(UIButton *)sender {

    //기존 버튼의 속성을 저장해놓음
    firstColor = sender.backgroundColor;
    firstRect = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height);
    
    //버튼의 속성을 애니메이션과 함께 변경함
    //애니메이션은 기본적으로 60프레임으로 돌아감
    [UIView animateWithDuration: 2.0
                     animations: ^{
                         
                         //iOS에서 RGB는 0 ~ 1 사이이다. 그래서 256컬러이면 255를 나눠서 값을 구해줘야함
                         sender.backgroundColor = [UIColor colorWithRed:0.7 green:0.1 blue:0.1 alpha:1];
                         
                         //frame 값을 변경한다.
                         sender.frame = CGRectMake(60, 120, 200, 30);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         //완료 이후, 한 번 더 애니메이션을 적용함
                         [UIView animateWithDuration: 1.0
                                          animations: ^{
                                              
                                              sender.backgroundColor = firstColor;
                                              sender.frame = firstRect;
                                              
                                          }
                                          completion:^(BOOL finished) {
                                          }];
                         
                     }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
