//
//  ViewController.m
//  Chair
//
//  Created by 최원영 on 2016. 11. 23..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "ViewController.h"
#import "LoginNetworkService.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;



@end

@implementation ViewController

//로그인 요청 네트워크를 담당하는 모델
LoginNetworkService *loginNetworkService;

/**
 *  로그인 버튼 터치
 **/
- (IBAction)loginBtnTouched:(UIButton *)sender {
    
    //동기로 요청을 보내서 결과를 받아온다.
//    NSDictionary *loginResultDict = [loginNetworkService sendLoginRequest:_emailTextField.text withPassword:_passwordTextField.text];
    
    //결과를 로그로 보여준다.
//    NSLog(@"login result = %@", loginResultDict);
    
    
    //비동기로 요청을 보낸다.
    [loginNetworkService sendLoginAsynchronousRequest:_emailTextField.text withPassword:_passwordTextField.text];
    
}


/**
 *  페이지 로딩 완료
 **/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //로그인 네트워크 요청 객체 생성
    loginNetworkService = [[LoginNetworkService alloc] init];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
