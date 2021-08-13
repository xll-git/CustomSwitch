//
//  CustomSwitch.m
//  CustomSwitch
//
//  Created by OKNI-IOS on 2020/10/23.
//

#import "CustomSwitch.h"

#define SwitchHeight    31.0f
#define SwitchWidth     51.0f
#define SwitchKnobSize  27.0f

@interface CustomSwitch ()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *knobImageView;
@property (nonatomic, assign) CGFloat margin;  // 间隙

@end

@implementation CustomSwitch

- (CGRect)roundRect:(CGRect)frame {
    CGRect newRect = frame;
    newRect.size.width = SwitchWidth;
    newRect.size.height = SwitchHeight;
    return newRect;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:[self roundRect:frame]];
    [self setNeedsLayout];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[self roundRect:frame]]) {
        self.backgroundColor = [UIColor clearColor];
        
        _onColor = [UIColor colorWithRed:58.0/255.0 green:198.0/255.0 blue:93.0/255.0 alpha:1.0];
        _offColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:235.0/255.0 alpha:1.0];
        _thumbColor = UIColor.whiteColor;
        _on = NO;
        _margin = (CGRectGetHeight(self.bounds) - SwitchKnobSize) / 2.0;
        
        _maskView = [[UIView alloc]initWithFrame:[self roundRect:self.bounds]];
        _maskView.layer.cornerRadius = SwitchHeight / 2.0;
        _maskView.layer.masksToBounds = YES;
        [self addSubview:_maskView];
        _maskView.backgroundColor = _on ?_onColor:_offColor;
        
        _knobImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_margin, _margin, SwitchKnobSize, SwitchKnobSize)];
        _knobImageView.backgroundColor = _thumbColor;
        _knobImageView.contentMode = UIViewContentModeCenter;
        _knobImageView.userInteractionEnabled = NO;
        _knobImageView.layer.cornerRadius = SwitchKnobSize /2.0;
        _knobImageView.layer.masksToBounds = YES;
        [_maskView addSubview:_knobImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapEvent:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanEvent:)];
        _maskView.userInteractionEnabled = YES;
        [_maskView addGestureRecognizer:tap];
        [_maskView addGestureRecognizer:pan];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.maskView.frame = [self roundRect:self.bounds];
    self.maskView.layer.cornerRadius = SwitchHeight / 2.0;
    self.maskView.layer.masksToBounds = YES;
    _maskView.backgroundColor = _on ?_onColor:_offColor;

    _margin = (CGRectGetHeight(self.bounds) - SwitchKnobSize) / 2.0;
    CGFloat knobLeft = _on?SwitchWidth - _margin - SwitchKnobSize:_margin;
    self.knobImageView.frame = CGRectMake(knobLeft, self.margin, SwitchKnobSize, SwitchKnobSize);
}

- (void)setOnColor:(UIColor *)onColor {
    _onColor = onColor;
    if (_on) {
        _maskView.backgroundColor = onColor;
    }
}

- (void)setOffColor:(UIColor *)offColor {
    _offColor = offColor;
    if (!_on) {
        _maskView.backgroundColor = offColor;
    }
}

- (void)setThumbColor:(UIColor *)thumbColor {
    _thumbColor = thumbColor;
    _knobImageView.backgroundColor = thumbColor;
}

- (void)setOnImage:(UIImage *)onImage {
    _onImage = onImage;
    if (_onImage && _offImage) {
        self.knobImageView.image = _on?_onImage:_offImage;
    }
}

- (void)setOffImage:(UIImage *)offImage {
    _offImage = offImage;
    if (_onImage && _offImage) {
        self.knobImageView.image = _on?_onImage:_offImage;
    }
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    if (on == _on) return;
    _on = on;
    
    if (_onImage && _offImage) {
        self.knobImageView.image = _on?_onImage:_offImage;
    }
    CGFloat knobLeft = on?SwitchWidth - _margin - SwitchKnobSize:_margin;
    
    [UIView animateWithDuration:animated?0.25:0.01 animations:^{
        self.knobImageView.frame = CGRectMake(knobLeft, self.margin, SwitchKnobSize, SwitchKnobSize);
    }];
    _maskView.backgroundColor = (_on ?_onColor:_offColor);
    if (animated) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        anim.duration = 0.25;
        anim.fromValue = (id)_maskView.backgroundColor;
        anim.toValue = (id)(_on ?_onColor:_offColor);
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.maskView.layer addAnimation:anim forKey:@"knobImageViewanim_knowGroup"];
    }
}

- (void)handleTapEvent:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self setOn:!_on animated:YES];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)handlePanEvent:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self scaleKnobImageViewFrame:YES];
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        [self setOn:!_on animated:YES];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }else if (pan.state == UIGestureRecognizerStateCancelled ||
              pan.state == UIGestureRecognizerStateFailed) {
        [self scaleKnobImageViewFrame:NO];
    }
}

- (void)scaleKnobImageViewFrame:(BOOL)scale {
    
    CGFloat margin = (CGRectGetHeight(self.bounds) - SwitchKnobSize) / 2.0;
    CGRect knobFrame = self.knobImageView.frame;
    CGFloat offset = 6.0f;
    
    if (_on) {
        self.knobImageView.frame = CGRectMake(SwitchWidth - SwitchKnobSize - margin - (scale ? offset : 0), margin, SwitchKnobSize, SwitchKnobSize);
    }else {
        self.knobImageView.frame = CGRectMake(margin, margin, SwitchKnobSize + (scale ? offset : 0), SwitchKnobSize);
    }
    
    CAAnimationGroup *knowGroup = [CAAnimationGroup animation];
    knowGroup.duration = 0.25;
    knowGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *knobAnm1 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    [knobAnm1 setFromValue:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(knobFrame), CGRectGetHeight(knobFrame))]];
    [knobAnm1 setToValue:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.knobImageView.frame), CGRectGetHeight(self.knobImageView.frame))]];
    CABasicAnimation *knobAnm2 = [CABasicAnimation animationWithKeyPath:@"position"];
    [knobAnm2 setFromValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(knobFrame), CGRectGetMidY(knobFrame))]];
    [knobAnm2 setToValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.knobImageView.frame), CGRectGetMidY(self.knobImageView.frame))]];
    knowGroup.animations = @[knobAnm1, knobAnm2];
    [self.knobImageView.layer addAnimation:knowGroup forKey:@"knobImageView_knowGroup"];
}

@end
