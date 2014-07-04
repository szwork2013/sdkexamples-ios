/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "CreateGroupViewController.h"

#import "ContactSelectionViewController.h"
#import "EMTextView.h"

@interface CreateGroupViewController ()<UITextFieldDelegate, UITextViewDelegate, EMChooseViewDelegate>

@property (nonatomic) BOOL isPublic;
@property (nonatomic) BOOL isOtherOn;
@property (strong, nonatomic) UIBarButtonItem *rightItem;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) EMTextView *textView;
@property (strong, nonatomic) UIView *switchView;
@property (strong, nonatomic) UILabel *groupTypeLabel;
@property (strong, nonatomic) UILabel *groupOtherTitleLabel;
@property (strong, nonatomic) UISwitch *groupOtherSwitch;
@property (strong, nonatomic) UILabel *groupOtherLabel;

@end

@implementation CreateGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isPublic = NO;
        _isOtherOn = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.title = @"创建群组";
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    addButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [addButton setTitle:@"添加成员" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addContacts:) forControlEvents:UIControlEventTouchUpInside];
    _rightItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    [self.navigationItem setRightBarButtonItem:_rightItem];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.switchView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = 3;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"请输入群组名称";
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    
    return _textField;
}

- (EMTextView *)textView
{
    if (_textView == nil) {
        _textView = [[EMTextView alloc] initWithFrame:CGRectMake(10, 70, 300, 80)];
        _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textView.layer.borderWidth = 0.5;
        _textView.layer.cornerRadius = 3;
        _textView.font = [UIFont systemFontOfSize:14.0];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeholder = @"请输入群组简介";
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
    }
    
    return _textView;
}

- (UIView *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UIView alloc] initWithFrame:CGRectMake(10, 160, 300, 80)];
        _switchView.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = @"群组权限";
        [_switchView addSubview:label];
        
        UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(100, 0, 50, _switchView.frame.size.height)];
        [switchControl addTarget:self action:@selector(groupTypeChange:) forControlEvents:UIControlEventValueChanged];
        [_switchView addSubview:switchControl];
        
        _groupTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(switchControl.frame.origin.x + switchControl.frame.size.width + 5, 0, 100, 35)];
        _groupTypeLabel.backgroundColor = [UIColor clearColor];
        _groupTypeLabel.font = [UIFont systemFontOfSize:12.0];
        _groupTypeLabel.textColor = [UIColor grayColor];
        _groupTypeLabel.text = @"私有群";
        [_switchView addSubview:_groupTypeLabel];
        
        _groupOtherTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _switchView.frame.size.height - 35, 100, 35)];
        _groupOtherTitleLabel.font = [UIFont systemFontOfSize:14.0];
        _groupOtherTitleLabel.backgroundColor = [UIColor clearColor];
        _groupOtherTitleLabel.text = @"成员邀请权限";
        [_switchView addSubview:_groupOtherTitleLabel];
        
        _groupOtherSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, _switchView.frame.size.height - 35, 50, 35)];
        [_groupOtherSwitch addTarget:self action:@selector(groupOtherChange:) forControlEvents:UIControlEventValueChanged];
        [_switchView addSubview:_groupOtherSwitch];
        
        _groupOtherLabel = [[UILabel alloc] initWithFrame:CGRectMake(_groupOtherSwitch.frame.origin.x + _groupOtherSwitch.frame.size.width + 5, _groupOtherTitleLabel.frame.origin.y, 150, 35)];
        _groupOtherLabel.backgroundColor = [UIColor clearColor];
        _groupOtherLabel.font = [UIFont systemFontOfSize:12.0];
        _groupOtherLabel.textColor = [UIColor grayColor];
        _groupOtherLabel.text = @"不允许群成员邀请其他人";
        [_switchView addSubview:_groupOtherLabel];
    }
    
    return _switchView;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - EMChooseViewDelegate

- (void)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    [self showHudInView:self.view hint:@"创建群组..."];
    
    NSMutableArray *source = [NSMutableArray array];
    for (EMBuddy *buddy in selectedSources) {
        [source addObject:buddy.username];
    }
    
    EMGroupStyleSetting *setting = [[EMGroupStyleSetting alloc] init];
    if (_isPublic) {
        if(_isOtherOn)
        {
            setting.groupStyle = EMGroupStylePublicOpenJoin;
        }
        else{
            setting.groupStyle = EMGroupStylePublicJoinNeedApproval;
        }
    }
    else{
        if(_isOtherOn)
        {
            setting.groupStyle = EMGroupStylePrivateMemberCanInvite;
        }
        else{
            setting.groupStyle = EMGroupStylePrivateOnlyOwnerInvite;
        }
    }
    
    __weak CreateGroupViewController *weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:self.textField.text description:self.textView.text invitees:source initialWelcomeMessage:@"" styleSetting:setting completion:^(EMGroup *group, EMError *error) {
        [weakSelf hideHud];
        if (group && !error) {
            [weakSelf showHint:@"创建群组成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            [weakSelf showHint:@"创建群组失败，请重新操作"];
        }
    } onQueue:nil];
    
//    if (_isPublic) {
//        [[EaseMob sharedInstance].chatManager asyncCreatePublicGroupWithSubject:self.textField.text description:self.textView.text invitees:source initialWelcomeMessage:@"" completion:^(EMGroup *group, EMError *error) {
//            [weakSelf hideHud];
//            if (group && !error) {
//                [weakSelf showHint:@"创建群组成功"];
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
//            else{
//                [weakSelf showHint:@"创建群组失败，请重新操作"];
//            }
//        } onQueue:nil];
//    }
//    else{
//        [[EaseMob sharedInstance].chatManager asyncCreatePrivateGroupWithSubject:self.textField.text description:self.textView.text invitees:source initialWelcomeMessage:@"" completion:^(EMGroup *group, EMError *error) {
//            [weakSelf hideHud];
//            if (group && !error) {
//                [weakSelf showHint:@"创建群组成功"];
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
//            else{
//                [weakSelf showHint:@"创建群组失败，请重新操作"];
//            }
//        } onQueue:nil];
//    }
}

#pragma mark - action

- (void)groupTypeChange:(UISwitch *)control
{
    _isPublic = control.isOn;
    
    [_groupOtherSwitch setOn:NO animated:NO];
    [self groupOtherChange:_groupOtherSwitch];
    
    if (control.isOn) {
        _groupTypeLabel.text = @"公有群";
    }
    else{
        _groupTypeLabel.text = @"私有群";
    }
}

- (void)groupOtherChange:(UISwitch *)control
{
    if (_isPublic) {
        _groupOtherTitleLabel.text = @"成员加入权限";
        if(control.isOn)
        {
            _groupOtherLabel.text = @"随便加入";
        }
        else{
            _groupOtherLabel.text = @"加入群组需要管理员同意";
        }
    }
    else{
        _groupOtherTitleLabel.text = @"成员邀请权限";
        if(control.isOn)
        {
            _groupOtherLabel.text = @"允许群成员邀请其他人";
        }
        else{
            _groupOtherLabel.text = @"不允许群成员邀请其他人";
        }
    }
    
    _isOtherOn = control.isOn;
}

- (void)addContacts:(id)sender
{
    if (self.textField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入群组名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self.view endEditing:YES];
    
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] init];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

@end
