//
//  ViewController.m
//  W6NetworkTest
//
//  Created by 최원영 on 2016. 11. 9..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "ViewController.h"
#import "LoginNextwork.h"
#import "MyCustomCell.h"
#import "TestNetwork.h"
#import "TableViewController.h"

@interface ViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *loginResultLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tableCellLabel;

@end


@implementation ViewController

//로그인 요청 네트워크를 담당하는 모델
LoginNextwork *loginNetwork;

//TestNetwork 네트워크를 담당하는 모델
TestNetwork *testNetwork;

//TestNetwork에서 받은 ArrayList
NSArray *testResult;

/**
 *  TableView로 이동하는 코드들
 */
- (IBAction)moveTableView:(UIButton *)sender {
    
    TableViewController *tableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
    
    [self presentViewController:tableVC animated:YES completion:nil];
    
}



/**
 *  로그인 요청 보내기
 **/
- (IBAction)sendLoginRequest:(UIButton *)sender {
    
    //로그인 결과를 받는다.
    NSDictionary *loginResultDict = [loginNetwork sendLoginRequest];
    
//    _loginResultLabel.text = [loginResultDict objectForKey:@"statusCode"];
    
    
    /**
     *  NSDictionary 사용법
     **/
//    NSArray          *dicts = ...; // wherever you get the array
//    NSDictionary   *mijnDict = [dicts objectAtIndex: n];
//    NSString     *omschrijving = [mijnDict objectForKey: @"Omschrijving"];
//    NSDictionary *ophaaldata = [mijnDict objectForkey: @"Ophaaldata"];
//    NSArray    *datum = [ophaaldata objectForkey: @"Datum"];
//    NSString *eersteDatum = [datum objectAtIndex: 0];
    
}


/**
 *  테이블 뷰에 몇 줄이나 그려야하니?(보통 내가 설정한 변수명인, tableView로 시작한다)
 *  section: 테이블 뷰의 그룹 구분(이 섹션 안에 row들이 존재한다)
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return testResult.count;   //네트워크 이후 받은 array 배열의 크기만큼 row가 생긴다.
}


/**
 *  Index Path를 보고 row에 맞는 셀을 리턴해주는 함수
 *  함수명을 잘 읽어보면 무슨 함수인지를 알 수 있다.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Array중 indexPath에 있는 애를 Dictionary에 저장한다.
    NSDictionary *row = testResult[indexPath.row];
    
    //Dictionary의 정보를 빼서 String으로 저장한다.
    NSString     *title = [row objectForKey: @"title"];
    NSLog(@"Parsing Result = %@", title );
    
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"basicTableCell" forIndexPath:indexPath];
    MyCustomCell* cell = [tableView dequeueReusableCellWithIdentifier:@"basicTableCell2" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", title];
//    cell.tableButton.title = [NSString stringWithFormat:@"%@", title];
    cell.tableButton.tag = indexPath.row;
    return cell;
}



/**
 *  페이지 로딩 완료
 **/
- (void)viewDidLoad {
    [super viewDidLoad];

    //로그인 네트워크 요청 객체 생성
    loginNetwork = [[LoginNextwork alloc] init];
    
    //tableView Test 네트워크 요청 객체 생성
    testNetwork = [[TestNetwork alloc] init];
    
    //TestNetwork에서 받아온 결과를 저장한다(테이블 뷰 세팅할 때 사용할 것)
    testResult = [testNetwork getTestDataForStudy];
    
    
    
    //TableDelegate를 선언한다.
//    self.tableView.delegate = self;   //  <UITableViewDelegate> -> 이건 눌렀을 때 뷰가 어떻게 바뀌는지 등등
    self.tableView.dataSource = self; // -> 셀에 버튼이 있고 그걸 동작하게하려면 셀클레스를 만들어서 동작하게 해야함
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
