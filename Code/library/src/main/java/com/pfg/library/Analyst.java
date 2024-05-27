package com.pfg.library;

import java.io.IOException;

import org.json.simple.JSONObject;

public class Analyst extends Communicable {

    private Orchestrator orchestrator;
    private JSONObject options;

    public Analyst(Orchestrator orchestrator) {
        super(new JSONObject()); // Config is empty in Communicable Server Mode
        this.orchestrator = orchestrator;
        this.options = orchestrator.getOptions();
    }

    public void start(int port) {
        try {
            listen(port);
            this.sendOptions();
            this.talk();
        } catch (IOException e) {
            System.out.println("Error Starting Analyst, is the port " + port + " available?");
            e.printStackTrace();
        }
    }

    private void sendOptions() {
        String options = this.options.toJSONString();
        send(options);
    }

    @Override
    protected void manageMessage(String message){
        if (this.orchestrator.isValidOption(message)) {
            send("0");
            this.orchestrator.selectOption(message);
            send(String.valueOf(this.orchestrator.execute()));
        }
        else {
            System.out.println("Error applying option " + message);
        }
        
    }

}