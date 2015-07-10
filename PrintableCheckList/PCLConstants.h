//
//  PCLConstants.h
//  PrintableCheckList
//
//  Created by Nick on 15/5/3.
//  Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#ifndef PrintableCheckList_PCLConstants____FILEEXTENSION___
#define PrintableCheckList_PCLConstants____FILEEXTENSION___

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define PCL_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define PCL_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define PCL_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define PCL_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#define CLIENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#ifdef DEBUG
#define PCL_LOG(__FORMAT__, ...) NSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define PCL_LOG(__FORMAT__, ...)
#endif

#endif
