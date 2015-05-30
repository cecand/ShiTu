//
//  MCResultView.m
//  ShiTu
//
//  Created by xingzhenzhen on 15/5/30.
//  Copyright (c) 2015年 Tudo Gostoso Internet. All rights reserved.
//

#import "MCResultView.h"

#define ButtonWidth 214.5f
#define ButtonHeight 45.5f
#define oColor [UIColor colorWithRed:236/255.0 green:130/255.0 blue:72/255.0 alpha:1]

@interface MCResultView()

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *reshotView;
@property (nonatomic, retain) UIButton *reshotButton;

@end

@implementation MCResultView {
    NSArray *_result;
}

- (void)dealloc{
    self.imageView = nil;
    self.contentView = nil;
    self.reshotView = nil;
    self.reshotButton = nil;
}

- (instancetype)initWithFrame:(CGRect)frame WithURL:(NSString*)url WithResult:(NSArray *)result
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        
        float screenWidth = frame.size.width;
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth/750*398)];
        self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        [self addSubview:self.imageView];
        
        _result = result;
         NSInteger contentHeight = 50+ (ButtonHeight + 15) * [result count];
        if (result != nil) {
            self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, screenWidth/750*398+20, screenWidth, contentHeight)];
            [self addSubview: self.contentView];
            
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, screenWidth, 30)];
//            label1.textColor = oColor;
            label1.text = @"您想找的菜可能是：";
            [self.contentView addSubview:label1];
            
            UIButton *button;
            for (int i = 0; i<[result count]; i++) {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake((screenWidth - ButtonWidth)/2, 50+(15+ButtonHeight)*i, ButtonWidth, ButtonHeight);
                button.backgroundColor = oColor;
                button.clipsToBounds = YES;
                button.layer.cornerRadius = 10;
                [button setTitle: result[i] forState: UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.tag = i;
                [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                NSLog(@"%@", result[i]);
                [self.contentView addSubview:button];
            }
        
        }
        
        self.reshotView = [[UIView alloc]initWithFrame:CGRectMake(0, screenWidth/750*398+20+contentHeight, screenWidth, 100)];
        [self addSubview:self.reshotView];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, screenWidth, 30)];
//        label1.textColor = oColor;
        label1.text = @"没有找到？换个角度拍试试？";
        [self.reshotView addSubview:label1];
        
        self.reshotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reshotButton.frame = CGRectMake((screenWidth - 180/2)/2, 40, 180/2 , 180/2);
        [self.reshotButton setImage:[UIImage imageNamed:@"reshotCamera"] forState:UIControlStateNormal];
        self.reshotButton.clipsToBounds = YES;
        self.reshotButton.layer.cornerRadius = 180/2/2.9f;
        [self.reshotButton addTarget:self action:@selector(onReshotButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.reshotView addSubview:self.reshotButton];
    }
    return self;
}

- (void)onButtonClicked:(id)sender {
    NSInteger tag = [sender tag];
    NSString *foodName = _result[tag];
    [self.delegate didSelectFoodNameResult:foodName];
}

- (void)onReshotButtonClicked {
    [self.delegate didReshotButtonClick];
}

@end
