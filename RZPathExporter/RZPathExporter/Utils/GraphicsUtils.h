//
//  GraphicsUtils.h
//  RZPathExporter
//
//  Created by Rob Visentin on 8/9/13.
//  Copyright (c) 2013 Rob Visentin. All rights reserved.
//

#ifndef RZPathExporter_GraphicsUtils_h
#define RZPathExporter_GraphicsUtils_h

static inline CGPoint RZRectGetCenter(CGRect rect)
{
    return CGPointMake(rect.origin.x + 0.5*rect.size.width, rect.origin.y + 0.5*rect.size.height);
}
static inline CGRect RZRectCenterOnPoint(CGRect rect, CGPoint center)
{
    return CGRectMake(center.x - 0.5*rect.size.width, center.y - 0.5*rect.size.height, rect.size.width, rect.size.height);
}

#endif
