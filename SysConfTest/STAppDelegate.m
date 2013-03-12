//
//  STAppDelegate.m
//  SysConfTest
//
//  Created by Shinone Tetsuya on 13/03/12.
//  Copyright (c) 2013年 Shinone Tetsuya. All rights reserved.
//

#import "STAppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation STAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    SCDynamicStoreRef store;
    SCDynamicStoreContext context;
    CFStringRef key;
    CFDictionaryRef val;
    
    NSArray *interfaces;
    
    memset(&context, 0, sizeof(context));
    context.info = self;
    store = SCDynamicStoreCreate(NULL, (CFStringRef)[[NSBundle mainBundle] bundleIdentifier], NULL, &context);
    
    key = SCDynamicStoreKeyCreateNetworkInterface(NULL, kSCDynamicStoreDomainState);
    val = (CFDictionaryRef)SCDynamicStoreCopyValue(store, key);
    interfaces = [NSArray arrayWithArray:[(NSDictionary *)val objectForKey:@"Interfaces"]];
    CFRelease(val);
    CFRelease(key);
    
    SCPreferencesRef preferences = SCPreferencesCreate(kCFAllocatorDefault, CFSTR("PRG"), NULL);
    CFArrayRef serviceArray = SCNetworkServiceCopyAll(preferences);
    for (int i = 0;i < CFArrayGetCount(serviceArray);i++) {
        SCNetworkServiceRef serviceRef = (SCNetworkServiceRef)CFArrayGetValueAtIndex(serviceArray, i);
		SCNetworkInterfaceRef interface = SCNetworkServiceGetInterface(serviceRef);
        key = SCDynamicStoreKeyCreateNetworkInterfaceEntity(NULL, kSCDynamicStoreDomainState, SCNetworkInterfaceGetBSDName(interface), kSCEntNetIPv4);
        val = (CFDictionaryRef)SCDynamicStoreCopyValue(store, key);
        NSLog(@"%@, %@, %@", key, SCNetworkInterfaceGetInterfaceType(interface), [(NSDictionary *)val description]);
        if (val != NULL)
            CFRelease(val);
        CFRelease(key);
    }
    CFRelease(serviceArray);
    
    /*for (NSString *interface in interfaces) {
        key = SCDynamicStoreKeyCreateNetworkInterfaceEntity(NULL, kSCDynamicStoreDomainState, (CFStringRef)interface, kSCEntNetIPv4);
        val = (CFDictionaryRef)SCDynamicStoreCopyValue(store, key);
        NSLog(@"%@\n%@", key, [(NSDictionary *)val description]);
        if (val != NULL)
            CFRelease(val);
        CFRelease(key);
        
        SCNetworkInterfaceRef interface = SCNetworkServiceGetInterface(serviceRef);
    }*/
}

@end
