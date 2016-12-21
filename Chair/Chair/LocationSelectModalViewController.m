//
//  LocationSelectModalViewController.m
//  Chair
//
//  Created by 최원영 on 2016. 12. 21..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "LocationSelectModalViewController.h"
#import "LocationCollectionViewCell.h"

//Custom Cell의 ID
NSString *locationCell = @"locationCell";

@interface LocationSelectModalViewController ()

//CollectionView를 가져온다.
@property (weak, nonatomic) IBOutlet UICollectionView *locationCollectionView;


@end

@implementation LocationSelectModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CollectionView의 Delegate를 자기자신(VC)로 지정한다
    _locationCollectionView.delegate = self;
    _locationCollectionView.dataSource = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Section의 헤더 만들기(Datasource)
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
   
    //이게 뭔지 찾아보고, 어떻게 만드는지 알아볼 것
    UICollectionReusableView *customHeader;
    
    return customHeader;
}

//Section이 몇개인지(Datasource)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

//Section안에 아이템이 몇 개인지(Datasourc)
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    LocationCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:locationCell forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
    cell.oneOfLocationLabel.text = [NSString stringWithFormat:@"랄랄랄 {%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
