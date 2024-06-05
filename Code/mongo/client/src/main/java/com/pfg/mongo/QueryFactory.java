package com.pfg.mongo;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

import com.pfg.mongo.queries.*;

public class QueryFactory {

    @SuppressWarnings("unchecked")
    public static Class<? extends Query>[] queries = new Class[]{Query.class,
        Query1.class, Query2.class, Query3.class, Query4.class, Query5.class,
        Query6.class, Query7.class, Query8.class, Query9.class, Query10.class,
        Query11.class, Query12.class, Query13.class, Query14.class, Query15.class,
        Query16.class, Query17.class, Query18.class, Query19.class, Query20.class,
        Query21.class, Query22.class,
    };

    public static Query create(int queryKey, String[] args) {
        try {
            Constructor<? extends Query> constructor = queries[queryKey].getDeclaredConstructor(String[].class);
            
            return constructor.newInstance((Object)args);
        } catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            e.printStackTrace();
            return null;
        }
    }
}
