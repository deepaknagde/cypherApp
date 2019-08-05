//
//  MoodGraphView.h
//  appCounselling
//
//  Created by MindCrew Technologies on 29/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoodGraphView : UIView
{
    UILabel *lblSubTitle;
    
    NSThread *_thread1;
    UIActivityIndicatorView *indicator1;

    UIView *viewMoodGraph;
    UIImageView *imgViewMoodGraph;
    UIButton *btnStart;
}

- (void)showImage:(NSString *)strImageURL;
- (void)setParameter:(NSDictionary *)dictAppointment;

@end
