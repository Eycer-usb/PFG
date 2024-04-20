package com.pfg.collector.api.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pfg.collector.api.entity.ClientMetrics;
import com.pfg.collector.api.repository.ClientMetricsRepository;

@Service
public class ClientMetricsService {

    private final ClientMetricsRepository clientMetricsRepository;

    @Autowired
    public ClientMetricsService(ClientMetricsRepository clientMetricsRepository) {
        this.clientMetricsRepository = clientMetricsRepository;
    }

    /*
     * Save a ClientMetrics
     * 
     * @param clientMetric to save
     * 
     * @return the persisted entity
     */

    public ClientMetrics saveClientMetrics(ClientMetrics clientMetric) {
        return clientMetricsRepository.save(clientMetric);
    }

    /*
     * Get All ClientMetrics
     * 
     * @return list of ClientMetrics
     */

    public List<ClientMetrics> getAllClientMetrics() {
        return clientMetricsRepository.findAll();
    }

    /*
     * Get ClientMetrics by Id
     */
    public Optional<ClientMetrics> getClientMetricsById(Long id){
        return clientMetricsRepository.findById(id);
    }

}
