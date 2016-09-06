//
//  JCTextFieldCell.m
//  Reddit Wallpaper
//
//  Created by Jeremy Curcio on 8/31/16.
//  Copyright © 2016 Jeremy Curcio. All rights reserved.
//

#import "JCTextFieldCell.h"

@implementation JCTextFieldCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here. (None needed.)
    }
    return self;
}

- (NSRect)drawingRectForBounds:(NSRect)rect {
    
    // This gives pretty generous margins, suitable for a large font size.
    // If you're using the default font size, it would probably be better to cut the inset values in half.
    // You could also propertize a CGFloat from which to derive the inset values, and set it per the font size used at any given time.
    NSRect rectInset = NSMakeRect(rect.origin.x + 11.0f, rect.origin.y - 1, rect.size.width - 10.0f, rect.size.height);
    return [super drawingRectForBounds:rectInset];
    
}

// Required methods
- (id)initWithCoder:(NSCoder *)decoder {
    return [super initWithCoder:decoder];
}
- (id)initImageCell:(NSImage *)image {
    return [super initImageCell:image];
}
- (id)initTextCell:(NSString *)string {
    return [super initTextCell:string];
}
@end
