//
//  LXQAFNforSoapParameter.h
//  百思不得姐
//
//  Created by 刘鑫奇 on 16/10/12.
//  Copyright © 2016年 刘鑫奇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXQAFNforSoapParameter : NSObject{
    NSString* name;
    NSString* xml;
    id value;
    BOOL null;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) id value;
@property (readonly) BOOL null;
@property (nonatomic, retain, readonly) NSString* xml;

-(id)initWithValue:(id)value forName: (NSString*) name;

@end
