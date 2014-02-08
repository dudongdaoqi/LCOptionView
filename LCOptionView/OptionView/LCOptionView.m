//
//  optionView.m
//  MobilePlateform
//
//  Created by lc on 13-1-29.
//  Copyright (c) 2013年 LC. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "LCOptionView.h"

#define POINT_X 0
#define POINT_Y 0
#define DISTANCE_X 60
#define DISTANCE_Y 60
#define LABEL_WIDTH 35
#define LABEL_HEIGHT 22
#define TEXT_WIDTH self.frame.size.width
#define kZero 0
#define kBigFont 23
#define kSmallFont 17

#ifdef DEBUG
#define safeRelease(x) [x release]
#else
#define safeRelease(x) [x release],x= nil
#endif

const static int Cell_Height = 40;
const static int Title_Height = 40;
static NSString *title = @"各个选项";

@interface LCOptionView ()

@property (nonatomic, retain) UILabel *m_pLabel;
@property (nonatomic, retain) UIButton *m_pTitleBtn;
@property (nonatomic, retain) UITableView *m_pTableView;
@property (nonatomic, assign) BOOL bMutilSelected;
@property (nonatomic, retain) NSIndexPath *m_pIndexPath;
@property (nonatomic, assign) BOOL bSelectedFlag;
@property (nonatomic, retain) UIButton *m_pImageBtn;
@property (nonatomic, retain) NSMutableArray *m_pOptionArray;
@property (nonatomic, assign) BOOL bfirstLoad;
@property (nonatomic, assign) float titleHeight;
@property (nonatomic, assign) float totalHeight;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, retain) NSMutableIndexSet *box;
@property (nonatomic, assign) BOOL isFristLoad;

@end



@implementation LCOptionView

@synthesize m_pTitleBtn = _m_pTitleBtn;
@synthesize isFristLoad = _isFristLoad;
@synthesize m_pLabel = _m_pLabel;
@synthesize m_pOptionArray = _m_pOptionArray;
@synthesize m_pIndexPath = _m_pIndexPath;
@synthesize bMutilSelected = _bMutilSelected;
@synthesize delegate = _delegate;
@synthesize m_pTitle = _m_pTitle;
@synthesize m_pDataScource = _m_pDataScource;
@synthesize bSelectedFlag = _bSelectedFlag;
@synthesize m_pTableView = _m_pTableView;
@synthesize m_pImageBtn = _m_pImageBtn;
@synthesize titleHeight = _titleHeight;
@synthesize totalHeight = _totalHeight;
@synthesize cellHeight = _cellHeight;
@synthesize box = _box;

- (void)dealloc
{
    safeRelease(_m_pTitleBtn);
    safeRelease(_box);
    safeRelease(_m_pLabel);
    safeRelease(_m_pOptionArray);
    safeRelease(_m_pIndexPath);
    safeRelease(_m_pTitle);
    safeRelease(_m_pDataScource);
    safeRelease(_m_pTableView);
    safeRelease(_m_pImageBtn);
    safeRelease(_box);
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame andData:(NSMutableArray *)array isMutiSelected:(BOOL)isMutiSelected
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _bMutilSelected = isMutiSelected;
        _bSelectedFlag = NO;
        _isFristLoad = YES;
        _titleHeight = Title_Height;
        _totalHeight = CGRectGetHeight(self.frame);
        _cellHeight = Cell_Height;
        self.clipsToBounds= YES;
        _box = [[NSMutableIndexSet alloc]init];
 
        [self addBtn];
        [self addTableView];
        [self setDataScource:array];
    
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_isFristLoad) {
        [self setMyFrame];
        _isFristLoad = NO;
    }
    
}

- (void)setMyFrame
{
    if ([self.delegate respondsToSelector:@selector(heightOfTitle:)]) {
        self.titleHeight = [self.delegate heightOfTitle:self];
        [self setView:self.m_pTitleBtn withHeight:self.titleHeight];
        [self setView:self.m_pLabel withHeight:self.titleHeight];
    }
    
    self.m_pImageBtn.frame =CGRectMake(POINT_X + TEXT_WIDTH - LABEL_WIDTH, POINT_Y+(self.titleHeight-LABEL_WIDTH)/2, LABEL_WIDTH, LABEL_WIDTH);
    
    
    if ([self.delegate respondsToSelector:@selector(titleOfOptionView:)]) {
        self.m_pTitle = [self.delegate titleOfOptionView:self];
    }else{
        self.m_pTitle = title;
    }
    self.m_pLabel.text = self.m_pTitle;

}

- (void)setView:(UIView *)view withHeight:(float)height
{
    CGRect rect = view.frame;
    rect.size.height = height;
    view.frame = rect;
}


- (void)addTableView
{
    UITableView *tableview = [[UITableView alloc]init];
    tableview.backgroundColor = [UIColor grayColor];
    tableview.frame =  CGRectMake(POINT_X,POINT_Y+self.titleHeight,TEXT_WIDTH,kZero);
    tableview.backgroundColor  = [UIColor clearColor];
    tableview.delegate= self;
    tableview.dataSource= self;
//    tableview.separatorColor= [UIColor clearColor];
//    tableview.showsVerticalScrollIndicator = NO;
    tableview.scrollEnabled = YES;
    tableview.hidden = YES;
    self.m_pTableView = tableview,[tableview release];
    [self addSubview:self.m_pTableView];
    
    
    if (!_m_pDataScource)
    {
        _m_pDataScource = [[NSMutableArray alloc]init];
    }
    else
    {
        [_m_pDataScource removeAllObjects];
    }
}

- (void)addBtn
{
    CGRect buttonRect2 = CGRectMake(POINT_X,POINT_Y,CGRectGetWidth(self.frame),self.titleHeight);
    CGRect labelRect = CGRectMake(POINT_X,POINT_Y,CGRectGetWidth(self.frame)-LABEL_WIDTH,self.titleHeight);

    UIButton *roundedRectButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    roundedRectButton2.backgroundColor = [UIColor greenColor];
	roundedRectButton2.userInteractionEnabled = YES;
    roundedRectButton2.frame = buttonRect2;
	[roundedRectButton2 addTarget:self action:@selector(pick)
                 forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:roundedRectButton2];
    self.m_pTitleBtn = roundedRectButton2, [roundedRectButton2 release];
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor greenColor];
    label.frame = labelRect;
    label.textAlignment = NSTextAlignmentLeft;
    label.font =  [UIFont boldSystemFontOfSize:kSmallFont];
    label.text = self.m_pTitle;
    [self addSubview:label];
    self.m_pLabel = label,[label release];

    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	imageBtn.userInteractionEnabled = YES;
    CGRect buttonRect = CGRectMake(POINT_X + TEXT_WIDTH - LABEL_WIDTH, POINT_Y, LABEL_WIDTH, LABEL_WIDTH);
	[imageBtn setFrame:buttonRect];
    [imageBtn setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
	[imageBtn addTarget:self action:@selector(pick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageBtn];
    self.m_pImageBtn = imageBtn;
}

- (void)pick
{
    self.m_pTableView.hidden = NO;
    
    [self.layer setBorderColor:[UIColor greenColor].CGColor];
    [self.layer setBorderWidth:1];
    
    [UIView animateWithDuration:.2 animations:
     ^{
         CGRect newFrame = self.frame;
         newFrame.size.height = _bSelectedFlag?self.titleHeight:self.totalHeight;
         self.frame = newFrame;
         
         self.m_pTableView.frame =  CGRectMake(POINT_X,POINT_Y+self.titleHeight,TEXT_WIDTH,_bSelectedFlag?kZero:self.totalHeight - self.titleHeight);
         self.m_pTableView.contentSize = CGSizeMake(TEXT_WIDTH, _bSelectedFlag?kZero:self.cellHeight*self.m_pDataScource.count);

         self.m_pImageBtn.transform = CGAffineTransformMakeRotation(_bSelectedFlag ?  kZero :-M_PI_2);
     }
    completion:^(BOOL finished)
    {
    }
     ];
    
    _bSelectedFlag = !_bSelectedFlag;
}

- (void)setDataScource:(NSMutableArray *)sender
{
    if (sender)
    {
        if (!_m_pOptionArray)
        {
            _m_pOptionArray = [[NSMutableArray alloc]init];
        }
        
        self.m_pDataScource = sender;

        [self setOptionTitle];
    }
}

#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(heightOfCell:)]) {
        self.cellHeight = [self.delegate heightOfCell:self];
    }else{
        self.cellHeight = Cell_Height;
    }
    return self.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_pDataScource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LCOptionView";
    
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:CellIdentifier
                 ] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_m_pDataScource.count > row)
    {
        cell.textLabel.text = [self.m_pDataScource objectAtIndex:row];
    }
    if ([self.box containsIndex:row]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
       
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!_bMutilSelected)
    {
        [self pick];
    }
    
    if ([self.delegate respondsToSelector:@selector(optionView:didSelectRowAtIndexPath:)]) {
        [self.delegate optionView:self didSelectRowAtIndexPath:indexPath];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectedFlag:cell withInexPath:indexPath withTableView:tableView];
}

//checkmak
- (void)selectedFlag:(UITableViewCell *)cell withInexPath:(NSIndexPath *)sIndexPath withTableView:(UITableView *)sTableView
{
    NSInteger row = sIndexPath.row;
    if (cell.accessoryType == UITableViewCellAccessoryNone){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.m_pOptionArray addObject:cell.textLabel.text];
        [self.box addIndex:row];
        if (!_bMutilSelected){
            if (self.m_pIndexPath.row == sIndexPath.row){
                self.m_pIndexPath = nil;
            }
            if (self.m_pIndexPath){
                UITableViewCell *newCell = [sTableView cellForRowAtIndexPath:self.m_pIndexPath];
                if (newCell.accessoryType == UITableViewCellAccessoryCheckmark){
                    [newCell setAccessoryType:UITableViewCellAccessoryNone];
                    [self.m_pOptionArray removeObject:cell.textLabel.text];
                    [self.box removeIndex:row];
                }
                
            }
            self.m_pIndexPath = sIndexPath;
        }
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self.m_pOptionArray removeObject:cell.textLabel.text];
        [self.box removeIndex:row];
    }
    [self setOptionTitle];
}

//title
- (void)setOptionTitle
{
    if (kZero == self.m_pOptionArray.count){
        self.m_pLabel.text = self.m_pTitle;
    }
    else{
        for (int i = 0; i < self.m_pOptionArray.count; i++){
            if (kZero == i){
                self.m_pLabel.text = [NSString stringWithFormat:@"%@:%@",self.m_pTitle,[self.m_pOptionArray objectAtIndex:i]];
            }else{
                NSMutableString *temp = [NSMutableString stringWithFormat:@"%@,%@",self.m_pLabel.text,[self.m_pOptionArray objectAtIndex:i]];
                self.m_pLabel.text = temp;
            }
        }
    }
    
}



@end
