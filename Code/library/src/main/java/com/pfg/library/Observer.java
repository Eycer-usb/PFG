package com.pfg.library;

import org.json.simple.JSONObject;
import java.net.*;
import java.io.*;

public class Observer {
    private JSONObject config;
    private Socket socket;
    private DataInputStream inputStream;
    private DataOutputStream outputStream;



    public Observer(JSONObject config) {
        this.config = config;
        String address = (String) config.get("address");
        Integer port = (Integer) config.get("port");
        socket = new Socket(address, port);
    }

    public boolean connect() {
         
        return true;
    }
}
