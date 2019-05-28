//
//  SearchBarDisplayCenter.m
//  KunShanETDZ
//
//  Created by 云联智慧 on 2019/5/20.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "SearchBarDisplayCenter.h"

@interface SearchBarDisplayCenter ()<UITextFieldDelegate>
/** 搜索标志 */
@property (nonatomic,strong) UIImageView *seachIconIV;
/** 底部view */
@property (nonatomic,strong) UIView *containerView;
/** 输入框 */
@property (nonatomic,strong) UITextField *searchField;
/** 提示 */
@property (nonatomic,strong) UILabel *placeholderLabel;
/** 盛装提示语和搜索标志的view */
@property (nonatomic,strong) UIView *placeholderView;
/** 记录居中时候搜索提示view的x坐标 */
@property(nonatomic,assign)CGFloat searchX;
@end

@implementation SearchBarDisplayCenter

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _containerView = [[UIView alloc]init];
        
        [self addSubview:_containerView];
        
        _searchField = [[UITextField alloc]init];
        _searchField.delegate = self;
        [_containerView addSubview:_searchField];
        
        _placeholderView = [[UIView alloc]init];
        [_containerView addSubview:_placeholderView];
        
        _placeholderLabel = [[UILabel alloc]init];
        [_placeholderView addSubview:_placeholderLabel];
        _seachIconIV = [[UIImageView alloc]init];
        [_placeholderView addSubview:_seachIconIV];
        [self addObserver];
    }
    return self;
}
#pragma mark -- 弹出键盘
-(void)showKeyboard:(NSNotification *)notification
{
    //键盘出现后的位置
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = endFrame.size.height;
    if (keyboardHeight==0)
    {
        //解决搜狗输入法三次调用此方法的bug、
        //        IOS8.0之后可以安装第三方键盘，如搜狗输入法之类的。
        //        获得的高度都为0.这是因为键盘弹出的方法:- (void)keyBoardWillShow:(NSNotification *)notification需要执行三次,你如果打印一下,你会发现键盘高度为:第一次:0;第二次:216:第三次:282.并不是获取不到高度,而是第三次才获取真正的高度.
        return;
    }
    //键盘弹起时的动画效果
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    //键盘动画时长
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    __block typeof(self)weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        
        weakSelf.placeholderView.frame = CGRectMake(16.0, 0, weakSelf.placeholderView.frame.size.width, weakSelf.placeholderView.frame.size.height);
    } completion:nil];
    
}
#pragma mark --- 收起键盘
-(void)hideKeyboard:(NSNotification *)notification
{
    NSLog(@"收起键盘");
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        if(weakSelf.searchField.text.length == 0)
        {
           weakSelf.placeholderView.frame = CGRectMake(weakSelf.searchX, 0, weakSelf.placeholderView.frame.size.width, weakSelf.placeholderView.frame.size.height);
        }
        
        
    } completion:nil];
}
#pragma mark 移除监听
/** 移除监听 */
-(void)dealloc
{
    NSLog(@"移除监听");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark 添加监听
/** 添加监听 */
-(void)addObserver
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldContentDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)textFieldContentDidChange:(NSNotification *)notification
{
    NSLog(@"textFieldContentDidChange");
    if(_searchField.text.length)
    {
        _placeholderLabel.hidden = YES;
    }
    else
    {
        _placeholderLabel.hidden = NO;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(getSearchKeyWord:)])
    {
        [_delegate getSearchKeyWord:_searchField.text];
    }
}
-(void)layoutSubviews
{
    CGFloat containerW = self.frame.size.width - 20.0;
    _containerView.frame = CGRectMake(10.0, 2.0, containerW, 35.0);
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 35.0 / 2.0;
    _containerView.layer.masksToBounds = YES;
    
    _searchField.frame = CGRectMake(16.0 + 14.0, 0, containerW - (16.0 + 14.0) - 16.0, 35.0);
    _searchField.font = [UIFont systemFontOfSize:13.0];
    _searchField.returnKeyType = UIReturnKeySearch;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_searchField.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(35.0 / 2.0, 35.0 / 2.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    //设置大小
    maskLayer.frame = _searchField.bounds;
    
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    _searchField.layer.mask = maskLayer;
    NSString *placeHolderStr = _placeholderStr.length?_placeholderStr:@"请输入关键词";
    CGSize needSize = [placeHolderStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 35.0) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0]} context:nil].size;
    //计算放大镜和提示语所占据宽度
    CGFloat needW = needSize.width + 2.0 + 4.0 + 14.0;
    _placeholderView.frame = CGRectMake((containerW - needW) / 2.0, 0, needW, 35.0);
    _searchX = (containerW - needW) / 2.0;
    _seachIconIV.frame = CGRectMake(0, (35.0 - 11.0) / 2.0, 14.0, 11.0);
    _seachIconIV.image = [UIImage imageNamed:@"search-icon"];
    _seachIconIV.userInteractionEnabled = NO;
    _placeholderLabel.frame = CGRectMake(_seachIconIV.frame.origin.x + _seachIconIV.frame.size.width + 4.0, 0, needSize.width + 2.0, 35.0);
    _placeholderLabel.text = placeHolderStr;
    _placeholderLabel.font = [UIFont systemFontOfSize:13.0];
    _placeholderLabel.userInteractionEnabled = YES;
    _placeholderLabel.textColor = [UIColor colorWithRed:(CGFloat)179.0 / 255.0 green:(CGFloat)179.0 / 255.0 blue:(CGFloat)179.0 / 255.0 alpha:1.0];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToShowKeyboard:)];
    [_placeholderView addGestureRecognizer:tapGesture];
}
-(void)tapToShowKeyboard:(UITapGestureRecognizer *)tapGesture
{
    [_searchField becomeFirstResponder];
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}
@end
