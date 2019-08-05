//
//  BeforeImpactQuestionView.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 21/03/17.
//  Copyright © 2017 iDevz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeforeImpactQuestionCell.h"
#import "ImpactQuestionParser.h"
#import "AppCounsellingChatBL.h"

@class AppDelegate;
@interface BeforeImpactQuestionView : UIView <UITableViewDelegate, UITableViewDataSource, BeforeImpactQuestionCellDelegate, ImpactQuestionParserDelegate, AppCounsellingChatBLDelegate>
{
    AppDelegate *appDelegate;
    NSMutableArray *arrQuestions;
    NSMutableArray *arrAnswers;
    UIScrollView *scrlViewBG;
    UITableView *tblQuestions;
    UIButton *btnSubmit;
}
@property(nonatomic) NSString *strUsername;
@property(nonatomic) NSString *strAppointmentId;
@property(nonatomic) NSString *strCounsellorId;

- (void)getAllQuestionsWebServiceCall;

@end
