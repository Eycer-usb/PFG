package com.pfg.library;

import org.json.simple.JSONObject;
import java.net.*;
import java.io.*;

public class Observer {

    private JSONObject config;
    private Socket socket;
    private BufferedReader input;
    private PrintWriter output;

    public Observer(JSONObject config) {
        this.config = config;
    }

    public boolean connect() {
        System.out.println("Starting Connection");
        String address = (String) config.get("address");
        int port = Integer.parseInt((String) config.get("port"));
        try {
            System.out.println("Starting Socket");
            this.socket = new Socket(address, port);
            System.out.println("Starting Data Input Stream");
            input = new BufferedReader(
                new InputStreamReader(socket.getInputStream()));
            System.out.println("Starting Data Output Stream");
            output = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())), true);
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
        }
        System.out.println("Connection Done");
        return true;
    }

    public String send(String message) {
        try {
            System.out.println("Sending Message " + message);
            output.println(message);
            System.out.println("Waiting Reception Confirmation");
            String response = input.readLine();
            System.out.println("Response: " + response);
            return response;
        } catch (Exception e) {
            System.err.println(e);
        }
        return null;
    }

    public boolean disconnect() {
        String response = this.send("9");
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
