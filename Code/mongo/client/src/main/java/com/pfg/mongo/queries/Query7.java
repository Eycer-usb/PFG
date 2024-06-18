package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.util.Date;

public class Query7 extends Query {
        public Query7(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Obtener la colección lineitem
        MongoCollection<Document> lineitemCollection = database.getCollection("lineitem");

        // Crear la consulta de agregación
        AggregateIterable<Document> result = lineitemCollection.aggregate(Arrays.asList(
            new Document("$lookup", new Document("from", "supplier")
                .append("localField", "l_suppkey")
                .append("foreignField", "s_suppkey")
                .append("as", "supplierDetails")),
            new Document("$unwind", "$supplierDetails"),
            new Document("$lookup", new Document("from", "orders")
                .append("localField", "l_orderkey")
                .append("foreignField", "o_orderkey")
                .append("as", "orderDetails")),
            new Document("$unwind", "$orderDetails"),
            new Document("$lookup", new Document("from", "customer")
                .append("localField", "orderDetails.o_custkey")
                .append("foreignField", "c_custkey")
                .append("as", "customerDetails")),
            new Document("$unwind", "$customerDetails"),
            new Document("$lookup", new Document("from", "nation")
                .append("localField", "supplierDetails.s_nationkey")
                .append("foreignField", "n_nationkey")
                .append("as", "supplierNationDetails")),
            new Document("$unwind", "$supplierNationDetails"),
            new Document("$lookup", new Document("from", "nation")
                .append("localField", "customerDetails.c_nationkey")
                .append("foreignField", "n_nationkey")
                .append("as", "customerNationDetails")),
            new Document("$unwind", "$customerNationDetails"),
            new Document("$match", new Document("$and", Arrays.asList(
                new Document("$or", Arrays.asList(
                    new Document("$and", Arrays.asList(
                        new Document("supplierNationDetails.n_name", "MOZAMBIQUE"),
                        new Document("customerNationDetails.n_name", "IRAQ")
                    )),
                    new Document("$and", Arrays.asList(
                        new Document("supplierNationDetails.n_name", "IRAQ"),
                        new Document("customerNationDetails.n_name", "MOZAMBIQUE")
                    ))
                )),
                new Document("l_shipdate", new Document("$gte", new Date(1995 - 1900, 1, 1))
                    .append("$lte", new Date(1996-1900, 12, 31)))
            ))),
            new Document("$project", new Document("supp_nation", "$supplierNationDetails.n_name")
                .append("cust_nation", "$customerNationDetails.n_name")
                .append("l_year", new Document("$year", "$l_shipdate"))
                .append("volume", new Document("$multiply", Arrays.asList("$l_extendedprice", new Document("$subtract", Arrays.asList(1, "$l_discount")))))),
            new Document("$group", new Document("_id", new Document("supp_nation", "$supp_nation")
                .append("cust_nation", "$cust_nation")
                .append("l_year", "$l_year"))
                .append("revenue", new Document("$sum", "$volume"))),
            new Document("$project", new Document("_id", 0)
                .append("supp_nation", "$_id.supp_nation")
                .append("cust_nation", "$_id.cust_nation")
                .append("l_year", "$_id.l_year")
                .append("revenue", "$revenue")),
            new Document("$sort", new Document("supp_nation", 1)
                .append("cust_nation", 1)
                .append("l_year", 1))
        ));

        // Procesar los resultados
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }

        }
}
