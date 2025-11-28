#include "ZKSwizzle.h"
#include "frida-gum.h"
#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>

CGColorRef CGColorCreateGenericRGB(CGFloat, CGFloat, CGFloat, CGFloat);
CGColorRef CGColorCreateSRGB(CGFloat, CGFloat, CGFloat, CGFloat);

CGColorRef color;
NSUserDefaults *defaults;

CGColorRef colorFromHexString(NSString *hexString) {
	CGColorRef fallback = CGColorCreateSRGB(1.0, 1.0, 1.0, 1.0);
	if (![hexString isKindOfClass:[NSString class]]) {
		return fallback;
	}
	if (hexString.length != 7 && hexString.length != 9) {
		return fallback;
	}
	unsigned long long value = 0;
	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	scanner.scanLocation = 1; // skip '#'
	if (![scanner scanHexLongLong:&value]) {
		return fallback;
	}
	CGFloat r, g, b, a;
	if (hexString.length == 7) {
		r = ((value & 0xFF0000) >> 16) / 255.0;
		g = ((value & 0x00FF00) >> 8) / 255.0;
		b = (value & 0x0000FF) / 255.0;
		a = 1.0;
	} else {
		r = ((value & 0xFF000000) >> 24) / 255.0;
		g = ((value & 0x00FF0000) >> 16) / 255.0;
		b = ((value & 0x0000FF00) >> 8) / 255.0;
		a = (value & 0x000000FF) / 255.0;
	}
	return CGColorCreateSRGB(r, g, b, a);
}

CGColorRef hook_CGColorCreateGenericRGB(CGFloat red, CGFloat green,
                                        CGFloat blue, CGFloat alpha) {
	NSLog(@"[colors]: %f, %f, %f", red, green, blue);

	// Floating point accuracy in a nutshell
	if (blue == 0.98431372549019602) {
		color = colorFromHexString([defaults stringForKey:@"expose-highlight"]);
		return color;
	}
	return CGColorCreateGenericRGB(red, green, blue, alpha);
}

void replace_color_function(void) {
	GumInterceptor *interceptor;

	gum_init_embedded();
	interceptor = gum_interceptor_obtain();
	GError *error = nil;
	GumModule *module = gum_module_load(
	    "/System/Library/CoreServices/Dock.app/Contents/MacOS/Dock", &error);
	GumAddress funcAddr =
	    gum_module_find_export_by_name(module, "CGColorCreateGenericRGB");
	GumReplaceReturn _ =
	    gum_interceptor_replace(interceptor, (gpointer)funcAddr,
	                            hook_CGColorCreateGenericRGB, NULL, NULL);
	gum_interceptor_end_transaction(interceptor);
}

__attribute__((constructor)) static void install(void) {
	@autoreleasepool {
		defaults = [NSUserDefaults standardUserDefaults];
		replace_color_function();
	}
}

// MARK: Swizzle

@interface WVMinimizedAndRecentsItemLayer : CALayer
- (struct CGRect)_frameForHighlight;
//- (CALayer *)_maskLayerForHighlight;
//- (CALayer *)innerImageLayer;
@end

ZKSwizzleInterface(HookWVMinimizedAndRecentsItemLayer,
                   WVMinimizedAndRecentsItemLayer, CALayer)
    @implementation HookWVMinimizedAndRecentsItemLayer

- (struct CGRect)_frameForHighlight {
	CGRect rect = _orig(CGRect);
	return CGRectMake(0, 0, 0, 0);
}

//- (CALayer *)innerImageLayer {
//	CALayer *layer = _orig(CALayer *);
//	NSLog(@"[d]: [WVMinimizedAndRecentsItemLayer innerImageLayer]");
//	return layer;
//}

@end
