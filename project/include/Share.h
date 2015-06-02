#ifndef OPENFLSHARE_H
#define OPENFLSHARE_H

#ifdef BLACKBERRY
#include <vector>
#endif

namespace openflShareExtension {

		#ifdef BLACKBERRY

		typedef struct {
			char key[256];
			char icon[256];
			char label[256];
		} ShareQueryResult;

		std::vector<ShareQueryResult> query();

		void doShare(const char *method, const char *text);

		#else

		void doShare(const char *text, const char *url, const char *subject);

		#endif

}

#endif
