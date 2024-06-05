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
import org.bson.Document;

public class Query2 extends Query {
        public Query2(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                MongoCollection<Document> partCollection = database.getCollection("part");

                // Construir la consulta de agregación
                AggregateIterable<Document> result = partCollection.aggregate(Arrays.asList(
                                Aggregates.match(Filters.and(
                                                Filters.eq("p_size", 23),
                                                Filters.regex("p_type", ".*STEEL.*"))),
                                Aggregates.lookup("partsupp", "p_partkey", "ps_partkey", "partsupp_docs"),
                                Aggregates.unwind("$partsupp_docs"),
                                Aggregates.lookup("supplier", "partsupp_docs.ps_suppkey", "s_suppkey", "supplier_docs"),
                                Aggregates.unwind("$supplier_docs"),
                                Aggregates.lookup("nation", "supplier_docs.s_nationkey", "n_nationkey", "nation_docs"),
                                Aggregates.unwind("$nation_docs"),
                                Aggregates.lookup("region", "nation_docs.n_regionkey", "r_regionkey", "region_docs"),
                                Aggregates.unwind("$region_docs"),
                                Aggregates.match(Filters.eq("region_docs.r_name", "AMERICA")),
                                Aggregates.group(
                                                new Document("p_partkey", "$p_partkey").append("s_suppkey",
                                                                "$supplier_docs.s_suppkey"),
                                                Accumulators.min("min_ps_supplycost", "$partsupp_docs.ps_supplycost")),
                                Aggregates.lookup("partsupp", Arrays.asList(
                                                new Variable<>("p_partkey", "$_id.p_partkey"),
                                                new Variable<>("s_suppkey", "$_id.s_suppkey")),
                                                Arrays.asList(
                                                                Aggregates.match(Filters.and(
                                                                                Filters.expr(new Document("$eq", Arrays
                                                                                                .asList("$p_partkey",
                                                                                                                "$$p_partkey"))),
                                                                                Filters.expr(new Document("$eq", Arrays
                                                                                                .asList("$ps_suppkey",
                                                                                                                "$$s_suppkey"))),
                                                                                Filters.expr(new Document("$eq", Arrays
                                                                                                .asList("$ps_supplycost",
                                                                                                                "$$min_ps_supplycost")))))),
                                                "matching_partsupp_docs"),
                                Aggregates.unwind("$matching_partsupp_docs"),
                                Aggregates.lookup("supplier", "$matching_partsupp_docs.ps_suppkey", "s_suppkey",
                                                "matching_supplier_docs"),
                                Aggregates.unwind("$matching_supplier_docs"),
                                Aggregates.lookup("nation", "$matching_supplier_docs.s_nationkey", "n_nationkey",
                                                "matching_nation_docs"),
                                Aggregates.unwind("$matching_nation_docs"),
                                Aggregates.lookup("region", "$matching_nation_docs.n_regionkey", "r_regionkey",
                                                "matching_region_docs"),
                                Aggregates.unwind("$matching_region_docs"),
                                Aggregates.project(Projections.fields(
                                                Projections.include("matching_supplier_docs.s_acctbal",
                                                                "matching_supplier_docs.s_name",
                                                                "matching_nation_docs.n_name", "p_partkey", "p_mfgr",
                                                                "matching_supplier_docs.s_address",
                                                                "matching_supplier_docs.s_phone",
                                                                "matching_supplier_docs.s_comment"),
                                                Projections.computed("p_partkey", "$_id.p_partkey"))),
                                Aggregates.sort(Sorts.orderBy(Sorts.descending("matching_supplier_docs.s_acctbal"),
                                                Sorts.ascending("matching_nation_docs.n_name"),
                                                Sorts.ascending("matching_supplier_docs.s_name"),
                                                Sorts.ascending("p_partkey"))),
                                Aggregates.limit(100)));

                // Procesar y mostrar los resultados
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
