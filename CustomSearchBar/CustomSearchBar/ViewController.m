//
//  ViewController.m
//  CustomSearchBar
//
//  Created by 云联智慧 on 2019/5/28.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "ViewController.h"
#import "TestSearchBarViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *testBtn = [[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 100, 200, 40)];
    [testBtn setTitle:@"展示搜索框" forState:UIControlStateNormal];
    testBtn.backgroundColor = [UIColor orangeColor];
    [testBtn addTarget:self action:@selector(tapToShowSearchVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}
-(void)tapToShowSearchVC:(UIButton *)sender
{
    TestSearchBarViewController *testsearchBarVC = [TestSearchBarViewController new];
    [self.navigationController pushViewController:testsearchBarVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
