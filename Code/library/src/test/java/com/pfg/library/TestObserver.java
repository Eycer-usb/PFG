package com.pfg.library;
import org.json.simple.JSONObject;
import junit.framework.TestCase;


public class TestObserver extends TestCase {

    public JSONObject config;
    public Observer obs;

    public TestObserver(String name){
        super(name);
        JSONObject executorConfig = (JSONObject) Utils.
        getJsonObjectFromFile("src/test/resources/config.json")
        .get("executor");
        this.config = (JSONObject) executorConfig.get("clientObserver");
        this.obs = new Observer(config);
    }


    public void testConfigSettings(){
        assertNotNull(this.obs);
        assertNotNull(this.obs.getConfig());
    }

    public void testMessages(){
        this.obs.connect();
        this.obs.startMonitoring("3");
        this.obs.stopMonitoring();
        this.obs.reportMetrics("5");
        this.obs.disconnect();
    }
}
