package com.pfg.library;

import org.json.simple.JSONObject;

import junit.framework.TestCase;

public class TestCollector extends TestCase {

    public String configFile = "src/test/resources/config.json";
    public JSONObject config;
    public Collector collector;

    public TestCollector(String name) {
        super(name);
        JSONObject config = Utils.getJsonObjectFromFile(this.configFile);
        this.config = (JSONObject) ((JSONObject) config.get("executor")).get("collector");
        this.collector = new Collector(this.config);
    }

    @SuppressWarnings("unchecked")
    public void testApiConnection(){
        JSONObject directive = new JSONObject();
        directive.put("databaseKey", "testing");
        directive.put("optimizationKey", "testing");
        directive.put("queryKey", "testing");
        directive.put("iteration", "5");
        directive.put("clientPid", "123");
        directive.put("serverPid", "456");
        directive.put("startTime", "789");
        directive.put("endTime", "0000");
        directive.put("executionTime", "11111");
        String id = collector.storeDirective(directive);
        System.out.println("Id Stored In Test: " + id);
        assertNotNull(id);
    }
}
