package com.pfg.library;
import org.json.simple.JSONObject;

public class Observer {
    public static Observer connectionFromConfig( JSONObject config ){
        return new Observer();
    }
}
