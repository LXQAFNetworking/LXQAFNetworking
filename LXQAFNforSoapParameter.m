//
//  LXQAFNforSoapParameter.m
//  百思不得姐
//
//  Created by 刘鑫奇 on 16/10/12.
//  Copyright © 2016年 刘鑫奇. All rights reserved.
//

#import "LXQAFNforSoapParameter.h"

@implementation LXQAFNforSoapParameter

@synthesize name, value, null, xml;


-(void)setValue:(id)valueParam{
    [valueParam retain];
    [value release];
    value = valueParam;
    null = (value == nil);
}

-(id)initWithValue:(id)valueParam forName: (NSString*) nameValue {
    if(self = [super init]) {
        self.name = nameValue;
        self.value = valueParam;
    }
    return self;
}

-(NSString*)xml{
    if(self.value == nil) {
        return [NSString stringWithFormat:@"<%@ xsi:nil=\"true\"/>", name];
    } else {
        return [NSString stringWithFormat:@"<%@>%@</%@>", self.name, self.value, self.name];
    }
}


@end
