package com.pfg.library;
import org.json.simple.JSONObject;

public class Colector {
    public static Colector connectionFromConfig( JSONObject config ){
        return new Colector();
    }
}
