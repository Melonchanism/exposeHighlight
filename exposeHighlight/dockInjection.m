#import <CoreGraphics/CoreGraphics.h>
#import <Cocoa/Cocoa.h>
#include "frida-gum.h"
#include "ZKSwizzle.h"

CGColorRef CGColorCreateGenericRGB(CGFloat, CGFloat, CGFloat, CGFloat);

static CGColorRef my_CGColorCreateGenericRGB(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
	// Replace color with custom one
	NSLog(@"!Called Color Creation Function");
	return CGColorCreateGenericRGB(96.5/255, 140.0/255, 77.0/255, 1.0);
}

void replace_color_function(void) {
	GumInterceptor * interceptor;
	
	gum_init_embedded();
	interceptor = gum_interceptor_obtain();
	GError *error = nil;
	GumModule *module = gum_module_load("/System/Library/CoreServices/Dock.app/Contents/MacOS/Dock", &error);
	GumAddress funcAddr = gum_module_find_export_by_name (module, "CGColorCreateGenericRGB");
	GumReplaceReturn result = gum_interceptor_replace(interceptor, (gpointer) funcAddr, my_CGColorCreateGenericRGB, NULL, NULL);
	gum_interceptor_end_transaction (interceptor);
}

__attribute__((constructor)) static void install(void) {
	@autoreleasepool {
		replace_color_function();
	}
}

//@interface WVMinimizedAndRecentsItemLayer : CALayer
//- (struct CGRect)_frameForHighlight;
//@end
//
//ZKSwizzleInterface(HookWVMinimizedAndRecentsItemLayer, WVMinimizedAndRecentsItemLayer, CALayer)
//
//@implementation HookWVMinimizedAndRecentsItemLayer
//
//- (struct CGRect)_frameForHighlight {
//	NSLog(@"!Created border");
//	return CGRectMake(0, 0, 0, 0);
//}
//
//@end
