//
//  DesignerRankingViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 1..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "DesignerRankingViewController.h"
#import "SideMenuViewController.h"

#import "RankingBetterDesignerCollectionViewCell.h"
#import "RankingNormalDesignerCollectionViewCell.h"
#import "DesignerRankingNetworkService.h"
#import "RankingSectionHeaderCollectionReusableView.h"
#import "LocationSelectModalViewController.h"
#import "Location.h"
#import "ColorValue.h"

#import "ConfirmChoiceAboutMyDesignerViewController.h"
#import "FullChoiceAboutMyDesignerViewController.h"
#import "ConfirmCancelAboutMyDesignerViewController.h"
#import "DetailDesignerInfoViewController.h"

#import "MyDesignerList.h"
#import "DesignerListInALocation.h"
#import "GetMyDesignerListNetworkService.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface DesignerRankingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *genderChangeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *rankingCollectionView;
@property (weak, nonatomic) IBOutlet UIView *emptyDesignerImage;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *invisibleButtonForSideMenu;

@property DesignerRankingNetworkService *designerRankingNetworkService;
@property LocationSelectModalViewController *locationSelectModalViewController;
@property SideMenuViewController *mySideMenuViewController;
@property ConfirmChoiceAboutMyDesignerViewController *confirmChoiceAboutMyDesignerViewController;
@property FullChoiceAboutMyDesignerViewController *fullChoiceAboutMyDesignerViewController;

@property NSNotificationCenter *notificationCenter;

@property NSMutableDictionary *userInfo;

@property NSMutableArray *onlyMyDesignerList;

@property Boolean isMale;

@property NSUserDefaults *standardDefault;

@property NSInteger myDesignerCount;

//디자이너 리스트 네트워크 요청을 위한 변수들
@property NSInteger customerId;
@property NSInteger locationId;
@property NSString *gender;

@property NSIndexPath *targetIndexPath;

@end

@implementation DesignerRankingViewController

/**
 *  <지금부터 뷰생명주기 관련 메소드>
 *  뷰의 로드가 마쳐질 때 불리는 메소드
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //delegate 지정
    _rankingCollectionView.delegate = self;
    _rankingCollectionView.dataSource = self;
    
    //임시 이미지와 검색바를 hidden 처리한다.
    _emptyDesignerImage.hidden = YES;
    _searchBar.hidden = YES;
    _invisibleButtonForSideMenu.hidden = YES;
    
    //NSUserDefault의 customerId, LocationId, gender 값을 빼낸다.
    _userInfo = [[NSMutableDictionary alloc] init];
    _standardDefault = [NSUserDefaults standardUserDefaults];
    _userInfo = [[_standardDefault objectForKey:@"userInfo"] mutableCopy]; //mutableCopy는 NSDictionary to NSMutableDictionary 과정
    _customerId = [[_userInfo objectForKey:@"id"] integerValue];
    _locationId = [[_userInfo objectForKey:@"location_id"] integerValue];
    _gender = [_userInfo objectForKey:@"sex"];
    
    //location label을 세팅한다.
    _locationLabel.text = [[_userInfo objectForKey:@"location"] objectForKey:@"location"];
    
    //성별에 따라 genderButton의 타이틀 텍스트를 변경한다.
    [self changeGenderButtonTitleTextByGender];
    
    //ranking 정보 불러오는 네트워크 요청을 실시한다
    _designerRankingNetworkService = [[DesignerRankingNetworkService alloc] init];
    [_designerRankingNetworkService callDesignerListByLocationIdRequest:_customerId withLocationId:_locationId withGender:_gender];
    
    //내 디자이너 정보를 불러오는 네트워크 요청을 실시한다.
    [[[GetMyDesignerListNetworkService alloc] init] getMyDesignerListRequest:_customerId];

    //옵저버 지정(콜백에서 Array 갱신하고, collectionview도 갱신할 것)
    _notificationCenter = [NSNotificationCenter defaultCenter];
    [_notificationCenter addObserver:self selector:@selector(designerListDidLoad:) name:@"designerListResult" object:_designerRankingNetworkService];
    [_notificationCenter addObserver:self selector:@selector(changeTempLocation:) name:@"changeMyLocation" object:_locationSelectModalViewController];
    [_notificationCenter addObserver:self selector:@selector(afterDesignerAddNetwork:) name:@"addMyDesignerResult" object:nil];
    [_notificationCenter addObserver:self selector:@selector(afterDesignerCancelNetwork:) name:@"cancelMyDesignerResult" object:nil];
    
    //SideMenu 만들고 설정하기
    _mySideMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    self.leftViewBackgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.leftViewBackgroundColor = [UIColor colorWithRed:0.25098039215686 green:0.27843137254902 blue:0.34725490196078 alpha:0.47];
    self.rootViewCoverColorForLeftView = [[ColorValue getColorValueObject]blackBlueColorChiar];
    self.leftViewController = _mySideMenuViewController;
    
    //collectionView의 selected 효과에 딜레이를 없애는 코드
    self.rankingCollectionView.delaysContentTouches = NO;
    
}

/**
 *  메모리 경고 떴을 때 불리는 메소드
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    return self;
}

/**
 *  현 VC가 없어질 떄 실행되는 메소드
 */
- (void)dealloc {
    //지금 달려있는 VC의 모든 옵저버를 없앰
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



/**
 *  <지금부터 내가 만든 메소드>
 *  성별 전환 버튼 터치
 */
- (IBAction)genderChangeButtonTouched:(UIButton *)sender {
    
    //gender 변수를 바꾸고 userDefault에 저장한 뒤, 버튼텍스트를 변경한다.
    if([_gender isEqualToString:@"M"]) {
        _gender = @"F";
    } else {
        _gender = @"M";
    }

    //_userInfo에 있는 sex 데이터를 바꾼다.
    [_userInfo removeObjectForKey:@"sex"];
    [_userInfo setObject:_gender forKey:@"sex"];
    
    //NSUserDefault는 NSMutableDictionary가 안들어가므로, NSDictionary로 새로 만들고 카피한 뒤 넣는다.
    NSDictionary *userInfoDictionaryForUserDeault = [[NSDictionary alloc] init];
    userInfoDictionaryForUserDeault = _userInfo;
    [_standardDefault setObject:userInfoDictionaryForUserDeault forKey:@"userInfo"];
    [_standardDefault synchronize];
    
    //버튼 텍스트를 바꾼다.
    [self changeGenderButtonTitleTextByGender];
    
    //성별전환 후 네트워크 요청을 다시 보낸다. 추후에는 그냥 지금 가지고 있는 데이터를 sorting 할 것.
    [_designerRankingNetworkService callDesignerListByLocationIdRequest:_customerId withLocationId:_locationId withGender:_gender];
    
}

/**
 *  장소전환 버튼 터치(관심지역 모달창을 띄운다)
 */
- (IBAction)locationButtonTouched:(UIButton *)sender {
    //모달창을 만든다.
    _locationSelectModalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationSelectModalViewController"];
    
    //배경이 투명한 모달 스타일로 만들어준 뒤, 뷰컨트롤러를 띄운다.
    _locationSelectModalViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [_locationSelectModalViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:_locationSelectModalViewController animated:YES completion:nil];
}

/**
 *  임시 지역정보를 변경, 라벨 정보도 변경한 뒤, 리스트를 갱신한다.
 */
- (void)changeTempLocation: (NSNotification*) noti {
    
    //noti에서 Location정보를 뽑아와서 임시지역정보를 갱신한다.
    Location *myLocationInfo = [[noti userInfo] objectForKey:@"myLocation"];
    _locationId = myLocationInfo.id;

    //라벨정보를 갱신한다.
    _locationLabel.text = myLocationInfo.location;
    
    [_designerRankingNetworkService callDesignerListByLocationIdRequest:_customerId withLocationId:_locationId withGender:_gender];
}

/**
 *  사이드 메뉴 버튼 터치
 */
- (IBAction)sideMenuButtonTouched:(UIButton *)sender {
    
    //임시 MutableDic을 만든다.
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    
    //designerRankingViewController 라고 메시지를 담는다.
    NSString *thisViewController = @"designerRankingViewController";
    [tempDic setObject:thisViewController forKey:@"whereIsThisViewControllerComeFrom"];
    
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
 *  검색 버튼 터치
 */
- (IBAction)searchButtonTouched:(UIButton *)sender {
}

/**
 *  _gender에 따라 성별전환 버튼의 텍스트를 수정하는 메소드('남성고객수'/'여성고객수')
 */
- (void)changeGenderButtonTitleTextByGender {
    
    //남자면 isMale을 true로 놓고, 여자면 isMale을 false로 놓는다. 남자면 버튼의 텍스트를 '남성고객수'로 여자면 '여성고객수'로 바꾼다.
    if([_gender isEqualToString:@"M"]) {
        _isMale = true;
        [_genderChangeButton setTitle:@"남성고객수" forState:UIControlStateNormal];
    } else {
        _isMale = false;
        [_genderChangeButton setTitle:@"여성고객수" forState:UIControlStateNormal];
    }
    
}


/**
 *  내 디자이너를 취소 버튼을 터치한다.
 */
- (void)cancelMyDesignerButton: (id)sender {
    NSLog(@"touchDownMyDesignerButton");
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.rankingCollectionView];
    _targetIndexPath = [self.rankingCollectionView indexPathForItemAtPoint:buttonPosition];
    if (_targetIndexPath != nil) {
        //필요한 정보를 Dictionary에 담는다.
        NSMutableDictionary *tempMutableDic = [[NSMutableDictionary alloc] init];
        [tempMutableDic setObject:_userInfo forKey:@"userInfo"];
        [tempMutableDic setObject:(([DesignerListInALocation getDesignerListObject].designerList)[_targetIndexPath.row])forKey:@"designerInfo"];
        
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
}

/**
 *  내 디자이너 등록 버튼을 터치한다.
 */
- (void)addMyDesignerButton: (UIButton*)sender {
    NSLog(@"touchDownNotMyDesignerButton");
    
    if([[MyDesignerList getMyDesignerListObject] myDesignerList].count > 2) {
        
        //3명이 가득찼다는 모달창 만들기
        FullChoiceAboutMyDesignerViewController *fullChoiceAboutMyDesignerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fullChoiceAboutMyDesignerViewController"];
        
        //배경이 투명한 모달 스타일로 만들어준 뒤, 뷰컨트롤러를 띄운다.
        fullChoiceAboutMyDesignerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [fullChoiceAboutMyDesignerViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:fullChoiceAboutMyDesignerViewController animated:YES completion:nil];

        NSLog(@"3명 풀");
        return;
    } else {
        
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.rankingCollectionView];
        _targetIndexPath = [self.rankingCollectionView indexPathForItemAtPoint:buttonPosition];

        if (_targetIndexPath != nil){
            
            //필요한 정보를 Dictionary에 담는다.
            NSMutableDictionary *tempMutableDic = [[NSMutableDictionary alloc] init];
            [tempMutableDic setObject:(([DesignerListInALocation getDesignerListObject].designerList)[_targetIndexPath.row]) forKey:@"designerInfo"];
            
            NSDictionary *designerinfo = tempMutableDic;
            
            //모달 창을 띄우고, 정보를 NSNotificationCenter로 보낸다.
            ConfirmChoiceAboutMyDesignerViewController *confirmChoiceAboutMyDesignerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmChoiceAboutMyDesignerViewController"];
            
            //배경이 투명한 모달 스타일로 만들어준 뒤, 뷰컨트롤러를 띄우고, 노티를 보낸다.
            confirmChoiceAboutMyDesignerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [confirmChoiceAboutMyDesignerViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:confirmChoiceAboutMyDesignerViewController animated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userAndDesignerInfo" object:self userInfo:designerinfo];
            }];        
        }
    }
}




/**
 *  << observer의 콜백 메소드!!!!!!!!!!!!!!!!!!! >>
 *  디자이너 리스트 불러오는 메소드
 */
- (void)designerListDidLoad: (NSNotification *) noti{
    
    NSLog(@"designerListDidLoad()로 들어옴");
    
    //만약 DesignerList안에 있는 designerlist가 비어있다면, 해당 지역에 등록된 디자이너가 없다는 Image를 덮어 씌우고 아니면 갱신한다.
    if(([DesignerListInALocation getDesignerListObject].designerList).count == 0){
        //imagehidden 값을 변경하거나 애니메이션을 줄 것
        [UIView transitionWithView:_emptyDesignerImage
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^(void){
                            _emptyDesignerImage.hidden = NO;
                        }
                        completion:nil];
    } else {
        [UIView transitionWithView:_emptyDesignerImage
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^(void){
                            _emptyDesignerImage.hidden = YES;
                        }
                        completion:nil];
        //collection view 갱신
        [self.rankingCollectionView reloadData];
    }
}

/**
 *  디자이너 등록이 완료된 이후 콜백 메소드
 */
- (void) afterDesignerAddNetwork: (NSNotification *) noti {
    NSString *result = [[[noti userInfo] objectForKey:@"resultDic"] objectForKey:@"result"];
    
    if([result isEqualToString:@"success"]) {
        
        if(_targetIndexPath.row < 10) {
            RankingBetterDesignerCollectionViewCell *cell = (RankingBetterDesignerCollectionViewCell*)[self.rankingCollectionView cellForItemAtIndexPath:_targetIndexPath];
            cell.myDesignerButton.hidden = NO;
            cell.notMyDesignerButton.hidden = YES;
        } else {
            RankingNormalDesignerCollectionViewCell *cell = (RankingNormalDesignerCollectionViewCell*)[self.rankingCollectionView cellForItemAtIndexPath:_targetIndexPath];
            cell.myDesignerButton.hidden = NO;
            cell.notMyDesignerButton.hidden = YES;
        }
        
        //콜렉션 뷰를 갱신한다.
        [_rankingCollectionView reloadData];
    }
}


/**
 *  내 디자이너 취소가 완료된 이후 콜백 메소드
 */
- (void) afterDesignerCancelNetwork: (NSNotification *) noti {
    NSString *result = [[[noti userInfo] objectForKey:@"resultDic"] objectForKey:@"result"];
    
    if([result isEqualToString:@"success"]) {
        if(_targetIndexPath.row < 10) {
            RankingBetterDesignerCollectionViewCell *cell = (RankingBetterDesignerCollectionViewCell*)[self.rankingCollectionView cellForItemAtIndexPath:_targetIndexPath];
            cell.myDesignerButton.hidden = YES;
            cell.notMyDesignerButton.hidden = NO;
        } else {
            RankingNormalDesignerCollectionViewCell *cell = (RankingNormalDesignerCollectionViewCell*)[self.rankingCollectionView cellForItemAtIndexPath:_targetIndexPath];
            cell.myDesignerButton.hidden = YES;
            cell.notMyDesignerButton.hidden = NO;
        }
        
        //콜렉션 뷰를 갱신한다.
        [_rankingCollectionView reloadData];

    }
}



/**
 *  <지금부터 CollectionView 관련 메소드>
 *  각 인덱스에 맞는 셀을 설정해주는 메소드(DataSource)
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"cellForItemAtIndexPath 메소드에 들어옴");
    NSDictionary *aDesigner = ([DesignerListInALocation getDesignerListObject].designerList)[indexPath.row];
    
    //셀에 맞는 정보를 designerList에서 추출한다.
    NSString *designerName = [aDesigner objectForKey:@"stageName"];
    NSString *careerContents = [aDesigner objectForKey:@"careerContents"];
    NSString *maleCustomerCount = [[aDesigner objectForKey:@"maleCustomerCount"] stringValue];
    NSString *femaleCustomerCount = [[aDesigner objectForKey:@"femaleCustomerCount"] stringValue];
    NSString *hairshopName = [[aDesigner objectForKey:@"hairshop"] objectForKey:@"hairshopName"];
    NSString *closingDay = [aDesigner objectForKey:@"closingDay"];
    Boolean isMyDesigner = [[aDesigner objectForKey:@"isMyDesigner"] boolValue];
    
    NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
    NSString *pictureUrl = [urlString stringByAppendingString:[aDesigner objectForKey:@"filename"]];
    NSLog(@"pictureUrl: %@", pictureUrl);
    
    NSString *hairshopPictureUrl = [urlString stringByAppendingString:[[aDesigner objectForKey:@"hairshop"] objectForKey:@"filename"]];
    NSLog(@"hairshopPictureUrl: %@", hairshopPictureUrl);
    
    
    //1위부터 10위까지는 betterDesignerCell
    if(indexPath.row < 10) {
        
        //betterDesignerCell을 만든다.
        RankingBetterDesignerCollectionViewCell *betterDesignerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rankingBetterDesignerCollectionViewCell" forIndexPath:indexPath];
        
        //각 정보를 셀에 세팅한다.
        betterDesignerCell.betterDesignerName.text = designerName;
        betterDesignerCell.betterDesignerPosition.text = careerContents;
        if(_isMale) {
            betterDesignerCell.betterDesignerCustomerNumber.text = maleCustomerCount;
        } else {
            betterDesignerCell.betterDesignerCustomerNumber.text = femaleCustomerCount;
        }
        betterDesignerCell.betterDesignerHairShopName.text = hairshopName;
        betterDesignerCell.betterDesignerClosedDay.text = closingDay;
        
        if(isMyDesigner) {
            betterDesignerCell.myDesignerButton.hidden = NO;
            betterDesignerCell.notMyDesignerButton.hidden = YES;
        } else {
            betterDesignerCell.myDesignerButton.hidden = YES;
            betterDesignerCell.notMyDesignerButton.hidden = NO;
        }
        //버튼의 콜백 메소드를 등록한다.
        [betterDesignerCell.myDesignerButton addTarget:self action:@selector(cancelMyDesignerButton:) forControlEvents:UIControlEventTouchUpInside];
        [betterDesignerCell.notMyDesignerButton addTarget:self action:@selector(addMyDesignerButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //betterDesigner의 프로필 사진을 세팅한다.
        [betterDesignerCell.betterDesignerImage sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
        betterDesignerCell.betterDesignerImage.layer.borderWidth = 3.0f;
        betterDesignerCell.betterDesignerImage.layer.borderColor = ([ColorValue getColorValueObject].brownColorChair).CGColor;
        betterDesignerCell.betterDesignerImage.layer.cornerRadius = betterDesignerCell.betterDesignerImage.frame.size.width / 2;
        
        //betterDesigner의 헤어샵 이미지를 세팅하고, 동그라미로 만든다.
        [betterDesignerCell.betterDesignerHairShopImage sd_setImageWithURL:[NSURL URLWithString:hairshopPictureUrl]];
        betterDesignerCell.betterDesignerHairShopImage.layer.cornerRadius = betterDesignerCell.betterDesignerHairShopImage.frame.size.width / 2;

        //betterDesigner는 순위를 세팅한다.
        switch (indexPath.row) {
            case 0:
                betterDesignerCell.betterDesignerRankingNumber.text = @"1ST.";
                break;
            case 1:
                betterDesignerCell.betterDesignerRankingNumber.text = @"2ND.";
                break;
            case 2:
                betterDesignerCell.betterDesignerRankingNumber.text = @"3RD.";
                break;
            case 3:
                betterDesignerCell.betterDesignerRankingNumber.text = @"4TH.";
                break;
            case 4:
                betterDesignerCell.betterDesignerRankingNumber.text = @"5TH.";
                break;
            case 5:
                betterDesignerCell.betterDesignerRankingNumber.text = @"6TH.";
                break;
            case 6:
                betterDesignerCell.betterDesignerRankingNumber.text = @"7TH.";
                break;
            case 7:
                betterDesignerCell.betterDesignerRankingNumber.text = @"8TH.";
                break;
            case 8:
                betterDesignerCell.betterDesignerRankingNumber.text = @"9TH.";
                break;
            case 9:
                betterDesignerCell.betterDesignerRankingNumber.text = @"10TH.";
                break;
                
            default:
                NSLog(@"순위가 제대로 세팅되지 않으면 들어오는 부분");
                break;
        }
        
        return betterDesignerCell;
        
    } else { //11위부터는 normalDesignerCell

        //normalDesignerCell을 만든다.
        RankingNormalDesignerCollectionViewCell *normalDesignerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rankingNormalDesignerCollectionViewCell" forIndexPath:indexPath];
        
        //각 정보를 셀에 세팅한다.
        normalDesignerCell.normalDesignerName.text = designerName;
        normalDesignerCell.normalDesignerPosition.text = careerContents;
        if(_isMale) {
            normalDesignerCell.normalDesignerCustomerNumber.text = maleCustomerCount;
        } else {
            normalDesignerCell.normalDesignerCustomerNumber.text = femaleCustomerCount;
        }
        normalDesignerCell.normalDesignerHairShopName.text = hairshopName;
        normalDesignerCell.normalDesignerClosedDay.text = closingDay;
        
        if(isMyDesigner) {
            normalDesignerCell.myDesignerButton.hidden = NO;
            normalDesignerCell.notMyDesignerButton.hidden = YES;
        } else {
            normalDesignerCell.myDesignerButton.hidden = YES;
            normalDesignerCell.notMyDesignerButton.hidden = NO;
        }
        
        //normalDesigner의 프로필 사진을 세팅한다.
        [normalDesignerCell.normalDesignerImage sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
        normalDesignerCell.normalDesignerImage.layer.borderWidth = 3.0f;
        normalDesignerCell.normalDesignerImage.layer.borderColor = ([ColorValue getColorValueObject].brownColorChair).CGColor;
        normalDesignerCell.normalDesignerImage.layer.cornerRadius = normalDesignerCell.normalDesignerImage.frame.size.width / 2;
        
        //normalDesigner의 헤어샵 이미지를 세팅하고, 동그라미로 만든다.
        [normalDesignerCell.normalDesignerHairShopImage sd_setImageWithURL:[NSURL URLWithString:hairshopPictureUrl]];
        normalDesignerCell.normalDesignerHairShopImage.layer.cornerRadius = normalDesignerCell.normalDesignerHairShopImage.frame.size.width / 2;

        return normalDesignerCell;
        
    }
    
}

/**
 *  Section 안에 몇개의 아이템이 들어가는지 설정(DataSrouce)
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ([DesignerListInALocation getDesignerListObject].designerList).count;
}

/**
 *  Section의 헤더 만들기(DataSource)
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    RankingSectionHeaderCollectionReusableView *sectionHeader = [self.rankingCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"imageNotificationHeaderForRankingPage" forIndexPath:indexPath];

    return sectionHeader;
;
}

/**
 *  Section이 몇개인지(DataSource)
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

/**
 *  item이 선택된 경우
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [_notificationCenter removeObserver:self];
    
    //디자이너 디테일 뷰컨트롤러를 생성한다.
    DetailDesignerInfoViewController *detailDesignerinfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailDesignerInfoViewController"];
    [detailDesignerinfoViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:detailDesignerinfoViewController animated:YES completion:nil];
    
    //디자이너 정보와, 어떤 뷰컨트롤러에서 보내는지에 대한 정보를 담아서 보낸다.
    NSDictionary *designerInfo = ([DesignerListInALocation getDesignerListObject].designerList)[indexPath.row];
    NSString *whereIsThisViewControllerComeFrom = @"designerRankingVeiwController";
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    [tempDic setObject:designerInfo forKey:@"designerInfo"];
    [tempDic setObject:whereIsThisViewControllerComeFrom forKey:@"whereIsthisViewControllerComeFrom"];
    NSDictionary *resultDic = tempDic;
    [_notificationCenter postNotificationName:@"informationsForDetailDesignerPage" object:self userInfo:resultDic];
    
}

/**
 *  화면 넓이에 따라서 셀의 크기를 조정해주는 코드
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float cellWidth = self.view.frame.size.width;
    float cellHeight;
    
    if(indexPath.row < 10) {
        cellHeight = cellWidth * 12.8f / 38.1f;
    } else {
        cellHeight = cellWidth * 10.92f / 38.1f;
    }
    return CGSizeMake(cellWidth, cellHeight);
}


@end
