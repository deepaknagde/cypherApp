//
//  AssessmentFormView.h
//  appCounselling
//
//  Created by MindCrew Technologies on 21/12/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@interface AssessmentFormView : UIView
{
    AppDelegate *appDelegate;
    UIScrollView *scrlForm;
    
    NSDictionary *dictQuestions;
}

- (void)getAllQuestionsWebServiceCall:(NSString *)strUsername;

@end
