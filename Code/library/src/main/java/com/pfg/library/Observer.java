package com.pfg.library;

import org.json.simple.JSONObject;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.io.*;

public class Observer {

    private JSONObject config;
    private Socket socket;
    private BufferedReader input;
    private PrintWriter output;

    public Observer(JSONObject config) {
        this.config = config;
    }

    public JSONObject getConfig() {
        return this.config;
    }

    public boolean connect() {
        String address = (String) config.get("address");
        int port = Integer.parseInt((String) config.get("port"));
        System.out.println("Connecting " + address + ":" + port);
        try {
            this.socket = new Socket(address, port);
            input = new BufferedReader(
                new InputStreamReader(socket.getInputStream()));
            output = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())), true);
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
        }
        System.out.println("Connected");
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
        System.out.println("Disconnecting...");
        String response = this.send("9");
        if (response.equals("0")) {
            try {
                socket.close();
                input.close();
                output.close();
                System.out.println("Disconnected");
                return true;

            } catch (Exception e) {
                System.err.println(e);
            }
        }
        return false;
    }

    void startMonitoring(String processPid){
        System.out.println("Sending Start Monitor Order for Pid: " + processPid);
        String response = this.send("1" + processPid);
        this.checkCorrectResponse(response);
    }

    void stopMonitoring(){
        System.out.println("Sending Stop Monitor Order");
        String response = this.send("2");
        this.checkCorrectResponse(response);
    }

    void reportMetrics(String registryId) {
        System.out.println("Sending Report Metrics Order");
        String response = this.send("3" + registryId);
        this.checkCorrectResponse(response);
    }

    private void checkCorrectResponse(String response) {
        if (!response.equals("0")) {
            System.out.print("Failed");
            System.exit(-1);
        }
    }
}
