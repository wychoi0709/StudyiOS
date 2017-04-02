//
//  CustomerListModalViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 3. 27..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "CustomerListModalViewController.h"
#import "CustomerListCollectionViewCell.h"
#import "CustomerListNetworkService.h"
#import "ColorValue.h"
#import "ChattingRoomViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface CustomerListModalViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *myCustomerCollectionView;
@property NSMutableDictionary *userInfo;
@property NSString *designerId;
@property NSMutableArray *customerList;
@property NSString *urlString;
@property (weak, nonatomic) IBOutlet UIView *viewOfNoCustomer;

@property NSIndexPath *targetIndexPath;

@end

@implementation CustomerListModalViewController

/*****************************************************************
 *   << 생명주기 관련 메소드 >>
 *****************************************************************/
- (BOOL)shouldAutorotate { return NO; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //초기 세팅
    [self initSettingForThisVC];
    
    //노티 옵저버를 등록한다.
    [self applyNotiObserver];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/*****************************************************************
 *   << 버튼터치 관련 메소드 >>
 *****************************************************************/

/**
 *  닫기 버튼 터치
 */
- (IBAction)closeBtnTouched:(UIButton *)sender {
    
    //모든 옵저버를 지운다.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 *  메시지 버튼 터치
 */
- (void) messageButtonTouched: (UIButton*)sender {
    NSLog(@"messageButtonTouched");
    
    ChattingRoomViewController *chattingRoomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"chattingRoomViewController"];
    
    chattingRoomViewController.isDesigner = true;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myCustomerCollectionView];
    _targetIndexPath = [self.myCustomerCollectionView indexPathForItemAtPoint:buttonPosition];
    
    if (_targetIndexPath != nil){

        Boolean isDesigner = YES;
        NSMutableDictionary *tempMutableDic = [[NSMutableDictionary alloc] init];
        [tempMutableDic setObject:_userInfo forKey:@"designerInfo"];
        [tempMutableDic setObject:_customerList[_targetIndexPath.row] forKey:@"customerInfo"];
        [tempMutableDic setObject:[NSNumber numberWithBool:isDesigner] forKey:@"isDesigner"];
        
        NSDictionary *userAndDesignerinfo = tempMutableDic;
 
        [self presentViewController:chattingRoomViewController animated:YES completion:^(){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getDesignerAndCutomerUid" object:self userInfo:userAndDesignerinfo];
        }];
        
    }
    
}


/*****************************************************************
 *   << 콜백 메소드 >>
 *****************************************************************/
- (void)getcustomerListResult: (NSNotification*)noti{
    NSLog(@"getCustomerListResult에 들어옴");
    
    _viewOfNoCustomer.hidden = YES;
    _myCustomerCollectionView.hidden = NO;
    
    _customerList = [[noti userInfo] objectForKey:@"customerListResult"];
    NSLog(@"customerList: %@", _customerList);
    
    [_myCustomerCollectionView reloadData];
}

- (void)getNoCustomerListResult: (NSNotification*)noti {
    NSLog(@"getNoCustomerListResult에 들어옴");
    _viewOfNoCustomer.hidden = NO;
    _myCustomerCollectionView.hidden = YES;
}
- (void) backToCustomerList: (NSNotification*)noti{
    NSLog(@"backToCustomerList 진입");
    [self initSettingForThisVC];
}
/*****************************************************************
 *   << 내가 만든 메소드 >>
 *****************************************************************/
- (void) initSettingForThisVC {
    _myCustomerCollectionView.delegate = self;
    _myCustomerCollectionView.dataSource = self;
    
    _viewOfNoCustomer.hidden = YES;

    _userInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] mutableCopy];
    _designerId = [[_userInfo objectForKey:@"designer"] objectForKey:@"id"]; //이게 디자이너 아이디
    
    CustomerListNetworkService *customerListNetworkService = [[CustomerListNetworkService alloc] init];
    [customerListNetworkService getCustomerListWithDesignerId:_designerId];
    
    //이미지 처리를 위한 기본 URL 확보
    _urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UrlInfoByYoung"];
}

- (void) applyNotiObserver {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(getcustomerListResult:) name:@"customerListResult" object:nil];
    [notificationCenter addObserver:self selector:@selector(getNoCustomerListResult:) name:@"noCustomerListResult" object:nil];
    [notificationCenter addObserver:self selector:@selector(backToCustomerList:) name:@"backToCustomerList" object:nil];
    
}


/*****************************************************************
 *   << 콜렉션뷰 관련 메소드 >>
 *****************************************************************/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"셀 만들어서 넣어주는 메소드에 들어옴");
    
    //스토리보드에서 셀을 추출한다.
    CustomerListCollectionViewCell *customerListCollectionViewCell = [_myCustomerCollectionView dequeueReusableCellWithReuseIdentifier:@"customerListCollectionViewCell" forIndexPath:indexPath];
    
    //정보를 빼온다.
    NSDictionary *aCustomer = _customerList[indexPath.row];
    
    //사진 매칭.
    NSString *pictureUrl = [_urlString stringByAppendingString:[aCustomer objectForKey:@"filename"]];
    [customerListCollectionViewCell.customerImageView sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
    //코너를 동그랗게 만든다.
    customerListCollectionViewCell.customerImageView.layer.borderWidth = 2.0f;
    customerListCollectionViewCell.customerImageView.layer.borderColor = ([ColorValue getColorValueObject].brownColorChair).CGColor;
    customerListCollectionViewCell.customerImageView.layer.cornerRadius = customerListCollectionViewCell.customerImageView.frame.size.width / 2;
    customerListCollectionViewCell.customerImageView.clipsToBounds = YES;
    
    //성별 매칭.
    NSString *gender = [aCustomer objectForKey:@"sex"];
    if ( [gender isEqualToString:@"F"] ) {
        customerListCollectionViewCell.customerGenderLabel.text = @"여";
    } else {
        customerListCollectionViewCell.customerGenderLabel.text = @"남";
    }
    
    //기타정보 매칭
    customerListCollectionViewCell.customerNameLabel.text = [aCustomer objectForKey:@"name"];
    customerListCollectionViewCell.customerPlaceLabel.text = [[aCustomer objectForKey:@"location"] objectForKey:@"location"];
    
    //메시지가 왔는지 여부에 따라서 N표시
    Boolean isTakenMessage = [[aCustomer objectForKey:@"isTakenMessage"] boolValue];
    if( isTakenMessage ) {
        customerListCollectionViewCell.messageCircleView.hidden = NO;
    } else {
        customerListCollectionViewCell.messageCircleView.hidden = YES;
    }
    
    [customerListCollectionViewCell.messageButton addTarget:self action:@selector(messageButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    return customerListCollectionViewCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_customerList count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

/**
 *  화면 넓이에 따라서 셀의 크기를 조정해주는 코드
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float cellWidth = self.myCustomerCollectionView.frame.size.width;
    float cellHeight = cellWidth * 12.8f / 38.1f;
    
    return CGSizeMake(cellWidth, cellHeight);
}
@end
