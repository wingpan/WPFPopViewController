//
//  FMVCardViewController.m
//  FetalMovement
//
//  Created by PanFengfeng on 14-6-12.
//  Copyright (c) 2014年 Doit.im. All rights reserved.
//

#import "WPFPopViewController.h"
#import <objc/runtime.h>

@interface UIViewController (WPFPopController_holder)

- (void)setPresentingPopViewController:(WPFPopViewController *)tc;
- (WPFPopViewController *)presentingPopViewController;

- (void)setPopViewController:(WPFPopViewController *)onwer;

@end


#pragma mark - WPFPopBar
@interface WPFPopBar : UIView

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *closeButton;

@end

@implementation WPFPopBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithWhite:0. alpha:.9];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton setImage:[UIImage imageNamed:@"btn-pop-delete"] forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _closeButton.center = CGPointMake(5 + CGRectGetMidX(_closeButton.bounds),
                                      CGRectGetMidY(self.bounds));
    
    _titleLabel.frame = self.bounds;
}

@end



#pragma mark - WPFPopNavigationController
@interface WPFPopNavigationController : UINavigationController

@end

@implementation WPFPopNavigationController

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [super setNavigationBarHidden:YES];
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated {
    [super setNavigationBarHidden:YES animated:animated];
}

@end

#pragma mark - WPFPopViewController
@interface WPFPopViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong)UIImageView *contentView;
@property (nonatomic, strong)WPFPopBar *popBar;
@property (nonatomic, strong)UINavigationController *internalNavigationController;

@property (nonatomic, weak)UIViewController *owner;

@end

const CGFloat WPFPopBarHeight = 68.;
const CGFloat kWPFPopAnimationTime = 0.3;


@implementation WPFPopViewController

- (id)initWithRootController:(UIViewController *)controller {
    self = [self init];
    
    if (self) {
        _internalNavigationController = [[WPFPopNavigationController alloc] initWithRootViewController:controller];
        _internalNavigationController.delegate = self;
        [_internalNavigationController setNavigationBarHidden:YES animated:NO];
        
        controller.popViewController = self;
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
    [self.view addSubview:_backgroundView];
    
    _contentView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.userInteractionEnabled = YES;
    [self.view addSubview:_contentView];
    
    _popBar = [[WPFPopBar alloc] initWithFrame:CGRectZero];
    _popBar.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_popBar];
    
    [_contentView addSubview:self.internalNavigationController.view];
    [self addChildViewController:self.internalNavigationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_popBar.closeButton addTarget:self action:@selector(on_close:) forControlEvents:UIControlEventTouchUpInside];

    UIViewController *viewController = self.internalNavigationController.topViewController;
    self.popBar.hidden = viewController.popBarHidden;
    
    self.popBar.titleLabel.text = viewController.title;
    if (viewController.popBarHidden == NO) {
        viewController.view.backgroundColor = [UIColor clearColor];
    }
    self.contentView.image = viewController.popImage;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.backgroundView.frame = self.view.bounds;
    
    
    self.contentView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                          CGRectGetHeight(self.view.bounds) - CGRectGetMidY(self.contentView.bounds));}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showWithAnimation {
    self.backgroundView.alpha = 0.;
    [self p_contentSizeToFit:nil];
    self.contentView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                          CGRectGetHeight(self.view.bounds) + CGRectGetMidY(self.contentView.bounds));
    
    [UIView animateWithDuration:kWPFPopAnimationTime
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backgroundView.alpha = 1.0;
                         self.contentView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                                                CGRectGetHeight(self.view.bounds) - CGRectGetMidY(self.contentView.bounds));
                     } completion:nil];
    
}

- (void)hideAnimation {
    [UIView animateWithDuration:kWPFPopAnimationTime
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.backgroundView.alpha = 0.;
                         self.contentView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                                               CGRectGetHeight(self.view.bounds) + CGRectGetMidY(self.contentView.bounds));

                     } completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                     }];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if (animated) {
        [UIView animateKeyframesWithDuration:kWPFPopAnimationTime delay:0
                                     options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                                  animations:^{
                                      self.popBar.hidden = viewController.popBarHidden;
                                      [self p_contentSizeToFit:viewController];
                                      self.contentView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                                                            CGRectGetHeight(self.view.bounds) - CGRectGetMidY(self.contentView.bounds));
                                  } completion:nil];
    }else {
        self.popBar.hidden = viewController.popBarHidden;
        [self p_contentSizeToFit:viewController];
        self.contentView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                              CGRectGetHeight(self.view.bounds) - CGRectGetMidY(self.contentView.bounds));
    }
    
    self.popBar.titleLabel.text = viewController.title;
    if (viewController.popBarHidden == NO) {
        viewController.view.backgroundColor = [UIColor clearColor];        
    }
    self.contentView.image = viewController.popImage;
    
    viewController.popViewController = self;
}


#pragma mark Private API
- (void)p_contentSizeToFit:(UIViewController *)controller {
    if (controller == nil) {
        controller = self.internalNavigationController.topViewController;
    }
    
    CGFloat contentHeight = 0;
    if (!controller.popBarHidden) {
        contentHeight = WPFPopBarHeight;
    }
    
    contentHeight += [controller popSize].height;
    
    self.contentView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),
                                         contentHeight);
    
    self.popBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), WPFPopBarHeight);
    
    if (controller.popBarHidden) {
        self.internalNavigationController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds),
                                                                  CGRectGetHeight(self.contentView.bounds));
    }else {
        self.internalNavigationController.view.frame = CGRectMake(0, WPFPopBarHeight,
                                                                  CGRectGetWidth(self.contentView.bounds),
                                                                  CGRectGetHeight(self.contentView.bounds) - WPFPopBarHeight);
    }
}

- (void)on_close:(id)sender {
    [self.internalNavigationController.topViewController dismissPopControllerAnimated:YES];
}

@end


#pragma mark - UIViewController
static void *WPFPopViewControllerOwnerKey = &WPFPopViewControllerOwnerKey;

@implementation UIViewController (WPFPopController_holder)

static void *presentingPopViewControllerKey = &presentingPopViewControllerKey;
- (void)setPresentingPopViewController:(WPFPopViewController *)tc {
    if ([tc isKindOfClass:[WPFPopViewController class]]) {
        objc_setAssociatedObject(self, presentingPopViewControllerKey, tc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else {
        objc_setAssociatedObject(self, presentingPopViewControllerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (WPFPopViewController *)presentingPopViewController {
    return objc_getAssociatedObject(self, presentingPopViewControllerKey);
}

- (void)setPopViewController:(WPFPopViewController *)onwer {
    if ([onwer isKindOfClass:[WPFPopViewController class]]) {
        objc_setAssociatedObject(self, WPFPopViewControllerOwnerKey, onwer, OBJC_ASSOCIATION_ASSIGN);
    }else {
        objc_setAssociatedObject(self, WPFPopViewControllerOwnerKey, nil, OBJC_ASSOCIATION_ASSIGN);
    }
}

@end

@implementation UIViewController (WPFPopViewController)

- (WPFPopViewController *)popViewController {
    return objc_getAssociatedObject(self, WPFPopViewControllerOwnerKey);
}

- (void)presentPopWithController:(UIViewController *)card animated:(BOOL)animated {
    if (card == self) {
        return;
    }
    
    if (![card isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    UIViewController *presentController = self;
    if (self.tabBarController) {
        presentController = self.tabBarController;
    }else if (self.navigationController) {
        presentController = self.navigationController;
    }
    
    WPFPopViewController *controller = [[WPFPopViewController alloc] initWithRootController:card];
    [presentController setPresentingPopViewController:controller];
    controller.view.frame = presentController.view.bounds;
    [presentController.view addSubview:controller.view];
    
    if (animated) {
        [controller showWithAnimation];
    }
    
    controller.owner = presentController;

}

- (void)dismissPopControllerAnimated:(BOOL)flag {
    WPFPopViewController *cardController = self.popViewController;
    if (cardController) {
        if (flag) {
            [cardController hideAnimation];
        }else {
            [cardController.view removeFromSuperview];
        }
        
        [cardController.owner setPresentingPopViewController:nil];
        cardController.owner = nil;
        
    }
    
    self.popViewController = nil;

}

- (CGSize)popSize {
    return CGSizeMake(0, 405);
}

- (UIImage *)popImage {
    return [UIImage imageNamed:@"bg-pop"];
}

- (BOOL)popBarHidden {
    return NO;
}

@end
