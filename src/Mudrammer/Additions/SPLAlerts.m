//
//  SPLAlerts.m
//  Mudrammer
//
//  Created by Jonathan Hersh on 11/2/14.
//  Copyright (c) 2014 Jonathan Hersh. All rights reserved.
//

#import "SPLAlerts.h"
#import <BlocksKit+UIKit.h>

@implementation UIViewController (SPLAlerts)

- (instancetype)SPLFrontViewController {
    UIViewController *frontVC = self;

    while ([frontVC presentedViewController]) {
        frontVC = [frontVC presentedViewController];
    }

    return frontVC;
}

@end

@implementation SPLAlerts

+ (void)SPLShowAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                      cancelTitle:(NSString *)cancelTitle
                      cancelBlock:(void (^)(void))cancelBlock
                          okTitle:(NSString *)okTitle
                          okBlock:(void (^)(void))okBlock
{
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];

        if ([cancelTitle length] > 0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *action) {
                                                                     if (cancelBlock) {
                                                                         cancelBlock();
                                                                     }
                                                                 }];

            [alertController addAction:cancelAction];
        }

        if ([okTitle length] > 0) {
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 if (okBlock) {
                                                                     okBlock();
                                                                 }
                                                             }];

            [alertController addAction:okAction];
        }

        [[[SSAppDelegate sharedApplication].window.rootViewController SPLFrontViewController] presentViewController:alertController
                                                                                                           animated:YES
                                                                                                         completion:nil];
    } else {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:title
                                                            message:message];

        if ([cancelTitle length] > 0) {
            [alertView bk_setCancelButtonWithTitle:cancelTitle
                                           handler:cancelBlock];
        }

        if ([okTitle length] > 0) {
            if (okBlock) {
                [alertView bk_setWillDismissBlock:^(UIAlertView *alert, NSInteger index) {
                    if (index == 1) {
                        okBlock();
                    }
                }];
            }

            [alertView bk_addButtonWithTitle:okTitle
                                     handler:nil];
        }

        [alertView show];
    }
}

+ (void)SPLShowActionViewWithTitle:(NSString *)title
                       cancelTitle:(NSString *)cancelTitle
                       cancelBlock:(void (^)(void))cancelBlock
                  destructiveTitle:(NSString *)destructiveTitle
                  destructiveBlock:(void (^)(void))destructiveBlock
                     barButtonItem:(UIBarButtonItem *)barButtonItem
                        sourceView:(UIView *)sourceView
                        sourceRect:(CGRect)sourceRect
{
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];


        if ([destructiveTitle length] > 0) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:destructiveTitle
                                                             style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction *anAction) {
                                                               if (destructiveBlock) {
                                                                   destructiveBlock();
                                                               }
                                                           }];

            [alert addAction:action];
        }

        if ([cancelTitle length] > 0) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:cancelTitle
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *anAction) {
                                                               if (cancelBlock) {
                                                                   cancelBlock();
                                                               }
                                                           }];

            [alert addAction:action];
        }

        [[[SSAppDelegate sharedApplication].window.rootViewController SPLFrontViewController] presentViewController:alert
                                                                                                           animated:YES
                                                                                                         completion:nil];

        if (alert.modalPresentationStyle == UIModalPresentationPopover) {
            UIPopoverPresentationController *popover = alert.popoverPresentationController;

            if (barButtonItem) {
                popover.barButtonItem = barButtonItem;
            } else if (sourceView && !CGRectEqualToRect(sourceRect, CGRectZero)) {
                popover.sourceView = sourceView;
                popover.sourceRect = sourceRect;
            }
        }
    } else {
        UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:title];
        sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;

        if ([destructiveTitle length] > 0) {
            [sheet bk_setDestructiveButtonWithTitle:destructiveTitle
                                            handler:destructiveBlock];
        }

        if ([cancelTitle length] > 0) {
            [sheet bk_setCancelButtonWithTitle:cancelTitle
                                       handler:cancelBlock];
        }

        if (barButtonItem) {
            [sheet showFromBarButtonItem:barButtonItem animated:YES];
        } else if (sourceView) {
            [sheet showInView:sourceView];
        }
    }
}

@end
