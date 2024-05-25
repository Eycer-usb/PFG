package com.pfg.postgres;

import org.json.simple.JSONObject;
import com.pfg.library.Executor;

public class PostgresExecutor {

    public void run(JSONObject config) throws Exception{
        PGDB postgresDatabase = new PGDB(config);
        Executor executor = new Executor(postgresDatabase, config);
        executor.execute();
        postgresDatabase.close();
    }
}