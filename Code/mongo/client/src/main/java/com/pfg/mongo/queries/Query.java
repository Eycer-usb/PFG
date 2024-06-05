package com.pfg.mongo.queries;

import com.mongodb.client.MongoDatabase;

public abstract class Query {
    protected String[] args;

    protected Query(String[] args) {
        this.args = args;
    }

    public void run(MongoDatabase db) {
        System.out.println("Running query");
    }
}
