//
// Created by Nick on 15/5/2.
// Copyright (c) 2015 WeHack Studio. All rights reserved.
//

#import "Item.h"


@implementation Item

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.itemId = [coder decodeObjectForKey:@"self.itemId"];
        self.title = [coder decodeObjectForKey:@"self.title"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.itemId forKey:@"self.itemId"];
    [coder encodeObject:self.title forKey:@"self.title"];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToItem:other];
}

- (BOOL)isEqualToItem:(Item *)item {
    if (self == item)
        return YES;
    if (item == nil)
        return NO;
    if (self.itemId != item.itemId && ![self.itemId isEqualToString:item.itemId])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return [self.itemId hash];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.itemId=%@", self.itemId];
    [description appendFormat:@", self.title=%@", self.title];
    [description appendString:@">"];
    return description;
}

@end