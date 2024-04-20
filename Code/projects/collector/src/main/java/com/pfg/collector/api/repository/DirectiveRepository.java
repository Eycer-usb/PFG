package com.pfg.collector.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.pfg.collector.api.entity.Directive;

@Repository
public interface DirectiveRepository extends JpaRepository<Directive, Long> {

}
