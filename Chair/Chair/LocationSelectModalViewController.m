//
//  LocationSelectModalViewController.m
//  Chair
//
//  Created by 최원영 on 2016. 12. 21..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "LocationSelectModalViewController.h"
#import "LocationCollectionViewCell.h"
#import "ColorValue.h"
#import "LocationCollectionReusableView.h"
#import "Location.h"

//Custom Cell의 ID
NSString *locationCell = @"locationCell";

@interface LocationSelectModalViewController ()

//CollectionView를 가져온다.
@property (weak, nonatomic) IBOutlet UICollectionView *locationCollectionView;

//NSUserDefaults에서 꺼내온 locationData를 넣을 곳
@property NSArray *locationData;

//cityDetail마다 section을 만들어서 값을 매치시켜놓을 Array
@property NSMutableArray *sectionNumberWithCityDetail;

//custom cell
@property LocationCollectionViewCell *cell;

@end

@implementation LocationSelectModalViewController

//section의 개수를 셀 때 쓸 변수
NSInteger sectionCount = 0;


/**
 *  취소 버튼을 눌렀을 때, 현재 viewController를 날리는 매소드
 */
- (IBAction)cancelBtnTouched:(UIButton *)sender {
    
    NSLog(@"LocationSelectModalViewController의 취소 버튼 눌림");
    [self dismissViewControllerAnimated:YES completion:nil];

}


/**
 *  뷰 로드 완료
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CollectionView의 Delegate를 자기자신(VC)로 지정한다
    _locationCollectionView.delegate = self;
    _locationCollectionView.dataSource = self;
    
    //CollectionView의 기본 배경색을 지정한다
    self.locationCollectionView.backgroundColor = [[ColorValue getColorValueObject] grayColorChair];
    
    //NSUserDefaults에서 locationData를 빼온 뒤, 그 안의 locations를 Array에 넣어둔다.
    NSUserDefaults *standardDefault = [NSUserDefaults standardUserDefaults];
    _locationData = [[standardDefault objectForKey:@"locationData"] objectForKey:@"locations"];
    
    //locationData를 뒤지면서 sectionCount를 초기화하고, sectionNumber와 함께 cityDetail값을 담는다.
    _sectionNumberWithCityDetail = [[NSMutableArray alloc] init];
    
    NSString *cityDetail = [[_locationData objectAtIndex:0] objectForKey:@"cityDetail"];
    NSString *tempCityDetail;
    [_sectionNumberWithCityDetail addObject:cityDetail];
    sectionCount++;
    
    for(int i = 0; i < _locationData.count; i++) {
        tempCityDetail = [[_locationData objectAtIndex:i] objectForKey:@"cityDetail"];
        if(![cityDetail isEqualToString:tempCityDetail]) {
            sectionCount++;
            [_sectionNumberWithCityDetail addObject:tempCityDetail];
            cityDetail = tempCityDetail;
        }
    }

}

-(void)viewDidDisappear:(BOOL)animated{
    //모달을 닫으면서 sectionCount를 초기화한다.
    sectionCount = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  Section의 헤더 만들기(Datasource)
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        //섹션을 가져온다.
        LocationCollectionReusableView *rView = [self.locationCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"locationSection" forIndexPath:indexPath];
        rView.sectionHeaderLabel.text = [_sectionNumberWithCityDetail objectAtIndex:indexPath.section];
        return rView;
    }
    return nil;
    
}


/**
 *  Section이 몇개인지(Datasource)_viewDidLoad에서 처리함
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return sectionCount;
}


/**
 *  Section안에 아이템이 몇 개인지(Datasource)
 */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    //위에서 section별 cityDetail을 넣어두는 배열을 만들었으니, 거기서 해당 section에 대한 cityDetil을 뺀 뒤, locationData에서 같은 cityDetail을 가지고 있는 숫자만큼 아이템을 생성한다.
    NSInteger itemCount = 0;
    NSString *cityDetailInThisSection = [_sectionNumberWithCityDetail objectAtIndex:section];
    NSString *tempCityDetail;
    
    for(int i = 0; i < _locationData.count; i++) {
        tempCityDetail = [[_locationData objectAtIndex:i] objectForKey:@"cityDetail"];
        
        if([cityDetailInThisSection isEqualToString:tempCityDetail]) {
            itemCount++;
        }
    }
    return itemCount;
    
}


/**
 *  셀 간의 줄간격 조절
 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2.0;
}


/**
 *  셀 간의 중간 간격 조절
 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.0;
}



/**
 *  셀 크기 조절
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((collectionView.frame.size.width/2 - 1), 36.0);
}


/**
 *  셀 모양, 셀 내용 조절
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    _cell = [cv dequeueReusableCellWithReuseIdentifier:locationCell forIndexPath:indexPath];
    
    //현재 cityDetail을 뽑아옴
    NSString *correntCityDetail = [_sectionNumberWithCityDetail objectAtIndex:indexPath.section];
    int index = 0;
    
    for(int i =0; i < _locationData.count; i++) {
        //citiDetail 값이 같을 때의 i 값을 가져옴
        if([correntCityDetail isEqualToString:[[_locationData objectAtIndex:i] objectForKey:@"cityDetail"]]) {
            index = i;
            break;
        }
    }
    
    _cell.oneOfLocationLabel.text = [[_locationData objectAtIndex:(index + indexPath.row)] objectForKey:@"location"];
    
    return _cell;
}


/**
 *  셀 선택되면 뭐할건지.
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    //여기 지금 안먹힘!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 왜인지 알아낼 것
//    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:collectionView.frame];
//    [selectedBackgroundView setBackgroundColor:[[ColorValue getColorValueObject] blueColorChair]];
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//    [selectedCell setBackgroundColor:[[ColorValue getColorValueObject] blueColorChair]];
    selectedCell.contentView.backgroundColor = [[ColorValue getColorValueObject] blueColorChair];
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    
    //Location 정보를 뽑기위해 index값을 구한다.
    NSString *correntCityDetail = [_sectionNumberWithCityDetail objectAtIndex:indexPath.section];
    int index = 0;
    
    for(int i =0; i < _locationData.count; i++) {
        //citiDetail 값이 같을 때의 i 값을 가져옴
        if([correntCityDetail isEqualToString:[[_locationData objectAtIndex:i] objectForKey:@"cityDetail"]]) {
            index = i;
            break;
        }
    }
    
    
    //Location을 만든다.
    NSInteger id = [[[_locationData objectAtIndex:(index + indexPath.row)] objectForKey:@"id"] integerValue];
    NSString *city = [[_locationData objectAtIndex:(index + indexPath.row)] objectForKey:@"city"];
    NSString *cityDetail = [[_locationData objectAtIndex:(index + indexPath.row)] objectForKey:@"cityDetail"];
    NSString *location = [[_locationData objectAtIndex:(index + indexPath.row)] objectForKey:@"location"];
    NSString *locationDetail = [[_locationData objectAtIndex:(index + indexPath.row)] objectForKey:@"locationDetail"];
    
    Location *myLocation = [[Location alloc] initWithLocationInfo:id withCity:city withCityDetail:cityDetail withLocation:location withLocationDetail:locationDetail];
    
    //노티로 보낼 데이터를 담는다.
    NSDictionary *locationDictionary = [NSDictionary dictionaryWithObject:myLocation forKey:@"myLocation"];
    
    //센터를 만들고, 노티를 보낸다.
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"changeMyLocation" object:self userInfo:locationDictionary];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  section간의 간격을 띄운다.
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //bottom을 20준다.
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 20, 0);
    return inset;
}

@end
