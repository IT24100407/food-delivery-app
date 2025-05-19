package com.example.onlindedelivery.services;

import com.example.onlindedelivery.dtos.CartItemDTO;
import com.example.onlindedelivery.models.CartItem;
import com.example.onlindedelivery.repositories.CartItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class CartItemService {

    @Autowired
    private CartItemRepository repository;

    public List<CartItemDTO> getAllItems() throws Exception {
        return repository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<CartItemDTO> getByUserId(String userId) throws Exception {
        return repository.findByUserId(userId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public CartItemDTO getById(String id) throws Exception {
        CartItem item = repository.findById(id);
        if (item == null) throw new RuntimeException("Cart item not found");
        return toDTO(item);
    }

    public CartItem create(CartItem item) throws Exception {
        System.out.println(item.getFoodItemId());
        String id = UUID.randomUUID().toString();
        item.setCartId(id);
        repository.save(item);
        return item;
    }

    public void update(String id, CartItem updatedItem) throws Exception {
        updatedItem.setCartId(id);
        repository.update(updatedItem);
    }

    public void delete(String id) throws Exception {
        repository.deleteById(id);
    }

    private CartItemDTO toDTO(CartItem item) {
        CartItemDTO dto = new CartItemDTO();
        dto.setCartId(item.getCartId());
        dto.setUserId(item.getUserId());
        dto.setFoodItemId(item.getFoodItemId());
        dto.setQuantity(item.getQuantity());
        dto.setAddedTime(item.getAddedTime());
        return dto;
    }
}