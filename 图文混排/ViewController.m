//
//  ViewController.m
//  图文混排
//
//  Created by caiyao's Mac on 15/10/14.
//  Copyright © 2015年 core's Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordArr;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *emotionBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    [self.toolBar addSubview:self.textField];
    [self.toolBar addSubview:self.emotionBtn];
    [self.view addSubview:self.toolBar];
    [self observeKeyboardChange];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeKeyboardChange
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notify
{
    
}

- (void)keyBoardWillShow:(NSNotification *)notify
{
    NSTimeInterval timeInterval = [notify.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    float keyBoardHeight = [notify.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    [UIView animateWithDuration:timeInterval animations:^{
        
        self.toolBar.frame = CGRectMake(0, WIN_SIZE.height - 44 - keyBoardHeight, WIN_SIZE.width, 44);
        self.tableView.frame = CGRectMake(0, 20, WIN_SIZE.width, WIN_SIZE.height - keyBoardHeight - 64);
    
    }];
}

- (void)keyBoardWillHide:(NSNotification *)notify
{
    NSTimeInterval timeInterval = [notify.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    [UIView animateWithDuration:timeInterval animations:^{
        
        self.toolBar.frame = CGRectMake(0, WIN_SIZE.height - 44, WIN_SIZE.width, 44);
        self.tableView.frame = CGRectMake(0, 20, WIN_SIZE.width, WIN_SIZE.height - 20 - 44);

    }];
}

-(UIButton *)emotionBtn
{
    if (!_emotionBtn)
    {
        _emotionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _emotionBtn.frame = CGRectMake(WIN_SIZE.width - 10 - 30, 7, 30, 30);
        [_emotionBtn setTitle:@"表情" forState:UIControlStateNormal];
        [_emotionBtn addTarget:self action:@selector(showEmotionView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emotionBtn;
}

- (void)showEmotionView
{
    if (self.textField.isFirstResponder)
    {
        EmotionListView *emotionListView = [[EmotionListView alloc] initWithFrame:CGRectMake(0, WIN_SIZE.height - 200, WIN_SIZE.width, 200)];
        emotionListView.delegate = self;
        emotionListView.tag = 500;
        [self.view addSubview:emotionListView];
        
        self.tableView.frame = CGRectMake(0, 20, WIN_SIZE.width, WIN_SIZE.height - 20 - 44 - 200);
        [self.textField resignFirstResponder];
        self.toolBar.frame = CGRectMake(0, WIN_SIZE.height - 200 - 44, WIN_SIZE.width, 44);
    }
    else
    {
        [[self.view viewWithTag:500] removeFromSuperview];
        
        [self.textField becomeFirstResponder];
    }
}

-(void)imageViewTapedWithTag:(NSInteger)index
{
    NSString *emotionStr = nil;
    
    switch (index)
    {
        case 1:
            emotionStr = @"/笑脸";
            break;
        default:
            break;
    }
    
    self.textField.text = emotionStr;
}

-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, WIN_SIZE.width, WIN_SIZE.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textField.text.length == 0)
    {
        return NO;
    }
    
    [self.recordArr addObject:self.textField.text];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.recordArr.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    self.textField.text = @"";
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[self.view viewWithTag:500] removeFromSuperview];
    return YES;
}

-(UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, WIN_SIZE.width - 20, 30)];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.returnKeyType = UIReturnKeySend;
        _textField.delegate = self;
    }
    return  _textField;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        [self.textField resignFirstResponder];
    }
}

-(UIToolbar *)toolBar
{
    if (!_toolBar)
    {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, WIN_SIZE.height - 44, WIN_SIZE.width, 44)];
    }
    return _toolBar;
}

-(NSMutableArray *)recordArr
{
    if (!_recordArr)
    {
        _recordArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _recordArr;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.numberOfLines = 0;
    }
    
    NSString *pattern = @"/[\\u4e00-\\u9fa5]{2}";
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regx matchesInString:self.recordArr[indexPath.row] options:NSMatchingReportCompletion range:NSMakeRange(0, [self.recordArr[indexPath.row] length])];
    if (results.count != 0)
    {
        NSTextCheckingResult * res = [results lastObject];
        NSString *strdd = [self.recordArr[indexPath.row] substringWithRange:res.range];
        NSLog(@"%@", strdd);
    }
    
    NSTextAttachment *textA = [[NSTextAttachment alloc] init];
    textA.image = [UIImage imageNamed:@"Expression_1"];
    
    NSMutableAttributedString *mrfdg = [NSMutableAttributedString attributedStringWithAttachment:textA];
    cell.textLabel.attributedText = mrfdg;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArr.count;
}














@end
