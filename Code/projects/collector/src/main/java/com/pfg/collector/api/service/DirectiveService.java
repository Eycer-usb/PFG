package com.pfg.collector.api.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pfg.collector.api.entity.Directive;
import com.pfg.collector.api.repository.DirectiveRepository;

@Service
public class DirectiveService {

    private final DirectiveRepository directiveRepository;

    @Autowired
    public DirectiveService(DirectiveRepository directiveRepository) {
        this.directiveRepository = directiveRepository;
    }

    /*
     * Save a Directive
     * 
     * @param directive to save
     * 
     * @return the persisted entity
     */

    public Directive saveDirective(Directive directive) {
        return directiveRepository.save(directive);
    }

    /*
     * Get All Directives
     * 
     * @return list of Directives
     */

    public List<Directive> getAllDirectives() {
        return directiveRepository.findAll();
    }

    /*
     * Get Directive by Id
     */
    public Optional<Directive> getDirectiveById(Long id){
        return directiveRepository.findById(id);
    }

}
