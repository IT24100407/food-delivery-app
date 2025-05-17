package com.example.onlindedelivery.services;

import com.example.onlindedelivery.dtos.FoodItemDTO;
import com.example.onlindedelivery.models.FoodItem;
import com.example.onlindedelivery.repositories.FoodItemRepository;
import com.example.onlindedelivery.utils.FoodItemQuickSort;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class FoodItemService {

    @Autowired
    private FoodItemRepository repository;

    public List<FoodItemDTO> getAllItems() throws Exception {
        return repository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }
    public List<FoodItemDTO> getSortedByPrice() throws Exception {
        List<FoodItem> items = new ArrayList<>();
        for (FoodItem item : repository.findAll()) {
            items.add(item.clone()); // Avoid modifying original data
        }

        FoodItemQuickSort.sortFoodItemsByPrice(items);

        return items.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }
    public FoodItemDTO getItemById(String id) throws Exception {
        FoodItem item = repository.findById(id);
        if (item == null) throw new RuntimeException("Food item not found");
        return toDTO(item);
    }

    public void createItem(FoodItem item) throws Exception {
        repository.save(item);
    }

    public void updateItem(String id, FoodItem updatedItem) throws Exception {
        updatedItem.setFoodItemId(id);
        repository.update(updatedItem);
    }

    public void deleteItem(String id) throws Exception {
        repository.deleteById(id);
    }

    private FoodItemDTO toDTO(FoodItem item) {
        FoodItemDTO dto = new FoodItemDTO();
        dto.setFoodItemId(item.getFoodItemId());
        dto.setName(item.getName());
        dto.setDescription(item.getDescription());
        dto.setPrice(item.getPrice());
        dto.setImage(item.getImage());
        return dto;
    }
}