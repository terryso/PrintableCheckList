//
// Created by Nick on 15/5/2.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "Project.h"
#import "Item.h"

@interface Project()


@end

@implementation Project

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.projectId = [coder decodeObjectForKey:@"self.projectId"];
        self.title = [coder decodeObjectForKey:@"self.title"];
        self.items = [coder decodeObjectForKey:@"self.items"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.projectId forKey:@"self.projectId"];
    [coder encodeObject:self.title forKey:@"self.title"];
    [coder encodeObject:self.items forKey:@"self.items"];
}

- (void)addItem:(Item *)item {
    NSMutableArray *items = [self mutableItems];
    [items addObject:item];
    self.items = items;
}

- (void)saveItem:(Item *)item {
    NSMutableArray *items = [self mutableItems];
    NSInteger index = [items indexOfObject:item];
    if (index != NSNotFound) {
        items[index] = item;
    }
}

- (void)deleteItem:(Item *)item {
    NSMutableArray *items = [self mutableItems];
    [items removeObject:item];
    self.items = items;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *items = [NSMutableArray array];
    for (Item *item in self.items) {
        [items addObject:item.title];
    }
    dict[self.title] = items;
    return dict;
}

- (NSMutableArray *)mutableItems {
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    if (!items) {
        items = [NSMutableArray array];
    }
    return items;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToProject:other];
}

- (BOOL)isEqualToProject:(Project *)project {
    if (self == project)
        return YES;
    if (project == nil)
        return NO;
    if (self.projectId != project.projectId && ![self.projectId isEqualToString:project.projectId])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return [self.projectId hash];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.projectId=%@", self.projectId];
    [description appendFormat:@", self.title=%@", self.title];
    [description appendFormat:@", self.items=%@", self.items];
    [description appendString:@">"];
    return description;
}

@end