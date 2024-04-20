package com.pfg.library;

import java.io.IOException;
import java.sql.Timestamp;
import org.json.simple.JSONObject;

public class Executor {
    JSONObject jsonConfig;
    Observer clientObserver;
    Observer serverObserver;
    Collector collector;
    Database database = null;

    public Executor(Database database, JSONObject config){
        this.database = database;
        this.jsonConfig = (JSONObject) config.get("executor");
        setClientObserver();
        setServerObserver();
        setCollector();
    } 

    @SuppressWarnings("unchecked")
    public void execute() {
        String clientPid = null;
        String serverPid = null;
        try {
            clientPid = getOwnPid();
            serverPid = this.database.getConnectionPid();
            System.out.println("Client Pid: " + clientPid);
            System.out.println("Server Pid: " + serverPid);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error Getting Process Ids");
            System.exit(-1);
        }


        this.clientObserver.startMonitoring(clientPid);
        this.serverObserver.startMonitoring(serverPid);

        Timestamp startTimestamp = getCurrentTimestamp();
        System.out.println("Timestamp: " + startTimestamp);
        this.database.runQuery();
        Timestamp endTimestamp = getCurrentTimestamp();
        System.out.println("Timestamp: " + endTimestamp);

        System.out.println("Stopping Client Observer");
        this.clientObserver.stopMonitoring();
        System.out.println("Stopping Server Observer");
        this.serverObserver.stopMonitoring();

        JSONObject directive = new JSONObject();
        directive.put("databaseKey", database.getDatabaseKey());
        directive.put("optimizationKey", database.getOptimizationKey());
        directive.put("queryKey", database.getQueryKey());
        directive.put("iteration", (String) this.jsonConfig.get("iteration"));
        directive.put("clientPid", clientPid);
        directive.put("serverPid", serverPid);
        directive.put("startTimestamp", startTimestamp);
        directive.put("endTimestamp", endTimestamp);
        directive.put("executionTime", getDuration(startTimestamp, endTimestamp));

        String registryId = this.collector.storeDirective( directive );
        this.clientObserver.reportMetrics(registryId);
        this.serverObserver.reportMetrics(registryId);
    }

    public static String getOwnPid() throws IOException {
        long pid = ProcessHandle.current().pid();
        return Long.toString(pid);
    }

    protected void setClientObserver() {
        JSONObject clientObserverConfig = (JSONObject) jsonConfig.get("clientObserver");
        clientObserver = new Observer(clientObserverConfig);
        clientObserver.connect();
    }

    protected void setServerObserver() {
        JSONObject serverObserverConfig = (JSONObject) jsonConfig.get("serverObserver");
        serverObserver = new Observer(serverObserverConfig);
        serverObserver.connect();
    }

    protected void setCollector() {
        JSONObject collectorConfig = (JSONObject) jsonConfig.get("collector");
        collector = new Collector(collectorConfig);
    }

    public static Timestamp getCurrentTimestamp() {
        final Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
        return currentTimestamp;
    }

    public static long getDuration(Timestamp startTime, Timestamp endTime) {
        return endTime.getTime() - startTime.getTime();
    }
}
