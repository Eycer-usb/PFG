package com.pfg.library;

import org.json.simple.JSONObject;
import java.net.*;
import java.io.*;

public class Observer {

    private JSONObject config;
    private Socket socket;
    private DataInputStream input;
    private DataOutputStream output;

    public Observer(JSONObject config) {
        this.config = config;
        try {
            input = new DataInputStream(new BufferedInputStream(socket.getInputStream()));
            output = new DataOutputStream(socket.getOutputStream());
        } catch (Exception e) {
            System.err.println(e);
            System.exit(-1);
        }
    }

    public boolean connect() {
        String address = (String) config.get("address");
        int port = (int) config.get("port");
        try {
            this.socket = new Socket(address, port);
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
        }
        return true;
    }

    public String send(String message) {
        try {
            output.writeUTF(message);
            String response = input.readUTF();
            return response;
        } catch (Exception e) {
            System.err.println(e);
        }
        return null;
    }

    public boolean disconnect() {
        String response = this.send("-1");
        if (response == "0") {
            try {
                socket.close();
                input.close();
                output.close();
                return true;
            } catch (Exception e) {
                System.err.println(e);
            }
        }
        return false;
    }
}
