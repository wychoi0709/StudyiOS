//
//  MyPageCustomerViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 2. 9..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "MyPageCustomerViewController.h"
#import "LocationSelectModalViewController.h"
#import "Location.h"
#import "ImageResizeUtil.h"
#import "EditMyPageNetworkService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ColorValue.h"

@interface MyPageCustomerViewController ()

//기본 데이터 및 필요 변수들
@property NSMutableDictionary *userInfo;
@property NSNotificationCenter *notificationCenter;
@property NSUserDefaults *standardDefault;
@property NSInteger customerId;
@property NSInteger locationId;
@property NSString *gender;
@property Location *location;
@property NSString *locationText;
@property NSData *myImageData;
@property NSString* urlString;
@property NSString* pictureUrl;

//페이지에 필요한 것들
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageGenderSelecterFemale;
@property (weak, nonatomic) IBOutlet UIImageView *imageGenderSelecterMale;
@property Boolean isMale;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myPictureImageView;

@end

@implementation MyPageCustomerViewController

/**
 *  << 생명 주기 관련 메소드 >>
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //노티 옵저버 등록(장소 선택 이후 콜백 / )
    _notificationCenter = [NSNotificationCenter defaultCenter];
    [_notificationCenter addObserver:self selector:@selector(afterLocationSelect:) name:@"changeMyLocation" object:nil];
    [_notificationCenter addObserver:self selector:@selector(afterUpdateMyInfoResult:) name:@"updateMyInfoResult" object:nil];
    
    //데이터 로딩, UIView에 세팅
    [self basicDataLoading];
    [self dataSettingInUIView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate { return NO; }


/**
 *  << 콜백 메소드 >>
 *  로케이션 모달에서 장소 선택 이후 콜백 메소드
 */
- (void)afterLocationSelect:(NSNotification*)noti{
    
    //장소 정보를 바꾸고, 반영한다.
    _location = [[noti userInfo] objectForKey:@"myLocation"];
    _locationId = _location.id;
    _locationText = _location.location;
    
    [self dataSettingInUIView];
}

- (void)afterUpdateMyInfoResult:(NSNotification*)noti{
    
    NSLog(@"업데이트 결과가 왔고, 콜백 메소드");
    
    //데이터 다시 로딩, UIView에 다시 세팅
    [self basicDataLoading];
    [self dataSettingInUIView];
}


/* 이미지 선택 이후 실행되는 콜백 메소드 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [ImageResizeUtil imageWithImage:chosenImage scaledToSize:CGSizeMake(50, 50)];
    
    _myPictureImageView.image = resizedImage;
    
    //코너를 동그랗게 만든다.
    _myPictureImageView.layer.borderWidth = 3.0f;
    _myPictureImageView.layer.borderColor = ([ColorValue getColorValueObject].brownColorChair).CGColor;
    _myPictureImageView.layer.cornerRadius = _myPictureImageView.frame.size.width / 2;
    _myPictureImageView.clipsToBounds = YES;
    
    _myImageData = UIImagePNGRepresentation(resizedImage);
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/* 이미지 선택을 취소했을때 콜백 메소드 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


/**
 *  << 내가 만든 버튼들 >>
 *  현재 뷰컨트롤러 닫기 버튼 터치
 */
- (IBAction)closeBtnTouched:(UIButton *)sender {
    //모든 옵저버를 지운다.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* 사진 수정 버튼 터치 */
- (IBAction)pictureEditBtnTouched:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"사진 선택"
                                                                   message:@"사진을 선택해주세요."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* albumAction = [UIAlertAction actionWithTitle:@"앨범" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self doAfterAlbumChoice];
                                                        }];
    [alert addAction:albumAction];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [self doAfterCameraChoice];
                                                             }];
        [alert addAction:cameraAction];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

/* 이름 수정 버튼 터치 */
- (IBAction)nameEditBtnTouched:(UIButton *)sender {
}

/* 여성 라디오 버튼 터치 */
- (IBAction)femaleGenderSelectBtnTouched:(UIButton *)sender {
    _imageGenderSelecterFemale.hidden = NO;
    _imageGenderSelecterMale.hidden = YES;
    _isMale = false;
}

/* 남성 라디오 버튼 터치 */
- (IBAction)maleGenderSelectBtnTouched:(UIButton *)sender {
    _imageGenderSelecterFemale.hidden = YES;
    _imageGenderSelecterMale.hidden = NO;
    _isMale = true;
}

/* locationSelectModal 열기 메소드 */
- (IBAction)locationChangeBtnTouched:(UIButton *)sender {
    [self openLocationSelectModalVC];
}

/* 내 정보 수정 완료 버튼 터치 */
- (IBAction)myInfoConfirmBtnTouched:(UIButton *)sender {
    //_isMale에 따라 gender를 설정하고, 사진, 이름, 지역id, 고객id 같이 다 네트워크 요청을 보낸다.
    //이후 콜백할 때는 Ranking과 Side 메뉴에도 적용되도록 해야한다. 거기서 나왔기 때문.
    NSString *gender;
    if(_isMale) { gender = @"M"; } else { gender = @"F"; }
    
    //userInfo에 filename이 있는지 여부도 같이 보낸다.
    Boolean isFilenameInUserInfo = false;
    if( [_userInfo objectForKey:@"filename"] ) {
        isFilenameInUserInfo = true;
    }
    
    EditMyPageNetworkService *editMyPageNetworkService = [[EditMyPageNetworkService alloc] init];
    [editMyPageNetworkService editMyInfo:_customerId withLocationId:_locationId withGender:gender withName:_nameLabel.text withPicture:_myImageData withIsFilenameInUserInfo: [NSNumber numberWithBool:isFilenameInUserInfo]  withUid: [_userInfo objectForKey:@"uid"]];
    
    [self setLocationIntoUserInfo];
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
    _locationText =[[_userInfo objectForKey:@"location"] objectForKey:@"location"];
    
    //하아.. 로케이션 VO 괜히 만들어서 고생 중ㅠㅠ
    _location = [[Location alloc] init];
    _location.id = [[[_userInfo objectForKey:@"location"] objectForKey:@"id"] integerValue];
    _location.city = [[_userInfo objectForKey:@"location"] objectForKey:@"city"];
    _location.cityDetail = [[_userInfo objectForKey:@"location"] objectForKey:@"cityDetail"];
    _location.location = [[_userInfo objectForKey:@"location"] objectForKey:@"location"];
    _location.locationDetail = [[_userInfo objectForKey:@"location"] objectForKey:@"locationDetail"];
    
    //이미지 세팅할 것 URL 불러와서 앞에 붙이고 SD뭐시기로 넣어!
    _urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
    _pictureUrl = [_urlString stringByAppendingString:[_userInfo  objectForKey:@"filename"]];
    NSLog(@"pictureUrl: %@", _pictureUrl);

}

/* UIView에 데이터를 세팅한다. */
- (void)dataSettingInUIView {
    
    _nameLabel.text = [_userInfo objectForKey:@"name"];
    if(_isMale) {
        _imageGenderSelecterFemale.hidden = YES;
        _imageGenderSelecterMale.hidden = NO;
    } else {
        _imageGenderSelecterFemale.hidden = NO;
        _imageGenderSelecterMale.hidden = YES;
    }
    _locationLabel.text = _locationText;
    
    [_myPictureImageView sd_setImageWithURL:[NSURL URLWithString:_pictureUrl]];
    _myPictureImageView.layer.borderWidth = 3.0f;
    _myPictureImageView.layer.borderColor = ([ColorValue getColorValueObject].brownColorChair).CGColor;
    _myPictureImageView.layer.cornerRadius = _myPictureImageView.frame.size.width / 2;
    _myPictureImageView.clipsToBounds = YES;

    
}

/* 장소 수정 모달 띄우기 */
- (void)openLocationSelectModalVC {
    
    //모달창을 만든다.
    LocationSelectModalViewController *locationSelectModalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationSelectModalViewController"];
    
    //배경이 투명한 모달 스타일로 만들어준 뒤, 뷰컨트롤러를 띄운다.
    locationSelectModalViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [locationSelectModalViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:locationSelectModalViewController animated:YES completion:nil];

}

/* 내 장소 정보를 바꾸고, 반영한다. */
- (void)setLocationIntoUserInfo {
    
    NSLog(@"작업 이전에 userInfo: %@", _userInfo);
    NSMutableDictionary *locationForUserInfo = [[NSMutableDictionary alloc] init];
    [locationForUserInfo setObject:[NSNumber numberWithInteger:_location.id] forKey:@"id"];
    [locationForUserInfo setObject:_location.city forKey:@"city"];
    [locationForUserInfo setObject:_location.cityDetail forKey:@"cityDetail"];
    [locationForUserInfo setObject:_location.location forKey:@"location"];
    [locationForUserInfo setObject:_location.locationDetail forKey:@"locationDetail"];
    
    [_userInfo setObject:locationForUserInfo forKey:@"location"];
    [_userInfo setObject:@(_locationId) forKey:@"location_id"];
    
    NSLog(@"작업 이후의 userInfo: %@", _userInfo);
    
    [_standardDefault setObject:_userInfo forKey:@"userInfo"];
    [_standardDefault synchronize];
    
}

/* 앨범,카메라 피커에서 앨범 선택했을 때 */
- (void)doAfterAlbumChoice{
    NSLog(@"doAfterAlbumChoice");
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

/* 앨범,카메라 피커에서 카메라 선택했을 때 */
- (void)doAfterCameraChoice{
    NSLog(@"doAfterCameraChoice");
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}
@end
