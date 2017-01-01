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


@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIView *locationModalContainerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *locationSelectBtn;

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
    
    NSLog(@"SignUp의 뷰가 로드됨");
    
}


/**
 *  옵저버를 통해 온 노티를 보고 라벨을 바꾸는 메소드
 */
- (void)changeMyLocationBtnLabel: (NSNotification *)noti {

    //realm에 담긴 myLocation 정보를 빼서 UI에 반영한다.
    NSLog(@"우선 changeMyLocationBtnLabel로 들어옴");
    
    Location *myLocation = [[Location allObjects] firstObject];
    _locationSelectBtn.titleLabel.text = myLocation.location;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    //지금 달려있는 VC의 모든 옵저버를 없앰
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
}

@end
