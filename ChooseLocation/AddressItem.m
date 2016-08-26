//
//  AddressItem.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "AddressItem.h"

@implementation AddressItem

+ (instancetype)initWithName:(NSString *)name isSelected:(BOOL)isSelected{
    
    AddressItem * item = [[AddressItem alloc]init];
    item.name = name;
    item.isSelected = isSelected;
    return item;
}

@end
