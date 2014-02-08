//
//  optionView.h
//  MobilePlateform
//
//  Created by lc on 13-1-29.
//  Copyright (c) 2013年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCOptionView;
@protocol LCOptionViewDelegate <NSObject>

@optional
- (NSString *)titleOfOptionView:(LCOptionView *)optionView;
- (CGFloat)heightOfTitle:(LCOptionView *)optionView;
- (CGFloat)heightOfCell:(LCOptionView *)optionView;
- (void)optionView:(LCOptionView *)optionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LCOptionView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *m_pDataScource;
@property (nonatomic, assign) id<LCOptionViewDelegate> delegate;
@property (nonatomic, retain) NSString *m_pTitle;

- (id)initWithFrame:(CGRect)frame andData:(NSMutableArray *)array isMutiSelected:(BOOL)isMutiSelected;


@end
