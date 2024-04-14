package com.pfg.postgres;

import java.io.FileReader;
import java.io.Reader;
import java.sql.Timestamp;
import java.util.Arrays;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Main {

    static JSONObject jsonConfig;
    static String[] results = {};
    static Observer clientObserverConnection;
    static Observer serverObserverConnection;
    static Colector colectorConnection;
    static PGDB pgConnection;

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
        Reader reader = new FileReader(configFilePath);
        jsonConfig = (JSONObject) parser.parse(reader);

        setDatabaseConnection();
        setClientObserverConnection();
        setServerObserverConnection();
        setColectorConnection();
    }

    private static void setDatabaseConnection() {
        JSONObject databaseConfig = (JSONObject) jsonConfig.get("database");
        pgConnection = PGDB.connectionFromConfig(databaseConfig);
    }

    private static void setClientObserverConnection() {
        JSONObject clientObserverConfig = (JSONObject) jsonConfig.get("clientObserver");
        clientObserverConnection = Observer.connectionFromConfig(clientObserverConfig);
    }

    private static void setServerObserverConnection() {
        JSONObject serverObserverConfig = (JSONObject) jsonConfig.get("ServerObserver");
        serverObserverConnection = Observer.connectionFromConfig(serverObserverConfig);
    }

    private static void setColectorConnection() {
        JSONObject colectorConfig = (JSONObject) jsonConfig.get("collector");
        colectorConnection = Observer.connectionFromConfig(colectorConfig);
    }

    private static void execute() {
        // Execute Query and send Reports
    }

    private static void print_help() {
        System.out
                .println("Usage: java -jar target/postgres-executor.1.0-SNAPSHOT.jar <config.json>");
    }
}