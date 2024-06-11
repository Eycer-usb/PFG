package com.pfg.postgres;
import org.json.simple.JSONObject;
import com.pfg.library.Utils;

import junit.framework.TestCase;

public class TestPGDB extends TestCase{

    public String configFile = "src/test/resources/config.json";

    public TestPGDB(String name) {
        super(name);
    }

    public void testGetConnectionPid() throws Exception {
        JSONObject config = Utils.getJsonObjectFromFile(this.configFile);
        PGDB database = new PGDB(config);
        assertNotNull(database.getConnectionPid());
    }

    public void testGetDatabaseKey() throws Exception {
        JSONObject config = Utils.getJsonObjectFromFile(this.configFile);
        PGDB database = new PGDB(config);
        assertEquals( "postgres", database.getDatabaseKey());
    }

    public void testGetOptimizationKey() throws Exception {
        JSONObject config = Utils.getJsonObjectFromFile(this.configFile);
        PGDB database = new PGDB(config);
        assertEquals("--index", database.getOptimizationKey());
    }

    public void testGetQueryKey() throws Exception {
        JSONObject config = Utils.getJsonObjectFromFile(this.configFile);
        PGDB database = new PGDB(config);
        assertEquals("21", database.getQueryKey());
    }

    public void testRunQuery() throws Exception {
        JSONObject config = Utils.getJsonObjectFromFile(this.configFile);
        PGDB database = new PGDB(config);
        database.runQuery();
    }
}