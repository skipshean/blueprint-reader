//
//  ModalNoAnim.m
//  
//
//  Created by Valentin Filip on 25.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "ModalNoAnim.h"

@implementation ModalNoAnim

-(void) perform {
    ((UINavigationController *)[self destinationViewController]).modalPresentationStyle = UIModalPresentationFormSheet;
    [[self sourceViewController] presentViewController:[self destinationViewController] animated:NO completion:nil];
}

@end
