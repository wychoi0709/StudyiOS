//
//  LoginViewController.m
//  Chair
//
//  Created by 최원영 on 2016. 12. 10..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginNetworkService.h"
#import "SignUpViewController.h"
#import "MeasurementHelper.h"
#import "DesignerRankingViewController.h"
#import "CheckEmailFormatHelper.h"
#import "SocialLoginNetworkService.h"

@import Firebase;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@property DesignerRankingViewController *designerRankingViewController;

@end

@implementation LoginViewController

//로그인 요청 네트워크를 담당하는 모델
LoginNetworkService *loginNetworkService;

/**
 *  로그인 버튼 터치
 */
- (IBAction)loginBtnTouched:(UIButton *)sender {
    
    if ([CheckEmailFormatHelper isValidEmailAddress:_emailTextField.text]) {
        
        NSLog(@"로그인 전송 요청 함");
        [[FIRAuth auth] signInWithEmail:_emailTextField.text password:_passwordTextField.text completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
        
            //애러나면.. 코드 적기
            if (error) {
                NSLog(@"이메일 로그인 중에 애러났어요..%@", error);
            
                // <<<<<<<<<  할 일  >>>>>>>>>
                // 여기에 비밀번호 잘못 입력하면 팝업 뜨도록 처리할 것
                // 없는 이메일이면 팝업 뜨도록 처리할 것
            
                return ;
            }
        
            //완료되면.. 코드 적고 채팅창 띄우기
            NSLog(@"유저 이메일: %@", user.email);
            NSLog(@"유저  uid: %@", user.uid);
            if (user) {
            
                //MeasurementHelper는 firebase에 로그 쌓아주는 애
                [MeasurementHelper sendLoginEvent];
            
                //완료됬으니 비동기로 요청을 보낸다.
                [loginNetworkService sendLoginAsynchronousRequest:user.uid];
            }
        
        }];
    
    } else {
        NSLog(@"이메일 형식이 아닙니다. 팝업창 만들어주세요!");
        //팝업을 띄운다.
    }
}


/**
 * 로그인 처리 콜백 함수(옵저버)
 */
- (void)didFinishLoginRequest:(NSNotification*) noti {
    
    NSLog(@"그냥 로그인 이후 콜백 함수입니다!");
    
    //결과를 뺀 뒤, afterLoginResult로 보낸다.
    NSDictionary* resultData = [[noti userInfo] objectForKey:@"loginResult"];
    [self afterLoginResult:resultData];
}

/**
 *  소셜로그인 처리 콜백 함수(옵저버)
 */
- (void)didFinishSocialLoginRequest:(NSNotification*) noti {
    NSLog(@"소셜로그인 콜백 함수_in 로그인페이지");
    //결과를 뺀 뒤, afterLoginResult로 보낸다.
    NSDictionary* resultData = [[noti userInfo] objectForKey:@"socialLoginResult"];
    [self afterLoginResult:resultData];
    
}

/**
 *  로그인 이후 userinfo에 맵핑하고 Ranking페이지로 보내는 함수(내가 만든 함수)
 */
- (void)afterLoginResult:(NSDictionary*)resultData{

    NSLog(@"afterLoginResult로 들어왔습니다.");
    
    NSUserDefaults *standardDefault = [NSUserDefaults standardUserDefaults];
    [standardDefault setObject:resultData forKey:@"userInfo"];
    [standardDefault synchronize];
    
    NSLog(@"sendLoginRequest result = %@", resultData);
    
    _designerRankingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"designerRankingViewController"];
    //DesignerRanking 뷰 컨트롤러로 보낸다.
    [self presentViewController:_designerRankingViewController animated:YES completion:nil];

}

/**
 *  키보드 날리는 함수
 */
-(void)dismissKeyboard {
    
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];

}


/**
 *  텍스트 필드의 리턴 버튼 눌렀을 때 매소드
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    return YES;

}


/**
 *  페이지 로딩 완료
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //로그인 네트워크 요청 객체 생성
    loginNetworkService = [[LoginNetworkService alloc] init];
    
    //노티를 만들고 옵저버를 add한다.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLoginRequest:) name:@"loginResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishSocialLoginRequest:) name:@"socialLoginResult" object:nil];
    
    //텍스트 필드에서 키보드 없애는 코드
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    //텍스트 필드의 delegate를 self로 지정한다.
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    
    //Firebase 인증이 완료된 이후에 로그인 화면을 자동으로 넘길 때 실행되는 리스너
    self.handle = [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nullable auth, FIRUser *_Nullable user){
        
        NSLog(@"자동로그인이에요.");
        NSLog(@"user.uid 정보에요: %@", user.uid);
        //user가 제대로 들어왔다면
        if (user) {
            
            //MeasurementHelper는 firebase에 로그 쌓아주는 애
            [MeasurementHelper sendLoginEvent];
            
            // 인증이 완료되면, 비동기로 우리 서버에 요청을 보낸다.
            [loginNetworkService sendLoginAsynchronousRequest:user.uid];
        }
        
    }];
    
    //자동 로그인을 한 번 시도했으니, 리스너를 날린다.
    [[FIRAuth auth] removeAuthStateDidChangeListener:_handle];
    
}


/**
 *  구글 로그인 클릭(AppDelegate의 메소드가 실행됨)
 */
- (IBAction)googleLoginBtnTouched:(UIButton *)sender {
    
    //혹시 몰라서 자동로그인 리스너 한 번 더 날리고 시작
    [[FIRAuth auth] removeAuthStateDidChangeListener:_handle];
    
    //Firebase 구글 로그인 설정 파일
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  회원가입 버튼을 클릭한다.
 */
- (IBAction)signUpBtnTouched:(UIButton *)sender {

    //회원가입 페이지를 만든다.
    SignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpViewController"];
    
    //뷰컨트롤러를 띄운다.
    [self presentViewController:signUpViewController animated:YES completion:nil];

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

}

//구글 로그인 인증 관련 코드
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    NSLog(@"구글 로그인을 시도해봅니다");
    
    if (error == nil) {
        NSLog(@"구글 쪽 애러는 안 난 모양입니다.");
        
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      
                                      //애러나면.. 코드 적기
                                      if (error) {
                                          NSLog(@"구글 로그인하고 파이어베이스 보내는 중에 애러났어요..%@", error);
                                          
                                          return ;
                                      }
                                      
                                      //완료되면.. 코드 적고 채팅창 띄우기
                                      NSLog(@"파이어베이스 쪽에도 잘 보냈답니다.");
                                      NSLog(@"유저 이메일: %@", user.email);
                                      NSLog(@"유저  uid: %@", user.uid);
                                      if (user) {
                                          
                                          //MeasurementHelper는 firebase에 로그 쌓아주는 애
                                          [MeasurementHelper sendLoginEvent];
                                          
                                          [[[SocialLoginNetworkService alloc] init] sendSocialLoginRequest:user.uid];
                                          
                                      }
                                  }];
    } else {
        NSLog(@"구글 로그인 중에 애러났어요..%@", error);
    }
}


@end
