//
//  OptionPickerManager.h
//  MeAndChange
//
//  Created by Raj Kumar Sharma on 27/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RMPickerViewController.h"

@interface OptionPickerManager : NSObject

+ (OptionPickerManager *)optionManager;

- (void)showOptionPickerSelectedIndex:(NSInteger)selectedIndex withData:(NSArray *)data completionBlock:(void (^)(NSArray *selectedIndexes, NSArray *selectedValues))block;

@end
