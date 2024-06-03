package com.pfg.mongo;

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
    static MongoDB mongo;

    public static void main(String[] args) throws Exception {

        if (args.length < 2) {
            print_help();
            System.exit(-1);
        } else {
            String configFilePath = args[0];
            int port = Integer.parseInt(args[1]);
            JSONObject config = Utils.getJsonObjectFromFile(configFilePath);
            MongoOrchestrator orchestrator = new MongoOrchestrator(config);
            Analyst analyst = new Analyst(orchestrator);
            analyst.start(port);
        }
    }

    private static void print_help() {
        System.out
                .println("Usage: java -jar target/mongo-orchestrator.1.0-SNAPSHOT.jar <config.json> <port>");
    }
}