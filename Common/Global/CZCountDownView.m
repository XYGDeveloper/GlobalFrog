

#import "CZCountDownView.h"
// label数量
#define labelCount 3
#define separateLabelCount 3
#define padding 5
@interface CZCountDownView (){
    // 定时器
    NSTimer *timer;
}

@property (nonatomic,strong)UILabel *dayLabel;
// hour
@property (nonatomic,strong)UILabel *hourLabel;
// minues
@property (nonatomic,strong)UILabel *minuesLabel;
// seconds
@property (nonatomic,strong)UILabel *secondsLabel;
//
@property (nonatomic,strong)UILabel *leftTtitle;
@property (nonatomic,strong)UILabel *rightTime;

@end

@implementation CZCountDownView
// 创建单例
+ (instancetype)cz_shareCountDown{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CZCountDownView alloc] init];
    });
    return instance;
}

+ (instancetype)cz_countDown{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
        self.leftTtitle = [[UILabel alloc]init];
        self.leftTtitle.textColor = HexColor(0x333333);
        self.leftTtitle.font = [UIFont systemFontOfSize:18.0f];
        self.leftTtitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_leftTtitle];
        self.rightTime = [[UILabel alloc]init];
        self.rightTime.textColor = AppStyleColor;
        self.rightTime.font = [UIFont systemFontOfSize:18.0f];
        self.rightTime.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rightTime];
        
    }
    return self;
}

- (void)setLeftTitle:(NSString *)leftTitle
{
    
    _leftTitle = leftTitle;
    self.leftTtitle.text = _leftTitle;
    
}

// 拿到外界传来的时间戳
- (void)setTimestamp:(NSInteger)timestamp{
    _timestamp = timestamp;
    if (_timestamp != 0) {
        timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
      //  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)timer:(NSTimer*)timerr{
    _timestamp--;
    [self getDetailTimeWithTimestamp:_timestamp];
    if (_timestamp == 0) {
        [timer invalidate];
        timer = nil;
        // 执行block回调
        self.timerStopBlock();
    }
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    self.rightTime.text = [NSString stringWithFormat:@"%zd : %zd",minute,second];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 获得view的宽、高
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height;
    // 单个label的宽高
    CGFloat labelW = viewW / 4;
    CGFloat labelH = viewH;
    self.leftTtitle.frame = CGRectMake(0, 0, labelW*2, labelH);
    self.rightTime.frame  = CGRectMake(labelW*2, 0, labelW, labelH);
}


#pragma mark - setter & getter

- (UILabel *)minuesLabel{
    if (_minuesLabel == nil) {
        _minuesLabel = [[UILabel alloc] init];
        _minuesLabel.textAlignment = NSTextAlignmentRight;
//        _minuesLabel.backgroundColor = [UIColor orangeColor];
    }
    return _minuesLabel;
}

- (UILabel *)secondsLabel{
    if (_secondsLabel == nil) {
        _secondsLabel = [[UILabel alloc] init];
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
//        _secondsLabel.backgroundColor = [UIColor yellowColor];
    }
    return _secondsLabel;
}


@end
