package com.pfg.library;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

public class RunnableMethodFromObject<T, U> implements Runnable {
    private final T obj;
    private final U arg;
    private final Method method;

    public RunnableMethodFromObject(T obj, String methodName, U arg) throws NoSuchMethodException {
        if (obj == null || methodName == null) {
            throw new IllegalArgumentException("Arguments cannot be null");
        }
        this.obj = obj;
        this.arg = arg;
        try {
            if (arg != null) {
                this.method = obj.getClass().getMethod(methodName, arg.getClass());
            } else {
                this.method = obj.getClass().getMethod(methodName);
            }
        } catch (NoSuchMethodException e) {
            throw new NoSuchMethodException("Method not found: " + methodName);
        }
        if (!Modifier.isPublic(method.getModifiers())) {
            throw new IllegalArgumentException("Method is not accessible");
        }
    }

    public void run() {
        try {
            if (arg != null) {
                method.invoke(obj, arg);
            } else {
                method.invoke(obj);
            }
        } catch (Exception e) {
            // Handle or log the exception appropriately
            e.printStackTrace();
        }
    }
}