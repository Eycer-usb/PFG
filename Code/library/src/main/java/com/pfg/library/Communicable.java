package com.pfg.library;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

import org.json.simple.JSONObject;

public abstract class Communicable {

    private JSONObject config;
    private ServerSocket serverSocket;
    private Socket clientSocket;
    private BufferedReader input;
    private PrintWriter output;

    Communicable(JSONObject config) {
        this.config = config;
    }

    public JSONObject getConfig() {
        return this.config;
    }

    // Running as a Client

    public boolean connect() {
        String address = (String) config.get("address");
        int port = Integer.parseInt((String) config.get("port"));
        System.out.println("Connecting " + address + ":" + port);
        try {
            this.clientSocket = new Socket(address, port);
            input = new BufferedReader(
                    new InputStreamReader(clientSocket.getInputStream()));
            output = new PrintWriter(new BufferedWriter(new OutputStreamWriter(clientSocket.getOutputStream())), true);
        } catch (Exception e) {
            System.out.println("Error connecting to observer, is " + address + ":" + port + " listening?");
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
            String response = null;
            while ( response == null) {
                response = input.readLine();
            }
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
                clientSocket.close();
                input.close();
                output.close();
                if (serverSocket != null) {
                    serverSocket.close();
                }
                System.out.println("Disconnected");
                return true;

            } catch (Exception e) {
                System.err.println(e);
            }
        }
        return false;
    }

    private boolean disconnect_server() {
        System.out.println("Disconnect order received...");
        sendReceivedConfirmation();
        try {
            clientSocket.close();
            input.close();
            output.close();
            serverSocket.close();
            System.out.println("Disconnected");
            return true;

        } catch (Exception e) {
            System.err.println(e);
        }
        return false;
    }

    // Running as a Server
    public void listen(int port) throws IOException{
        serverSocket = new ServerSocket(port);
        clientSocket = serverSocket.accept();
        input = new BufferedReader(
                    new InputStreamReader(clientSocket.getInputStream()));
        output = new PrintWriter(new BufferedWriter(new OutputStreamWriter(clientSocket.getOutputStream())), true);
        System.out.println("Connection Received");
    }

    public void talk() throws IOException{
        System.out.println("Starting talk");
        String inputLine;
        while ((inputLine = input.readLine()) != null) {
            if("9".equals(inputLine)){
                disconnect_server();
                break;
            }
            manageMessage(inputLine);
        }
    }

    protected void sendReceivedConfirmation(){
        System.out.println("Sending reception confirmation");
        output.println("0");
    }

    protected void manageMessage(String message){
        System.out.println("Option received:" + message);
    }
}
