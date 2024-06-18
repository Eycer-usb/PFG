package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query13 extends Query {
        public Query13(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Obtener la colección customer
        MongoCollection<Document> customerCollection = database.getCollection("customer");

        // Crear la consulta de agregación
        AggregateIterable<Document> result = customerCollection.aggregate(Arrays.asList(
            new Document("$lookup", new Document("from", "orders")
                .append("localField", "c_custkey")
                .append("foreignField", "o_custkey")
                .append("as", "orders")),
            new Document("$addFields", new Document("orders", new Document("$filter", new Document("input", "$orders")
                .append("as", "order")
                .append("cond", new Document("$not", new Document("$regexMatch", new Document("input", "$$order.o_comment")
                    .append("regex", "pending.*accounts")
                    .append("options", "i"))))))),
            new Document("$project", new Document("c_custkey", 1)
                .append("c_count", new Document("$size", "$orders"))),
            new Document("$group", new Document("_id", "$c_count")
                .append("custdist", new Document("$sum", 1))),
            new Document("$project", new Document("_id", 0)
                .append("c_count", "$_id")
                .append("custdist", "$custdist")),
            new Document("$sort", new Document("custdist", -1)
                .append("c_count", -1))
        ));

        // Procesar los resultados
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }

        }
}
