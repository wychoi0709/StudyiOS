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
#import "MyDesignerList.h"
#import "MyPageCustomerViewController.h"
#import "DetailDesignerInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@import Firebase;

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
@property (weak, nonatomic) IBOutlet UIButton *moveMyInfoBtn;
@property (weak, nonatomic) IBOutlet UIView *designerAcceptView;

@property NSInteger myDesignerCount;
@property NSMutableArray *onlyMyDesignerList;
@property NSNotificationCenter *notificationCenter;
@property DesignerRankingViewController *designerRankingViewController;
@property NSMutableDictionary *userInfo;

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
    
    //디테일 페이지로 이동한다.
    [self moveDetailPage];

    
    //첫번째 버튼이라는 정보를 넣고, 노티를 보낸다.
    NSDictionary *whereIsThisViewControllerComeFrom = [NSDictionary dictionaryWithObject:@"firstDetailDesignerInfoViewController" forKey:@"whereIsThisViewControllerComeFrom"];
    [_notificationCenter postNotificationName:@"informationsForDetailDesignerPage" object:self userInfo:whereIsThisViewControllerComeFrom];

}


- (IBAction)secondDesignerTouched:(UIButton *)sender {

    //디테일 페이지로 이동한다.
    [self moveDetailPage];
    
    //두번째 버튼이라는 정보를 넣고, 노티를 보낸다.
    NSDictionary *whereIsThisViewControllerComeFrom = [NSDictionary dictionaryWithObject:@"secondDetailDesignerInfoViewController" forKey:@"whereIsThisViewControllerComeFrom"];
    [_notificationCenter postNotificationName:@"informationsForDetailDesignerPage" object:self userInfo:whereIsThisViewControllerComeFrom];

}


- (IBAction)thirdDesignerTouched:(UIButton *)sender {
    
    //디테일 페이지로 이동한다.
    [self moveDetailPage];
    
    //세번째 버튼이라는 정보를 넣고, 노티를 보낸다.
    NSDictionary *whereIsThisViewControllerComeFrom = [NSDictionary dictionaryWithObject:@"thirdDetailDesignerInfoViewController" forKey:@"whereIsThisViewControllerComeFrom"];
    [_notificationCenter postNotificationName:@"informationsForDetailDesignerPage" object:self userInfo:whereIsThisViewControllerComeFrom];


}

- (void) moveDetailPage {

    //사이드메뉴를 만든다.
    _designerRankingViewController = (DesignerRankingViewController *)self.sideMenuController;
    
    
    //화면을 띄우고, 사이드 메뉴를 닫는다.
    DetailDesignerInfoViewController *detailDesignerInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailDesignerInfoViewController"];
    [detailDesignerInfoViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:detailDesignerInfoViewController animated:YES completion:^{
        [_designerRankingViewController hideLeftViewAnimated:NO completionHandler:nil];
    }];

}


/**
 *  내 정보 수정 버튼 터치
 */
- (IBAction)moveMyInformationEditPage:(UIButton *)sender {
    
    //옵저버를 없앤다.
    [_notificationCenter removeObserver:self];
    
    //내 정보 페이지로 이동.
    MyPageCustomerViewController *myPageCustomerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myPageCustomerViewController"];
    [myPageCustomerViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:myPageCustomerViewController animated:YES completion:^{
         [_designerRankingViewController hideLeftViewAnimated:NO completionHandler:nil];
    }];

}

/**
 *  로그아웃 버튼 터치
 */
- (IBAction)logoutButtonTouched:(UIButton *)sender {
    
    //Firebase 인증관련 객체를 FIRAuth에서 받아옴. 이 FIRAuth는 Firebase 클래스인가봄.
    FIRAuth *firebaseAuth = [FIRAuth auth];
    
    //objective C 문법인 듯 한데, 애러를 하나 만들어?
    NSError *signOutError;
    
    //Firebase Auth에서 signOut을 하면서 애러가 난다면 아까 만든 애러에 넣어.
    BOOL status = [firebaseAuth signOut:&signOutError];
    
    //만약 애러가 났다면 애러라고 알려줘.
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    } else {
        //옵저버를 없앤다.
        [_notificationCenter removeObserver:self];
        
        [_designerRankingViewController hideLeftViewAnimated:NO completionHandler:nil];
        
        //내 디자이너 선생님 리스트를 초기화시킨다.
        [[MyDesignerList getMyDesignerListObject] refreshMyDesignerList];
        
        //로그인 창으로 돌아간다.
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (IBAction)myPageAsDesigner:(UIButton *)sender {
    //그냥 화면 넘긴다음, 넘어간 화면에서 userInfo로 디자이너 정보 뽑으면돼. pist라서 어디서든 쓸 수 있잖아?
}

/**
 *  << 콜백 관련 메소드 >>
 *  들어온 곳을 표시하고, 디자이너 정보를 표시하는 메소드
 */
- (void)closedBtnAndPresentDesignerInfo: (NSNotification*) noti {
    
    //내 디자이너 관련 정보를 뷰에 띄운다.
    switch (([MyDesignerList getMyDesignerListObject].myDesignerList).count) {
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
            
            _firstDesignerName.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][0] objectForKey:@"stageName"];
            _firstDesignerCareer.text =[[[MyDesignerList getMyDesignerListObject] myDesignerList][0] objectForKey:@"careerContents"];
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
            
            _firstDesignerName.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][0] objectForKey:@"stageName"];
            _firstDesignerCareer.text =[[[MyDesignerList getMyDesignerListObject] myDesignerList][0] objectForKey:@"careerContents"];
            _secondDesignerName.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][1] objectForKey:@"stageName"];
            _secondDesignerCareer.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][1] objectForKey:@"careerContents"];
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
            
            _firstDesignerName.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][0] objectForKey:@"stageName"];
            _firstDesignerCareer.text =[[[MyDesignerList getMyDesignerListObject] myDesignerList][0] objectForKey:@"careerContents"];
            _secondDesignerName.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][1] objectForKey:@"stageName"];
            _secondDesignerCareer.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][1] objectForKey:@"careerContents"];
            _thirdDesignerName.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][2] objectForKey:@"stageName"];
            _thirdDesignerCareer.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][2] objectForKey:@"careerContents"];
            
            break;

        default:
            break;
    }
    
    //이름을 매핑하고 이미지를 넣는다.
    _userNameLabel.text = [[noti userInfo] objectForKey:@"name"];
    NSString *userPictureUrl = [[noti userInfo] objectForKey:@"userPictureUrl"];
    if( userPictureUrl ) {
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:userPictureUrl]];
    }
    _userInfo = [[noti userInfo] objectForKey:@"userInfo"];
    
    //등록 중인 디자이너에게 한 마디를 하고 싶다면 이용할 것
//    Boolean isApplyDesigner = [[_userInfo objectForKey:@"applyDesigner"] boolValue];
    Boolean isPermissionOfApply = [[_userInfo objectForKey:@"permissionOfApply"] boolValue];
    
    if ( isPermissionOfApply ) {
        //view를 살린다
        _designerAcceptView.hidden = NO;
        
        //내가 등록한 선생님 뷰의 위치를 조정한다.
        
    } else {
        //view를 없앤다.
        _designerAcceptView.hidden = YES;
        
        //내가 등록한 선생님 뷰의 위치를 조정한다.
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
