//
//  FullChoiceAboutMyDesignerViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 11..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "FullChoiceAboutMyDesignerViewController.h"

@interface FullChoiceAboutMyDesignerViewController ()

@end

@implementation FullChoiceAboutMyDesignerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/**
 *  뷰 컨트롤러를 날린다.
 */
- (IBAction)confirmBtnTouched:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
