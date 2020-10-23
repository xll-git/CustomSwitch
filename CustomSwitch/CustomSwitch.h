//
//  CustomSwitch.h
//  CustomSwitch
//
//  Created by OKNI-IOS on 2020/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomSwitch : UIControl

@property (nonatomic, strong) UIColor *onColor;  //开颜色
@property (nonatomic, strong) UIColor *offColor;  //关颜色

@property (nonatomic, strong) UIColor *thumbColor;  // 按钮颜色
@property (nonatomic, strong) UIImage *onImage;  //开图片
@property (nonatomic, strong) UIImage *offImage;  //关图片

@property (nonatomic, assign, getter = isOn) BOOL on;  // 默认关

@end

NS_ASSUME_NONNULL_END
