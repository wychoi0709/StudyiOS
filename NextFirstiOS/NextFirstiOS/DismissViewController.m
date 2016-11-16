//
//  DismissViewController.m
//  NextFirstiOS
//
//  Created by 최원영 on 2016. 10. 12..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "DismissViewController.h"

@interface DismissViewController ()
    @property (weak, nonatomic) IBOutlet UIButton *dismissButton;

@end

@implementation DismissViewController

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
- (IBAction)dismissButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
