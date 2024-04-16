package com.pfg.postgres;

import org.json.simple.JSONObject;
import com.pfg.library.Observer;
import com.pfg.library.Utils;
import com.pfg.library.Collector;
import com.pfg.library.Executor;

public class Main {

    static JSONObject jsonConfig;
    static String[] results = {};
    static Observer clientObserver;
    static Observer serverObserver;
    static Collector collector;
    static PGDB pg;

    public static void main(String[] args) throws Exception {

        if (args.length < 2) {
            print_help();
            System.exit(-1);
        } else {
            String configFilePath = args[1];
            JSONObject config = Utils.getJsonObjectFromFile(configFilePath);
            PGDB postgresDatabase = new PGDB(config);
            Executor executor = new Executor(postgresDatabase, config);
            executor.execute();
            postgresDatabase.close();
        }
    }

    private static void print_help() {
        System.out
                .println("Usage: java -jar target/postgres-executor.1.0-SNAPSHOT.jar <config.json>");
    }
}