//
//  ViewController.m
//  QiPageController
//
//  Created by QLY on 2019/5/26.
//  Copyright © 2019 qishare. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"
#import "PageMenuViewController.h"
#import "MenuViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (IBAction)QiPageMenuView:(id)sender {
    
    MenuViewController *page = [MenuViewController new];
    self.navigationItem.title = @"QiPageMenuView";
    [self.navigationController pushViewController:page animated:YES];
    
}

- (IBAction)QiPageViewController:(id)sender {
    
    PageViewController *page = [PageViewController new];
    self.navigationItem.title = @"PageViewController";
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)mix:(id)sender {
    
    PageMenuViewController *page = [[PageMenuViewController alloc]init];
    self.navigationItem.title = @"QiMenuView+QiPageViewController";
    [self.navigationController pushViewController:page animated:YES];
    
}
@end
