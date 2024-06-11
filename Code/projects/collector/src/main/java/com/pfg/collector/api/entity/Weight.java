package com.pfg.collector.api.entity;
import jakarta.persistence.*;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
 
@Entity
@Table(name = "weight")
public class Weight {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    @Column(nullable = false)
    private String optimizationKey;

    @Column(nullable = false)
    private String weight;

    @Column(nullable = false)
    private String dbType;

    // Getters

    public Long getId(){
        return this.id;
    }

    public String getOptimizationKey(){
        return this.optimizationKey;
    }

    public String getWeight(){
        return this.weight;
    }

    public String getDbType(){
        return this.dbType;
    }

    // Setters

    public void setId(Long value){
        this.id = value;
    }

    public void setOptimizationKey(String value){
        this.optimizationKey = value;
    }

    public void setWeight(String value){
        this.weight = value;
    }

    public void setDbType(String value){
        this.dbType = value;
    }


}
