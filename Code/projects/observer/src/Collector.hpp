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
            curl_easy_setopt(curl, CURLOPT_URL, endpoint.c_str());    // Pass endpoint as const char*
            curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body.c_str()); // Pass body as const char*
            res = curl_easy_perform(curl);
            if (res != CURLE_OK)
            {
                cerr << "curl_easy_perform() failed: " << curl_easy_strerror(res) << endl; // Output error message to stderr
            }
            curl_slist_free_all(slist1); // Free the allocated memory for the header list
            curl_easy_cleanup(curl);
        }
        curl_global_cleanup();
        return 0;
    }
};

#endif // COLLECTOR_H