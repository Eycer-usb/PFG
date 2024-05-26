package com.pfg.postgres;

import com.pfg.library.Executor;

public class PostgresExecutor {

    public void run(JSONObject config) throws Exception{
        PGDB postgresDatabase = new PGDB(config);
        postgresDatabase.connect();
        Executor executor = new Executor(postgresDatabase, config);
        executor.execute();
        postgresDatabase.close();
    }
}