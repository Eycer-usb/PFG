package com.pfg.mongo.queries;

import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;
import org.bson.Document;
import org.bson.conversions.Bson;
import java.time.LocalDate;
import java.util.Arrays;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Accumulators;

public class Query1 extends Query {
        public Query1(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                MongoCollection<Document> collection = database.getCollection("lineitem");

                LocalDate date = LocalDate.parse("1998-12-01").minusDays(Integer.parseInt(args[0]));
                Bson filter = Filters.lte("l_shipdate", date.toString());
                Bson group = Aggregates.group(
                                new Document("returnFlag", "$l_returnflag")
                                                .append("lineStatus", "$l_linestatus"),
                                Arrays.asList(
                                                Accumulators.sum("sum_qty", "$l_quantity"),
                                                Accumulators.sum("sum_base_price", "$l_extendedprice"),
                                                Accumulators.sum("sum_disc_price",
                                                                new Document("$sum",
                                                                                new Document("$multiply",
                                                                                                Arrays.asList("$l_extendedprice",
                                                                                                                new Document("$subtract",
                                                                                                                                Arrays.asList(1, "$l_discount")))))),
                                                Accumulators.sum("sum_charge",
                                                                new Document("$sum",
                                                                                new Document("$multiply",
                                                                                                Arrays.asList("$l_extendedprice",
                                                                                                                new Document("$subtract",
                                                                                                                                Arrays.asList(1, "$l_discount")),
                                                                                                                new Document("$add",
                                                                                                                                Arrays.asList(1, "$l_tax")))))),
                                                Accumulators.avg("avg_qty", "$l_quantity"),
                                                Accumulators.avg("avg_price", "$l_extendedprice"),
                                                Accumulators.avg("avg_disc", "$l_discount"),
                                                Accumulators.sum("count_order", 1)));
                Bson sort = Sorts.orderBy(Sorts.ascending("returnFlag", "lineStatus"));
                Bson limit = new Document("$limit", 1);

                // Ejecuta la consulta
                collection.aggregate(Arrays.asList(
                                Aggregates.match(filter),
                                group,
                                Aggregates.sort(sort),
                                limit)).forEach(document -> System.out.println(document.toJson()));
        }
}
