//
//  WebManager.h
//  myYIDA
//
//  Created by xiaojia on 4/3/14.
//  Copyright (c) 2014 sirius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebManager : NSObject

@property (strong, nonatomic)   NSArray *classList;

-(Boolean)ConcWebWithUserCode:(NSString *)usercode Password:(NSString *)password;
-(void)GetClass;

@end
