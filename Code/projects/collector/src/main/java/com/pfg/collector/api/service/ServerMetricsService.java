package com.pfg.collector.api.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pfg.collector.api.entity.ServerMetrics;
import com.pfg.collector.api.repository.ServerMetricsRepository;

@Service
public class ServerMetricsService {

    private final ServerMetricsRepository serverMetricsRepository;

    @Autowired
    public ServerMetricsService(ServerMetricsRepository serverMetricsRepository) {
        this.serverMetricsRepository = serverMetricsRepository;
    }

    /*
     * Save a ServerMetrics
     * 
     * @param serverMetric to save
     * 
     * @return the persisted entity
     */

    public ServerMetrics saveServerMetrics(ServerMetrics serverMetric) {
        return serverMetricsRepository.save(serverMetric);
    }

    /*
     * Get All ServerMetrics
     * 
     * @return list of ServerMetrics
     */

    public List<ServerMetrics> getAllServerMetrics() {
        return serverMetricsRepository.findAll();
    }

    /*
     * Get ServerMetrics by Id
     */
    public Optional<ServerMetrics> getServerMetricsById(Long id){
        return serverMetricsRepository.findById(id);
    }

}
