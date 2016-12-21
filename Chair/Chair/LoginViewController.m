//
//  LoginViewController.m
//  Chair
//
//  Created by 최원영 on 2016. 12. 10..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginNetworkService.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

//로그인 요청 네트워크를 담당하는 모델
LoginNetworkService *loginNetworkService;

/**
 *  로그인 버튼 터치
 */
- (IBAction)loginBtnTouched:(UIButton *)sender {
    
    NSLog(@"로그인 전송 요청 함");
    
    //비동기로 요청을 보낸다.
    [loginNetworkService sendLoginAsynchronousRequest:_emailTextField.text withPassword:_passwordTextField.text];
    
}


/**
 * 로그인 처리 콜백 함수(옵저버)
 */
- (void)didFinishLoginRequest:(NSNotification*) noti {
    
    //결과를 빼온다.
    NSDictionary* resultData = [[noti userInfo] objectForKey:@"loginResult"];
    
    NSLog(@"sendLoginRequest result = %@", resultData);
    
}


/**
 *  페이지 로딩 완료
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //로그인 네트워크 요청 객체 생성
    loginNetworkService = [[LoginNetworkService alloc] init];
    
    //노티를 만들고 옵저버를 add한다.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLoginRequest:) name:@"loginResult" object:loginNetworkService];
    
    //각 요소에 폰트를 적용합니다.
//    _emailTextField.font = [UIFont fontWithName:@"NotoSansKR-Bold" size:35];
//    _passwordTextField.font = [UIFont fontWithName:@"NotoSansKR-Medium" size:13];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  생명주기 상 얘는 view가 없어질 때 등장한다. 문제는 얘가 실행되고 난 다음 view가 다시 등장했을 때, viewDidLoad가 실행되지 않는다(옵저버 등록에 주의)
 */
- (void)viewDidDisappear:(BOOL)animated {
    
}


/**
 *  이 VC가 없어질 때 호출된다.
 */
- (void)dealloc {
    //지금 달려있는 VC의 모든 옵저버를 없앰
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //어떤 옵저버를 없앨 것인지 구체적으로 명시
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"randomizeCard" object:randomCardSupplyFactory];
}

@end
