#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include "Share.h"
#include <hx/CFFI.h>

using namespace openflShareExtension;

#define safe_alloc_string(a) (a!=NULL?alloc_string(a):NULL)

#ifdef BLACKBERRY

static value share_do(value method, value text) {
	doShare(val_string(method), val_string(text));
	return alloc_null();
}
DEFINE_PRIM(share_do, 2);

static value share_query() {
	std::vector<ShareQueryResult> resultCpp = query();
	value resultHaxe = alloc_array(resultCpp.size());
	for (int i=0; i<resultCpp.size(); ++i) {
		value entry = alloc_empty_object();
		alloc_field(entry, val_id("key"), safe_alloc_string(resultCpp.at(i).key));
		alloc_field(entry, val_id("icon"), safe_alloc_string(resultCpp.at(i).icon));
		alloc_field(entry, val_id("label"), safe_alloc_string(resultCpp.at(i).label));
		val_array_set_i(resultHaxe, i, entry);
	}
	return resultHaxe;
}
DEFINE_PRIM(share_query, 0);

#else

static value share_do (value text, value url, value subject, value image) {
	doShare(val_string(text), val_string(url), val_string(subject), val_string(image));
	return alloc_null();
}
DEFINE_PRIM(share_do, 4);

#endif

extern "C" void share_main () {	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (share_main);


extern "C" int openflShareExtension_register_prims () { return 0; }
