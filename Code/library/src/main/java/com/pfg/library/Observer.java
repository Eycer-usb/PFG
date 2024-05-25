package com.pfg.library;

import org.json.simple.JSONObject;

public class Observer extends Communicable{

    public Observer(JSONObject config) {
        super(config);
    }

    public void startMonitoring(String processPid){
        System.out.println("Sending Start Monitor Order for Pid: " + processPid);
        String response = this.send("1" + processPid);
        this.checkCorrectResponse(response);
    }

    public void stopMonitoring(){
        System.out.println("Sending Stop Monitor Order");
        String response = this.send("2");
        this.checkCorrectResponse(response);
    }

    public void reportMetrics(String registryId) {
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
