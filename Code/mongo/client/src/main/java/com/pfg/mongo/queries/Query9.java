package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Projections;
import com.mongodb.client.model.Sorts;
import com.mongodb.client.model.Variable;
import com.mongodb.client.model.*;
import org.bson.Document;

public class Query9 extends Query {
        public Query9(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Colecciones
                MongoCollection<Document> partCollection = database.getCollection("part");
                MongoCollection<Document> supplierCollection = database.getCollection("supplier");
                MongoCollection<Document> lineitemCollection = database.getCollection("lineitem");
                MongoCollection<Document> partsuppCollection = database.getCollection("partsupp");
                MongoCollection<Document> ordersCollection = database.getCollection("orders");
                MongoCollection<Document> nationCollection = database.getCollection("nation");

                // Construir la consulta de agregación
                AggregateIterable<Document> result = partCollection.aggregate(Arrays.asList(
                                Aggregates.lookup("lineitem", "p_partkey", "l_partkey", "lineitem_docs"),
                                Aggregates.unwind("$lineitem_docs"),
                                Aggregates.lookup("supplier", "lineitem_docs.l_suppkey", "s_suppkey", "supplier_docs"),
                                Aggregates.unwind("$supplier_docs"),
                                // Agregar una clave compuesta
                                Aggregates.addFields(new Field<>("lineitem_docs.ps_suppkey_ps_partkey",
                                                new Document("ps_suppkey", "$lineitem_docs.l_suppkey")
                                                                .append("ps_partkey", "$lineitem_docs.l_partkey"))),
                                Aggregates.lookup("partsupp", Arrays.asList(
                                                new Variable<>("ps_suppkey_ps_partkey",
                                                                "$lineitem_docs.ps_suppkey_ps_partkey")),
                                                Arrays.asList(
                                                                Aggregates.match(Filters.expr(new Document("$and",
                                                                                Arrays.asList(
                                                                                                new Document("$eq",
                                                                                                                Arrays.asList("$ps_suppkey",
                                                                                                                                "$$ps_suppkey_ps_partkey.ps_suppkey")),
                                                                                                new Document("$eq",
                                                                                                                Arrays.asList("$ps_partkey",
                                                                                                                                "$$ps_suppkey_ps_partkey.ps_partkey"))))))),
                                                "partsupp_docs"),
                                Aggregates.unwind("$partsupp_docs"),
                                Aggregates.lookup("orders", "lineitem_docs.l_orderkey", "o_orderkey", "orders_docs"),
                                Aggregates.unwind("$orders_docs"),
                                Aggregates.lookup("nation", "supplier_docs.s_nationkey", "n_nationkey", "nation_docs"),
                                Aggregates.unwind("$nation_docs"),
                                Aggregates.match(Filters.regex("p_name", ".*green.*", "i")),
                                Aggregates.project(Projections.fields(
                                                Projections.computed("nation", "$nation_docs.n_name"),
                                                Projections.computed("o_year",
                                                                new Document("$year", "$orders_docs.o_orderdate")),
                                                Projections.computed("amount", new Document("$subtract", Arrays.asList(
                                                                new Document("$multiply", Arrays.asList(
                                                                                "$lineitem_docs.l_extendedprice",
                                                                                new Document("$subtract", Arrays.asList(
                                                                                                1,
                                                                                                "$lineitem_docs.l_discount")))),
                                                                new Document("$multiply", Arrays.asList(
                                                                                "$partsupp_docs.ps_supplycost",
                                                                                "$lineitem_docs.l_quantity"))))))),
                                Aggregates.group(
                                                new Document()
                                                                .append("nation", "$nation")
                                                                .append("o_year", "$o_year"),
                                                Accumulators.sum("sum_profit", "$amount")),
                                Aggregates.sort(Sorts.ascending("_id.nation", "_id.o_year")),
                                Aggregates.limit(1)));

                // Procesar y mostrar los resultados
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
