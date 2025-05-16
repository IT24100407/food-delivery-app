package com.example.onlindedelivery.controllers;

import com.example.onlindedelivery.dtos.DeliveryDTO;
import com.example.onlindedelivery.models.Delivery;
import com.example.onlindedelivery.services.DeliveryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/deliveries")
public class DeliveryController {

    @Autowired
    private DeliveryService service;

    // GET ALL DELIVERIES
    @GetMapping
    public List<DeliveryDTO> getAll() throws Exception {
        return service.getAllDeliveries();
    }

    // GET DELIVERY BY ID
    @GetMapping("/{id}")
    public DeliveryDTO getById(@PathVariable String id) throws Exception {
        return service.getDeliveryById(id);
    }

    // CREATE NEW DELIVERY
    @PostMapping
    public void create(@RequestBody Delivery delivery) throws Exception {
        UUID uuid = UUID.randomUUID();
        delivery.setDeliveryId(uuid.toString());
        service.createDelivery(delivery);
    }

    // UPDATE EXISTING DELIVERY
    @PutMapping("/{id}")
    public void update(@PathVariable String id, @RequestBody Delivery delivery) throws Exception {
        service.updateDelivery(delivery);
    }

    // DELETE DELIVERY
    @DeleteMapping("/{id}")
    public void delete(@PathVariable String id) throws Exception {
        service.deleteDelivery(id);
    }
}