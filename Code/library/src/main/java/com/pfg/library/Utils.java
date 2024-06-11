package com.pfg.library;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.Reader;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class Utils {
    public static JSONObject getJsonObjectFromFile(String configFilePath) {
        JSONParser parser = new JSONParser();
        try {
            Reader reader = new FileReader(configFilePath);
            return (JSONObject) parser.parse(reader);
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
        }
        return null;
    }

    public static String getFileContent(String filepath) {

        StringBuilder content = new StringBuilder();
        try (FileReader reader = new FileReader(filepath); // Replace with your file path
                BufferedReader br = new BufferedReader(reader)) {
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line).append("\n"); // Add newline after each line
            }

        } catch (Exception e) {
            System.err.println(e);
            System.exit(-1);
        }
        return content.toString();

    }
}
