#include <Share.h>

#include <bps/event.h>
#include <bps/navigator.h>
#include <bps/navigator_invoke.h>
#include <screen/screen.h>
#include <string.h>
#include <string>
#include <unistd.h>
#include <vector>

using namespace std;

namespace openflShareExtension {

	void log(const char *msg) {
		FILE *logFile = fopen("logs/log.txt", "a");
		fprintf(logFile, "%s\n", msg);
		fclose(logFile);
	}

	void doShare(const char *method, const char *text) {

		navigator_invoke_invocation_t *invoke = NULL;
		navigator_invoke_invocation_create(&invoke);

		navigator_invoke_invocation_set_action(invoke, "bb.action.SHARE");
		navigator_invoke_invocation_set_data(invoke, text, strlen(text));
		navigator_invoke_invocation_set_target(invoke, method);
		navigator_invoke_invocation_set_type(invoke, "text/plain");

		navigator_invoke_invocation_send(invoke);
		navigator_invoke_invocation_destroy(invoke);

	}

	vector<ShareQueryResult> query() {

		FILE *logFile = fopen("logs/log.txt", "w");
		fclose(logFile);
		char msg[64];

		snprintf(msg, 64, "pid %d\n", getpid());
		log(msg);

		vector<ShareQueryResult> results;

		navigator_invoke_query_t *query = NULL;
		navigator_invoke_query_create(&query);

		navigator_invoke_query_set_id(query, "12345");
		navigator_invoke_query_set_action(query, "bb.action.SHARE");
		navigator_invoke_query_set_type(query, "text/plain");

		if (navigator_invoke_query_send(query)!=BPS_SUCCESS) {
			log("navigator_invoke_query_send Failed");
		}

		bps_event_t *event = NULL;

		do {

			bps_get_event(&event, -1);
			snprintf(msg, 64, "query result %#04x\n", bps_event_get_code(event));
			log(msg);

		} while (

			navigator_get_domain()!=bps_event_get_domain(event) ||
			bps_event_get_code(event)!=NAVIGATOR_INVOKE_QUERY_RESULT

		);

		// create integer holding the number of actions returned by the query
		int action_count =
			navigator_invoke_event_get_query_result_action_count(event);

		// loop listing all actions returned by the query
		for (int i=0; i<action_count; i++) {

			const navigator_invoke_query_result_action_t *action =
				navigator_invoke_event_get_query_result_action(event, i);

			// retrieve action attributes
			const char *name =
				navigator_invoke_query_result_action_get_name(action);
			const char *icon =
				navigator_invoke_query_result_action_get_icon(action);
			const char *label =
				navigator_invoke_query_result_action_get_label(action);

			// create integer holding the number of targets in the action
			int target_count =
				navigator_invoke_query_result_action_get_target_count(action);

			// loop listing all targets in the action
			for (int j=0; j < target_count; j++) {

				const navigator_invoke_query_result_target_t *target =
					navigator_invoke_query_result_action_get_target(action, j);

				if (target==NULL) {
					log("target is null!");
				}

				// retrieve target attributes
				ShareQueryResult result;

				const char *key =
					navigator_invoke_query_result_target_get_key(target);
				const char *icon =
					navigator_invoke_query_result_target_get_icon(target);
				const char *label =
					navigator_invoke_query_result_target_get_label(target);

				strcpy(result.key, key);
				strcpy(result.icon, icon);	
				strcpy(result.label, label);

				results.push_back(result);

			}

		}

		navigator_invoke_query_destroy(query);

		return results;

	}

}
