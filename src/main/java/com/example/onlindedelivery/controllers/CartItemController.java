package com.example.onlindedelivery.controllers;

import com.example.onlindedelivery.dtos.CartItemDTO;
import com.example.onlindedelivery.models.CartItem;
import com.example.onlindedelivery.services.CartItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
public class CartItemController {

    @Autowired
    private CartItemService service; 

    // GET ALL CART ITEMS
    @GetMapping
    public List<CartItemDTO> getAll() throws Exception {
        return service.getAllItems();
    }

    // GET CART ITEMS BY USER ID
    @GetMapping("/user/{userId}")
    public List<CartItemDTO> getByUser(@PathVariable String userId) throws Exception {
        return service.getByUserId(userId);
    }

    // GET ITEM BY ID
    @GetMapping("/{id}")
    public CartItemDTO getById(@PathVariable String id) throws Exception {
        return service.getById(id);
    }

    // CREATE ITEM
    @PostMapping
    public CartItem create(@RequestBody CartItem item) throws Exception {
      return  service.create(item);
    }

    // UPDATE ITEM   
    @PutMapping("/{id}")
    public void update(@PathVariable String id, @RequestBody CartItem updatedItem) throws Exception {
        service.update(id, updatedItem);
    }

    // DELETE ITEM
    @DeleteMapping("/{id}")
    public void delete(@PathVariable String id) throws Exception {
        service.delete(id);
    }
}
