package com.pfg.postgres;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class Query {

    protected static Timestamp getCurrentTimestamp()  {
        final Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
        return currentTimestamp;
    }

    protected static long getDuration(Timestamp startTime, Timestamp endTime) {
        return endTime.getTime() - startTime.getTime();
    }
}