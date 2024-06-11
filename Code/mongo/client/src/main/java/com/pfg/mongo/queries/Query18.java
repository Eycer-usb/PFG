package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query18 extends Query {
        public Query18(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Definir la consulta de agregación
                AggregateIterable<Document> result = database.getCollection("lineitem").aggregate(Arrays.asList(
                                // Agrupar por l_orderkey para calcular la suma de l_quantity
                                new Document("$group", new Document("_id", "$l_orderkey")
                                                .append("total_quantity", new Document("$sum", "$l_quantity"))),
                                // Filtrar órdenes con total_quantity > 314
                                new Document("$match", new Document("total_quantity", new Document("$gt", 314))),
                                // Unir con la colección orders
                                new Document("$lookup", new Document("from", "orders")
                                                .append("localField", "_id")
                                                .append("foreignField", "o_orderkey")
                                                .append("as", "order_info")),
                                new Document("$unwind", "$order_info"),
                                // Unir con la colección customer
                                new Document("$lookup", new Document("from", "customer")
                                                .append("localField", "order_info.o_custkey")
                                                .append("foreignField", "c_custkey")
                                                .append("as", "customer_info")),
                                new Document("$unwind", "$customer_info"),
                                // Agrupar por los campos deseados
                                new Document("$group",
                                                new Document("_id", new Document("c_name", "$customer_info.c_name")
                                                                .append("c_custkey", "$customer_info.c_custkey")
                                                                .append("o_orderkey", "$order_info.o_orderkey")
                                                                .append("o_orderdate", "$order_info.o_orderdate")
                                                                .append("o_totalprice", "$order_info.o_totalprice"))
                                                                .append("sum_quantity",
                                                                                new Document("$sum",
                                                                                                "$total_quantity"))),
                                // Proyectar los campos deseados
                                new Document("$project", new Document("_id", 0)
                                                .append("c_name", "$_id.c_name")
                                                .append("c_custkey", "$_id.c_custkey")
                                                .append("o_orderkey", "$_id.o_orderkey")
                                                .append("o_orderdate", "$_id.o_orderdate")
                                                .append("o_totalprice", "$_id.o_totalprice")
                                                .append("sum_quantity", "$sum_quantity")),
                                // Ordenar por o_totalprice y o_orderdate
                                new Document("$sort", new Document("o_totalprice", -1)
                                                .append("o_orderdate", 1)),
                                // Limitar los resultados a 100
                                new Document("$limit", 100)));

                // Imprimir el resultado
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
