package com.pfg.mongo;

import com.pfg.library.Executor;
import org.json.simple.JSONObject;

public class MongoExecutor {

    public void run(JSONObject config) {
        MongoDB mongoDatabase = new MongoDB(config);
        mongoDatabase.connect();
        Executor executor = new Executor(mongoDatabase, config);
        executor.execute();
        mongoDatabase.close();
    }
}