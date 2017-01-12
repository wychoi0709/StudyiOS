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
@property (weak, nonatomic) IBOutlet UIButton *invisibleButtonForSideMenu;

@property NSMutableDictionary *userInfo;
@property NSDictionary *designerInfo;
@property Location *location;
@property NSNotificationCenter *notificationCenter;

@property NSInteger myDesignerCount;
@property NSMutableArray *onlyMyDesignerList;

@property SideMenuViewController *mySideMenuViewController;

@property NSUserDefaults *standardDefault;
@property NSIndexPath *indexPath;

@property Boolean isMale;

@property NSInteger customerId;
@property NSInteger locationId;
@property NSString *gender;

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
    
    //SideMenu 만들고 설정하기
    _mySideMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    self.leftViewBackgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.leftViewBackgroundColor = [UIColor colorWithRed:0.25098039215686 green:0.27843137254902 blue:0.34725490196078 alpha:0.47];
    self.rootViewCoverColorForLeftView = [[ColorValue getColorValueObject]blackBlueColorChiar];
    self.leftViewController = _mySideMenuViewController;

    //onlyMyDesignerList를 초기화한다.
    _onlyMyDesignerList = [[NSMutableArray alloc] init];
    
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
    
    //임시 indexPath를 초기화한다.
    _indexPath = [[NSIndexPath alloc] init];

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
    
    //내 디자이너 관련 정보를 넣는다.
    _myDesignerCount = [[[noti userInfo] objectForKey:@"myDesignerCount"] integerValue];
    if(_myDesignerCount > 0) {
        _onlyMyDesignerList = [[noti userInfo] objectForKey:@"onlyMyDesignerList"];
    }
    _designerInfo = [[noti userInfo] objectForKey:@"designerInfo"];
    
    //라벨, 버튼, 이미지를 설정한다.
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
}

/**
 *  디자이너 등록이 완료된 이후 콜백 메소드
 */
- (void) afterDesignerAddNetwork: (NSNotification *) noti {
    NSString *result = [[[noti userInfo] objectForKey:@"resultDic"] objectForKey:@"result"];
    
    if([result isEqualToString:@"success"]) {
        _myDesignerCount++;
        _myDesignerButton.hidden = NO;
        _notMyDesignerButton.hidden = YES;
        
        //등록이 완료되면, 디자이너리스트에 있는 디자이너를 내 디자이너 리스트에 담아
        [_onlyMyDesignerList addObject:_designerInfo];
        
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
    NSString *result = [[[noti userInfo] objectForKey:@"resultDic"] objectForKey:@"result"];
    
    if([result isEqualToString:@"success"]) {
        _myDesignerCount--;
        _myDesignerButton.hidden = YES;
        _notMyDesignerButton.hidden = NO;
        
        //취소한 디자이너를 onlyMyDesignerList에서 제거한다.
        for(int i =0; i < _onlyMyDesignerList.count; i++) {
            if([_onlyMyDesignerList[i] objectForKey:@"id"] == [_designerInfo objectForKey:@"id"]){
                [_onlyMyDesignerList removeObject:_onlyMyDesignerList[i]];
            }
        }
        
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
 *  사이드 메뉴 버튼 터치
 */
- (IBAction)sideMenuButtonTouched:(UIButton *)sender {
    
    //임시 MutableDic을 만든다.
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    
    //designerRankingViewController 라고 메시지를 담는다.
    NSString *thisViewController = @"detailDesignerInfoViewController";
    [tempDic setObject:thisViewController forKey:@"whereIsThisViewControllerComeFrom"];
    
    //myDesignerCount를 담는다.
    [tempDic setObject:[NSNumber numberWithInteger:_myDesignerCount] forKey:@"myDesignerCount"];
    
    //myDesignerCount가 0보다 크면, onlyMyDesignerList Array를 담고, 0이면 임시 값을 담는다.
    if(_myDesignerCount > 0) {
        [tempDic setObject:_onlyMyDesignerList forKey:@"onlyMyDesignerList"];
    } else {
        NSMutableArray *emptyMyDesignerList = [[NSMutableArray alloc] init];
        [emptyMyDesignerList addObject:@"임시 값"];
        [tempDic setObject:_onlyMyDesignerList forKey:@"onlyMyDesignerList"];
    }
    
    //결과 Dic에 넣는다.
    NSDictionary *whereIsThisViewControllerComeFrom = tempDic;
    
    //노티를 보낸다.
    [_notificationCenter postNotificationName:@"guidingPreviousViewController" object:self userInfo:whereIsThisViewControllerComeFrom];
    
    //사이드메뉴를 띄운다.
    [self showLeftViewAnimated:YES completionHandler:^{
        //사이드 메뉴 닫기 버튼 구역을 보이게 한다.
        _invisibleButtonForSideMenu.hidden = NO;
    }];
    
}

/**
 *  사이드 메뉴를 없애는 버튼(안보임)
 */
- (IBAction)hiddenLeftSideMenuBtnTouched:(UIButton *)sender {
    [self hideLeftViewAnimated:YES completionHandler:nil];
    _invisibleButtonForSideMenu.hidden = YES;
}

/**
 *  내 디자이너 등록버튼을 클릭한다.
 */
- (IBAction)addMyDesignerButton:(UIButton *)sender {
    NSLog(@"touchDownNotMyDesignerButton");
    if(_myDesignerCount > 2) {
        
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
        [tempMutableDic setObject:_indexPath forKey:@"indexPath"];
        
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
 *  내 디자이너를 취소한다.
 */
- (IBAction)cancelMyDesignerButton:(UIButton *)sender {
    NSLog(@"touchDownMyDesignerButton");
    
    //필요한 정보를 Dictionary에 담는다.
    NSMutableDictionary *tempMutableDic = [[NSMutableDictionary alloc] init];
    [tempMutableDic setObject:_userInfo forKey:@"userInfo"];
    [tempMutableDic setObject:_designerInfo forKey:@"designerInfo"];
    [tempMutableDic setObject:_indexPath forKey:@"indexPath"];
    
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

@end
