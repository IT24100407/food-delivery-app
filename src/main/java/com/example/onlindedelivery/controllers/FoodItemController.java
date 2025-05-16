package com.example.onlindedelivery.controllers;

import com.example.onlindedelivery.dtos.FoodItemDTO;
import com.example.onlindedelivery.models.FoodItem;
import com.example.onlindedelivery.services.FoodItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.UUID;
import java.util.List;


@RestController
@RequestMapping("/api/food-items")
public class FoodItemController {

    @Autowired
    private FoodItemService service;

    // GET ALL FOOD ITEMS
    @GetMapping
    public List<FoodItemDTO> getAll() throws Exception {
        return service.getAllItems();
    }

    // GET ITEM BY ID
    @GetMapping("/{id}")
    public FoodItemDTO getById(@PathVariable String id) throws Exception {
    

        return service.getItemById(id);
    }

    // CREATE ITEM
    @PostMapping
    public void create(@RequestBody FoodItem item) throws Exception {
        UUID uuid = UUID.randomUUID(); 
        item.setFoodItemId(uuid.toString());
        service.createItem(item);
    }

    // UPDATE ITEM
    @PutMapping("/{id}")
    public void update(@PathVariable String id, @RequestBody FoodItem updatedItem) throws Exception {
        service.updateItem(id, updatedItem);
    }

    // DELETE ITEM
    @DeleteMapping("/{id}")
    public void delete(@PathVariable String id) throws Exception {
        service.deleteItem(id);
    }

    @GetMapping("/sorted-by-price")
    public List<FoodItemDTO> getSortedByPrice() throws Exception {
        return service.getSortedByPrice();
    }
}
