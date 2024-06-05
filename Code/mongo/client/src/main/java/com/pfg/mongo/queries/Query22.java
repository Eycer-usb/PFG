package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query22 extends Query {
    public Query22(String[] args) {
        super(args);
    }

    @Override
    public void run(MongoDatabase database) {
        // Obtener la colección customer
        MongoCollection<Document> customerCollection = database.getCollection("customer");

        // Paso 1: Calcular el promedio de c_acctbal
        AggregateIterable<Document> avgResult = customerCollection.aggregate(Arrays.asList(
                new Document("$match", new Document("c_acctbal", new Document("$gt", 0.00))
                        .append("c_phone", new Document("$regex", "^(41|25|23|40|24|35|43)"))),
                new Document("$group",
                        new Document("_id", null).append("avg_acctbal", new Document("$avg", "$c_acctbal")))));

        double avgAcctBal = 0.0;
        for (Document doc : avgResult) {
            avgAcctBal = doc.getDouble("avg_acctbal");
        }

        // Paso 2: Obtener los clientes con c_acctbal mayor que el promedio y sin
        // órdenes
        AggregateIterable<Document> result = customerCollection.aggregate(Arrays.asList(
                new Document("$match", new Document("c_acctbal", new Document("$gt", avgAcctBal))
                        .append("c_phone", new Document("$regex", "^(41|25|23|40|24|35|43)"))),
                new Document("$lookup", new Document("from", "orders")
                        .append("localField", "c_custkey")
                        .append("foreignField", "o_custkey")
                        .append("as", "orderDetails")),
                new Document("$match", new Document("orderDetails", new Document("$eq", Arrays.asList()))),
                new Document("$project",
                        new Document("cntrycode", new Document("$substr", Arrays.asList("$c_phone", 0, 2)))
                                .append("c_acctbal", 1)),
                new Document("$group", new Document("_id", "$cntrycode")
                        .append("numcust", new Document("$sum", 1))
                        .append("totacctbal", new Document("$sum", "$c_acctbal"))),
                new Document("$sort", new Document("_id", 1)),
                new Document("$limit", 1)));

        // Procesar los resultados
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }

    }
}
