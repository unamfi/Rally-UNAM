//
//  SharedData.m
//  Rally UNAM
//
//  Created by Oscar Belman on 11/26/13.
//  Copyright (c) 2013 UNAM. All rights reserved.
//

#import "SharedData.h"

@implementation SharedData

static NSDictionary *sharedJSONDictionary = nil;

+(void)setSharedJSONDictionary:(NSDictionary *)dictionary
{
    sharedJSONDictionary = dictionary;
}

+(NSDictionary *)getSharedJSONDictionary
{
    return sharedJSONDictionary;
}

+ (void)saveData:(NSMutableArray *)array name:(NSString*)name
{
    
    NSData *_plist = (NSData *)array;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", name]]; //add our image to the path
    
    [fileManager createFileAtPath:fullPath contents:_plist attributes:nil]; //finally save the path (image)
    
}

+ (void)removeData:(NSString*)name
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", name]];
    
    [fileManager removeItemAtPath: fullPath error:NULL];
}

+ (NSMutableArray*)loadData:(NSString*)name
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", name]];
    
    return  [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
}

@end
