#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Share.h"

using namespace openflShareExtension;


static value share_do(value text, value url){
	doShare(val_string(text), val_string(url));
	return alloc_null();
}
DEFINE_PRIM(share_do,2);


extern "C" void share_main () {	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (share_main);


extern "C" int openflShareExtension_register_prims () { return 0; }
