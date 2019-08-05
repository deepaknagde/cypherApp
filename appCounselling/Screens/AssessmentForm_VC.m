
//
//  AssessmentForm_VC.m
//  appCounselling
//
//  Created by Apple on 18/09/18.
//  Copyright © 2018 MindcrewTechnology. All rights reserved.
//

#import "AssessmentForm_VC.h"
#import "TextField_TV_Cell.h"
#import "Text_Area_TV_Cell.h"
#import "Redio_btn_TV_Cell.h"
#import "Check_mark_TV_Cell.h"
#import "Paragraph_TV_Cell.h"
#import "Select_TV_Cell.h"
#import "dateF_TV_Cell.h"
#import "number_TV_Cell.h"

@interface AssessmentForm_VC ()

@end

@implementation AssessmentForm_VC

@synthesize Info_TV, JsonArr;

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"--Font name--  %@", name);
        }
    }
    
    
    ColorArray = [[NSMutableArray alloc] init];
    [ColorArray addObject:[UIColor colorWithRed:88.0/255.0 green:201.0/255.0 blue:199.0/255.0 alpha:1.0]];
    [ColorArray addObject:[UIColor colorWithRed:255.0/255.0 green:142.0/255.0 blue:195.0/255.0 alpha:1.0]];
    [ColorArray addObject:[UIColor colorWithRed:255.0/255.0 green:196.0/255.0 blue:67.0/255.0 alpha:1.0]];
    [ColorArray addObject:[UIColor colorWithRed:145.0/255.0 green:14.0/255.0 blue:65.0/255.0 alpha:1.0]];
    [ColorArray addObject:[UIColor colorWithRed:13.0/255.0 green:160.0/255.0 blue:178.0/255.0 alpha:1.0]];
//    [ColorArray addObject:[UIColor colorWithRed:112.0/255.0 green:35.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    NSLog(@"--JsonArr--%@", JsonArr);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Info_TV.delegate = self;
    Info_TV.dataSource = self;
    
    Info_TV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [Info_TV registerNib:[UINib nibWithNibName:@"TextField_TV_Cell" bundle:nil]
         forCellReuseIdentifier:@"TextField_TV_Cell"];
    
    [Info_TV registerNib:[UINib nibWithNibName:@"Text_Area_TV_Cell" bundle:nil]
  forCellReuseIdentifier:@"Text_Area_TV_Cell"];

    [Info_TV registerNib:[UINib nibWithNibName:@"Redio_btn_TV_Cell" bundle:nil]
  forCellReuseIdentifier:@"Redio_btn_TV_Cell"];

    [Info_TV registerNib:[UINib nibWithNibName:@"Check_mark_TV_Cell" bundle:nil]
  forCellReuseIdentifier:@"Check_mark_TV_Cell"];

    [Info_TV registerNib:[UINib nibWithNibName:@"Paragraph_TV_Cell" bundle:nil]
  forCellReuseIdentifier:@"Paragraph_TV_Cell"];

    [Info_TV registerNib:[UINib nibWithNibName:@"Select_TV_Cell" bundle:nil]
  forCellReuseIdentifier:@"Select_TV_Cell"];

    [Info_TV registerNib:[UINib nibWithNibName:@"dateF_TV_Cell" bundle:nil]
  forCellReuseIdentifier:@"dateF_TV_Cell"];

    [Info_TV registerNib:[UINib nibWithNibName:@"number_TV_Cell" bundle:nil]
  forCellReuseIdentifier:@"number_TV_Cell"];

    [Info_TV reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [JsonArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSMutableDictionary *LocalDict = [[NSMutableDictionary alloc] initWithDictionary:[JsonArr objectAtIndex:section]];
    
    NSString *Label_STR = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"label"]];
    
    if ([Label_STR isEqualToString:@"Enter appCounselling code"]) {
        return 0;
    } else {
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSMutableDictionary *LocalDict = [[NSMutableDictionary alloc] initWithDictionary:[JsonArr objectAtIndex:section]];
    
    UIView *Header_V = [[UIView alloc] init];
    
    NSString *Label_STR = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"label"]];
    
    if (![Label_STR isEqualToString:@"Enter appCounselling code"]) {
        Header_V.frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
        
        // Recommended color
//        CGFloat red = arc4random_uniform(256) / 255.0;
//        CGFloat green = arc4random_uniform(256) / 255.0;
//        CGFloat blue = arc4random_uniform(256) / 255.0;
        
//        Header_V.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        
//        uint32_t rnd = arc4random_uniform([ColorArray count]);
        
        NSString *Type_STR = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"type"]];
        
        Header_V.backgroundColor = [ColorArray objectAtIndex:section%5];
        
        NSString *str_Title = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"label"]];
        UILabel *Title_LB = [[UILabel alloc] init];
        Title_LB.frame = CGRectMake(10, 0, tableView.frame.size.width-20, 40);
        Title_LB.textColor = UIColor.whiteColor;
        if ([Type_STR isEqualToString:@"paragraph"])
        {
            Title_LB.text = @"Paragraph";
        } else {
            Title_LB.text = str_Title;
        }
        Title_LB.font = [UIFont fontWithName:@"Ubuntu-Title" size:24.0];
        [Header_V addSubview:Title_LB];
    }
    
    return Header_V;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *LocalDict = [[NSMutableDictionary alloc] initWithDictionary:[JsonArr objectAtIndex:indexPath.section]];
    
    NSString *Type_STR = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"type"]];
    if ([Type_STR isEqualToString:@"text"]) {
        NSString *Label_STR = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"label"]];
        if ([Label_STR isEqualToString:@"Enter appCounselling code"]) {
            return 0;
        } else {
            return 75;
        }
    }
    else if ([Type_STR isEqualToString:@"paragraph"])
    {
        return UITableViewAutomaticDimension;

    }
    else if ([Type_STR isEqualToString:@"textarea"])
    {
        return UITableViewAutomaticDimension;
        
    }
    else {
        return 50;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *LocalDict = [[NSMutableDictionary alloc] initWithDictionary:[JsonArr objectAtIndex:section]];
    
    NSString *str = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"type"]];
    
    if ([str isEqualToString:@"radio-group"])
    {
        NSMutableArray *localArray = [[NSMutableArray alloc] initWithArray:[LocalDict valueForKey:@"values"]];
        
        return localArray.count;
    }
    else if ([str isEqualToString:@"checkbox-group"])
    {
        NSMutableArray *localArray = [[NSMutableArray alloc] initWithArray:[LocalDict valueForKey:@"values"]];
        
        return localArray.count;
    }
    
    else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *LocalDict = [[NSMutableDictionary alloc] initWithDictionary:[JsonArr objectAtIndex:indexPath.section]];
    NSString *str_Type = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"type"]];

    if ([str_Type isEqualToString:@"text"]) {
        
        TextField_TV_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextField_TV_Cell" forIndexPath:indexPath];
        
        NSString *str_value = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"value"]];
      
        cell.Text_TF.text = str_value;

        return cell;

    }
    else if ([str_Type isEqualToString:@"textarea"])
    {
        Text_Area_TV_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Text_Area_TV_Cell" forIndexPath:indexPath];
        
        NSString *str_value = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"value"]];
        cell.Lbl_Area_detail.numberOfLines = 0;
        cell.Lbl_Area_detail.text = str_value;

        return cell;

    }
    else if ([str_Type isEqualToString:@"radio-group"])
    {
        Redio_btn_TV_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Redio_btn_TV_Cell" forIndexPath:indexPath];
        
        NSMutableArray *localArray = [[NSMutableArray alloc] initWithArray:[LocalDict valueForKey:@"values"]];
        
        NSString *localSTR = [NSString stringWithFormat:@"%@", [[localArray objectAtIndex:indexPath.row] valueForKey:@"label"]];
        
        NSString *selected_STR = [NSString stringWithFormat:@"%@", [[localArray objectAtIndex:indexPath.row] valueForKey:@"selected"]];
        
       if ([selected_STR isEqualToString:@"1"])
       {
  [cell.Img_redio_btn setImage:[UIImage imageNamed:@"correct.png"]];
        } else {
  [cell.Img_redio_btn setImage:[UIImage imageNamed:@"close_red"]];
        }
        
        
        cell.Lbl_Redio_btn_name.text = localSTR;
        //Img_redio_btn
        return cell;

    }
    else if ([str_Type isEqualToString:@"checkbox-group"])
    {
        Check_mark_TV_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Check_mark_TV_Cell" forIndexPath:indexPath];
        
        NSMutableArray *localArray = [[NSMutableArray alloc] initWithArray:[LocalDict valueForKey:@"values"]];
        
        NSString *localSTR = [NSString stringWithFormat:@"%@", [[localArray objectAtIndex:indexPath.row] valueForKey:@"label"]];
        
        NSString *selected_STR = [NSString stringWithFormat:@"%@", [[localArray objectAtIndex:indexPath.row] valueForKey:@"selected"]];
        
        if ([selected_STR isEqualToString:@"1"])
        {
            [cell.img_checkmark setImage:[UIImage imageNamed:@"accept.png"]];
        } else {
            [cell.img_checkmark setImage:[UIImage imageNamed:@"checkbox_unchecked.png"]];
        }
        
        cell.Lbl_Option_name.text = localSTR;
        //Img_redio_btn
        return cell;
    }
    else if ([str_Type isEqualToString:@"paragraph"])
    {
        Paragraph_TV_Cell
        *cell = [tableView dequeueReusableCellWithIdentifier:@"Paragraph_TV_Cell" forIndexPath:indexPath];
        NSString *str_value = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"label"]];
        
        cell.Info_LB.numberOfLines = 0;
        cell.Info_LB.text = str_value;
        
        //cell.Text_TF.text = str_value;

        return cell;

    }
    else if ([str_Type isEqualToString:@"number"])
    {
        number_TV_Cell
        *cell = [tableView dequeueReusableCellWithIdentifier:@"number_TV_Cell" forIndexPath:indexPath];
        NSString *str_value = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"value"]];
        
        cell.Lbl_Number.text = str_value;
        
        return cell;
        
    }
    
    else if ([str_Type isEqualToString:@"date"])
    {
        dateF_TV_Cell
        *cell = [tableView dequeueReusableCellWithIdentifier:@"dateF_TV_Cell" forIndexPath:indexPath];
        NSString *str_value = [NSString stringWithFormat:@"%@", [LocalDict valueForKey:@"value"]];
        
        cell.Lbl_Date.text = str_value;
        
        return cell;
        
    }

    else if ([str_Type isEqualToString:@"select"])
    {
        Select_TV_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Select_TV_Cell" forIndexPath:indexPath];
        
        
        NSMutableArray *localArray = [[NSMutableArray alloc] initWithArray:[LocalDict valueForKey:@"values"]];
        
        NSString *Selected_STR = @"";
        
        for (int i=0; i<[localArray count]; i++) {
            
            if ([[NSString stringWithFormat:@"%@", [[localArray objectAtIndex:i] valueForKey:@"selected"]] isEqualToString:@"1"]) {
                Selected_STR = [NSString stringWithFormat:@"%@", [[localArray objectAtIndex:i] valueForKey:@"value"]];
                
                break;
            }
        }
        
        NSLog(@"--Selected_STR--%@", Selected_STR);
        
        cell.lbl_selected_value.text = Selected_STR;
        
        return cell;

    }
    else {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
        
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)action_back:(id)sender {
    
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
    
//    [[self navigationController ]popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:true completion:nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
