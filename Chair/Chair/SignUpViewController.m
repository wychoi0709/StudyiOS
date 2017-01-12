//
//  SignUpViewController.m
//  Chair
//
//  Created by 최원영 on 2016. 12. 20..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "SignUpViewController.h"
#import "LocationSelectModalViewController.h"
#import "Location.h"
#import "SignUpNetworkService.h"
#import "DesignerRankingViewController.h"


@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIView *locationModalContainerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *locationSelectBtn;
@property Location *myLocation;
@property SignUpNetworkService *signupNetworkService;

@end

@implementation SignUpViewController

/**
 *  관심지역 모달창의 띄우는 메소드
 */
- (IBAction)myLocationBtnTouched:(UIButton *)sender {
    
    //모달창을 만든다.
    LocationSelectModalViewController *locationSelectModalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationSelectModalViewController"];

    //배경이 투명한 모달 스타일로 만들어준 뒤, 뷰컨트롤러를 띄운다.
    locationSelectModalViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [locationSelectModalViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:locationSelectModalViewController animated:YES completion:nil];
    
}


/**
 *  닫기 버튼 클릭시 뷰컨트롤러를 날린다.
 */
- (IBAction)closedBtnTouched:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


/**
 *  키보드 날리는 함수
 */
-(void)dismissKeyboard {
    
    [_emailTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}


/**
 *  텍스트 필드의 리턴 버튼 눌렀을 때 메소드
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_emailTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //텍스트 필드에서 키보드 없애는 코드
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    //텍스트 필드의 delegate를 self로 지정한다.
    _emailTextField.delegate = self;
    _nameTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    //노티 옵저버를 만들어서 선택한 locataion 정보를 받는다.
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(changeMyLocationBtnLabel:) name:@"changeMyLocation" object:_locationModalContainerView];
    [notificationCenter addObserver:self selector:@selector(didFinishSignUpRequest:) name:@"signUpResultNotification" object:_signupNetworkService];
    
    NSLog(@"SignUp의 뷰가 로드됨");
    
}


-(void)didFinishSignUpRequest: (NSNotification *)noti {
    NSLog(@"changeMyLocationBtnLabel로 들어옴");
    
    //결과를 빼온 뒤, NSUserDefaults에 'userInfo'로 맵핑시켜놓는다.
    NSDictionary* resultData = [[noti userInfo] objectForKey:@"signUpResult"];
    NSUserDefaults *standardDefault = [NSUserDefaults standardUserDefaults];
    [standardDefault setObject:resultData forKey:@"userInfo"];
    [standardDefault synchronize];
    
    NSLog(@"sendSignUpRequest result = %@", resultData);
    
    //DesignerRanking 뷰 컨트롤러로 보낸다.
    DesignerRankingViewController *designerRankingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"designerRankingViewController"];
    [self presentViewController:designerRankingViewController animated:YES completion:nil];
}


/**
 *  옵저버를 통해 온 노티를 보고 라벨을 바꾸는 메소드
 */
- (void)changeMyLocationBtnLabel: (NSNotification *)noti {

    NSLog(@"changeMyLocationBtnLabel로 들어옴");
    
    //노티에 담겨온 location 정보를 빼낸다.
    _myLocation = [[noti userInfo] objectForKey:@"myLocation"];
    
    //버튼의 타이틀을 수정한다.
    [_locationSelectBtn setTitle:_myLocation.location forState:UIControlStateNormal];
    [_locationSelectBtn setTitle:_myLocation.location forState:UIControlStateSelected];
    
}

- (IBAction)signUpBtnTouched:(UIButton *)sender {
    
    _signupNetworkService = [[SignUpNetworkService alloc] init];
    
    [_signupNetworkService sendSignUpAsynchronousRequest:_nameTextField.text withEmail:_emailTextField.text withPassword:_passwordTextField.text withLocationId:_myLocation.id];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    //지금 달려있는 VC의 모든 옵저버를 없앰
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
}

@end
