package com.pfg.mongo.queries;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.AggregateIterable;
import org.bson.Document;

import java.util.Arrays;
import java.util.Date;


public class Query12 extends Query {
        public Query12(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                 // Get the collection lineitem
        MongoCollection<Document> lineitemCollection = database.getCollection("lineitem");

        // Create the aggregation query
        AggregateIterable<Document> result = lineitemCollection.aggregate(Arrays.asList(
            new Document("$lookup", new Document("from", "orders")
                .append("localField", "l_orderkey")
                .append("foreignField", "o_orderkey")
                .append("as", "orderDetails")),
            new Document("$unwind", "$orderDetails"),
            new Document("$match", new Document("l_shipmode", new Document("$in", Arrays.asList("REG AIR", "FOB")))
                .append("l_commitdate", new Document("$lt", "$l_receiptdate"))
                .append("l_shipdate", new Document("$lt", "$l_commitdate"))
                .append("l_receiptdate", new Document("$gte", new Date(96, 0, 1)).append("$lt", new Date(97, 0, 1)))),
            new Document("$group", new Document("_id", "$l_shipmode")
                .append("high_line_count", new Document("$sum", new Document("$cond", Arrays.asList(
                    new Document("$or", Arrays.asList(
                        new Document("$eq", Arrays.asList("$orderDetails.o_orderpriority", "1-URGENT")),
                        new Document("$eq", Arrays.asList("$orderDetails.o_orderpriority", "2-HIGH"))
                    )),
                    1,
                    0
                ))))
                .append("low_line_count", new Document("$sum", new Document("$cond", Arrays.asList(
                    new Document("$and", Arrays.asList(
                        new Document("$ne", Arrays.asList("$orderDetails.o_orderpriority", "1-URGENT")),
                        new Document("$ne", Arrays.asList("$orderDetails.o_orderpriority", "2-HIGH"))
                    )),
                    1,
                    0
                ))))),
            new Document("$sort", new Document("_id", 1)),
            new Document("$project", new Document("_id", 0)
                .append("l_shipmode", "$_id")
                .append("high_line_count", 1)
                .append("low_line_count", 1))
        ));

        // Process the results
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }
        }
}
