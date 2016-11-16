//
//  SecondViewController.m
//  W5mission1
//
//  Created by 최원영 on 2016. 11. 2..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "SecondViewController.h"
#import "StudentNumberModel.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabelOfStudentNumberByName;

@end



@implementation SecondViewController

//학생 정보가 담겨있는 모델 생성
StudentNumberModel *studentNumberModel;


/**
 *  학생 이름으로 학번 찾는 버튼
 **/
- (IBAction)searchResult:(UIButton *)sender {
    
    //필요한 변수 선언
    NSString *name = _nameTextField.text;
    NSString *resultNumber;
    
    //결과 값을 모델에서 받아오고, 결과 값에 따라서 다르게 보여지도록 설정
    resultNumber = [[studentNumberModel findByName: name] stringValue];
    if (resultNumber == nil) {
        _resultLabelOfStudentNumberByName.text = @"결과 없음";
    } else {
        _resultLabelOfStudentNumberByName.text = resultNumber;
    }
    
}


/**
 *  모든 학생의 정보를 뿌려주는 버튼
 **/
- (IBAction)searchAllStudent:(UIButton *)sender {
    
    //필요한 변수 설정
    NSString *resultStrings;
    
    //모델에서 결과 값을 받아옴
    resultStrings = [studentNumberModel findAllStudent];
    
    //UIAlertController를 통해서 결과값을 보여줌
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"모든 학생 표시"
                                  message:resultStrings
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //학생 정보 모델 초기화
    studentNumberModel = [[StudentNumberModel alloc] init];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
