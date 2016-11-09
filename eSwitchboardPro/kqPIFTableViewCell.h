//
//  kqPIFTableViewCell.h
//  eSwitchboardPro
//
//  Created by 海峰 on 15/9/25.
//  Copyright © 2015年 海峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kqPIFTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *postionLabel;

@end
