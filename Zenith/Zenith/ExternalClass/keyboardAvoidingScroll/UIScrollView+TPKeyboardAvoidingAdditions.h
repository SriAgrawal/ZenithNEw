//
//  UIScrollView+TPKeyboardAvoidingAdditions.h
//  TPKeyboardAvoidingSample
//
//  Created by Michael Tyson on 30/09/2013.
//  Copyright 2013 A Tasty Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (EDKeyboardAvoidingAdditions)
- (BOOL)EDKeyboardAvoiding_focusNextTextField;
- (void)EDKeyboardAvoiding_scrollToActiveTextField;

- (void)EDKeyboardAvoiding_keyboardWillShow:(NSNotification*)notification;
- (void)EDKeyboardAvoiding_keyboardWillHide:(NSNotification*)notification;
- (void)EDKeyboardAvoiding_updateContentInset;
- (void)EDKeyboardAvoiding_updateFromContentSizeChange;
- (void)EDKeyboardAvoiding_assignTextDelegateForViewsBeneathView:(UIView*)view;
- (UIView*)EDKeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view;
-(CGSize)EDKeyboardAvoiding_calculatedContentSizeFromSubviewFrames;
@end
