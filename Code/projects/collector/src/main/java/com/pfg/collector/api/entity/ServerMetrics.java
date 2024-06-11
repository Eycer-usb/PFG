package com.pfg.collector.api.entity;

import jakarta.persistence.*;
 
@Entity
@Table(name = "server_metrics")
public class ServerMetrics {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long directiveIdFk;

    @Column(nullable = false)
    private String energyConsumed;

    @Column(nullable = true)
    private String cpuUsage;

    // Getters and Setters

    public Long getId(){
        return this.id;
    }


    public Long getDirectiveIdFk(){
        return this.directiveIdFk;
    }

    public String getEnergyConsumed(){
        return this.energyConsumed;
    }

    public String getCpuUsage(){
        return this.cpuUsage;
    }

    public void setId(Long value){
        this.id = value;
    }


    public void setDirectiveIdFk(Long value){
        this.directiveIdFk = value;
    }

    public void setEnergyConsumed(String value){
        this.energyConsumed = value;
    }

    public void setCpuUsage(String value){
        this.cpuUsage = value;
    }

}
