package com.pfg.collector.api.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "directive")
public class Directive {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @Column(nullable = false)
    private String databaseKey;

    @Column(nullable = false)
    private String optimizationKey;

    @Column(nullable = false)
    private String queryKey;

    @Column(nullable = false)
    private String iteration;

    @Column(nullable = false)
    private String clientPid;

    @Column(nullable = false)
    private String serverPid;

    @Column(nullable = false)
    private String startTime;

    @Column(nullable = false)
    private String endTime;

    @Column(nullable = false)
    private String executionTime;

    // Getters and Setters

    public Long getId(){
        return this.id;
    }

    public String getOptimizationKey(){
        return this.optimizationKey;
    }

    public String getIteration(){
        return this.iteration;
    }

    public String getClientPid(){
        return this.clientPid;
    }

    public String getServerPid(){
        return this.serverPid;
    }

    public String getStartTime() {
        return this.startTime;
    }

    public String getEndTime() {
        return this.endTime;
    }

    public String getDatabaseKey(){
        return this.databaseKey;
    }

    public String getQueryKey(){
        return this.queryKey;
    }

    public String getExecutionTime(){
        return this.executionTime;
    }
    
    public void setId(Long value){
        this.id = value;
    }

    public void setOptimizationKey(String value){
        this.optimizationKey = value;
    }

    public void setIteration(String value){
        this.iteration = value;
    }

    public void setClientPid(String value){
        this.clientPid = value;
    }

    public void setServerPid(String value){
        this.serverPid = value;
    }

    public void setStartTime(String value) {
        this.startTime = value;
    }

    public void setEndTime(String value) {
        this.endTime = value;
    }

    public void setDatabaseKey(String value){
        this.databaseKey = value;
    }

    public void setQueryKey(String value){
        this.queryKey = value;
    }

    public void setExecutionTime(String value){
        this.executionTime = value;
    }

    
}