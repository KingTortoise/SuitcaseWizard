//
//  PlayMethodViewController.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/10.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "PlayMethodViewController.h"
#import "Utils.h"

#define SW_MAX_STARWORDS_LENGTH  200

@interface PlayMethodViewController ()
@property (weak, nonatomic) IBOutlet UILabel *remaining;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) UIButton *saveButton;
@end

@implementation PlayMethodViewController
#pragma mark - lifeCricle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self bindData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - init
- (void)initView{
    [self judgePlayMethodNum];
    [self setNavigationBarBackButtonWithImage:[UIImage imageNamed:@"backImage"]];
    if (self.contentString != nil) {
        self.contentTextView.text = self.contentString;
    }
}

- (void)judgePlayMethodNum{
    switch (self.playMethod) {
        case SWPlayMethodBrightSpotWrite:
            [self setNavigationBarTitle:@"玩法亮点" Color:SW_NAVIGATIONTITLE_COLOR];
            self.contentTextView.editable = YES;
            [self.contentTextView becomeFirstResponder];
            self.remaining.hidden = NO;
            self.saveButton = [Utils createNewBarButtonWithTitle:@"保存"];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
            break;
        case SWPlayMethodBrightSpotRead:
            [self setNavigationBarTitle:@"玩法亮点" Color:SW_NAVIGATIONTITLE_COLOR];
            self.contentTextView.editable = NO;
            self.remaining.hidden = YES;
            break;
        case SWPlayMethodIntroductionWrite:
            [self setNavigationBarTitle:@"玩法介绍" Color:SW_NAVIGATIONTITLE_COLOR];
            self.contentTextView.editable = YES;
            [self.contentTextView becomeFirstResponder];
            self.remaining.hidden = NO;
            self.saveButton = [Utils createNewBarButtonWithTitle:@"保存"];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
            break;
        case SWPlayMethodIntroductionRead:
            [self setNavigationBarTitle:@"玩法介绍" Color:SW_NAVIGATIONTITLE_COLOR];
            self.contentTextView.editable = NO;
            self.remaining.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)bindData{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextViewTextDidChangeNotification" object:nil]subscribeNext:^(NSNotification *obj) {
        UITextView *textView = (UITextView *)obj.object;
        NSString *toBeString = textView.text;
        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position || !selectedRange)
        {
            if (toBeString.length > SW_MAX_STARWORDS_LENGTH)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:SW_MAX_STARWORDS_LENGTH];
                if (rangeIndex.length == 1)
                {
                    textView.text = [toBeString substringToIndex:SW_MAX_STARWORDS_LENGTH];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, SW_MAX_STARWORDS_LENGTH)];
                    textView.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }];
    [[[self.contentTextView rac_textSignal]filter:^BOOL(NSString *value) {
        return value.length <= 200;
    }]  subscribeNext:^(NSString *text) {
        @strongify(self);
        NSInteger remainLength = 200 - text.length;
        NSString *str = [NSString stringWithFormat:@"%@%@%@",@"还可以输入",@(remainLength),@"个汉字"];
        self.remaining.text = str;
    }];
    /*点击保存按钮*/
    [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (_playMethod == SWPlayMethodBrightSpotWrite) {
            [_delegate getTextContent:self.contentTextView.text playMethod:SWPlayMethodBrightSpotWrite];
        }else if (_playMethod == SWPlayMethodIntroductionWrite){
            [_delegate getTextContent:self.contentTextView.text playMethod:SWPlayMethodIntroductionWrite];
        }
        [self.rt_navigationController popViewControllerAnimated:YES];
    }];
}
@end
