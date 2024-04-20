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

import com.pfg.collector.api.entity.ServerMetrics;
import com.pfg.collector.api.service.ServerMetricsService;

@RestController
@RequestMapping("/api/v1/server-metrics")
public class ServerMetricsController {

    public final ServerMetricsService serverMetricsService;

    @Autowired
    public ServerMetricsController(
        ServerMetricsService serverMetricsService
    ){
        this.serverMetricsService = serverMetricsService;
    }

    @PostMapping("/add")
    public ResponseEntity<ServerMetrics> saveServerMetrics(@RequestBody ServerMetrics directive) {
        ServerMetrics newServerMetrics = serverMetricsService.saveServerMetrics(directive);
        return ResponseEntity.ok(newServerMetrics);
    }

    @GetMapping("/")
    public List<ServerMetrics> getAllServerMetrics(){
        return serverMetricsService.getAllServerMetrics();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ServerMetrics> getServerMetricsById(@PathVariable Long id){
        Optional<ServerMetrics> directive = serverMetricsService.getServerMetricsById(id);
        return directive.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
