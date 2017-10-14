//
//  RateView.m
//  CustomView
//
//  Created by Ray Wenderlich on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RateView.h"

@implementation RateView

@synthesize notSelectedImage = _notSelectedImage;
@synthesize halfSelectedImage = _halfSelectedImage;
@synthesize fullSelectedImage = _fullSelectedImage;
@synthesize rating = _rating;
@synthesize editable = _editable;
@synthesize imageViews = _imageViews;
@synthesize maxRating = _maxRating;
@synthesize midMargin = _midMargin;
@synthesize leftMargin = _leftMargin;
@synthesize minImageSize = _minImageSize;
@synthesize delegate = _delegate;

- (void)baseInit {
    _notSelectedImage = nil;
    _halfSelectedImage = nil;
    _fullSelectedImage = nil;
    _rating = 0;
    _editable = NO;    
    _imageViews = [[NSMutableArray alloc] init];
    _maxRating = 4;
    _midMargin = 0;
    _leftMargin = 0;
    _minImageSize = CGSizeMake(5, 5);
    _delegate = nil;    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

- (void)refresh {
    for(int i = 0; i < self.imageViews.count; ++i) {
        UIButton *imageView = [self.imageViews objectAtIndex:i];
        if (self.rating >= i+1) {
            [imageView setImage:self.fullSelectedImage forState:UIControlStateNormal];
        } else if (self.rating > i) {
            [imageView setImage:self.halfSelectedImage forState:UIControlStateNormal];
        } else {
            [imageView setImage:self.notSelectedImage forState:UIControlStateNormal];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.notSelectedImage == nil) return;
    
    float desiredImageWidth = (self.frame.size.width - (self.leftMargin*2) - (self.midMargin*self.imageViews.count)) / self.imageViews.count;
    float imageWidth = MAX(self.minImageSize.width, desiredImageWidth);
//    float imageHeight = MAX(self.minImageSize.height, self.frame.size.height);
    float imageHeight = self.frame.size.height;
    
    for (int i = 0; i < self.imageViews.count; ++i) {
        
        UIButton *imageView = [self.imageViews objectAtIndex:i];
        CGRect imageFrame = CGRectMake(self.leftMargin + i*(self.midMargin+imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
    }    
}

- (void)setMaxRating:(int)maxRating {
    _maxRating = maxRating;
    
    // Remove old image views
    for(int i = 0; i < self.imageViews.count; ++i) {
        UIButton *imageView = (UIButton *) [self.imageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    // Add new image views
    for(int i = 0; i < maxRating; ++i) {
        UIButton *imageView = [[UIButton alloc] init];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView addTarget:self action:@selector(buttonTapped:withEvent:) forControlEvents:UIControlEventTouchDown];
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
    }
    
    // Relayout and refresh
    [self setNeedsLayout];
    [self refresh];
}

- (void)setNotSelectedImage:(UIImage *)image {
    _notSelectedImage = image;
    [self refresh];
}

- (void)setHalfSelectedImage:(UIImage *)image {
    _halfSelectedImage = image;
    [self refresh];
}

- (void)setFullSelectedImage:(UIImage *)image {
    _fullSelectedImage = image;
    [self refresh];
}

- (void)setRating:(float)rating {
    _rating = rating;
    [self refresh];
}

- (void)handleTouchAtLocation:(CGPoint)touchLocation {
//    if (!self.editable) return;
//    
//    int newRating = 0;
//    for(int i = self.imageViews.count - 1; i >= 0; i--) {
//        UIImageView *imageView = [self.imageViews objectAtIndex:i];        
//        if (touchLocation.x > imageView.frame.origin.x) {
//            newRating = i+1;
//            break;
//        }
//    }
//    
//    self.rating = newRating;
    if (!self.editable) return;
    
    //The rating starts out as 0 and then builds from there.
    CGFloat newRating = 0;
    //loop through the image collection backwards so if it exits the loop it will have identified the MAX
    for(int i = self.imageViews.count - 1; i >= 0; i--) {
        UIButton *imageView = [self.imageViews objectAtIndex:i];
        
        CGFloat distance = touchLocation.x - imageView.frame.origin.x;
        
        CGFloat frameWidth = imageView.frame.size.width;
        
        if (distance <= 0){
            //this means that the click was to the left of the frame
            continue;
        }
        if (distance /frameWidth >.75) {
            //If this ratio is >.75 then you are to the right 3/4 of the image or past th image
            newRating = i + 1;
            break;
        } else {
            //you didn't drop out or mark the entire star, so mark it half.
            newRating = i + 0.5;
            break;
        }
    }
    
    self.rating = newRating;
    [self.delegate rateView:self ratingDidChange:self.rating];

}

- (void)buttonTapped:(UIButton *)button withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event touchesForView:button] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
   // UITouch *touch = [touches anyObject];
    //CGPoint touchLocation = [touch locationInView:self];
  //  [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate rateView:self ratingDidChange:self.rating];

}

@end
