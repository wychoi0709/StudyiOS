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

@interface SideMenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *firstDesignerName;
@property (weak, nonatomic) IBOutlet UILabel *firstDesignerCareer;
@property (weak, nonatomic) IBOutlet UILabel *secondDesignerName;
@property (weak, nonatomic) IBOutlet UILabel *secondDesignerCareer;
@property (weak, nonatomic) IBOutlet UILabel *thirdDesignerName;
@property (weak, nonatomic) IBOutlet UILabel *thirdDesignerCareer;

@end

@implementation SideMenuViewController

/**
 *  <생명주기 관련 메소드>
 *  viewDidLoad 호출
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DesignerRankingViewController *mainViewController = (DesignerRankingViewController *)self.sideMenuController;

//    mainViewController presentViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  <내가 만든 메소드 및 버튼 터치 메소드>
 *  첫번째 디자이너 터치
 */
- (IBAction)firstDesignerTouched:(UIButton *)sender {
}


- (IBAction)secondDesignerTouched:(UIButton *)sender {
}


- (IBAction)thirdDesignerTouched:(UIButton *)sender {
}


- (IBAction)moveDesignerRankingPage:(UIButton *)sender {
}


- (IBAction)moveMyInformationEditPage:(UIButton *)sender {
}


- (IBAction)logoutButtonTouched:(UIButton *)sender {
}


/**
 *  <사이드 메뉴 라이브러리 관련 메소드>
 *  상위 셋은 뭔지 잘 모름.
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
