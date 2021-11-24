
#import <Foundation/Foundation.h>

#if __has_include(<EasyAdModel/EasyAdModel.h>)
FOUNDATION_EXPORT double EasyAdModelVersionNumber;
FOUNDATION_EXPORT const unsigned char EasyAdModelVersionString[];
#import <EasyAdModel/NSObject+EasyAdModel.h>
#import <EasyAdModel/EasyAdClassInfo.h>
#else
#import "NSObject+EasyAdModel.h"
#import "EasyAdClassInfo.h"
#endif
