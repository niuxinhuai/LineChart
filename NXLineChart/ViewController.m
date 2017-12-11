//
//  ViewController.m
//  NXLineChart
//
//  Created by 牛新怀 on 2017/10/14.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
#ifndef OffWidth
#define OffWidth [UIScreen mainScreen].bounds.size.width / 375
#endif
#ifndef OffHeight
#define OffHeight [UIScreen mainScreen].bounds.size.height / 667
#endif
#ifndef ScreenWidth
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif
#ifndef ScreenHeight
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif
#import "ViewController.h"
#import "NXLineChartView.h"
#import "FSLineChart.h"
@interface ViewController ()
@property (nonatomic, strong) NXLineChartView * chartView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.chartView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NXLineChartView * )chartView{
    if (!_chartView) {
        _chartView = [[NXLineChartView alloc]init];
        _chartView.backgroundColor = [UIColor whiteColor];
        _chartView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        _chartView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-100, 200);
        _chartView.lineChartXLabelArray = @[@"魅族",@"华为",@"中兴",@"小米",@"苹果",@"一加",@"乐视",@"音乐",@"电视",@"体育"];
        _chartView.lineChartYLabelArray = @[];
        _chartView.LineChartDataArray   = @[@100,@40,@60,@45,@100,@55,@33,@120,@40,@100];
    }
    return _chartView;
}

@end
