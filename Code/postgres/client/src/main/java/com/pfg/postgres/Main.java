package com.pfg.postgres;

import org.json.simple.JSONObject;
import com.pfg.library.Observer;
import com.pfg.library.Utils;
import com.pfg.library.Collector;
import com.pfg.library.Analyst;

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
            String configFilePath = args[0];
            int port = Integer.valueOf(args[1]);
            JSONObject config = Utils.getJsonObjectFromFile(configFilePath);
            PostgresOrchestrator orchestrator = new PostgresOrchestrator(config);
            Analyst analyst = new Analyst(orchestrator);
            analyst.start(port);
        }
    }

    private static void print_help() {
        System.out
                .println("Usage: java -jar target/postgres-orchestrator.1.0-SNAPSHOT.jar <config.json> <port>");
    }
}