package com.pfg.library;
import java.sql.Timestamp;

import org.json.simple.JSONObject;
import junit.framework.TestCase;

public class TestExecutor extends TestCase{

    public String configFile = "src/test/resources/config.json";

    public TestExecutor(String name) {
        super(name);
    }

    public void testGetOwnPid() {
        try {
            String pid = Executor.getOwnPid();
            System.out.println("Own Pid: " + pid);
            assertNotNull(pid);
        } catch (Exception e) {
            System.err.println(e);
        }
    }

    public void testGetCurrentTimestamp() {
        Timestamp time = Executor.getCurrentTimestamp();
        assertNotNull(time);
    }

    public void testGetDuration() {
        Timestamp start = new Timestamp(0);
        Timestamp end = new Timestamp(100);
        assertEquals(100, Executor.getDuration(start, end));
    }
}
