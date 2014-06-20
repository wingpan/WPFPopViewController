//
//  FMVCardViewController.h
//  FetalMovement
//
//  Created by PanFengfeng on 14-6-12.
//  Copyright (c) 2014年 Doit.im. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPFPopViewController : UIViewController

//@property (nonatomic, assign)BOOL popBarHidden;

@end


@interface UIViewController (WPFPopViewController)

- (WPFPopViewController *)popViewController;

- (void)presentPopWithController:(UIViewController *)card animated:(BOOL)animated;
- (void)dismissPopControllerAnimated:(BOOL)flag;


//单个controller的表现配置
- (CGSize)popSize;
- (UIImage *)popImage;
- (BOOL)popBarHidden;
@end

