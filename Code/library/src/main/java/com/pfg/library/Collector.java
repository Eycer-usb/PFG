package com.pfg.library;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;


import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class Collector {

    JSONObject config;
    String endpoint;
    HttpClient client;

    public Collector(JSONObject config) {
        this.config = config;
        this.endpoint = (String) config.get("endpoint");
        client = HttpClient.newBuilder().build();
    }

    String storeDirective(JSONObject directive) {
        try {
            String body = directive.toJSONString();
            System.out.println(body);
            var client = HttpClient.newHttpClient();
            var request = HttpRequest.newBuilder()
                .uri(URI.create(this.endpoint))
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .header("Content-Type", "application/json")
                .build();
            HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
            JSONParser jsonParser = new JSONParser();
            JSONObject json = (JSONObject) jsonParser.parse(response.body());
            Long id = (Long) json.get("id");
            return Long.toString(id);

        } catch (Exception e) {
            System.err.println(e);
        }
        return "";
    }
}
