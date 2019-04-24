

#import <UIKit/UIKit.h>

@interface MyTextView : UITextView<UITextViewDelegate>
@property (nonatomic ,strong) UILabel *placeholderLab;//输入提示
@property (nonatomic, strong) UILabel *titleNumLab;//字数统计
/*
 * frame      textView的frame
 * placeStr   输入提示
 * labFont    textView、输入提示及字数统计的字号
 * maxLabNum  允许输入的最大字数，为0时不显示字数统计
 * messageStr 超出最大输入字数后的提示语，maxLabNum为0时不显示
 * subView    添加textView的父视图
*/
- (instancetype)initWithFrame:(CGRect)frame placeholderLab:(NSString *)placeStr labFont:(float)labFont maxLabNum:(NSInteger)maxLabNum alertMge:(NSString *)messageStr addSub:(id)subView;

/**截取fgStr之前的所有字符串，并给其设置颜色（加粗）*/
-(NSMutableAttributedString *)yuanStr:(NSString *)yStr fengeStr:(NSString *)fgStr qianColor:(UIColor *)qColor;

/**预留==编辑时-View上推*/
@property (nonatomic, copy)void (^upTheView)();
/**预留==编辑完成-View回落*/
@property (nonatomic, copy)void (^downTheView)();

@end
