package com.pfg.postgres;

import java.io.FileReader;
import java.io.Reader;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import com.pfg.library.Observer;
import com.pfg.library.Colector;

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
        try{
            Reader reader = new FileReader(configFilePath);
            jsonConfig = (JSONObject) parser.parse(reader);
        }
        catch (Exception e){
            e.printStackTrace();
            System.exit(-1);
        }

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
        colectorConnection = Colector.connectionFromConfig(colectorConfig);
    }

    private static void execute() {
        
    }

    private static void print_help() {
        System.out
                .println("Usage: java -jar target/postgres-executor.1.0-SNAPSHOT.jar <config.json>");
    }
}