package com.pfg.mongo.queries;
import java.util.Arrays;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Query17 extends Query {
        public Query17(String[] args) {
                super(args);
        }

        @Override
        public void run(MongoDatabase database) {
                // Definir la consulta de agregación
                AggregateIterable<Document> result = database.getCollection("lineitem").aggregate(Arrays.asList(
                                // Agrupar por l_partkey para calcular avg_quantity
                                new Document("$group", new Document("_id", "$l_partkey")
                                                .append("avg_quantity", new Document("$avg", "$l_quantity"))),
                                // Unir con la colección part
                                new Document("$lookup", new Document("from", "part")
                                                .append("localField", "_id")
                                                .append("foreignField", "p_partkey")
                                                .append("as", "part_info")),
                                new Document("$unwind", "$part_info"),
                                // Filtrar por p_brand, p_container, y l_quantity < avg_quantity
                                new Document("$match", new Document("part_info.p_brand", "Brand#53")
                                                .append("part_info.p_container", "MED DRUM")),
                                new Document("$lookup", new Document("from", "lineitem")
                                                .append("localField", "_id")
                                                .append("foreignField", "l_partkey")
                                                .append("as", "lineitem_info")),
                                new Document("$unwind", "$lineitem_info"),
                                new Document("$match",
                                                new Document("lineitem_info.l_quantity",
                                                                new Document("$lt", "$avg_quantity"))),
                                // Agrupar para calcular la suma de l_extendedprice
                                new Document("$group", new Document("_id", null)
                                                .append("total_extendedprice",
                                                                new Document("$sum",
                                                                                "$lineitem_info.l_extendedprice"))),
                                // Calcular el promedio anual
                                new Document("$project", new Document("_id", 0)
                                                .append("avg_yearly",
                                                                new Document("$divide",
                                                                                Arrays.asList("$total_extendedprice",
                                                                                                7)))),
                                // Limitar el resultado a 1
                                new Document("$limit", 1)));

                // Imprimir el resultado
                for (Document doc : result) {
                        System.out.println(doc.toJson());
                }
        }
}
