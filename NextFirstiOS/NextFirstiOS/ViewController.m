//
//  ViewController.m
//  NextFirstiOS
//
//  Created by 최원영 on 2016. 10. 12..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
    @property (weak, nonatomic) IBOutlet UIButton *pushButton;
    @property (weak, nonatomic) IBOutlet UIButton *dismissButton;
            
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"안뇽안뇽?? iOS 고고고고고고ㅗ고!!!고고고!!!고고고고고고고");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouched:(id)sender {
    _pushButton.backgroundColor = [UIColor whiteColor];
    NSLog(@"버튼이 눌림눌림");
}
- (IBAction)buttonTouchedOut:(id)sender {
    _pushButton.backgroundColor = [UIColor blueColor];
}
- (IBAction)dismissButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
