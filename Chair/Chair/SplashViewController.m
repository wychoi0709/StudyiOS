//
//  SplashViewController.m
//  Chair
//
//  Created by 최원영 on 2016. 12. 10..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "SplashViewController.h"
#import "LoginViewController.h"
#import "Location.h"

@interface SplashViewController ()

//ConnectionDelegate에서 쓸 변수(응답받은 변수)
@property NSMutableData *responseData;

//네트워크 통신에 필요한 변수들
@property NSString *aURLString;
@property NSString *aFormData;
@property NSURL *aURL;
@property NSMutableURLRequest *aRequest;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //서버에서 Location 정보를 받아온 뒤, 노티 센터로 노티를 쏜다.
    
    //URL String을 토대로 URL 객체를 만든 뒤, 이를 토대로 Request 객체를 생성한다.
    _aURLString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
    _aURLString = [_aURLString stringByAppendingString:@"/location/selectlocations"];
    _aURL = [NSURL URLWithString:_aURLString];
    _aRequest = [NSMutableURLRequest requestWithURL:_aURL];
    
    //Request 객체를 Setting한다.
    [_aRequest setHTTPMethod:@"GET"];
    
    //커넥션을 만든 뒤, 실행시킨다.
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:_aRequest delegate:self];
    [conn start];
    
    [self performSelector:@selector(moveLoginViewController) withObject:nil afterDelay:0.3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  로그인뷰컨트롤러로 이동시켜주는 메소드
 */
- (void)moveLoginViewController {
    NSLog(@"Enter moveLoginViewController Method");
    
    //로그인 뷰컨트롤러를 만들고 거기로 보낸다.
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self presentViewController:loginViewController animated:YES completion:nil];
}



/**
 *  [NSURLConnectionDelegate]Response에서 Header부분을 받고 호출되는 메소드
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //응답받을 데이터 변수를 초기화한다.
    _responseData = [[NSMutableData alloc] init];

    
}


/**
 *  [NSURLConnectionDelegate]Response에서 데이터를 받는 메소드
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //응답받은 데이터를 붙인다(데이터가 크면 여러번 실행될 수 있다)
    [_responseData appendData:data];
    
}


/**
 *  [NSURLConnectionDelegate] 모든 통신이 완료된 후 실행되는 메소드
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //결과를 파싱한다(추후에 VO를 어떻게 쓸지 생각해 볼 것)
    NSDictionary *dataDictionary = [NSJSONSerialization
                                    JSONObjectWithData:_responseData
                                    options:NSJSONReadingMutableContainers
                                    error:nil];
    NSLog(@"Location result = %@", dataDictionary);
    

    //결과를 NSUserDefaults에 저장하거나 업데이트한다(추후에는 버전만 확인하고 업데이트는 선별적으로)
    NSUserDefaults *standardDefault = [NSUserDefaults standardUserDefaults];
    [standardDefault setObject:dataDictionary forKey:@"locationData"];
    [standardDefault synchronize];
    
    //딜레이를 1초간 주고, moveloginViewController 메소드를 실행한다.
    [self performSelector:@selector(moveLoginViewController) withObject:nil afterDelay:0.3];
    
}


/**
 *  [NSURLConnectionDelegate]애러나면 실행되는 코드
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    //네트워크 연결이 안되어 있다고 다이얼로그 띄우고, 확인 누르면 위에 코드 재시도
    //딜레이를 1초간 주고, moveloginViewController 메소드를 실행한다.
    [self performSelector:@selector(moveLoginViewController) withObject:nil afterDelay:0.3];
    
    
}


@end
