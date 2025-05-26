package com.example.onlindedelivery.utils;

import com.example.onlindedelivery.models.Order;
import org.springframework.context.annotation.Bean;

public class OrderQueue {
    private Order[] queue;
    private int front;
    private int rear;
    private int size;
    private int capacity;

    public OrderQueue(int capacity) {
        this.capacity=capacity;
        this.queue= new Order[capacity];
        this.front=0;
        this.rear=-1;
        this.size=0;


    }

    public boolean enqueueOrder(Order order){
        if(size==capacity) return false;    //check to queue is full
        rear=(rear+1)% capacity;
        queue[rear]= order;
        size++;
        return true;



    }

    public Order dequeueOrder(){
        if(isQueueEmpty())return null;
        Order order= queue[front];
        front=(front+1)%capacity;
        size--;
        return order;


    }

    public Order peekNextOrder(){
        if(isQueueEmpty()) return null;
        return queue[front];

    }

    public boolean isQueueEmpty(){
        return size==0;

    }

    public Order[] getAllQueuedOrders(){
        Order[] result= new  Order[size];
        for(int i=0; i< size; i++){
            result[i]=queue[(front+i)% capacity];

        }

        return result;

    }








}

