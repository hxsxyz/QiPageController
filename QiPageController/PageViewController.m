//
//  PageViewController.m
//  QiPageController
//
//  Created by QLY on 2019/5/26.
//  Copyright © 2019 qishare. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIViewController *ctrl = [UIViewController new];
    ctrl.view.backgroundColor = [UIColor blueColor];
    
    UIViewController *ctrl1 = [UIViewController new];
    ctrl1.view.backgroundColor = [UIColor purpleColor];
    
    UIViewController *ctrl2 = [UIViewController new];
    ctrl2.view.backgroundColor = [UIColor brownColor];
    
    self.controllerArray = @[ctrl,ctrl1,ctrl2];
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
