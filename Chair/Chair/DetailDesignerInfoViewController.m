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
#import "CustomerListModalViewController.h"

//Price 콜렉션뷰 관련 import
#import "DetailPriceDesignerCollectionViewCell.h"
#import "DetailPriceDesignerCollectionReusableView.h"
#import "GetPriceInfoOfDesigner.h"

//채팅룸 관련 import
#import "ChattingRoomViewController.h"
#import "BasicButton.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface DetailDesignerInfoViewController ()

//디자이너 정보 UI관련 변수들
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
@property (weak, nonatomic) IBOutlet UIButton *chattingRoomButton;
@property (weak, nonatomic) IBOutlet UIView *infoAfterPermissionView;
@property (weak, nonatomic) IBOutlet UIView *messageButtonAndIconView;
@property (weak, nonatomic) IBOutlet UIView *brownLineAfterDesignerPermission;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintAboutPriceCollectionView;
@property (weak, nonatomic) IBOutlet UIView *viewOfPriceCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintAboutPriceCollectionVeiw;
@property (weak, nonatomic) IBOutlet BasicButton *myCustomerButton;

//기타 필요한 정보들
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

//가격정보를 위한 변수들
@property (weak, nonatomic) IBOutlet UICollectionView *priceCollectionView;
@property NSMutableArray *priceInfo;

//자신이 등록된 디자이너일 경우
@property Boolean amIDesigner;


@end

@implementation DetailDesignerInfoViewController

/**
 *  << 생명주기 관련 메소드 >>
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSUserDefault의 customerId, LocationId, gender 값을 빼낸다.
    [self extractUserInfo];
    
    //노티 옵저버를 등록한다.
    [self applyNotiObserver];
    
    _priceCollectionView.delegate = self;
    _priceCollectionView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate { return NO; }


/**
 *  << 콜백 메소드 >>
 */

//페이지 로딩 이후 데이터 세팅 콜백 메소드
-(void) settingBasicDataForDetailPage:(NSNotification*)noti{
    NSLog(@"settingBasicDataForDetailPage 콜백 진입");
    
    _amIDesigner = NO;
    
    //어떤 버튼인지 파악한 뒤, 디자이너 정보를 설정한다.
    NSString *whereIsThisViewControllerComeFrom = [[noti userInfo] objectForKey:@"whereIsThisViewControllerComeFrom"];
    if ([whereIsThisViewControllerComeFrom isEqualToString:@"firstDetailDesignerInfoViewController"]) {
        _designerInfo = [[MyDesignerList getMyDesignerListObject] myDesignerList][0];
    } else if ([whereIsThisViewControllerComeFrom isEqualToString:@"secondDetailDesignerInfoViewController"]) {
        _designerInfo = [[MyDesignerList getMyDesignerListObject] myDesignerList][1];
    } else if ([whereIsThisViewControllerComeFrom isEqualToString:@"thirdDetailDesignerInfoViewController"]) {
        _designerInfo = [[MyDesignerList getMyDesignerListObject] myDesignerList][2];
    } else if ([whereIsThisViewControllerComeFrom isEqualToString:@"registeredCustomerAsDesigner"]){
        _designerInfo = [_userInfo objectForKey:@"designer"];
        
        _amIDesigner = YES;
        
    } else {
        _designerInfo = [[noti userInfo] objectForKey:@"designerInfo"];
    }
    
    //designerInfo에 따라서 디자이너 UI를 재설정한다.
    [self setDesignerUiAsDesignerInfo];
    
    GetPriceInfoOfDesigner *getPriceInfoIfDesigner = [[GetPriceInfoOfDesigner alloc] init];
    [getPriceInfoIfDesigner getPriceInfoOfDesignerRequest:[[_designerInfo objectForKey:@"id"] intValue] withHairshopId:[[[_designerInfo objectForKey:@"hairshop"] objectForKey:@"id"] intValue]];

}

//내 디자이너 등록이 완료된 이후 콜백 메소드
- (void) afterDesignerAddNetwork: (NSNotification *) noti {
    NSLog(@"afterDesignerAddNetwork 콜백 진입");
    NSString *result = [[[noti userInfo] objectForKey:@"resultDic"] objectForKey:@"result"];
    
    //결과에 따라서 내 디자이너 등록을 반영한다.
    [self applyToResultOfMyDesignerAdd:result];

}

//내 디자이너 취소가 완료된 이후 콜백 메소드
- (void) afterDesignerCancelNetwork: (NSNotification *) noti {
    NSLog(@"afterDesignerCancelNetwork 콜백 진입");
    NSString *result = [[[noti userInfo] objectForKey:@"resultDic"] objectForKey:@"result"];

    //결과에 따라서 내 디자이너 취소를 반영한다.
    [self applyToResultOfMyDesignerCancel:result];

}

//가격 정보를 불러온 이후 콜백 메소드
- (void) afterGetPriceInfoOfDesignerNetwork: (NSNotification *) noti {

    NSLog(@"afterGetPriceInfoOfDesignerNetwork 콜백 진입");
    
    //가격 리스트를 가져옴
    _priceInfo =[[noti userInfo] objectForKey:@"priceInfo"];
    
    //collection view 갱신
    [self.priceCollectionView reloadData];
}

/**
 *  << 버튼 관련 메소드 >>
 */

//내 디자이너 등록 버튼 터치
- (IBAction)addMyDesignerButton:(UIButton *)sender {
    NSLog(@"touchDownNotMyDesignerButton");
    if([[MyDesignerList getMyDesignerListObject]myDesignerList].count > 2) {
        
        //3명 모두 찼다는 모달창 띄우기
        [self presentFullChoiceAboutMyDesignerVC];
        return;
        
    } else {
        
        //내 디자이너 등록을 확인하는 모달창에 정보를 보내면서 모달창을 띄운다.
        [self presentConfirmChoicAboutMyDesignerVCWithData];
        
    }
}

//내 디자이너 취소 버튼 터치
- (IBAction)cancelMyDesignerButton:(UIButton *)sender {
    NSLog(@"touchDownMyDesignerButton");
    
    //내 디자이너 취소를 위한 정보를 보내면서 모달을 띄운다.
    [self presentConfirmCancelAboutMyDesignerViewControllerVCWithData];

}

//닫기 버튼을 터치한다.
- (IBAction)dismissThisViewController:(UIButton *)sender {
    
    //모든 옵저버를 지운다.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //닫는다.
    [self dismissViewControllerAnimated:YES completion:nil];
}

//채팅방으로 이동하는 버튼을 터치했음.
- (IBAction)moveChatroom:(UIButton *)sender {
    
    Boolean isDesigner = NO;
    
    NSMutableDictionary *meta = [[NSMutableDictionary alloc] init];
    [meta setObject:_designerInfo forKey:@"designerInfo"];
    [meta setObject:_userInfo forKey:@"userInfo"];
    [meta setObject:[NSNumber numberWithBool:isDesigner] forKey:@"isDesigner"];
    
    NSLog(@"designer & customer Uid = %@", meta);
    
    ChattingRoomViewController *chattingRoomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"chattingRoomViewController"];
    [self presentViewController:chattingRoomViewController animated:YES completion:^(){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getDesignerAndCutomerUid" object:self userInfo:meta];
    }];
}

- (IBAction)myCustomerButtonTouched:(BasicButton *)sender {
    
    //모달창을 만들고 투명한 모달 스타일로 설정해서 띄운다.
    CustomerListModalViewController *customerListModalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"customerListModalViewController"];
    customerListModalViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [customerListModalViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self presentViewController:customerListModalViewController animated:YES completion:nil];
    
}

/**
 *  콜렉션 뷰 관련 메소드들
 */

//각 인덱스에 맞는 셀을 설정해주는 메소드(DataSource)
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"가격 정보에 대한 cellForItemAtIndexPath 메소드에 들어옴");
    NSDictionary *aPriceinfo = _priceInfo[indexPath.row];
    
    NSString *styleName = [aPriceinfo objectForKey:@"styleName"];
    NSString *sex = [aPriceinfo objectForKey:@"sex"];
    NSString *price = [[aPriceinfo objectForKey:@"price"] stringValue];

    DetailPriceDesignerCollectionViewCell *detailPriceDesignerCollectionViewCell =[collectionView dequeueReusableCellWithReuseIdentifier:@"detailPriceDesignerCollectionViewCell" forIndexPath:indexPath];
    
    detailPriceDesignerCollectionViewCell.styleName.text = styleName;
    detailPriceDesignerCollectionViewCell.sex.text = sex;
    detailPriceDesignerCollectionViewCell.price.text = price;

    return detailPriceDesignerCollectionViewCell;
}

//Section 안에 몇개의 아이템이 들어가는지 설정(DataSrouce)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //Price 정보가 얼마나 되는지 count를 셀 것
    return _priceInfo.count;
}

//Section의 헤더 만들기(DataSource)
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    DetailPriceDesignerCollectionReusableView *sectionHeader = [self.priceCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"detailPriceDesignerCollectionReusableView" forIndexPath:indexPath];
    
    return sectionHeader;
    ;
}

//Section이 몇개인지(DataSource)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


/**
 *  << 내가 만든 메소드(정리용) >>
 */

//노티 옵저버를 등록한다.
- (void) applyNotiObserver {
    _notificationCenter = [NSNotificationCenter defaultCenter];
    [_notificationCenter addObserver:self selector:@selector(settingBasicDataForDetailPage:) name:@"informationsForDetailDesignerPage" object:nil];
    [_notificationCenter addObserver:self selector:@selector(afterDesignerCancelNetwork:) name:@"cancelMyDesignerResult" object:nil];
    [_notificationCenter addObserver:self selector:@selector(afterDesignerAddNetwork:) name:@"addMyDesignerResult" object:nil];
    [_notificationCenter addObserver:self selector:@selector(afterGetPriceInfoOfDesignerNetwork:) name:@"priceRequestResult" object:nil];
}

//NSUserDefault의 customerId, LocationId, gender 값을 빼낸다.
- (void) extractUserInfo{
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

//designerInfo에 따라서 디자이너 UI를 재설정한다.
- (void) setDesignerUiAsDesignerInfo {
    
    //라벨, 버튼 UI를 설정한다.
    _designerName.text = [_designerInfo objectForKey:@"stageName"];
    _designerPosition.text = [_designerInfo objectForKey:@"careerContents"];
    _designerMaleCustomerNumber.text = [[_designerInfo objectForKey:@"maleCustomerCount"] stringValue];
    _designerFemaleCustomerNumber.text = [[_designerInfo objectForKey:@"femaleCustomerCount"] stringValue];
    _designerHairShopName.text =[[_designerInfo objectForKey:@"hairshop"] objectForKey:@"hairshopName"];
    _designerClosedDay.text = [_designerInfo objectForKey:@"closingDay"];
    
    //디자이너 등록을 마친 customer가 자기 페이지로 들어온 경우임.
    if(_amIDesigner) {
        
        //인포 정보, 고객보기 버튼 활성화
        _infoAfterPermissionView.hidden = NO;
        _myCustomerButton.hidden = NO;
        
        //채팅버튼을 없앨 것. 디자이너 등록/취소 버튼을 없앨 것.
        _messageButtonAndIconView.hidden = YES;
        _myDesignerButton.hidden = YES;
        _notMyDesignerButton.hidden = YES;
        
        //콜렉션뷰 위치 수정
        NSLayoutConstraint *newTopConstraintForCollectionView =
        [NSLayoutConstraint constraintWithItem:_viewOfPriceCollectionView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_brownLineAfterDesignerPermission
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:0.0];
        
        [self.view addConstraint:newTopConstraintForCollectionView];
        [self.view removeConstraint:_topConstraintAboutPriceCollectionView];
        
        NSLayoutConstraint *newBottomConstraintForCollectionView =
        [NSLayoutConstraint constraintWithItem:_viewOfPriceCollectionView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_infoAfterPermissionView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0.0];
        
        [self.view addConstraint:newBottomConstraintForCollectionView];
        [self.view removeConstraint:_bottomConstraintAboutPriceCollectionVeiw];
        
        [self.view updateConstraints];
        
    //일반 디자이너 페이지에 들어온 경우임.
    } else {
        Boolean isMyDesigner = [[_designerInfo objectForKey:@"isMyDesigner"] boolValue];
        if(isMyDesigner) {
            _myDesignerButton.hidden = NO;
            _notMyDesignerButton.hidden = YES;
        } else {
            _myDesignerButton.hidden = YES;
            _notMyDesignerButton.hidden = NO;
        }
        
        _infoAfterPermissionView.hidden = YES;
        _myCustomerButton.hidden = YES;
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
    _designerImage.clipsToBounds = YES;
    
    [_designerHairShopImage sd_setImageWithURL:[NSURL URLWithString:hairshopPictureUrl]];
    _designerHairShopImage.layer.cornerRadius = _designerHairShopImage.frame.size.width / 2;
    _designerHairShopImage.clipsToBounds = YES;
}

//결과에 따라서 내 디자이너 등록을 반영한다.
- (void) applyToResultOfMyDesignerAdd:(NSString*) result {
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

//결과에 따라서 내 디자이너 취소를 반영한다.
- (void) applyToResultOfMyDesignerCancel:(NSString*) result {
    
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

//3명 모두 찼다는 모달창 띄우기
- (void) presentFullChoiceAboutMyDesignerVC {
    //3명이 가득찼다는 모달창 만들기
    FullChoiceAboutMyDesignerViewController *fullChoiceAboutMyDesignerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fullChoiceAboutMyDesignerViewController"];
    
    //배경이 투명한 모달 스타일로 만들어준 뒤, 뷰컨트롤러를 띄운다.
    fullChoiceAboutMyDesignerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [fullChoiceAboutMyDesignerViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:fullChoiceAboutMyDesignerViewController animated:YES completion:nil];
    
    NSLog(@"3명 풀");
}

//내 디자이너 등록을 확인하는 모달창에 정보를 보내면서 모달창을 띄운다.
- (void) presentConfirmChoicAboutMyDesignerVCWithData{
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

//내 디자이너 취소를 위한 정보를 보내면서 모달을 띄운다.
- (void) presentConfirmCancelAboutMyDesignerViewControllerVCWithData{
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
@end
