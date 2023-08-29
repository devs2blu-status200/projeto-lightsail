package com.mywebapp.controller;

import com.mywebapp.model.Visitor;
import com.mywebapp.repository.VisitorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class Controller {

    @Autowired
    private VisitorRepository visitorRepository;

    @GetMapping("/hello")
    public String sayHello() {
        Visitor visitor;
        if(visitorRepository.count() == 0) {
            visitor = new Visitor();
            visitor.setCount(1);
        } else {
            visitor = visitorRepository.findAll().get(0);
            visitor.setCount(visitor.getCount() + 1);
        }
        visitorRepository.save(visitor);
        return "Hello, world! Visitor count: " + visitor.getCount();
    }
}