//
//  WLDebugingOverlay.m
//  WLDebugWindow
//
//  Created by Fallrainy on 2018/1/8.
//  Copyright © 2018年 Fallrainy. All rights reserved.
//

#import "WLDebugingOverlay.h"



static NSString * const kCellId = @"itemCellId";

static NSString * const kItemTitleKey = @"title";

static NSString * const kItemHandlerKey = @"handler";

@interface WLDebugingRootTableViewController ()

@property (nonatomic, readwrite) NSMutableArray<NSDictionary *> *items;


@end


@implementation WLDebugingRootTableViewController {
    CGFloat _panBeginingPointY;
    CGFloat _superViewBeginingPointY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(didTapDismissBarButton:)];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(navigationBarPanGesture:)];
    [self.navigationController.navigationBar addGestureRecognizer:panGestureRecognizer];
}

- (void)didTapDismissBarButton:(UIBarButtonItem *)barButtonItem {
    WLDebugingOverlay *overlay = (WLDebugingOverlay *)self.view.window;
    if ([overlay isKindOfClass:[WLDebugingOverlay class]]) {
        [overlay toggleVisibility];
    }
}

- (void)navigationBarPanGesture:(UIPanGestureRecognizer *)gesture {
    UIView *superContainer = self.navigationController.view.superview;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            _panBeginingPointY = [gesture locationInView:self.view.window].y;
            _superViewBeginingPointY = CGRectGetMinY(superContainer.frame);
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat panCurrentPointY = [gesture locationInView:self.view.window].y;
            CGFloat offset = panCurrentPointY - _panBeginingPointY;
            superContainer.frame = ({
                CGRect frame = superContainer.frame;
                frame.origin.y = _superViewBeginingPointY + offset;
                frame.origin.y = MAX(frame.origin.y, 20);
                frame.origin.y = MIN(frame.origin.y, CGRectGetHeight(superContainer.superview.bounds) - CGRectGetHeight(frame) - 10);
                frame;
            });
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.items[indexPath.row];
    dispatch_block_t block = item[kItemHandlerKey];
    if (block) {
        block();
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.items[indexPath.row];
    NSString *title = item[kItemTitleKey];
    cell.textLabel.text = title;
}

- (NSMutableArray<NSDictionary *> *)items {
    if (!_items) {
        _items = [[NSMutableArray<NSDictionary *> alloc] init];
    }
    return _items;
}

@end

/********** WLDebugingOverlayViewController **********/

@interface WLDebugingOverlayViewController ()

@property (nonatomic) UIView *shadowView;

@property (nonatomic, strong) UIView *containerView;

@end

static CGFloat const kCornerRadius = 23;

@implementation WLDebugingOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.containerView];
    
    //添加 containerView
    [self.containerView addSubview:self.shadowView];
    [self makeConstraintForView:self.shadowView edgeEqualToView:self.containerView];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.rootTableViewController];
    [self addChildViewController:navController];
    [navController didMoveToParentViewController:self];
    [self.containerView addSubview:navController.view];
    navController.view.layer.cornerRadius = kCornerRadius;
    navController.view.layer.masksToBounds = YES;
    navController.view.frame = self.containerView.bounds;
}

- (void)makeConstraintForView:(UIView *)firstView edgeEqualToView:(UIView *)secondView {
    firstView.translatesAutoresizingMaskIntoConstraints = NO;
    [secondView addConstraint:[NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [secondView addConstraint:[NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [secondView addConstraint:[NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [secondView addConstraint:[NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}


- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = kCornerRadius;
            view.layer.shadowColor = [UIColor blackColor].CGColor;
            view.layer.shadowOpacity = 0.4;
            view.layer.shadowOffset = CGSizeMake(0, 4);
            view.layer.shadowRadius = 17;
            view;
        });;
    }
    return _shadowView;
}


- (UIView *)containerView {
    if (!_containerView) {
        _containerView = ({
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height * 0.5);
            view.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.view.bounds) / 2);
            view;
        });
    }
    return _containerView;
}

- (WLDebugingRootTableViewController *)rootTableViewController {
    if (!_rootTableViewController) {
        _rootTableViewController = [[WLDebugingRootTableViewController alloc] init];
    }
    return _rootTableViewController;
}
@end

/********** WLDebugingOverlay **********/

@interface  WLDebugingOverlay ()

@end

@implementation WLDebugingOverlay {
    UIWindow *_lastKeyWindow;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return (view == self || view == self.rootViewController.view)? nil : view;
}

+ (instancetype)overlay{
    static dispatch_once_t onceToken;
    static WLDebugingOverlay *overlay;
    dispatch_once(&onceToken, ^{
        overlay = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlay.windowLevel = UIWindowLevelStatusBar + 1;
        overlay.backgroundColor = [UIColor clearColor];

        WLDebugingOverlayViewController *overlayViewController = ({
            WLDebugingOverlayViewController *controller = [[WLDebugingOverlayViewController alloc] init];
            controller.rootTableViewController = ({
                WLDebugingRootTableViewController *tableViewController = [[WLDebugingRootTableViewController alloc] init];
                tableViewController;
            });
            controller;
        });
        
        overlay.rootViewController = overlayViewController;
        overlay.overlayViewController = overlayViewController;
        overlay.rootTableViewController = overlayViewController.rootTableViewController;
    });
    return overlay;
}

+ (void)prepareDebuggingOverlay {
    /* 在status bar中添加点击手势 点击三次 唤出调试窗口*/
#ifdef DEBUG
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    WLDebugingOverlay *overlay = [WLDebugingOverlay overlay];
    UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:overlay action:@selector(_handleActivationGesture:)];
    tapGesture.numberOfTapsRequired = 3;
    [statusBar addGestureRecognizer:tapGesture];
#endif
    
}


- (void)addActionWithTitle:(NSString *)title handler:(dispatch_block_t)handler {
    NSMutableDictionary *item = [NSMutableDictionary new];
    item[kItemTitleKey] = title;
    item[kItemHandlerKey] = [handler copy];
    [self.rootTableViewController.items addObject:item];
    
    //如果rootTableViewController view已经加载，直接刷新tableView
    if ([self.rootTableViewController isViewLoaded]) {
        [self.rootTableViewController.tableView reloadData];
    }
}

- (void)toggleVisibility {
    if ([self isKeyWindow]) {
        self.hidden = YES;
        [_lastKeyWindow makeKeyAndVisible];
    } else {
        _lastKeyWindow = [UIApplication sharedApplication].keyWindow;
        [self makeKeyAndVisible];
    }
}

// MARK: Gesture Handler
- (void)_handleActivationGesture:(UITapGestureRecognizer *)gesture {
    if (![self isKeyWindow]) {
        [self toggleVisibility];
    }
}

// MARK: Accessors


@end
