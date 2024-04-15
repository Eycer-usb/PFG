package com.pfg.library;

import org.json.simple.JSONObject;

public class Main {
    public static void main(String[] args) {
        System.out.println("=================== INFO ===================");
        System.out.println("This is the library for Executors Communication");
        System.out.println("Provides the Observer and the Collector Class");

        JSONObject config = new JSONObject();
        config.put("address", "192.168.2.102");
        config.put("port", "43316");
        Observer observer = new Observer(config);
        observer.connect();
        observer.send("1");
        observer.send("1Hola");
        observer.send("2");
        observer.send("2Epale");
        observer.disconnect();
    }

}