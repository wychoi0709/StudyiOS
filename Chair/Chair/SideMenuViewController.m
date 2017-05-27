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
#import "ColorValue.h"


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


@property (weak, nonatomic) IBOutlet UIView *firstDesignerView;
@property (weak, nonatomic) IBOutlet UIView *firstDesignerEmptyMessageView;
@property (weak, nonatomic) IBOutlet UIView *secondDesignerView;
@property (weak, nonatomic) IBOutlet UIView *secondDesignerEmptyMessageView;
@property (weak, nonatomic) IBOutlet UIView *thirdDesignerView;
@property (weak, nonatomic) IBOutlet UIView *thirdDesignerEmptyMessageView;

@property (weak, nonatomic) IBOutlet UIView *myDesignerBackground;
@property (weak, nonatomic) IBOutlet UIView *myDesignerTextView;

@property (weak, nonatomic) IBOutlet UIView *myDesignerView;
@property (weak, nonatomic) IBOutlet UIView *myInfoEditView;

@property (weak, nonatomic) IBOutlet UIButton *firstDesignerBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondDesignerBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdDesignerBtn;
@property (weak, nonatomic) IBOutlet UIButton *moveMyInfoBtn;
@property (weak, nonatomic) IBOutlet UIView *designerAcceptView;
@property (weak, nonatomic) IBOutlet UIView *messageButtonView;

@property NSInteger myDesignerCount;
@property NSMutableArray *onlyMyDesignerList;
@property NSNotificationCenter *notificationCenter;
@property DesignerRankingViewController *designerRankingViewController;
@property NSMutableDictionary *userInfo;

@property CGRect tempBackgroundFrame;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myDesignerViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myDesignerTopBeforePermission;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myPageViewAfterPermission;

@property NSUserDefaults *standardDefault;


@end

@implementation SideMenuViewController

/**
 *  <생명주기 관련 메소드>
 *  viewDidLoad 호출
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //들어온 viewController을 확인하기 위한 옵저버
    _notificationCenter = [NSNotificationCenter defaultCenter];
    [_notificationCenter addObserver:self selector:@selector(closedBtnAndPresentDesignerInfo:) name:@"guidingPreviousViewController" object:nil];
    [_notificationCenter addObserver:self selector:@selector(afterChangedUserInfo:) name:@"updateMyInfoResult" object:nil];

}

- (BOOL)shouldAutorotate { return NO; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }


/**
 *  << 버튼 터치 메소드 >>
 *  디자이너 터치
 */
- (IBAction)firstDesignerTouched:(UIButton *)sender {
    
    //사이드메뉴를 만든다.
    _designerRankingViewController = (DesignerRankingViewController *)self.sideMenuController;
    
    //화면을 띄우고, 사이드 메뉴를 닫는다.
    DetailDesignerInfoViewController *detailDesignerInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailDesignerInfoViewController"];
    [detailDesignerInfoViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    detailDesignerInfoViewController.amIDesigner = NO;
    detailDesignerInfoViewController.designerInfo = [[MyDesignerList getMyDesignerListObject] myDesignerList][0];
    [self presentViewController:detailDesignerInfoViewController animated:YES completion:nil];

}


- (IBAction)secondDesignerTouched:(UIButton *)sender {

    //사이드메뉴를 만든다.
    _designerRankingViewController = (DesignerRankingViewController *)self.sideMenuController;
    
    //화면을 띄우고, 사이드 메뉴를 닫는다.
    DetailDesignerInfoViewController *detailDesignerInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailDesignerInfoViewController"];
    [detailDesignerInfoViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    detailDesignerInfoViewController.amIDesigner = NO;
    detailDesignerInfoViewController.designerInfo = [[MyDesignerList getMyDesignerListObject] myDesignerList][1];
    [self presentViewController:detailDesignerInfoViewController animated:YES completion:nil];
    
}


- (IBAction)thirdDesignerTouched:(UIButton *)sender {
    
    //사이드메뉴를 만든다.
    _designerRankingViewController = (DesignerRankingViewController *)self.sideMenuController;
    
    //화면을 띄우고, 사이드 메뉴를 닫는다.
    DetailDesignerInfoViewController *detailDesignerInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailDesignerInfoViewController"];
    [detailDesignerInfoViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    detailDesignerInfoViewController.amIDesigner = NO;
    detailDesignerInfoViewController.designerInfo = [[MyDesignerList getMyDesignerListObject] myDesignerList][2];
    [self presentViewController:detailDesignerInfoViewController animated:YES completion:nil];
}


/**
 *  내 정보 수정 버튼 터치
 */
- (IBAction)moveMyInformationEditPage:(UIButton *)sender {
    
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
    
    //사이드메뉴를 만든다.
    _designerRankingViewController = (DesignerRankingViewController *)self.sideMenuController;
    
    //화면을 띄우고, 사이드 메뉴를 닫는다.
    DetailDesignerInfoViewController *detailDesignerInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailDesignerInfoViewController"];
    [detailDesignerInfoViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    detailDesignerInfoViewController.amIDesigner = YES;
    detailDesignerInfoViewController.designerInfo = [_userInfo objectForKey:@"designer"];
    
    [self presentViewController:detailDesignerInfoViewController animated:YES completion:nil];
    
}


/**
 *  << 콜백 관련 메소드 >>
 *  들어온 곳을 표시하고, 디자이너 정보를 표시하는 메소드
 */
- (void)closedBtnAndPresentDesignerInfo: (NSNotification*) noti {
    
    NSLog(@"사이드바의 UI를 수정하기 위한 콜백 메소드로 들어옴");

    //투명 배경의 크기를 조정하기 위한 변수를 만든다.
    _tempBackgroundFrame = _myDesignerBackground.frame;
    _tempBackgroundFrame.size.height = 0.0;
    _tempBackgroundFrame.size.height += _myDesignerTextView.frame.size.height;
    
    //내 디자이너 관련 정보를 뷰에 띄운다.
    switch (([MyDesignerList getMyDesignerListObject].myDesignerList).count) {
        case 0:
            _firstDesignerView.hidden = YES;
            _secondDesignerView.hidden = YES;
            _thirdDesignerView.hidden = YES;
            _firstDesignerEmptyMessageView.hidden = NO;
            _secondDesignerEmptyMessageView.hidden = YES;
            _thirdDesignerEmptyMessageView.hidden = YES;
            _tempBackgroundFrame.size.height += _firstDesignerEmptyMessageView.frame.size.height;
            break;
        
        case 1:
            _firstDesignerView.hidden = NO;
            _secondDesignerView.hidden = YES;
            _thirdDesignerView.hidden = YES;
            _firstDesignerEmptyMessageView.hidden = YES;
            _secondDesignerEmptyMessageView.hidden = NO;
            _thirdDesignerEmptyMessageView.hidden = YES;
            _tempBackgroundFrame.size.height += _firstDesignerView.frame.size.height;
            _tempBackgroundFrame.size.height += _secondDesignerEmptyMessageView.frame.size.height;
            
            _firstDesignerName.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][0] objectForKey:@"stageName"];
            _firstDesignerCareer.text =[[[MyDesignerList getMyDesignerListObject] myDesignerList][0] objectForKey:@"careerContents"];
            break;
            
        case 2:
            _firstDesignerView.hidden = NO;
            _secondDesignerView.hidden = NO;
            _thirdDesignerView.hidden = YES;
            _firstDesignerEmptyMessageView.hidden = YES;
            _secondDesignerEmptyMessageView.hidden = YES;
            _thirdDesignerEmptyMessageView.hidden = NO;
            _tempBackgroundFrame.size.height += _firstDesignerView.frame.size.height;
            _tempBackgroundFrame.size.height += _secondDesignerView.frame.size.height;
            _tempBackgroundFrame.size.height += _thirdDesignerEmptyMessageView.frame.size.height;
            
            _firstDesignerName.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][0] objectForKey:@"stageName"];
            _firstDesignerCareer.text =[[[MyDesignerList getMyDesignerListObject] myDesignerList][0] objectForKey:@"careerContents"];
            _secondDesignerName.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][1] objectForKey:@"stageName"];
            _secondDesignerCareer.text = [[[MyDesignerList getMyDesignerListObject] myDesignerList][1] objectForKey:@"careerContents"];
            break;
            
        case 3:
            _firstDesignerView.hidden = NO;
            _secondDesignerView.hidden = NO;
            _thirdDesignerView.hidden = NO;
            _firstDesignerEmptyMessageView.hidden = YES;
            _secondDesignerEmptyMessageView.hidden = YES;
            _thirdDesignerEmptyMessageView.hidden = YES;
            _tempBackgroundFrame.size.height += _firstDesignerView.frame.size.height;
            _tempBackgroundFrame.size.height += _secondDesignerView.frame.size.height;
            _tempBackgroundFrame.size.height += _thirdDesignerView.frame.size.height;
            
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
    
    //내 디자이너 뷰의 위치와 배경을 조정한다.
    _tempBackgroundFrame.size.height += 9.0;
    
    [self presentUIFromUserInfo];

}

- (void)afterChangedUserInfo:(NSNotification*)noti {
    [self presentUIFromUserInfo];
}

/**
 *  NSUserDefault의 값을 통해 UI를 갱신한다.
 */
-(void) presentUIFromUserInfo{
    
    //userInfo 뺐음.
    _userInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] mutableCopy];
    
    //이름을 매핑하고 이미지를 넣는다.
    _userNameLabel.text = [_userInfo objectForKey:@"name"];
    NSString *userPictureUrl = [_userInfo objectForKey:@"filename"];
    NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
    NSString *pictureUrl = [urlString stringByAppendingString:userPictureUrl];
    
    if( pictureUrl ) {
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
        
        self.userImageView.layer.borderWidth = 1.5f;
        self.userImageView.layer.borderColor = ([ColorValue getColorValueObject].brownColorChair).CGColor;
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
        self.userImageView.clipsToBounds = YES;
    }
    
    Boolean isPermissionOfApply = [[_userInfo objectForKey:@"permissionOfApply"] boolValue];
    
    if ( isPermissionOfApply ) {
        //view를 살린다
        _designerAcceptView.hidden = NO;
        
    } else {
        //view를 없앤다.
        _designerAcceptView.hidden = YES;
        
        //내가 등록한 선생님 뷰를 조정한다.
        //콜렉션뷰 위치 수정
        NSLayoutConstraint *newTopConstraintForDesignerAcceptview =
        [NSLayoutConstraint constraintWithItem:_myDesignerView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_userImageView
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:24.0];
        [self.view addConstraint:newTopConstraintForDesignerAcceptview];
        [self.view removeConstraint:_myDesignerTopBeforePermission];
        
        [self.view updateConstraints];
    }
    
    Boolean isTakenMessage = [[_userInfo objectForKey:@"isTakenMessage"] boolValue];
    
    if ( isTakenMessage ) {
        _messageButtonView.hidden = NO;
    } else {
        _messageButtonView.hidden = YES;
    }
    
    
    //컨스트레인트 수정으로 내가 등록한 선생님보기 뷰의 높이 변경
    _myDesignerViewHeight.constant = _tempBackgroundFrame.size.height;
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
