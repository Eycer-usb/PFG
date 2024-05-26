package com.pfg.library;

import java.io.IOException;
import java.sql.SQLException;

public interface Database {
    public String getConnectionPid();
    public String getDatabaseKey();
    public String getOptimizationKey();
    public String getQueryKey();
    public void runQuery();
    public void executeFile(String filepath) throws SQLException, IOException;
    public void connect();
    public void restartService();
    public void dropDatabase();
    public void close();
}
