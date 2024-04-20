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

import com.pfg.collector.api.entity.Directive;
import com.pfg.collector.api.service.DirectiveService;

@RestController
@RequestMapping("/api/v1/directives")
public class DirectiveController {

    public final DirectiveService directiveService;

    @Autowired
    public DirectiveController(
        DirectiveService directiveService
    ){
        this.directiveService = directiveService;
    }

    @PostMapping("/add")
    public ResponseEntity<Directive> saveDirective(@RequestBody Directive directive) {
        System.out.println("Request " + directive);
        Directive newDirective = directiveService.saveDirective(directive);
        System.out.println(newDirective);
        return ResponseEntity.ok(newDirective);
    }

    @GetMapping("/")
    public List<Directive> getAllDirectives(){
        return directiveService.getAllDirectives();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Directive> getDirectiveById(@PathVariable Long id){
        Optional<Directive> directive = directiveService.getDirectiveById(id);
        return directive.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
