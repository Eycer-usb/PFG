#if !defined(COLLECTOR_H)
#define COLLECTOR_H

#include <string>
#include <cstring>
#include <iostream>
#include <curl/curl.h>

using namespace std;

class Collector
{
private:
    /* data */
public:
    int storeMetrics(string endpoint, string body)
    {
        CURL *curl;
        CURLcode res;
        curl_global_init(CURL_GLOBAL_ALL);
        curl = curl_easy_init();
        if (curl)
        {
            struct curl_slist *slist1 = NULL;
            slist1 = curl_slist_append(slist1, "Content-Type: application/json");
            curl_easy_setopt(curl, CURLOPT_HTTPHEADER, slist1);
            curl_easy_setopt(curl, CURLOPT_URL, endpoint);
            curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body);
            res = curl_easy_perform(curl);
            if (res != CURLE_OK)
                fprintf(stderr, "curl_easy_perform() failed: %s\n",
                        curl_easy_strerror(res));
            curl_easy_cleanup(curl);
        }
        curl_global_cleanup();
        return 0;
    }
};

#endif // COLLECTOR_H