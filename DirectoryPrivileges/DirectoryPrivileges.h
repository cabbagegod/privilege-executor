//
//  DirectoryPrivileges.h
//  DirectoryPrivileges
//
//  Created by Henry McIntyre on 8/6/24.
//

#import <Foundation/Foundation.h>

@interface DirectoryPrivileges : NSObject

+ (char*) StartAsAdmin;
+ (bool) TestValue;

@end
