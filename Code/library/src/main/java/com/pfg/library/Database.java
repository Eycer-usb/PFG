package com.pfg.library;

public interface Database {
    public String getConnectionPid();
    public String getDatabaseKey();
    public String getOptimizationKey();
    public String getQueryKey();
    public void runQuery();
    public void execute(String query) throws Exception;
    public void executeFile(String filepath) throws Exception;
    public void connect();
    public void close();
    public void restartService();
    public void dropDatabase();
    public void createDatabase();
}
