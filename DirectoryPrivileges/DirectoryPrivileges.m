#import "DirectoryPrivileges.h"
#import <Foundation/Foundation.h>
#import <Security/Security.h>

#ifdef __cplusplus
extern "C" {
#endif

char* StartAsAdmin(const char *directoryPath) {
    // Create an Authorization Reference
    AuthorizationRef authRef;
    AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagExtendRights;
    AuthorizationRights rightsRequest;
    AuthorizationItem authItem = {kAuthorizationRightExecute, 0, NULL, 0};
    
    // Initialize the authorization reference
    OSStatus status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, flags, &authRef);
    if (status != errAuthorizationSuccess) {
        NSString *errorString = (NSString *)CFBridgingRelease(SecCopyErrorMessageString(status, NULL));
        AuthorizationFree(authRef, kAuthorizationFlagDefaults);
        return strdup([errorString UTF8String]);
    }
    
    // Define the rights request (e.g., access the directory)
    rightsRequest.count = 1;
    rightsRequest.items = &authItem;
    
    // Perform authorization request
    status = AuthorizationCopyRights(authRef, &rightsRequest, kAuthorizationEmptyEnvironment, flags, NULL);
    if (status != errAuthorizationSuccess) {
        NSString *errorString=(NSString*)CFBridgingRelease(SecCopyErrorMessageString(status, NULL));
        AuthorizationFree(authRef, kAuthorizationFlagDefaults);
        return strdup([errorString UTF8String]);
    }
    
    flags = kAuthorizationFlagDefaults;
    char *myArguments[] = { "-privileged", NULL };
    FILE *myCommunicationsPipe = NULL;
    
    status = AuthorizationExecuteWithPrivileges(authRef, directoryPath, flags, myArguments, myCommunicationsPipe);
    if(status != errAuthorizationSuccess) {
        NSString *errorString=(NSString*)CFBridgingRelease(SecCopyErrorMessageString(status, NULL));
        AuthorizationFree(authRef, kAuthorizationFlagDefaults);
        return strdup([errorString UTF8String]);
    }
    
    AuthorizationFree(authRef, kAuthorizationFlagDefaults);
    return strdup("Success");
}

    bool TestValue(bool test) {
        return test;
    }
    
#ifdef __cplusplus
}
#endif
