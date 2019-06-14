//
//  MenuViewController.m
//  QiPageController
//
//  Created by QLY on 2019/5/26.
//  Copyright © 2019 qishare. All rights reserved.
//

#import "MenuViewController.h"
#import "UIView+frame.h"
#import "QiPageMenuView.h"
@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupMenuViewMethod1];
    
    
   
    // Do any additional setup after loading the view.
}

- (void)setupMenuViewMethod1 {
    
    //定制样式
    NSDictionary *dataSource = @{
                                 QiPageMenuViewNormalTitleColor : [UIColor blackColor],
                                 QiPageMenuViewSelectedTitleColor : [UIColor redColor],
                                 QiPageMenuViewTitleFont : [UIFont systemFontOfSize:14],
                                 QiPageMenuViewSelectedTitleFont : [UIFont systemFontOfSize:16],
                                 QiPageMenuViewItemIsVerticalCentred : @(YES),
                                 QiPageMenuViewItemTitlePadding : @(20.0),
                                 QiPageMenuViewItemTopPadding : @(20.0),
                                 QiPageMenuViewItemPadding : @(10.0),
                                 QiPageMenuViewLeftMargin : @(20.0),
                                 QiPageMenuViewRightMargin : @(20.0),
                                 QiPageMenuViewItemWidth : @(120.0),
                                 QiPageMenuViewItemsAutoResizing : @(YES),
                                 QiPageMenuViewItemHeight : @(40.0),
                                 QiPageMenuViewHasUnderLine :@(YES),
                                 QiPageMenuViewLineColor : [UIColor greenColor],
                                 QiPageMenuViewLineWidth : @(30.0),
                                 QiPageMenuViewLineHeight : @(4.0),
                                 QiPageMenuViewLineTopPadding : @(10.0)
                                 };
    
    QiPageMenuView *menuView = [[QiPageMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50) titles:@[@"系统消息",@"节日息",@"广播",@"系统消息",@"节日消息",@"广播通知",@"系统消息",@"节日消息",@"广播通知"] dataSource:dataSource];
    menuView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:menuView];

}

- (void)setupMenuViewMethod2 {
    
    QiPageMenuView *menuView = [[QiPageMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50) titles:@[@"系统消息",@"节日消息",@"广播通知",@"修改能提交"]];
    menuView.backgroundColor = [UIColor orangeColor];
    //定制样式
    menuView.normalTitleColor = [UIColor blackColor];
    menuView.selectedTitleColor = [UIColor redColor];
    
    menuView.titleFont = [UIFont systemFontOfSize:14];
    menuView.selectedTitleFont = [UIFont systemFontOfSize:14];
    
    menuView.itemIsVerticalCentred = YES;
    
    menuView.itemTitlePadding = 10.0;
    menuView.itemTopPadding = 20.0;
    menuView.itemSpace = 10.0;
    menuView.leftMargin = 20.0;
    menuView.rightMargin = 20.0;
    
    menuView.itemsAutoResizing = YES;
    menuView.itemWidth = 90;
    menuView.itemHeight = 40;
    
    menuView.hasUnderLine = YES;
    menuView.lineColor = [UIColor greenColor];
    menuView.lineWitdh = 30;
    menuView.lineHeight = 4.0;
    menuView.lineTopPadding = 10;
    
    [self.view addSubview:menuView];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)dealloc
{
    NSLog(@"🐯🐯🐯🐯🐯🐯🐯🐯🐯🐯🐯");
}
@end
