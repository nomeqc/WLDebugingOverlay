//
//  WLDebugingOverlay.h
//  WLDebugWindow
//
//  Created by Fallrainy on 2018/1/8.
//  Copyright © 2018年 Fallrainy. All rights reserved.
//

#import <UIKit/UIKit.h>

/********** WLDebugingRootTableViewController **********/
@interface WLDebugingRootTableViewController : UITableViewController

@property (nonatomic, readonly) NSMutableArray<NSDictionary *> *items;

@end

/********** WLDebugingOverlayViewController **********/
@interface  WLDebugingOverlayViewController : UIViewController

//@property (nonatomic, assign) bool isFullscreen;
//@property (nonatomic, strong) UIView * shadowView;
//@property (nonatomic, strong) UISplitViewController * splitViewController;
//@property (nonatomic, strong) UIView * containerView;
//@property (nonatomic, strong) UIDebuggingInformationRootTableViewController * rootTableViewController;

@property (nonatomic) WLDebugingRootTableViewController *rootTableViewController;

@end


/********** WLDebugingOverlay **********/
@interface WLDebugingOverlay : UIWindow

@property (nonatomic, weak) WLDebugingOverlayViewController *overlayViewController;

@property (nonatomic) WLDebugingRootTableViewController *rootTableViewController;


+ (instancetype)overlay;

/**
 overlay显示前调用此方法
 */
+ (void)prepareDebuggingOverlay;

/**
 控制overlay的显示和隐藏
 */
- (void)toggleVisibility;

- (void)addActionWithTitle:(NSString *)title handler:(dispatch_block_t)handler;


@end
