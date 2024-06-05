package com.pfg.mongo.queries;

import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import org.bson.Document;

import java.util.Date;

public class Query6 extends Query {
    public Query6(String[] args) {
        super(args);
    }

    @Override
    public void run(MongoDatabase database) {
        // Colección
        MongoCollection<Document> lineitemCollection = database.getCollection("lineitem");

        // Fecha inicial y final para el filtro de fecha
        Date startDate = new Date(1997 - 1900, 0, 1); // date '1997-01-01'
        Date endDate = new Date(1998 - 1900, 0, 1); // date '1997-01-01' + interval '1' year

        // Construir la consulta de agregación
        AggregateIterable<Document> result = lineitemCollection.aggregate(Arrays.asList(
                Aggregates.match(Filters.and(
                        Filters.gte("l_shipdate", startDate),
                        Filters.lt("l_shipdate", endDate),
                        Filters.gte("l_discount", 0.02 - 0.01),
                        Filters.lte("l_discount", 0.02 + 0.01),
                        Filters.lt("l_quantity", 25))),
                Aggregates.group(null,
                        Accumulators.sum("revenue",
                                new Document("$multiply", Arrays.asList("$l_extendedprice", "$l_discount")))),
                Aggregates.limit(1)));

        // Procesar y mostrar los resultados
        for (Document doc : result) {
            System.out.println(doc.toJson());
        }
    }
}
