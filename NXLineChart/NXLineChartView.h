//
//  NXLineChartView.h
//  NXLineChart
//
//  Created by 牛新怀 on 2017/10/14.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXLineChartView : UIView
@property (nonatomic, strong) NSArray * lineChartYLabelArray;
@property (nonatomic, strong) NSArray * lineChartXLabelArray; // X轴数据
@property (nonatomic, strong) NSArray * LineChartDataArray; // 数据源
@end
