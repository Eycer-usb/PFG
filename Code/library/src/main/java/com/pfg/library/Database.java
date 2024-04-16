package com.pfg.library;

public interface Database {
    String getConnectionPid();
    String getDatabaseKey();
    String getOptimizationKey();
    String getQueryKey();
    void runQuery();
}
