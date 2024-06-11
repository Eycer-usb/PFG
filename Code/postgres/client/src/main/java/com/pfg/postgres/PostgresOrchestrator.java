package com.pfg.postgres;

import com.pfg.library.Orchestrator;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import java.util.ArrayList;
import java.util.HashMap;

public class PostgresOrchestrator implements Orchestrator {

    public JSONObject config;
    private PGDB pgdb;

    PostgresOrchestrator(JSONObject config) {
        this.config = config;
        this.pgdb = new PGDB(config);
    }

    public JSONObject getOptions() {
        JSONParser parser = new JSONParser();
        ArrayList<JSONObject> list = new ArrayList<JSONObject>();
        HashMap<String, ArrayList<JSONObject>> map = new HashMap<String, ArrayList<JSONObject>>();

        try {
            list.add((JSONObject) parser.parse("{\"label\":\"Base\", \"key\": \"base\"}"));
            list.add((JSONObject) parser.parse("{\"label\":\"Indexation\", \"key\": \"index\"}"));
            list.add((JSONObject) parser.parse("{\"label\":\"Compression\", \"key\": \"compression\"}"));
            list.add(
                    (JSONObject) parser.parse("{\"label\":\"Index and Compression\", \"key\": \"index-compression\"}"));
            map.put("options", list);
            return new JSONObject(map);
        } catch (ParseException e) {
            System.out.println("Error parsing options");
            e.printStackTrace();
            return new JSONObject();
        }
    }

    // Set Database configuration
    public boolean selectOption(String option) {
        switch (option) {
            case "base":
                pgdb.setBase();
                return true;
            case "index":
                pgdb.setIndex();
                return true;
            case "compression":
                pgdb.setCompression();
                return true;
            case "index-compression":
                pgdb.setIndexCompression();
                return true;
            default:
                System.out.println("Invalid Option " + option);
                return false;
        }

    }

    // Verify if a given option is a valid option
    public boolean isValidOption(String message) {
        if (message.equals("base") || message.equals("index") ||
                message.equals("compression") || message.equals("index-compression")) {
            return true;
        }
        return false;
    }

    // Run the 30 iteration over the 22 queries in the database configured in the
    // selected option
    @SuppressWarnings("unchecked")
    public int execute() {
        JSONObject databaseConfig = (JSONObject) this.config.get("database");
        JSONObject executorConfig = (JSONObject) this.config.get("executor");
        for (int i = 1; i <= 22; i++) {
            databaseConfig.put("queryKey", String.valueOf(i));
            databaseConfig.put("queryPath", 
                (String) databaseConfig.get("queriesDirectory") + "/" + String.valueOf(i) + ".sql");
            config.put("database", databaseConfig);
            for (int j = 1; j <= 30; j++) {
                executorConfig.put("iteration", String.valueOf(j));
                config.put("executor", executorConfig);
                pgdb.restartService();
                PostgresExecutor executor = new PostgresExecutor();
                executor.run(config);
            }
        }
        return 0;
    }

}
