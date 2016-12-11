//
//  ViewController.m
//  W9CardDeck
//
//  Created by 최원영 on 2016. 11. 30..
//  Copyright © 2016년 최원영. All rights reserved.
//
//  메인 ViewController

#import "ViewController.h"
#import "RandomCardSupplyFactory.h"

@interface ViewController ()

//카드선택의 결과가 보여지는 라벨과 이미지뷰
@property (weak, nonatomic) IBOutlet UILabel *randomlySelectedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *randomlySelectedImage;

@end

@implementation ViewController

RandomCardSupplyFactory *randomCardSupplyFactory;

/**
 *  카드 선택 버튼을 클릭한 경우
 */
- (IBAction)randomlySelectCardBtnTouchUp:(UIButton *)sender {
    [randomCardSupplyFactory randomize];
}


/**
 *  observer가 변경된 값을 받아오면, 라벨을 변경시켜주는 메소드
 */
- (void)showRandomCardIntoLabel:(NSNotification *)noti {
    
    //노티에 담겨온 카드를 빼낸다.
    Card *card = [[noti userInfo] objectForKey:@"card"];
    
    //받아온 카드에서 결과 텍스트를 만든 후, 라벨에 입력한다.
    NSString *resultString = [[card.cardSimbol stringByAppendingString:card.cardNumber ] stringByAppendingString:@".png"];
    _randomlySelectedLabel.text = resultString;
    
    //결과 텍스트를 토대로 이미지를 보여준다.
    UIImage *img = [UIImage imageNamed:resultString];
    [_randomlySelectedImage setImage:img];
}


/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //초기화
    randomCardSupplyFactory = [[RandomCardSupplyFactory alloc] init];
    
    //NotificationCenter 생성
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    //VC에 Noti를 등록. Obsesrver로 등록할 대상은 self, 콜백(샐렉터)은 showRandomCardIntoLabel, 관찰한 노티 이름은 randomizeCard, object는 누가 보내는지를 명시(nil은 '누구든 보내면'이라는 의미)
    [notificationCenter addObserver:self selector:@selector(showRandomCardIntoLabel:) name:@"randomizeCard" object:randomCardSupplyFactory];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  생명주기 상 얘는 view가 없어질 때 등장한다. 문제는 얘가 실행되고 난 다음 view가 다시 등장했을 때, viewDidLoad가 실행되지 않는다(옵저버 등록에 주의)
 */
- (void)viewDidDisappear:(BOOL)animated {
    
}


/**
 *  VC가 끝나면, NSNotificationCenter를 제거함.
 */
- (void)dealloc {
    //지금 달려있는 VC의 모든 옵저버를 없앰
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //어떤 옵저버를 없앨 것인지 구체적으로 명시
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"randomizeCard" object:randomCardSupplyFactory];
}

@end
