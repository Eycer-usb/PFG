package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query21 extends Query {
    public Query21(String[] args) {
        super(args);
    }

    @Override
    public void run(MongoDatabase database) {
        // Obtener la colección lineitem
        MongoCollection<Document> collection = database.getCollection("lineitem");

        // Crear la consulta de agregación
        AggregateIterable<Document> result = collection.aggregate(Arrays.asList(
                new Document("$match", new Document("l_receiptdate", new Document("$gt", "$l_commitdate"))),
                new Document("$lookup", new Document("from", "orders")
                        .append("localField", "l_orderkey")
                        .append("foreignField", "o_orderkey")
                        .append("as", "orderDetails")),
                new Document("$unwind", "$orderDetails"),
                new Document("$match", new Document("orderDetails.o_orderstatus", "F")),
                new Document("$lookup", new Document("from", "supplier")
                        .append("localField", "l_suppkey")
                        .append("foreignField", "s_suppkey")
                        .append("as", "supplierDetails")),
                new Document("$unwind", "$supplierDetails"),
                new Document("$lookup", new Document("from", "nation")
                        .append("localField", "supplierDetails.s_nationkey")
                        .append("foreignField", "n_nationkey")
                        .append("as", "nationDetails")),
                new Document("$unwind", "$nationDetails"),
                new Document("$match", new Document("nationDetails.n_name", "PERU")),
                new Document("$lookup", new Document("from", "lineitem")
                        .append("let", new Document("orderkey", "$l_orderkey").append("suppkey", "$l_suppkey"))
                        .append("pipeline", Arrays.asList(
                                new Document("$match", new Document("$expr", new Document("$and", Arrays.asList(
                                        new Document("$eq", Arrays.asList("$l_orderkey", "$$orderkey")),
                                        new Document("$ne", Arrays.asList("$l_suppkey", "$$suppkey"))))))))
                        .append("as", "otherSuppliers")),
                new Document("$match", new Document("otherSuppliers", new Document("$ne", Arrays.asList()))),
                new Document("$lookup", new Document("from", "lineitem")
                        .append("let", new Document("orderkey", "$l_orderkey").append("suppkey", "$l_suppkey"))
                        .append("pipeline", Arrays.asList(
                                new Document("$match", new Document("$expr", new Document("$and", Arrays.asList(
                                        new Document("$eq", Arrays.asList("$l_orderkey", "$$orderkey")),
                                        new Document("$ne", Arrays.asList("$l_suppkey", "$$suppkey")),
                                        new Document("$gt", Arrays.asList("$l_receiptdate", "$l_commitdate"))))))))
                        .append("as", "lateSuppliers")),
                new Document("$match", new Document("lateSuppliers", new Document("$eq", Arrays.asList()))),
                new Document("$group",
                        new Document("_id", "$supplierDetails.s_name").append("numwait", new Document("$sum", 1))),
                new Document("$sort", new Document("numwait", -1).append("_id", 1)),
                new Document("$limit", 100)));

        // Procesar los resultados
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }

    }
}
