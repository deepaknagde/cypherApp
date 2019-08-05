//
//  AssessmentFormView.m
//  appCounselling
//
//  Created by MindCrew Technologies on 21/12/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import "AssessmentFormView.h"
#import "AppDelegate.h"
#import "AssessmentFormParser.h"

#import "NSData+Base64.h"
#import "StringEncryption.h"

@implementation AssessmentFormView
#define strKeyWebService @"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R"

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        scrlForm = [[UIScrollView alloc] init];
     
        [self screenDesigning];
    }
    return self;
}

- (void)screenDesigning
{
    scrlForm.frame = CGRectMake(0, 0, appDelegate.screenWidth, self.frame.size.height-50);
    scrlForm.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:scrlForm];
    
    UIButton *btnClose = [[UIButton alloc] init];
    btnClose.frame = CGRectMake(0, self.frame.size.height-50, appDelegate.screenWidth, 50);
//    btnClose.backgroundColor = [UIColor blueColor];
    btnClose.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClose setTitle:@"Close" forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    [btnClose addTarget:self action:@selector(btnCloseClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
}

- (void)btnCloseClicked
{
    [self removeFromSuperview];
}

- (void)getAllQuestionsWebServiceCall:(NSString *)strUsername
{
//    {
//        "requestData":{
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data":{
//                "clun01":"GB"
//            },
//            "requestType":"userassesmentdata"
//        }
//    }
    
    [appDelegate addChargementLoader];
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strUsername, nil] forKeys:[NSArray arrayWithObjects:@"clun01", nil]];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"userassesmentdata", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:requestData forKey:@"requestData"];
    
    //PendingFriendRequest
    [[AssessmentFormParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dictData in responseDict)
            {
                dictQuestions = dictData;
                break;
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(dictQuestions != nil)
            {
                self.alpha = 1.0;
                [appDelegate removeChargementLoader];
                [self showAssessmentForm];
            }
            else
            {
                [appDelegate removeChargementLoader];
//                [self showAlertMessage:@"User did not fill the Impact Questions"];
                [self removeFromSuperview];
            }
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getAllQuestionsWebServiceCall:strUsername];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)showAssessmentForm
{
/*
    "_id" = 5a3b6f329c66a4003a3e62f7;
    "accept_terms" = true;
    address = "mNOHiZk9qRNOC/q29WupYw==";
    clun01 = "ZpJhigkWqc34SDuSOh/t3g==";
    "counselling_reason" = "qfCX7NiwqBD8lZ8EiKOI6g==";
    "created_at" = "2017-12-21T08:22:10.651Z";
    dob = "12/21/2005";
    email = "duuy4eLVgUj5AU4Rk8amEmK6EfvSIlhVrnijmAx1a0Q=";
    feel = 6;
    firstname = "MvqxEtT41iGZ16Q5c3H2+g==";
    lastname = "+NtzVKTcOr5fL8EH5DRR8g==";
    "phone_number" = 447999475488;
    "previous_counselling" = No;
    "signed_by" = "MUyiMiBTXaBqmtYcvRYtA5w/UOG9IMISf5zBG2PHvMc=";
    "updated_at" = "2017-12-21T08:22:10.651Z";
*/

    NSString *strFirstName = [dictQuestions objectForKey:@"firstname"];
    strFirstName = [self getDycryptString:strFirstName];
    
    NSString *strLastName = [dictQuestions objectForKey:@"lastname"];
    strLastName = [self getDycryptString:strLastName];
    
    NSString *strAddress = [dictQuestions objectForKey:@"address"];
    strAddress = [self getDycryptString:strAddress];
    
    NSString *strPhoneNumber = [dictQuestions objectForKey:@"phone_number"];
    strPhoneNumber = [NSString stringWithFormat:@"+44-%@", strPhoneNumber];

    NSString *strEmail = [dictQuestions objectForKey:@"email"];
    strEmail = [self getDycryptString:strEmail];
    
    NSString *strPrevious = [dictQuestions objectForKey:@"previous_counselling"];

    NSString *strReason = [dictQuestions objectForKey:@"counselling_reason"];
    strReason = [self getDycryptString:strReason];

    NSString *strFeel = [dictQuestions objectForKey:@"feel"];
    
    NSString *strDOB = [dictQuestions objectForKey:@"dob"];
    strDOB = [self getDycryptString:strFirstName];
    
    NSString *strSignedBy = [dictQuestions objectForKey:@"signed_by"];
    strSignedBy = [self getDycryptString:strSignedBy];
    strSignedBy = [NSString stringWithFormat:@" %@", strSignedBy];

    UIColor *color1 = [UIColor  colorWithRed:110/255.0 green:031/255.0 blue:147/255.0 alpha:1.0];
    UIColor *color2 = [UIColor  colorWithRed:251/255.0 green:142/255.0 blue:199/255.0 alpha:1.0];
    UIColor *color3 = [UIColor  colorWithRed:253/255.0 green:198/255.0 blue:001/255.0 alpha:1.0];
    UIColor *color4 = [UIColor  colorWithRed:142/255.0 green:016/255.0 blue:066/255.0 alpha:1.0];
    UIColor *color5 = [UIColor  colorWithRed:053/255.0 green:225/255.0 blue:236/255.0 alpha:1.0];
    UIColor *color6 = [UIColor  colorWithRed:235/255.0 green:064/255.0 blue:064/255.0 alpha:1.0];
    

    CGFloat yRef = 20;
    CGFloat ySpace = 10;
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblTitle.text = @" First name";
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = color1;
    [scrlForm addSubview:lblTitle];

    yRef = yRef+lblTitle.frame.size.height;

    UILabel *lblValue = [[UILabel alloc] init];
    lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblValue.text = strFirstName;
    lblValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblValue.numberOfLines = 0;
    lblValue.textColor = [UIColor blackColor];
    lblValue.backgroundColor = [UIColor  whiteColor];
    [scrlForm addSubview:lblValue];

    yRef = yRef+lblValue.frame.size.height+ySpace;
    
    lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblTitle.text = @" Last name";
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = color2;
    [scrlForm addSubview:lblTitle];
    
    yRef = yRef+lblTitle.frame.size.height;
    
    lblValue = [[UILabel alloc] init];
    lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblValue.text = strLastName;
    lblValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblValue.numberOfLines = 0;
    lblValue.textColor = [UIColor blackColor];
    lblValue.backgroundColor = [UIColor  whiteColor];
    [scrlForm addSubview:lblValue];

//    yRef = yRef+lblValue.frame.size.height+ySpace;
//
//    lblTitle = [[UILabel alloc] init];
//    lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
//    lblTitle.text = @" Home address";
//    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
//    lblTitle.numberOfLines = 0;
//    lblTitle.textColor = [UIColor whiteColor];
//    lblTitle.backgroundColor = color3;
//    [scrlForm addSubview:lblTitle];
//
//    yRef = yRef+lblTitle.frame.size.height;
//
//    lblValue = [[UILabel alloc] init];
//    lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
//    lblValue.text = strAddress;
//    lblValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
//    lblValue.numberOfLines = 0;
//    lblValue.textColor = [UIColor blackColor];
//    lblValue.backgroundColor = [UIColor  whiteColor];
//    [scrlForm addSubview:lblValue];

    CGSize size = [strAddress sizeWithFont:lblValue.font constrainedToSize:CGSizeMake(appDelegate.screenWidth-40, 1000) lineBreakMode:NSLineBreakByCharWrapping];

    if(size.height < 44)
        lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    else
        lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, size.height+10);
    
    
    yRef = yRef+lblValue.frame.size.height+ySpace;
    
    lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblTitle.text = @" Phone number";
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = color4;
    [scrlForm addSubview:lblTitle];
    
    yRef = yRef+lblTitle.frame.size.height;
    
    lblValue = [[UILabel alloc] init];
    lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblValue.text = strPhoneNumber;
    lblValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblValue.numberOfLines = 0;
    lblValue.textColor = [UIColor blackColor];
    lblValue.backgroundColor = [UIColor  whiteColor];
    [scrlForm addSubview:lblValue];
    
    yRef = yRef+lblValue.frame.size.height+ySpace;

    lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblTitle.text = @" Email?";
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = color5;
    [scrlForm addSubview:lblTitle];
    
    yRef = yRef+lblTitle.frame.size.height;
    
    lblValue = [[UILabel alloc] init];
    lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblValue.text = strEmail;
    lblValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblValue.numberOfLines = 0;
    lblValue.textColor = [UIColor blackColor];
    lblValue.backgroundColor = [UIColor  whiteColor];
    [scrlForm addSubview:lblValue];
    
    yRef = yRef+lblValue.frame.size.height+ySpace;

    lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 60);
    lblTitle.text = @" Previous counselling experience";
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = color6;
    [scrlForm addSubview:lblTitle];
    
    size = [lblTitle.text sizeWithFont:lblValue.font constrainedToSize:CGSizeMake(appDelegate.screenWidth-40, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    
    if(size.height < 44)
        lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    else
        lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, size.height+10);

    yRef = yRef+lblTitle.frame.size.height;
    
    lblValue = [[UILabel alloc] init];
    lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblValue.text = strPrevious;
    lblValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblValue.numberOfLines = 0;
    lblValue.textColor = [UIColor blackColor];
    lblValue.backgroundColor = [UIColor  whiteColor];
    [scrlForm addSubview:lblValue];
    
    yRef = yRef+lblValue.frame.size.height+ySpace;

    lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 60);
    lblTitle.text = @" Reasons for seeking counselling";
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = color1;
    [scrlForm addSubview:lblTitle];
    
    size = [lblTitle.text sizeWithFont:lblValue.font constrainedToSize:CGSizeMake(appDelegate.screenWidth-40, 1000) lineBreakMode:NSLineBreakByCharWrapping];

    if(size.height < 44)
        lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    else
        lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, size.height+10);

    yRef = yRef+lblTitle.frame.size.height;
    
    lblValue = [[UILabel alloc] init];
    lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblValue.text = strReason;
    lblValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblValue.numberOfLines = 0;
    lblValue.textColor = [UIColor blackColor];
    lblValue.backgroundColor = [UIColor  whiteColor];
    [scrlForm addSubview:lblValue];

    size = [lblValue.text sizeWithFont:lblValue.font constrainedToSize:CGSizeMake(appDelegate.screenWidth-40, 1000) lineBreakMode:NSLineBreakByCharWrapping];

    if(size.height < 44)
        lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    else
        lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, size.height+10);
    
    yRef = yRef+ySpace+lblValue.frame.size.height;

    
    //"Please identify how you feel from a scale of 1-10, 1= extremely low and 10=happy and content:"
    lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 60);
    lblTitle.text = @" Counselling scale:";
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = color2;
    [scrlForm addSubview:lblTitle];
    
    size = [lblTitle.text sizeWithFont:lblValue.font constrainedToSize:CGSizeMake(appDelegate.screenWidth-40, 1000) lineBreakMode:NSLineBreakByCharWrapping];

    if(size.height < 44)
        lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    else
        lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, size.height+10);
    
    yRef = yRef+lblTitle.frame.size.height;
    
    lblValue = [[UILabel alloc] init];
    lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblValue.text = strFeel;
    lblValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblValue.numberOfLines = 0;
    lblValue.textColor = [UIColor blackColor];
    lblValue.textAlignment = NSTextAlignmentCenter;
    lblValue.backgroundColor = [UIColor  whiteColor];
    [scrlForm addSubview:lblValue];

    yRef = yRef+lblValue.frame.size.height;

    lblValue = [[UILabel alloc] init];
    lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblValue.text = @"";
    lblValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblValue.numberOfLines = 0;
    lblValue.textColor = [UIColor blackColor];
    lblValue.textAlignment = NSTextAlignmentCenter;
    lblValue.backgroundColor = [UIColor  whiteColor];
    [scrlForm addSubview:lblValue];

    UISlider *sliderFeel = [[UISlider alloc] init];
    sliderFeel.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 40);
    sliderFeel.minimumValue = 1;
    sliderFeel.maximumValue = 10;
    sliderFeel.backgroundColor = [UIColor whiteColor];
    sliderFeel.value = strFeel.floatValue;
    [scrlForm addSubview:sliderFeel];
    sliderFeel.userInteractionEnabled = NO;
    yRef = yRef+lblValue.frame.size.height+ySpace;

    lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 60);
    lblTitle.text = @" Signature";
    lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = color3;
    [scrlForm addSubview:lblTitle];
    
    size = [lblTitle.text sizeWithFont:lblValue.font constrainedToSize:CGSizeMake(appDelegate.screenWidth-40, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    
    if(size.height < 44)
        lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    else
        lblTitle.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, size.height+10);
    
    yRef = yRef+lblTitle.frame.size.height;

    lblValue = [[UILabel alloc] init];
    lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    lblValue.text = strSignedBy;
    lblValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    lblValue.numberOfLines = 0;
    lblValue.textColor = [UIColor blackColor];
    lblValue.backgroundColor = [UIColor  whiteColor];
    [scrlForm addSubview:lblValue];
    
    size = [lblValue.text sizeWithFont:lblValue.font constrainedToSize:CGSizeMake(appDelegate.screenWidth-40, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    
    if(size.height < 44)
        lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, 44);
    else
        lblValue.frame = CGRectMake(10, yRef, appDelegate.screenWidth-20, size.height+10);
    
    yRef = yRef+ySpace+lblValue.frame.size.height;
    
    scrlForm.contentSize = CGSizeMake(appDelegate.screenWidth, yRef);
    
    //
    /*
     objQuestion1.strLabel = "What is your first name?"
     objQuestion1.strName = "Enter first name"

     objQuestion2.strLabel = "What is your last name?"
     objQuestion2.strName = "Enter last name"
     
     objQuestion4.strLabel = "What is your home address?"
     objQuestion4.strName = "Enter your home address"

     objQuestion5.strLabel = "What is your phone number?"
     objQuestion5.strName = "Enter your phone number"

     objQuestion6.strLabel = "What is your email?"
     objQuestion6.strName = "Enter your email"

     objQuestion7.strLabel = "Do you have previous counselling experience?"
     objQuestion7.strName = "previous counselling experience"

     objQuestion8.strLabel = "What is the reasons for seeking counselling?"
     objQuestion8.strName = "Enter the reasons"

     objQuestion9.strLabel = "Please identify how you feel from a scale of 1-10, 1= extremely low and 10=happy and content:"
     objQuestion9.strName = "Please identify how you feel from a scale of 1-10, 1= extremely low and 10=happy and content:"

     objQuestion10.strLabel = "Enter session code {optional}."
     objQuestion10.strName = "Enter session code {optional}."

     objQuestion11.strLabel = "Terms of use"
     objQuestion11.strName = "Terms of use"
     
     objQuestion12.strLabel = "Please enter your full name to sign."
     objQuestion12.strName = "Enter your full name"
     */
    
}


-(NSString *)getEncryptedString:(NSString *)strString
{
    //    let key: String = appDelegate.objEncrypter.sha256("newapp17mindcrew", length: 32)
    //    let iv: String = "mindcrewnewapp17"
    //    let encryptedData: Data = appDelegate.objEncrypter.encrypt(secret.data(using: String.Encoding.utf8), key: key, iv: iv)
    
    
    StringEncryption *objEncrypter = [[StringEncryption alloc] init];
    
    
    //    -  (NSString*)sha256:(NSString *)key length:(NSInteger) length;
    
    NSString *key = [objEncrypter sha256:@"newapp17mindcrew" length:32];
    NSString *iv = @"mindcrewnewapp17";
    
    
    NSData * encryptedData = [objEncrypter encrypt:[strString dataUsingEncoding:NSUTF8StringEncoding] key:key iv:iv];
    
    //        print("Encrypted data ", encryptedData.base64EncodedString());
    
    return [encryptedData  base64EncodingWithLineLength:0];
}

- (NSString *)getDycryptString:(NSString *)secret  {
    
    NSString *key = [[[StringEncryption alloc] init] sha256:@"newapp17mindcrew" length:32];
    NSString *iv = @"mindcrewnewapp17";
    
    NSData * encryptedData = [NSData dataWithBase64EncodedString:secret];
    
    encryptedData = [[[StringEncryption alloc] init] decrypt:encryptedData key:key iv:iv];
    
    NSString * decryptedText = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    
    return decryptedText;
}
@end
