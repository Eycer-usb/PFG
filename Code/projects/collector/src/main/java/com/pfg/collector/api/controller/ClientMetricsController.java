package com.pfg.collector.api.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.pfg.collector.api.entity.ClientMetrics;
import com.pfg.collector.api.service.ClientMetricsService;

@RestController
@RequestMapping("/api/v1/client-metrics")
public class ClientMetricsController {

    public final ClientMetricsService clientMetricsService;

    @Autowired
    public ClientMetricsController(
        ClientMetricsService clientMetricsService
    ){
        this.clientMetricsService = clientMetricsService;
    }

    @PostMapping("/add")
    public ResponseEntity<ClientMetrics> saveClientMetrics(@RequestBody ClientMetrics directive) {
        ClientMetrics newClientMetrics = clientMetricsService.saveClientMetrics(directive);
        return ResponseEntity.ok(newClientMetrics);
    }

    @GetMapping("/")
    public List<ClientMetrics> getAllClientMetricss(){
        return clientMetricsService.getAllClientMetrics();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ClientMetrics> getClientMetricsById(@PathVariable Long id){
        Optional<ClientMetrics> directive = clientMetricsService.getClientMetricsById(id);
        return directive.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
