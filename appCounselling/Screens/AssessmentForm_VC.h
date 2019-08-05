//
//  AssessmentForm_VC.h
//  appCounselling
//
//  Created by Apple on 18/09/18.
//  Copyright © 2018 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssessmentForm_VC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *JsonArr;
    NSMutableArray *ColorArray;
}

@property (weak, nonatomic) IBOutlet UITableView *Info_TV;

@property(nonatomic, retain) NSMutableArray *JsonArr;

@end
