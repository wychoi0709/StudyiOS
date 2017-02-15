//
//  DetailDesignerInfoViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 12..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "DetailDesignerInfoViewController.h"
#import "Location.h"
#import "SideMenuViewController.h"
#import "ColorValue.h"
#import "FullChoiceAboutMyDesignerViewController.h"
#import "ConfirmChoiceAboutMyDesignerViewController.h"
#import "ConfirmCancelAboutMyDesignerViewController.h"
#import "MyDesignerList.h"
#import "DesignerListInALocation.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface DetailDesignerInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *designerImage;
@property (weak, nonatomic) IBOutlet UILabel *designerName;
@property (weak, nonatomic) IBOutlet UILabel *designerPosition;
@property (weak, nonatomic) IBOutlet UILabel *designerMaleCustomerNumber;
@property (weak, nonatomic) IBOutlet UILabel *designerFemaleCustomerNumber;
@property (weak, nonatomic) IBOutlet UIImageView *designerHairShopImage;
@property (weak, nonatomic) IBOutlet UILabel *designerHairShopName;
@property (weak, nonatomic) IBOutlet UILabel *designerClosedDay;
@property (weak, nonatomic) IBOutlet UIButton *myDesignerButton;
@property (weak, nonatomic) IBOutlet UIButton *notMyDesignerButton;

@property NSMutableDictionary *userInfo;
@property NSDictionary *designerInfo;
@property Location *location;
@property NSNotificationCenter *notificationCenter;

@property NSUserDefaults *standardDefault;

@property Boolean isMale;

@property NSInteger customerId;
@property NSInteger locationId;
@property NSString *gender;

@property NSInteger myDesignerSeq;

@end

@implementation DetailDesignerInfoViewController

/**
 *  << 생명주기 관련 메소드 >>
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //노티 옵저버를 등록한다.
    _notificationCenter = [NSNotificationCenter defaultCenter];
    [_notificationCenter addObserver:self selector:@selector(settingBasicDataForDetailPage:) name:@"informationsForDetailDesignerPage" object:nil];
    [_notificationCenter addObserver:self selector:@selector(afterDesignerCancelNetwork:) name:@"cancelMyDesignerResult" object:nil];
    [_notificationCenter addObserver:self selector:@selector(afterDesignerAddNetwork:) name:@"addMyDesignerResult" object:nil];
    
    //NSUserDefault의 customerId, LocationId, gender 값을 빼낸다.
    _userInfo = [[NSMutableDictionary alloc] init];
    _standardDefault = [NSUserDefaults standardUserDefaults];
    _userInfo = [[_standardDefault objectForKey:@"userInfo"] mutableCopy]; //mutableCopy는 NSDictionary to NSMutableDictionary 과정
    _customerId = [[_userInfo objectForKey:@"id"] integerValue];
    _locationId = [[_userInfo objectForKey:@"location_id"] integerValue];
    _gender = [_userInfo objectForKey:@"sex"];
    if([_gender isEqualToString:@"M"]) {
        _isMale = true;
    } else {
        _isMale = false;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  << 콜백 메소드 >>
 *  페이지 로딩 이후 데이터 세팅 콜백 메소드
 */
-(void) settingBasicDataForDetailPage:(NSNotification*)noti{
    
    //어떤 버튼인지 파악한 뒤, 설정한다.
    NSString *whereIsThisViewControllerComeFrom = [[noti userInfo] objectForKey:@"whereIsThisViewControllerComeFrom"];
    if([whereIsThisViewControllerComeFrom isEqualToString:@"firstDetailDesignerInfoViewController"]) {
        _designerInfo = [[MyDesignerList getMyDesignerListObject] myDesignerList][0];
    } else if([whereIsThisViewControllerComeFrom isEqualToString:@"secondDetailDesignerInfoViewController"]) {
        _designerInfo = [[MyDesignerList getMyDesignerListObject] myDesignerList][1];
    } else if([whereIsThisViewControllerComeFrom isEqualToString:@"thirdDetailDesignerInfoViewController"]) {
        _designerInfo = [[MyDesignerList getMyDesignerListObject] myDesignerList][2];
    } else {
        _designerInfo = [[noti userInfo] objectForKey:@"designerInfo"];
    }
    
    //라벨, 버튼을 설정한다.
    _designerName.text = [_designerInfo objectForKey:@"stageName"];
    _designerPosition.text = [_designerInfo objectForKey:@"careerContents"];
    _designerMaleCustomerNumber.text = [[_designerInfo objectForKey:@"maleCustomerCount"] stringValue];
    _designerFemaleCustomerNumber.text = [[_designerInfo objectForKey:@"femaleCustomerCount"] stringValue];
    _designerHairShopName.text =[[_designerInfo objectForKey:@"hairshop"] objectForKey:@"hairshopName"];
    _designerClosedDay.text = [_designerInfo objectForKey:@"closingDay"];
    Boolean isMyDesigner = [[_designerInfo objectForKey:@"isMyDesigner"] boolValue];
    if(isMyDesigner) {
        _myDesignerButton.hidden = NO;
        _notMyDesignerButton.hidden = YES;
    } else {
        _myDesignerButton.hidden = YES;
        _notMyDesignerButton.hidden = NO;
    }
    
    //디자이너 이미지 URL, 헤어샵 이미지 URL을 추출하여 이미지를 설정한다.
    NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
    NSString *pictureUrl = [urlString stringByAppendingString:[_designerInfo objectForKey:@"filename"]];
    NSLog(@"pictureUrl: %@", pictureUrl);
    
    NSString *hairshopPictureUrl = [urlString stringByAppendingString:[[_designerInfo objectForKey:@"hairshop"] objectForKey:@"filename"]];
    NSLog(@"hairshopPictureUrl: %@", hairshopPictureUrl);
    
    [_designerImage sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
    _designerImage.layer.borderWidth = 3.0f;
    _designerImage.layer.borderColor = ([ColorValue getColorValueObject].brownColorChair).CGColor;
    _designerImage.layer.cornerRadius = _designerImage.frame.size.width / 2;
    
    [_designerHairShopImage sd_setImageWithURL:[NSURL URLWithString:hairshopPictureUrl]];
    _designerHairShopImage.layer.cornerRadius = _designerHairShopImage.frame.size.width / 2;

}

/**
 *  디자이너 등록이 완료된 이후 콜백 메소드
 */
- (void) afterDesignerAddNetwork: (NSNotification *) noti {
    NSString *result = [[[noti userInfo] objectForKey:@"resultDic"] objectForKey:@"result"];
    
    if([result isEqualToString:@"success"]) {
        _myDesignerButton.hidden = NO;
        _notMyDesignerButton.hidden = YES;
        
        if(_isMale){
            NSInteger maleCount = [[_designerInfo objectForKey:@"maleCustomerCount"] integerValue];
            maleCount++;
            _designerMaleCustomerNumber.text = [NSString stringWithFormat: @"%ld", (long)maleCount];
        } else {
            NSInteger femaleCount = [[_designerInfo objectForKey:@"femaleCustomerCount"] integerValue];
            femaleCount++;
            _designerFemaleCustomerNumber.text = [NSString stringWithFormat: @"%ld", (long)femaleCount];
        }
    }
}

/**
 *  내 디자이너 취소가 완료된 이후 콜백 메소드
 */
- (void) afterDesignerCancelNetwork: (NSNotification *) noti {
    NSLog(@"afterDesignerCancelNetwork 진입");
    NSString *result = [[[noti userInfo] objectForKey:@"resultDic"] objectForKey:@"result"];
    
    if([result isEqualToString:@"success"]) {
        _myDesignerButton.hidden = YES;
        _notMyDesignerButton.hidden = NO;
        
        if(_isMale){
            NSInteger maleCount = [[_designerInfo objectForKey:@"maleCustomerCount"] integerValue];
            maleCount--;
            _designerMaleCustomerNumber.text = [NSString stringWithFormat: @"%ld", (long)maleCount];
        } else {
            NSInteger femaleCount = [[_designerInfo objectForKey:@"femaleCustomerCount"] integerValue];
            femaleCount--;
            _designerFemaleCustomerNumber.text = [NSString stringWithFormat: @"%ld", (long)femaleCount];
        }
    }
}


/**
 *  << 버튼 관련 메소드 >>
 *  내 디자이너 등록 버튼 터치
 */
- (IBAction)addMyDesignerButton:(UIButton *)sender {
    NSLog(@"touchDownNotMyDesignerButton");
    if([[MyDesignerList getMyDesignerListObject]myDesignerList].count > 2) {
        
        //3명이 가득찼다는 모달창 만들기
        FullChoiceAboutMyDesignerViewController *fullChoiceAboutMyDesignerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fullChoiceAboutMyDesignerViewController"];
        
        //배경이 투명한 모달 스타일로 만들어준 뒤, 뷰컨트롤러를 띄운다.
        fullChoiceAboutMyDesignerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [fullChoiceAboutMyDesignerViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:fullChoiceAboutMyDesignerViewController animated:YES completion:nil];
        
        NSLog(@"3명 풀");
        return;
        
    } else {
        
        //필요한 정보를 Dictionary에 담는다.
        NSMutableDictionary *tempMutableDic = [[NSMutableDictionary alloc] init];
        [tempMutableDic setObject:_userInfo forKey:@"userInfo"];
        [tempMutableDic setObject:_designerInfo forKey:@"designerInfo"];
        
        NSDictionary *userAndDesignerinfo = tempMutableDic;
        
        //모달 창을 띄우고, 정보를 NSNotificationCenter로 보낸다.
        ConfirmChoiceAboutMyDesignerViewController *confirmChoiceAboutMyDesignerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmChoiceAboutMyDesignerViewController"];
        
        //배경이 투명한 모달 스타일로 만들어준 뒤, 뷰컨트롤러를 띄우고, 노티를 보낸다.
        confirmChoiceAboutMyDesignerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [confirmChoiceAboutMyDesignerViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:confirmChoiceAboutMyDesignerViewController animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userAndDesignerInfo" object:self userInfo:userAndDesignerinfo];
        }];
    }
}


/**
 *  내 디자이너 취소 버튼 터치
 */
- (IBAction)cancelMyDesignerButton:(UIButton *)sender {
    NSLog(@"touchDownMyDesignerButton");
    
    //필요한 정보를 Dictionary에 담는다.
    NSMutableDictionary *tempMutableDic = [[NSMutableDictionary alloc] init];
    [tempMutableDic setObject:_userInfo forKey:@"userInfo"];
    [tempMutableDic setObject:_designerInfo forKey:@"designerInfo"];
    
    NSDictionary *userAndDesignerinfo = tempMutableDic;
    
    //모달 창을 띄우고, 정보를 NSNotificationCenter로 보낸다.
    ConfirmCancelAboutMyDesignerViewController *confirmCancelAboutMyDesignerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmCancelAboutMyDesignerViewController"];
    
    //배경이 투명한 모달 스타일로 만들어준 뒤, 뷰컨트롤러를 띄우고, 노티를 보낸다.
    confirmCancelAboutMyDesignerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [confirmCancelAboutMyDesignerViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:confirmCancelAboutMyDesignerViewController animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userAndDesignerInfo" object:self userInfo:userAndDesignerinfo];
    }];
}

/**
 *  닫기 버튼을 터치한다.
 */
- (IBAction)dismissThisViewController:(UIButton *)sender {
    
    //모든 옵저버를 지운다.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //닫는다.
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
