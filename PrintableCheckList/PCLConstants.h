//
//  PCLConstants.h
//  PrintableCheckList
//
//  Created by Nick on 15/5/3.
//  Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#ifndef PrintableCheckList_PCLConstants____FILEEXTENSION___
#define PrintableCheckList_PCLConstants____FILEEXTENSION___

#define CLIENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#ifdef DEBUG
#define PCL_LOG(__FORMAT__, ...) NSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define PCL_LOG(__FORMAT__, ...)
#endif

#endif
