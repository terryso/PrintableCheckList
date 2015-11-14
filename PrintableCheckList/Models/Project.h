//
// Created by Nick on 15/5/2.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;

@interface Project : NSObject <NSCoding>

@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *items;

- (void)addItem:(Item *)item;
- (void)saveItem:(Item *)item;
- (void)deleteItem:(Item *)item;

- (NSDictionary *)toDictionary;

@end