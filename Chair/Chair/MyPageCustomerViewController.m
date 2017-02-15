//
//  MyPageCustomerViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 2. 9..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "MyPageCustomerViewController.h"
#import "LocationSelectModalViewController.h"

@interface MyPageCustomerViewController ()

//기본 데이터 및 필요 변수들
@property NSMutableDictionary *userInfo;
@property NSNotificationCenter *notificationCenter;
@property NSUserDefaults *standardDefault;
@property NSInteger customerId;
@property NSInteger locationId;
@property NSString *gender;
@property NSString *location;

//페이지에 필요한 것들
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageGenderSelecterFemale;
@property (weak, nonatomic) IBOutlet UIImageView *imageGenderSelecterMale;
@property Boolean isMale;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation MyPageCustomerViewController

/**
 *  << 생명 주기 관련 메소드 >>
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //노티 옵저버 등록(장소 선택 이후 콜백 / )
    _notificationCenter = [NSNotificationCenter defaultCenter];
    [_notificationCenter addObserver:self selector:@selector(afterLocationSelect:) name:@"informationsForDetailDesignerPage" object:nil];
    
    //데이터 로딩, UIView에 세팅
    [self basicDataLoading];
    [self dataSettingInUIView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  << 콜백 메소드 >>
 *  로케이션 모달에서 장소 선택 이후 콜백 메소드
 */
- (void)afterLocationSelect:(NSNotification*)noti{
    
    //장소 정보를 바꾸고, 반영한다.
    _location = [[noti userInfo] objectForKey:@"location"];
    _locationId = [[[noti userInfo] objectForKey:@"locationId"] integerValue];
    [self dataSettingInUIView];
    
}


/**
 *  << 내가 만든 버튼들 >>
 *  현재 뷰컨트롤러 닫기 버튼 터치
 */
- (IBAction)closeBtnTouched:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pictureEditBtnTouched:(UIButton *)sender {
    
}

- (IBAction)nameEditBtnTouched:(UIButton *)sender {
}

- (IBAction)femaleGenderSelectBtnTouched:(UIButton *)sender {
    _imageGenderSelecterFemale.hidden = NO;
    _imageGenderSelecterMale.hidden = YES;
    _isMale = false;
}

- (IBAction)maleGenderSelectBtnTouched:(UIButton *)sender {
    _imageGenderSelecterFemale.hidden = YES;
    _imageGenderSelecterMale.hidden = NO;
    _isMale = true;
}

//locationSelectModal 열기 메소드
- (IBAction)locationChangeBtnTouched:(UIButton *)sender {
    [self openLocationSelectModalVC];
}

- (IBAction)myInfoConfirmBtnTouched:(UIButton *)sender {
    //_isMale에 따라 gender를 설정하고, 사진, 이름, 지역id, 고객id 같이 다 네트워크 요청을 보낸다.
    //이후 콜백할 때는 Ranking과 Side 메뉴에도 적용되도록 해야한다. 거기서 나왔기 때문.
}


/**
 *  << 현재 뷰컨트롤러 안에서만 쓰일 메소드들(정리용) >>
 *  페이지 로딩
 */
- (void)basicDataLoading {
    //NSUserDefault의 customerId, LocationId, gender 값을 빼낸다.
    _userInfo = [[NSMutableDictionary alloc] init];
    _standardDefault = [NSUserDefaults standardUserDefaults];
    _userInfo = [[_standardDefault objectForKey:@"userInfo"] mutableCopy];
    _customerId = [[_userInfo objectForKey:@"id"] integerValue];
    _locationId = [[_userInfo objectForKey:@"location_id"] integerValue];
    _gender = [_userInfo objectForKey:@"sex"];
    if([_gender isEqualToString:@"M"]) { _isMale = true; } else { _isMale = false; }
    _location =[[_userInfo objectForKey:@"location"] objectForKey:@"location"];
}

- (void)dataSettingInUIView {
    _nameLabel.text = [_userInfo objectForKey:@"name"];
    if(_isMale) {
        _imageGenderSelecterFemale.hidden = YES;
        _imageGenderSelecterMale.hidden = NO;
    } else {
        _imageGenderSelecterFemale.hidden = NO;
        _imageGenderSelecterMale.hidden = YES;
    }
    _locationLabel.text = _location;
}

- (void)openLocationSelectModalVC {
    
    //모달창을 만든다.
    LocationSelectModalViewController *locationSelectModalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationSelectModalViewController"];
    
    //배경이 투명한 모달 스타일로 만들어준 뒤, 뷰컨트롤러를 띄운다.
    locationSelectModalViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [locationSelectModalViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:locationSelectModalViewController animated:YES completion:nil];

}

//사진, 앨범 피커 샘플 찾아보기
- (void)openCameraAndAlbumSelect {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
    }
}
@end
