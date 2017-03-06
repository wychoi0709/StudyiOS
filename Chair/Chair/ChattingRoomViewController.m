//
//  ChattingRoomViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 2. 28..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "ChattingRoomViewController.h"
#import "SendMessageCollectionViewCell.h"
#import "TakenMessgaeCollectionViewCell.h"

@import Firebase;

@interface ChattingRoomViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate> {
    
    //Firebase 관련 변수들
    int _msglength;
    FIRDatabaseHandle _refHandle;
    FIRDatabaseHandle _refChatroomIdHandle;
    
}
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIImageView *myPictureForSendingMsg;
@property (weak, nonatomic) IBOutlet UILabel *textFieldForInputTextCount;
@property (weak, nonatomic) IBOutlet UICollectionView *chattingCollectionView;

//Firebase 관련 객체들
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *messages;

@property NSString *chatroomId;
@property NSString *designerUid;
@property NSString *customerUid;
@property NSString *lastMessage;
@property NSString *timestamp;
@property Boolean isDesigner;

@end


@implementation ChattingRoomViewController


/*****************************************************************
 *   << 생명주기 관련 메소드 >>
 *****************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _msglength = 10;
    _messages = [[NSMutableArray alloc] init];
    
    _chattingCollectionView.delegate = self;
    _chattingCollectionView.dataSource = self;
    
    //노티 옵저버를 등록한다.
    [self applyNotiObserver];
    
    _messageTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    
}



/*****************************************************************
 *   << 콜렉션 뷰 관련 Delegate 관련 메소드 >>
 *****************************************************************/

//각 인덱스에 맞는 셀을 설정해주는 메소드(DataSource)
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"채팅에 대한 cellForItemAtIndexPath 메소드에 들어옴");
    
    // Firebase에서 꺼낸 메시지를 세팅한다. (Objective-c 문법 중 message[MessageFieldsname]은 뭘까...)
    FIRDataSnapshot *messageSnapshot = _messages[indexPath.row];
    NSDictionary<NSString *, NSString *> *message = messageSnapshot.value;
    
    NSString *text = message[@"text"];
    NSString *uid = message[@"uid"];
    
    Boolean isSendingMessage;
    
    /** 지금 메시지가 sendingMessage의 경우의 수는
        1. 내가 디자이너인데, uid == designerUid 이거나,
        2. 내가 디자이너가 아닌데, uid == customerUid!
        이외의 모든 건 지금은 sendingMessage가 NO라는 것.  **/
    if(_isDesigner && ([uid isEqualToString: _designerUid])) {
        isSendingMessage = YES;
    } else if ((!_isDesigner) && ([uid isEqualToString: _customerUid])) {
        isSendingMessage = YES;
    } else {
        isSendingMessage = NO;
    }

    //sendingMessage면 해당 셀을 반환하고,
    if ( isSendingMessage ) {
        
        SendMessageCollectionViewCell *sendMessageCollectionViewCell =[collectionView dequeueReusableCellWithReuseIdentifier:@"sendMessageCollectionViewCell" forIndexPath:indexPath];
        sendMessageCollectionViewCell.sendingMessageLabel.text = text;
        return sendMessageCollectionViewCell;
        
    //takenMessage면 해당 셀을 반환한다.
    } else {
    
        TakenMessgaeCollectionViewCell *takenMessgaeCollectionViewCell =[collectionView dequeueReusableCellWithReuseIdentifier:@"takenMessgaeCollectionViewCell" forIndexPath:indexPath];
        takenMessgaeCollectionViewCell.takenMessageLabel.text = text;
        return takenMessgaeCollectionViewCell;
    }
}

//Section 안에 몇개의 아이템이 들어가는지 설정(DataSrouce)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //채팅 정보가 얼마나 되는지 count를 셀 것
    return [_messages count];
}

//Section이 몇개인지(DataSource)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}



/*****************************************************************
 *   << 텍스트필드, 키보드 관련 메소드 >>
 *****************************************************************/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string {
    NSString *text = textField.text;
    if (!text) {
        return YES;
    }
    long newLength = text.length + string.length - range.length;
    return (newLength <= _msglength);
}


/**
 *  UITextViewDelegate protocol methods(텍스트 치다가 리턴 눌렀을 때의 메소드)
 *  전송 버튼 눌렀을 때도 여기로 연결된다.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //리턴을 누르면, 텍스트 필드를 무조건 내린다.
    [_messageTextField resignFirstResponder];
    
    //텍스트 필드가 비어있다면, 메시지를 날리지 않는다.
    if( ![textField.text isEqualToString:@""] ) {
        //lsatMessage에 텍스트를 넣어둔다.
        _lastMessage = textField.text;
        
        //텍스트 필드의 텍스트를 dictionary로 보낸다.
        [self sendMessage:@{@"text": textField.text}];
        
        //이 후 텍스트 필드를 비우고 내린다.
        textField.text = @"";
        [self.view endEditing:YES];
    }
    
    return YES;
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

/**
 *  키보드 날리는 함수
 */
-(void)dismissKeyboard {
    
    [_messageTextField resignFirstResponder];
    
}



/*****************************************************************
 *   << 버튼 관련 메소드 >>
 *****************************************************************/

//닫기 버튼 터치
- (IBAction)closingVCBtnTouched:(UIButton *)sender {
    
    //모든 옵저버를 지운다.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //ref는 Firebase의 데이터베이스 객체(FIRDatabaseReference)
    [[_ref child:@"messages"] removeObserverWithHandle:_refHandle];
    
    //chatmetas에 customerId: @"" / designerId: @"" / lastMessage: @"" / timestamp:@"" 4개 넣어둔다.
    //    [[[[_ref child:@"chatmetas"] child:_chatroomId] childByAutoId] setValue:mdata];
    
    
    //닫는다.
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)sendMessageBtnTouched:(UIButton *)sender {
    [self textFieldShouldReturn:_messageTextField];
}



/*****************************************************************
 *   << 내가 만든 관련 메소드 >>
 *****************************************************************/

/**
 *  콜렉션 뷰의 포커스를 가장 아래 셀로 옮기는 메소드 **콜렉션 뷰 소스 찾아볼 것(되는지 불명확함)
 */
-(void)goToBottom {
    NSArray *visibleItems = [self.chattingCollectionView indexPathsForVisibleItems];
    NSIndexPath *currentItem = [visibleItems objectAtIndex:0];
    NSIndexPath *nextItem = [NSIndexPath indexPathForItem:currentItem.item + 1 inSection:currentItem.section];
    [self.chattingCollectionView scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

/**
 *  메시지 보내기 기능(이미지, 텍스트 뭐든)
 */
- (void)sendMessage:(NSDictionary *)data {
    
    NSMutableDictionary *mdata = [data mutableCopy];
    
    //uid를 넣어서 같이 보낸다.
    mdata[@"uid"] = [FIRAuth auth].currentUser.uid;
//    mdata[@"name"] = @"";   //user 이름 혹은 디자이너 이름을 명기
//    _timestamp = [FIRServerValue timestamp];
//    mdata[@"timestamp"] = _timestamp;
    
    NSLog(@"mdata: %@", mdata);
    NSLog(@"timestamp: %@", [FIRServerValue timestamp]);
    
    //Timestamp 어떻게 찍더라
    
    //firebase의 데이터베이스에 데이터를 푸쉬한다. (messages라는 곳에 child로 넣는데, 새로운 ID를 자동 생성해서 mdata를 집어넣는다)
    [[[[_ref child:@"messages"] child:_chatroomId] childByAutoId] setValue:mdata];
}

//노티 옵저버를 등록한다.
- (void) applyNotiObserver {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(getDesignerAndCutomerUid:) name:@"getDesignerAndCutomerUid" object:nil];
    [notificationCenter addObserver:self selector:@selector(afterGetChatroomIdInfo:) name:@"getChatroomIdInfo" object:nil];
    
    //텍스트 필드에서 키보드 없애는 코드
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    //키보드 나타나거나, 없어질 때의 노티를 등록한다.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}



/*****************************************************************
 *   << 노티 관련 콜백 메소드 >>
 *****************************************************************/

//채팅룸Id 콜백 메소드
-(void) afterGetChatroomIdInfo:(NSNotification*)noti{
    NSLog(@"afterGetChatroomIdInfo 콜백 진입");
    
    //firebase 데이터베이스로부터 새로운 메시지를 리스닝한다.
    _refHandle = [[[_ref child:@"messages"] child:_chatroomId] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        
        NSLog(@"파이어베이스로부터 새로운 메시지를 리스닝한다는걸 선언함.");
        
        //새로운 메시지가 넘어오면, 메시지를 토탈 메시지에 넣고,
        [_messages addObject:snapshot];
        NSLog(@"새로운 메시지: %@", snapshot);
        
        //콜렉션 뷰를 갱신한다.
        [self.chattingCollectionView reloadData];
        NSLog(@"콜렉션 뷰 갱신 완료");

        //그 후 콜렉션 뷰를 아래로 보낸다.(보낼 수 없다. 아직 콜랙션 뷰에 내용이 채워지지 않았으니깐.
        NSInteger section = [self numberOfSectionsInCollectionView:self.chattingCollectionView] - 1;
        NSInteger item = [self collectionView:self.chattingCollectionView numberOfItemsInSection:section] - 1;
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        
        [self.chattingCollectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        NSLog(@"콜렉션 뷰 아래로 보내기");
    }];
}

- (void) getDesignerAndCutomerUid:(NSNotification*)noti {
    NSLog(@"getDesignerAndCutomerUid 콜백 진입");
    
    _designerUid =[[noti userInfo] objectForKey:@"designerUid"];
    _customerUid =[[noti userInfo] objectForKey:@"customerUid"];
    _isDesigner = [[[noti userInfo] objectForKey:@"isDesigner"] boolValue];
    
    NSLog(@"designerUid: %@", _designerUid);
    NSLog(@"custoemrUid: %@", _customerUid);
    NSLog(@"isDesigner : %@", [NSNumber numberWithBool:_isDesigner]);
    
    //Firebase의 설정을 세팅한다.
    [self configureDatabase];
}



/*****************************************************************
 *   << 파이어베이스 설정 관련 메소드 >>
 *****************************************************************/

/**
 *  Firebase Realtime database를 활용하기 위한 설정 메소드
 */
- (void)configureDatabase {
    NSLog(@"configureDatabase 진입(파이어베이스의 데이터베이스 설정하는 메소드)");

    //ref를 설정한다.
    _ref = [[FIRDatabase database] reference];
    
    //Firebase의 userChatinfo 테이블에 내 uid 객체 안의 -> 디자이너 uid 객체 안의 -> chatroomId를 가져온다(없음 만들고)
    [[[[_ref child:@"userChatInfo"] child:_customerUid] child:_designerUid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        //snapshop 결과가 없으면 새롭게 만들고 노티를 날린다.
        if(snapshot.value == (NSString *)[NSNull null]) {
            
            _chatroomId = [[[[_ref child:@"userChatInfo"] child:_customerUid] child:_designerUid] childByAutoId].key;
            NSLog(@"chatroomId: %@", _chatroomId);
            [[[[_ref child:@"userChatInfo"] child:_customerUid] child:_designerUid] setValue:@{@"chatroomId": _chatroomId}];
        } else {
            //있으면 잘 빼서
            NSDictionary *postDict = snapshot.value;
            _chatroomId = [postDict objectForKey:@"chatroomId"];
            NSLog(@"chatroomId: %@", _chatroomId);
        }
        
        //노티를 날린다.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getChatroomIdInfo" object:self userInfo:nil];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}

@end
