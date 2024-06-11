package com.pfg.collector.api.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.pfg.collector.api.entity.ServerMetrics;

@Repository
public interface ServerMetricsRepository extends JpaRepository<ServerMetrics, Long>{

}
