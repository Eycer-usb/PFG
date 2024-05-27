package com.pfg.postgres;

import com.pfg.library.Executor;
import org.json.simple.JSONObject;

public class PostgresExecutor {

    public void run(JSONObject config) {
        PGDB postgresDatabase = new PGDB(config);
        postgresDatabase.connect();
        Executor executor = new Executor(postgresDatabase, config);
        executor.execute();
        postgresDatabase.close();
    }
}