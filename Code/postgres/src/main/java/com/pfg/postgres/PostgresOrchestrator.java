package com.pfg.postgres;

import com.pfg.library.Orchestrator;
import com.pfg.library.Utils;

import netscape.javascript.JSObject;

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

public class PostgresOrchestrator implements Orchestrator {

    public JSONObject config;
    private PGDB pgdb;

    PostgresOrchestrator(JSONObject config){
        this.config = config;
        this.pgdb = new PGDB(config);
    }

    public JSONObject getOptions() {
        JSONArray options;
        options.add(new JSONObject("{\"label\":\"Base\", \"key\": \"base\"}"));
        options.add(new JSONObject("{\"label\":\"Indexation\", \"key\": \"index\"}"));
        options.add(new JSONObject("{\"label\":\"Compression\", \"key\": \"compression\"}"));
        options.add(new JSONObject("{\"label\":\"Index and Compression\", \"key\": \"index-compression\"}"));
        return options;
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


    // Run the 30 iteration over the 22 queries in the database configured in the selected option
    private int execute(){
        JSONObject databaseConfig =  (JSONObject) this.config.get("database");
        JSObject executorConfig = (JSONObject) this.config.get("executor");
        for (int i = 1; i <= 22; i++) {
            databaseConfig.put("queryKey", String.valueOf(i));
            databaseConfig.put("queryPath", "src/main/resources/queries/" + String.valueOf(i) + ".sql");
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
