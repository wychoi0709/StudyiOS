//
//  SideMenuViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 1. 1..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "SideMenuViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "DesignerRankingViewController.h"
#import "LoginViewController.h"
#import "DetailDesignerInfoViewController.h"

@interface SideMenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *firstDesignerName;
@property (weak, nonatomic) IBOutlet UILabel *firstDesignerCareer;
@property (weak, nonatomic) IBOutlet UIImageView *firstDesignerComma;
@property (weak, nonatomic) IBOutlet UILabel *secondDesignerName;
@property (weak, nonatomic) IBOutlet UILabel *secondDesignerCareer;
@property (weak, nonatomic) IBOutlet UIImageView *secondDesignerComma;
@property (weak, nonatomic) IBOutlet UILabel *thirdDesignerName;
@property (weak, nonatomic) IBOutlet UILabel *thirdDesignerCareer;
@property (weak, nonatomic) IBOutlet UIImageView *thirdDesignerComma;

@property (weak, nonatomic) IBOutlet UIButton *firstDesignerBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondDesignerBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdDesignerBtn;
@property (weak, nonatomic) IBOutlet UIButton *moveDesignerRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *moveMyInfoBtn;

@property NSInteger myDesignerCount;
@property NSMutableArray *onlyMyDesignerList;
@property NSNotificationCenter *notificationCenter;

@end

@implementation SideMenuViewController

/**
 *  <생명주기 관련 메소드>
 *  viewDidLoad 호출
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //들어온 viewController을 확인하기 위한 옵저버
    _notificationCenter = [NSNotificationCenter defaultCenter];
    [_notificationCenter addObserver:self selector:@selector(closedBtnAndPresentDesignerInfo:) name:@"guidingPreviousViewController" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  << 버튼 터치 메소드 >>
 *  첫번째 디자이너 터치
 */
- (IBAction)firstDesignerTouched:(UIButton *)sender {
    
    //임시 MutableDic을 만든다.
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    
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
    
    //첫번째 디자이너의 정보도 따로 넣는다.
    [tempDic setObject:_onlyMyDesignerList[0] forKey:@"designerInfo"];
    
    //결과 Dic에 넣는다.
    NSDictionary *whereIsThisViewControllerComeFrom = tempDic;
    
    //화면을 띄우고 노티를 보낸다.
    DetailDesignerInfoViewController *detailDesignerInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailDesignerInfoViewController"];
    [detailDesignerInfoViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:detailDesignerInfoViewController animated:YES completion:^{
        }];
    
    [_notificationCenter postNotificationName:@"informationsForDetailDesignerPage" object:self userInfo:whereIsThisViewControllerComeFrom];
    
}


- (IBAction)secondDesignerTouched:(UIButton *)sender {
    //임시 MutableDic을 만든다.
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    
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
    
    //두번째 디자이너의 정보도 따로 넣는다.
    [tempDic setObject:_onlyMyDesignerList[1] forKey:@"designerInfo"];
    
    //결과 Dic에 넣는다.
    NSDictionary *whereIsThisViewControllerComeFrom = tempDic;
    
    //화면을 띄우고 노티를 보낸다.
    DetailDesignerInfoViewController *detailDesignerInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailDesignerInfoViewController"];
    [detailDesignerInfoViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:detailDesignerInfoViewController animated:YES completion:^{
    }];
    
    [_notificationCenter postNotificationName:@"informationsForDetailDesignerPage" object:self userInfo:whereIsThisViewControllerComeFrom];
}


- (IBAction)thirdDesignerTouched:(UIButton *)sender {
    //임시 MutableDic을 만든다.
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    
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
    
    //세번째 디자이너의 정보도 따로 넣는다.
    [tempDic setObject:_onlyMyDesignerList[2] forKey:@"designerInfo"];
    
    //결과 Dic에 넣는다.
    NSDictionary *whereIsThisViewControllerComeFrom = tempDic;
    
    //화면을 띄우고 노티를 보낸다.
    DetailDesignerInfoViewController *detailDesignerInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailDesignerInfoViewController"];
    [detailDesignerInfoViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:detailDesignerInfoViewController animated:YES completion:^{
    }];
    
    [_notificationCenter postNotificationName:@"informationsForDetailDesignerPage" object:self userInfo:whereIsThisViewControllerComeFrom];
}

/**
 *  디자이너 랭킹 버튼 터치
 */
- (IBAction)moveDesignerRankingPage:(UIButton *)sender {
    DesignerRankingViewController *designerRankingViewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"designerRankingViewController"];
    [designerRankingViewcontroller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:designerRankingViewcontroller animated:YES completion:nil];
}

/**
 *  내 정보 수정 버튼 터치
 */
- (IBAction)moveMyInformationEditPage:(UIButton *)sender {
}

/**
 *  로그아웃 버튼 터치
 */
- (IBAction)logoutButtonTouched:(UIButton *)sender {
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

/**
 *  << 콜백 관련 메소드 >>
 *  들어온 곳을 표시하고, 디자이너 정보를 표시하는 메소드
 */
- (void)closedBtnAndPresentDesignerInfo: (NSNotification*) noti {
    
    //내 디자이너 관련 정보를 넣는다.
    _myDesignerCount = [[[noti userInfo] objectForKey:@"myDesignerCount"] integerValue];
    if(_myDesignerCount > 0) {
        _onlyMyDesignerList = [[noti userInfo] objectForKey:@"onlyMyDesignerList"];
    }
    
    //내 디자이너 관련 정보를 뷰에 띄운다.
    switch (_myDesignerCount) {
        case 0:
            _firstDesignerBtn.hidden = YES;
            _firstDesignerName.hidden = YES;
            _firstDesignerCareer.hidden = YES;
            _firstDesignerComma.hidden = YES;
            _secondDesignerBtn.hidden = YES;
            _secondDesignerName.hidden = YES;
            _secondDesignerCareer.hidden = YES;
            _secondDesignerComma.hidden = YES;
            _thirdDesignerBtn.hidden = YES;
            _thirdDesignerName.hidden = YES;
            _thirdDesignerCareer.hidden = YES;
            _thirdDesignerComma.hidden = YES;
            break;
        
        case 1:
            _firstDesignerBtn.hidden = NO;
            _firstDesignerName.hidden = NO;
            _firstDesignerCareer.hidden = NO;
            _firstDesignerComma.hidden = NO;
            _secondDesignerBtn.hidden = YES;
            _secondDesignerName.hidden = YES;
            _secondDesignerCareer.hidden = YES;
            _secondDesignerComma.hidden = YES;
            _thirdDesignerBtn.hidden = YES;
            _thirdDesignerName.hidden = YES;
            _thirdDesignerCareer.hidden = YES;
            _thirdDesignerComma.hidden = YES;
            
            _firstDesignerName.text = [_onlyMyDesignerList[0]  objectForKey:@"stageName"];
            _firstDesignerCareer.text = [_onlyMyDesignerList[0] objectForKey:@"careerContents"];
            break;
            
        case 2:
            _firstDesignerBtn.hidden = NO;
            _firstDesignerName.hidden = NO;
            _firstDesignerCareer.hidden = NO;
            _firstDesignerComma.hidden = NO;
            _secondDesignerBtn.hidden = NO;
            _secondDesignerName.hidden = NO;
            _secondDesignerCareer.hidden = NO;
            _secondDesignerComma.hidden = NO;
            _thirdDesignerBtn.hidden = YES;
            _thirdDesignerName.hidden = YES;
            _thirdDesignerCareer.hidden = YES;
            _thirdDesignerComma.hidden = YES;
            
            _firstDesignerName.text = [_onlyMyDesignerList[0]  objectForKey:@"stageName"];
            _firstDesignerCareer.text = [_onlyMyDesignerList[0] objectForKey:@"careerContents"];
            _secondDesignerName.text = [_onlyMyDesignerList[1] objectForKey:@"stageName"];
            _secondDesignerCareer.text = [_onlyMyDesignerList[1] objectForKey:@"careerContents"];
            break;
            
        case 3:
            _firstDesignerBtn.hidden = NO;
            _firstDesignerName.hidden = NO;
            _firstDesignerCareer.hidden = NO;
            _firstDesignerComma.hidden =NO;
            _secondDesignerBtn.hidden = NO;
            _secondDesignerName.hidden = NO;
            _secondDesignerCareer.hidden = NO;
            _secondDesignerComma.hidden = NO;
            _thirdDesignerBtn.hidden = NO;
            _thirdDesignerName.hidden = NO;
            _thirdDesignerCareer.hidden = NO;
            _thirdDesignerComma.hidden = NO;
            
            _firstDesignerName.text = [_onlyMyDesignerList[0]  objectForKey:@"stageName"];
            _firstDesignerCareer.text = [_onlyMyDesignerList[0] objectForKey:@"careerContents"];
            _secondDesignerName.text = [_onlyMyDesignerList[1] objectForKey:@"stageName"];
            _secondDesignerCareer.text = [_onlyMyDesignerList[1] objectForKey:@"careerContents"];
            _thirdDesignerName.text = [_onlyMyDesignerList[2] objectForKey:@"stageName"];
            _thirdDesignerCareer.text = [_onlyMyDesignerList[2] objectForKey:@"careerContents"];
            break;

        default:
            break;
    }
    
    //어떤 뷰 컨트롤러에서 왔는지 확인하고, 버튼을 조정한다.
    NSString *previousViewController = [[noti userInfo] objectForKey:@"whereIsThisViewControllerComeFrom"];

    if([previousViewController isEqualToString:@"designerRankingViewController"]) {
        //designerRankingviewController에서 왔다면, 특정한 표시를 한다.
        //무슨 표시할까?
        
        //버튼을 비활성화 시킨다
//        _moveDesignerRankingBtn.hidden = YES;
    } else if([previousViewController isEqualToString:@"detailDesignerInfoViewController"]){

        //버튼을 모두 ON한다.
//        _moveDesignerRankingBtn.hidden = NO;
        
        //들어온 디자이너 버튼을 없앤다.
    }

}

/**
 *  <사이드 메뉴 라이브러리 관련 메소드>
 *  뭔지 잘 모름.
 */
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}



@end
