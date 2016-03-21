//
//  LPGViewController.m
//  Phonagotchi
//
//  Created by Steven Masuch on 2014-07-26.
//  Copyright (c) 2014 Lighthouse Labs. All rights reserved.
//

#import "LPGViewController.h"

@interface LPGViewController ()

@property (nonatomic) UIImageView *petImageView;
@property (nonatomic) UIImageView *bucketImageView;
@property (nonatomic) UIImageView *appleImageView;
@property (nonatomic) UIImageView *appleToFeedImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *pressAppleGesture; //used instead of pinch bc easier on simulator
@property (nonatomic, strong) UIPanGestureRecognizer *panAppleToFeedGesture;


@end

@implementation LPGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:(252.0/255.0) green:(240.0/255.0) blue:(228.0/255.0) alpha:1.0];

//create petImageView, i.e. cat pick
    self.petImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.petImageView.translatesAutoresizingMaskIntoConstraints = NO;
//use this BOOL method, "userInteractionEnabled" to allow user interaction on UIImageViews, which otherwise wouldn't allow it
    self.petImageView.userInteractionEnabled = YES;
    self.petImageView.image = [UIImage imageNamed:@"default"];
    
    [self.view addSubview:self.petImageView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.petImageView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.petImageView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
//create bucket in bottom left
    self.bucketImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bucketImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bucketImageView.image = [UIImage imageNamed:@"bucket"];
    
    [self.view addSubview:self.bucketImageView];
    
    NSLayoutConstraint *bucketLeftConstraint = [NSLayoutConstraint
                                                constraintWithItem:self.bucketImageView
                                                attribute:NSLayoutAttributeLeft
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self.view
                                                attribute:NSLayoutAttributeLeft
                                                multiplier:1.0
                                                constant:0.0];
    
    NSLayoutConstraint *bucketBottomConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.bucketImageView
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                                  attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                  constant:0.0];
    
    NSLayoutConstraint *bucketWidth = [NSLayoutConstraint
                                       constraintWithItem:self.bucketImageView
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                       constant:150];
    
    NSLayoutConstraint *bucketHeight = [NSLayoutConstraint
                                       constraintWithItem:self.bucketImageView
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                       constant:150];
    
    [self.view addConstraints: @[bucketBottomConstraint, bucketLeftConstraint, bucketWidth, bucketHeight]];
    
//create apple
    self.appleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, self.view.bounds.size.height - 95, 40, 40)];
    self.appleImageView.userInteractionEnabled = YES;
    self.appleImageView.image = [UIImage imageNamed:@"apple"];
    
    [self.view addSubview:self.appleImageView];
    
    
    [self prepareGestureRecognizers];
    self.pressAppleGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressApple:)];
    [self.appleImageView addGestureRecognizer:self.pressAppleGesture];
    
}

- (void)prepareGestureRecognizers {
//here the target is the whole view controller; telling it to look out for panPet message
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPet:)];
//once the panGesture object is created, add the gesture to the pet image
    [self.petImageView addGestureRecognizer:self.panGesture];
    
}

-(void)panPet:(UIPanGestureRecognizer *)panGesture {
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"GESTURE BEGAN");
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint velocity = [panGesture velocityInView:self.view];
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
            NSLog(@"%f",magnitude);
            if (magnitude > 1000) {
                [self catIsGrumpy];
            }
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"GESTURE ENDED");
            break;
        default:
            break;
        }
    }
}

-(void)catIsGrumpy {
    self.petImageView.image = [UIImage imageNamed:@"grumpy"];
}

-(void)longPressApple:(UILongPressGestureRecognizer *)pressApple {

/*ensures the longPressFEEDapple is created once the pressApple state ENDS, not at the start or middle -- this solved a bug where the apple was created multiple times during the pressApple gesture*/
    
    if (pressApple.state == UIGestureRecognizerStateEnded ) {
        
        self.appleToFeedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, self.view.bounds.size.height - 95, 40, 40)];
        self.appleToFeedImageView.userInteractionEnabled = YES;
        self.appleToFeedImageView.image = [UIImage imageNamed:@"apple"];
        
        [self.view addSubview:self.appleToFeedImageView];
        
        //initialize the panAppleToFeed gesture
        self.panAppleToFeedGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFeedApple:)];
        [self.appleToFeedImageView addGestureRecognizer:self.panAppleToFeedGesture];
    }

}

-(void)panFeedApple:(UIPanGestureRecognizer *)panFeedApple {
    switch (panFeedApple.state) {
        case UIGestureRecognizerStateChanged:{
            self.appleToFeedImageView.center = [panFeedApple locationInView:nil];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (CGRectIntersectsRect(self.appleToFeedImageView.frame, self.petImageView.frame))
            {
                [UIView transitionFromView:self.appleToFeedImageView
                                    toView:self.petImageView
                                  duration:1
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                completion:^(BOOL finished){
                                    [self.appleToFeedImageView removeFromSuperview];
                                }];
                
            } else {
                [UIView transitionFromView:self.appleToFeedImageView
                                    toView:self.petImageView
                                  duration:1
                                   options:UIViewAnimationOptionTransitionCurlDown
                                completion:^(BOOL finished){
                                    [self.appleToFeedImageView removeFromSuperview];
                                }];
            }
            self.appleToFeedImageView = nil;
            break;
        
        }
        default:
            break;
    }
}

@end
