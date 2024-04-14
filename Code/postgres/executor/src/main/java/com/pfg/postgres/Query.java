package com.pfg.postgres;

import java.sql.Timestamp;

public class Query {

    protected static Timestamp getCurrentTimestamp()  {
        final Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
        return currentTimestamp;
    }

    protected static long getDuration(Timestamp startTime, Timestamp endTime) {
        return endTime.getTime() - startTime.getTime();
    }
}