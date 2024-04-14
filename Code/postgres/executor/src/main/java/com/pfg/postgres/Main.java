package com.pfg.postgres;

import java.io.FileReader;
import java.io.Reader;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import com.pfg.library.Observer;
import com.pfg.library.Collector;

public class Main {

    static JSONObject jsonConfig;
    static String[] results = {};
    static Observer clientObserver;
    static Observer serverObserver;
    static Collector collector;
    static PGDB pg;

    public static void main(String[] args) throws Exception {

        String configFilePath = "";

        if (args.length < 2) {
            print_help();
            System.exit(-1);
        } else {
            configFilePath = args[1];
            loadConfigs(configFilePath);
            execute();
        }
    }

    private static void loadConfigs(String configFilePath) {
        JSONParser parser = new JSONParser();
        try{
            Reader reader = new FileReader(configFilePath);
            jsonConfig = (JSONObject) parser.parse(reader);
        }
        catch (Exception e){
            e.printStackTrace();
            System.exit(-1);
        }

        setDatabase();
        setClientObserver();
        setServerObserver();
        setCollector();
    }

    private static void setDatabase() {
        JSONObject databaseConfig = (JSONObject) jsonConfig.get("database");
        pg = new PGDB(databaseConfig);
    }

    private static void setClientObserver() {
        JSONObject clientObserverConfig = (JSONObject) jsonConfig.get("clientObserver");
        clientObserver = new Observer(clientObserverConfig);
    }

    private static void setServerObserver() {
        JSONObject serverObserverConfig = (JSONObject) jsonConfig.get("ServerObserver");
        serverObserver = new Observer(serverObserverConfig);
    }

    private static void setCollector() {
        JSONObject collectorConfig = (JSONObject) jsonConfig.get("collector");
        collector = new Collector(collectorConfig);
    }

    private static void execute() {
                
    }

    private static void print_help() {
        System.out
                .println("Usage: java -jar target/postgres-executor.1.0-SNAPSHOT.jar <config.json>");
    }
}