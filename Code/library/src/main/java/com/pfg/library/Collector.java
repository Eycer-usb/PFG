package com.pfg.library;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.http.HttpClient;

import javax.net.ssl.HttpsURLConnection;

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
            String response = "";
            String body = directive.toJSONString();
            URL url = new URL(this.endpoint);
            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json");

            DataOutputStream dos = new DataOutputStream(conn.getOutputStream());
            dos.writeBytes(body);

            BufferedReader bf = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = bf.readLine()) != null) {
                response = response + line;
            }
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(response);
            return (String) json.get("id");
        } catch (Exception e) {
            System.err.println(e);
        }
        return "";
    }
}
