//
//  FMVCardViewController.h
//  FetalMovement
//
//  Created by PanFengfeng on 14-6-12.
//  Copyright (c) 2014年 Doit.im. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat WPFPopBarHeight;

@interface WPFPopViewController : UIViewController

//@property (nonatomic, assign)BOOL popBarHidden;

@end

@protocol WPFPopViewControllerDelegate <NSObject>

- (void)popViewController:(UIViewController *)controller dismissWithAnimated:(BOOL)animated;

@end


@interface UIViewController (WPFPopViewController)

@property (nonatomic, weak)id<WPFPopViewControllerDelegate> popUpDelegate;

- (WPFPopViewController *)popViewController;

- (void)presentPopWithController:(UIViewController *)card animated:(BOOL)animated;
- (void)dismissPopControllerAnimated:(BOOL)flag;


//单个controller的表现配置
- (CGSize)popSize;
- (UIImage *)popImage;
- (BOOL)popBarHidden;
@end
