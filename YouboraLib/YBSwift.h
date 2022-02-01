// This is to be able to import Swift's generated interface header in different circumstances:
// - as `<Module/Module-Swift.h>`, when the library is built as a dynamic framework;
// - as `"Module-Swift.h"`, when it's built as a static library (for example, when it is used via Cocoapods
//   without `use_frameworks!` in the Podfile).
#if __has_include("YouboraLib-Swift.h")
	#import "YouboraLib-Swift.h"
#else
	#import "YouboraLib/YouboraLib-Swift.h"
#endif
