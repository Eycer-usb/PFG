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

    public Executor(Database database, JSONObject config) {
        this.database = database;
        this.jsonConfig = (JSONObject) config.get("executor");
        setClientObserver();
        setServerObserver();
        setCollector();
    }

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

        this.startObservers(clientPid, serverPid);
        Timestamp startTimestamp = getCurrentTimestamp();
        System.out.println("Timestamp: " + startTimestamp);
        this.database.runQuery();
        Timestamp endTimestamp = getCurrentTimestamp();
        System.out.println("Timestamp: " + endTimestamp);
        this.stopObservers();

        String registryId = this.storeDirective(clientPid, serverPid, startTimestamp, endTimestamp);

        this.reportMetrics(registryId);
        
        this.disconnectObservers();

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

    protected void startObservers(String clientPid, String serverPid) {
        Thread clientThread;
        try {
            clientThread = new Thread(
                new RunnableMethodFromObject<Observer, String>(
                        this.clientObserver,
                        "startMonitoring",
                        clientPid));
            clientThread.start();
            this.serverObserver.startMonitoring(serverPid);
            clientThread.join();
        } catch (Exception e) {
            System.out.println("Error Starting Monitors");
            e.printStackTrace();
        }
    }

    protected void stopObservers() {
        Thread clientThread;
        try {
            clientThread = new Thread(
                    new RunnableMethodFromObject<Observer, Object>(
                            this.clientObserver,
                            "stopMonitoring",
                            null));
            System.out.println("Stopping Client Observer");
            clientThread.start();
            System.out.println("Stopping Server Observer");
            this.serverObserver.stopMonitoring();
            clientThread.join();

        } catch (Exception e) {
            System.out.println("Error Stopping Monitors");
            e.printStackTrace();
        }
    }

    protected void reportMetrics(String registryId) {
        Thread clientThread;
        try {
            clientThread = new Thread(
                    new RunnableMethodFromObject<Observer, String>(
                            this.clientObserver,
                            "reportMetrics",
                            registryId));
            clientThread.start();
            this.serverObserver.reportMetrics(registryId);
            clientThread.join();
        } catch (Exception e) {
            System.out.println("Error Reporting in Monitors");
            e.printStackTrace();
        }
    }

    protected void disconnectObservers(){
        Thread clientThread;
        try {
            clientThread = new Thread(
                    new RunnableMethodFromObject<Observer, Object>(
                            this.clientObserver,
                            "disconnect",
                            null));
            clientThread.start();
            this.serverObserver.disconnect();
            clientThread.join();
        } catch (Exception e) {
            System.out.println("Error Disconnecting Monitors");
            e.printStackTrace();
        }
    }

    @SuppressWarnings("unchecked")
    protected String storeDirective(String clientPid, String serverPid, Timestamp startTimestamp, Timestamp endTimestamp){
        System.out.println("Storing Directive");
        JSONObject directive = new JSONObject();
        directive.put("databaseKey", database.getDatabaseKey());
        directive.put("optimizationKey", database.getOptimizationKey());
        directive.put("queryKey", database.getQueryKey());
        directive.put("iteration", (String) this.jsonConfig.get("iteration"));
        directive.put("clientPid", clientPid);
        directive.put("serverPid", serverPid);
        directive.put("startTime", Long.toString(startTimestamp.getTime()));
        directive.put("endTime", Long.toString(endTimestamp.getTime()));
        directive.put("executionTime", Long.toString(getDuration(startTimestamp, endTimestamp)));

        String registryId = this.collector.storeDirective(directive);
        return registryId;
    }


    public static Timestamp getCurrentTimestamp() {
        final Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
        return currentTimestamp;
    }

    public static long getDuration(Timestamp startTime, Timestamp endTime) {
        return endTime.getTime() - startTime.getTime();
    }
}
