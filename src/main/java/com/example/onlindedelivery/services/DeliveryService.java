package com.example.onlindedelivery.services;

import com.example.onlindedelivery.dtos.DeliveryDTO;
import com.example.onlindedelivery.models.Delivery;
import com.example.onlindedelivery.repositories.DeliveryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class DeliveryService {

    @Autowired
    private DeliveryRepository repository;

    public List<DeliveryDTO> getAllDeliveries() throws Exception {
        return repository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public DeliveryDTO getDeliveryById(String id) throws Exception {
        Delivery delivery = repository.findById(id);
        if (delivery == null) throw new RuntimeException("Delivery not found");
        return toDTO(delivery);
    }

    public void createDelivery(Delivery delivery) throws Exception {
        repository.save(delivery);
    }

    public void updateDelivery(Delivery updatedDelivery) throws Exception {
        repository.update(updatedDelivery);
    }

    public void deleteDelivery(String id) throws Exception {
        repository.deleteById(id);
    }

    private DeliveryDTO toDTO(Delivery delivery) {
        DeliveryDTO dto = new DeliveryDTO();
        dto.setDeliveryId(delivery.getDeliveryId());
        dto.setOrderId(delivery.getOrderId());
        dto.setDeliveryStatus(delivery.getDeliveryStatus());
        dto.setEstimatedDeliveryTime(delivery.getEstimatedDeliveryTime());
        dto.setActualDeliveryTime(delivery.getActualDeliveryTime());
        dto.setDeliveryAddress(delivery.getDeliveryAddress());
        return dto;
    }
}