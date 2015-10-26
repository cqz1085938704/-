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

#pragma mark - application life cycle
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

#pragma mark - keyboard
- (void)observeKeyboardChange
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShow:(NSNotification *)notify
{
    NSTimeInterval timeInterval = [notify.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    float keyBoardHeight = [notify.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    [UIView animateWithDuration:timeInterval animations:^{
        
        self.toolBar.frame = CGRectMake(0, WIN_SIZE.height - 44 - keyBoardHeight, WIN_SIZE.width, 44);
        self.tableView.frame = CGRectMake(0, 20, WIN_SIZE.width, WIN_SIZE.height - keyBoardHeight - 64);
        
        if (self.recordArr.count > 0)
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.recordArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
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

#pragma mark - lazy loading
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

-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, WIN_SIZE.width, WIN_SIZE.height - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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

-(UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, WIN_SIZE.width - 20 - 10 - 30, 30)];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.returnKeyType = UIReturnKeySend;
        _textField.delegate = self;
    }
    return  _textField;
}

#pragma mark - other
- (void)showEmotionView
{
    if (self.textField.isFirstResponder)
    {
        [self.textField resignFirstResponder];
        self.toolBar.frame = CGRectMake(0, WIN_SIZE.height - 200 - 44, WIN_SIZE.width, 44);
        self.tableView.frame = CGRectMake(0, 20, WIN_SIZE.width, WIN_SIZE.height - 20 - 44 - 200);
        
        EmotionListView *emotionListView = [[EmotionListView alloc] initWithFrame:CGRectMake(0, WIN_SIZE.height - 200, WIN_SIZE.width, 200)];
        emotionListView.delegate = self;
        emotionListView.tag = 500;
        [self.view addSubview:emotionListView];
    }
    else
    {
        [[self.view viewWithTag:500] removeFromSuperview];
        
        [self.textField becomeFirstResponder];
    }
}

#pragma mark - EmotionListViewDelegate
-(void)imageViewTapedWithTag:(NSInteger)index
{
    NSMutableString *mStr = [[NSMutableString alloc] initWithCapacity:1];
    [mStr appendString:self.textField.text];
    
    NSString *emotionName = [self getEmotionStringWithIndex:index];
    
    [mStr appendString:emotionName];
    self.textField.text = mStr;
}

- (NSString *)getEmotionStringWithIndex:(NSInteger)index
{
    NSString *imageName = [NSString stringWithFormat:@"Expression_%li", (long)index];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EmotionMap" ofType:@"plist"];
    NSDictionary *emotionDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *emotionName = emotionDic[imageName];
    return emotionName;
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textField.text.length == 0)
    {
        return NO;
    }
    
    [self.recordArr addObject:self.textField.text];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.recordArr.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    self.textField.text = @"";
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.recordArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[self.view viewWithTag:500] removeFromSuperview];
    return YES;
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        [self.textField resignFirstResponder];
    }
}


#pragma mark - UITableViewDelegate and UITextFieldDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSString *message = self.recordArr[indexPath.row];
    
    NSString *pattern = @"\\[[\\u4e00-\\u9fa5]+\\]";
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regx matchesInString:message options:NSMatchingReportCompletion range:NSMakeRange(0, [message length])];
    
    if (results.count == 0)
    {
        cell.textLabel.text = message;
    }
    else
    {
        NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:message];
        //NSMutableString *mstr = [NSMutableString stringWithString:message];
        for (NSTextCheckingResult *checkingResult in results)
        {
            NSArray *arr1 = [message componentsSeparatedByString:[message substringWithRange:checkingResult.range]];
            
            
            NSString *emotionStr = [message substringWithRange:checkingResult.range];
            NSLog(@"%@", emotionStr);
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EmotionMap" ofType:@"plist"];
            NSDictionary *emotionDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
            
            NSTextAttachment *textA = [[NSTextAttachment alloc] init];
            for (NSString *key in [emotionDic allKeys])
            {
                if ([emotionDic[key] isEqual:emotionStr])
                {
                    textA.image = [UIImage imageNamed:key];
                    break;
                }
            }
            NSAttributedString *emotionAttr = [NSAttributedString attributedStringWithAttachment:textA];
        }
        
        
        cell.textLabel.attributedText = mutableAttributedStr;
    }
    
    cell.imageView.image = [UIImage imageNamed:@"Expression_1@2x"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = [self.recordArr[indexPath.row] boundingRectWithSize:CGSizeMake(WIN_SIZE.width - 90, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    CGFloat height = 10 + rect.size.height + 10 + 10;
    
    if (height < 80)
    {
        return 80;
    }
    
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArr.count;
}









@end
