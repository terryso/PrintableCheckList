//
// Created by Nick on 15/5/3.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "PrintManager.h"
#import "Project.h"
#import "Item.h"


@implementation PrintManager

+ (NSString *)printTextForProject:(Project *)project {
    NSData *checkBoxData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"button" withExtension:@"gif"]];
    NSString *checkBoxImg = [checkBoxData base64EncodedStringWithOptions:0];
    NSString *checkBox = [NSString stringWithFormat:@"<img src=\"data:image/gif;base64,%@\" style=\"width:16px; height:16px; border:2px solid black; margin: 5px 20px 0 0; float: left;\" />", checkBoxImg];
    NSMutableString *printText = [NSMutableString string];
    NSString *itemClass = @"line-height: 30px; font-size: 16px; padding-left: 35px; margin-bottom: 15px;";
    [printText appendFormat:@"<div><h1>%@</h1></div>", project.title];
    for (Item *item in project.items) {
        [printText appendFormat:@"<div style=\"%@\">%@<div style=\"%@\">%@</div></div>", itemClass, checkBox, itemClass, item.title];
    }
    NSString *template = @"<html><head><meta name=\"viewport\" content=\"width=device-width, minimum-scale=1.0, initial-scale=1.0, maximum-scale=1.0, user-scalable=1\"></head><body>%@</body></html>";
    return [NSString stringWithFormat:template, printText];
}

@end