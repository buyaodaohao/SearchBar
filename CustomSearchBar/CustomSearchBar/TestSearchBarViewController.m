//
//  TestSearchBarViewController.m
//  CustomSearchBar
//
//  Created by 云联智慧 on 2019/5/28.
//  Copyright © 2019 云联智慧. All rights reserved.
//

#import "TestSearchBarViewController.h"
#import "SearchBarDisplayCenter.h"
@interface TestSearchBarViewController ()<SearchBarDisplayCenterDelegate>

@end

@implementation TestSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    SearchBarDisplayCenter *searchBar = [[SearchBarDisplayCenter alloc]initWithFrame:CGRectMake(0, 100.0, [UIScreen mainScreen].bounds.size.width, 35.0 + 2.0 + 2.0)];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SearchBarDisplayCenterDelegate
-(void)getSearchKeyWord:(NSString *)searchWord
{
    NSLog(@"searchWord = %@",searchWord);
}
@end
