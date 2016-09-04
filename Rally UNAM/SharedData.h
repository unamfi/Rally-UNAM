//
//  SharedData.h
//  Rally UNAM
//
//  Created by Oscar Belman on 11/26/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedData : NSObject

+(void)setSharedJSONDictionary:(NSDictionary *)dictionary;
+(NSDictionary *)getSharedJSONDictionary;

+ (void)saveData:(NSMutableArray *)array name:(NSString*)name;
+ (void)removeData:(NSString*)name;
+ (NSMutableArray*)loadData:(NSString*)name;

@end
