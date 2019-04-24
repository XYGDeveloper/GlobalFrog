

#define RGBAUIColorFrom(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#import "MyTextView.h"
#import "Masonry.h"
@interface MyTextView(){
    NSString *_placeStr;
    NSString *_messageStr;
    NSInteger _maxLabNum;
}
@end
@implementation MyTextView
#pragma mark- init初始化
- (instancetype)initWithFrame:(CGRect)frame placeholderLab:(NSString *)placeStr labFont:(float)labFont maxLabNum:(NSInteger)maxLabNum alertMge:(NSString *)messageStr addSub:(id)subView{//
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.font = [UIFont systemFontOfSize:labFont];
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = [UIColor blackColor];
        [subView addSubview:self];
        
        //placeholder
        if (placeStr.length > 0) {
            _placeholderLab = [UILabel new];
            _placeholderLab.text = placeStr;
            _placeholderLab.numberOfLines = 0;
            _placeholderLab.font = [UIFont systemFontOfSize:labFont];
            _placeholderLab.textColor = [UIColor blackColor];
            _placeholderLab.enabled = NO;
            [self addSubview:_placeholderLab];
            _placeStr = placeStr;
            [_placeholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(7);
                make.left.equalTo(self.mas_left).offset(5);
                make.width.offset(self.bounds.size.width - 5);
            }];
        }
        //字数统计
        if (maxLabNum != 0) {
            UIView *v = [[UIView alloc]init];
            v.backgroundColor = [UIColor clearColor];
            v.userInteractionEnabled = NO;
            [self addSubview:v];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(self.mas_top).offset(self.bounds.size.height - 20);
                make.height.offset(20);
                make.width.offset(self.bounds.size.width);
            }];
            
            _titleNumLab.text = @"";
            _titleNumLab = [UILabel new];
            _titleNumLab.attributedText = [self yuanStr:[NSString stringWithFormat:@"0/%zd",maxLabNum] fengeStr:@"/" qianColor:RGBAUIColorFrom(0x999999, 1)];
            _titleNumLab.font = [UIFont systemFontOfSize:labFont];
            [v addSubview:_titleNumLab];
            _maxLabNum = maxLabNum;
            _messageStr = messageStr;
            
            [_titleNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.equalTo(v);
            }];
            
        }
    }
    return self;
}

#pragma mark- textView
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{//开始编辑时调用
    if (self.upTheView) {//主要用于处理键盘遮住textView后的View上推
        self.upTheView();
    }
    _placeholderLab.text = @"";
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{//编辑完成时调用
    if (self.downTheView) {
        self.downTheView();
    }
    _placeholderLab.text = textView.text.length == 0 ? _placeStr : @"";
}
- (void)textViewDidChange:(UITextView *)textView {//正在编辑时调用
    if (_maxLabNum != 0) {
        //字数统计
        _titleNumLab.attributedText  = [self yuanStr:[NSString stringWithFormat:@"%zd/%zd",textView.text.length,_maxLabNum] fengeStr:@"/" qianColor:RGBAUIColorFrom(0x999999, 1)];
        if (textView.text.length > _maxLabNum && textView.markedTextRange == nil) {
            _titleNumLab.attributedText =  [self yuanStr:[NSString stringWithFormat:@"%zd/%zd",_maxLabNum,_maxLabNum] fengeStr:@"/" qianColor:RGBAUIColorFrom(0x999999, 1)];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:_messageStr delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alert show];
            textView.text = [textView.text substringToIndex:_maxLabNum];
        }
    }
}
-(NSMutableAttributedString *)yuanStr:(NSString *)yStr fengeStr:(NSString *)fgStr qianColor:(UIColor *)qColor{//截取fgStr之前的所有字符串，并给其设置颜色（加粗）
    NSArray *strarray = [yStr componentsSeparatedByString:fgStr];
    NSRange redRange = [yStr rangeOfString:strarray[0]];
    NSMutableAttributedString *redStr = [[NSMutableAttributedString alloc] initWithString:yStr];
    [redStr addAttribute:NSForegroundColorAttributeName value:qColor range:redRange];
    //    [redStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:redRange];范围内的加粗处理
    return redStr;
}

@end
