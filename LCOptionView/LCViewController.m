//
//  LCViewController.m
//  LCOptionView
//
//  Created by lc on 14-2-8.
//  Copyright (c) 2014年 lc. All rights reserved.
//

#import "LCViewController.h"
#import "LCOptionView.h"

@interface LCViewController ()<LCOptionViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataSource;

@end

@implementation LCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:5];
    for (int i =0; i < 100; i++) {
        [arr addObject:[NSString stringWithFormat:@"%i",i]];
    }
    self.dataSource = arr, [arr release];
    
    LCOptionView *op = [[LCOptionView alloc]initWithFrame:CGRectMake(10, 10, 300, 200) andData:arr isMutiSelected:YES];
    op.m_pTitle = @"请选择";
    op.delegate = self;
    [self.view addSubview:op];
}

- (NSInteger)optionView:(LCOptionView *)optionView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (void)optionView:(LCOptionView *)optionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%i",indexPath.row);
}


// - (CGFloat)heightOfCell:(LCOptionView *)optionView
// {
//     return 60;
// }
// - (CGFloat)heightOfTitle:(LCOptionView *)optionView
// {
//     return 60;
// }
// - (NSString *)titleOfOptionView:(LCOptionView *)optionView
// {
//     return @"请选择";
// }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
