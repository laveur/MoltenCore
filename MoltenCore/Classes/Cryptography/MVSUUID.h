//
//  MVSUUID.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 6/3/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//
#ifndef MVSUUID_H
#define MVSUUID_H
#include <CoreFoundation/CoreFoundation.h>

CFUUIDRef CFUUIDCreateVersion3(CFUUIDRef namespaceUUID, CFStringRef name);
CFUUIDRef CFUUIDCreateVersion5(CFUUIDRef namespaceUUID, CFStringRef name);

#endif // MVSUUID_H