select * from customers_s;
select * from ororderitems_s;
select * from orders_s;
select * from products_s;



         select 
         product_category,
          round (sum(quantity * unit_price),2) as total_revenue 
         from products_s
         join ororderitems_s
         on products_s.product_id = ororderitems_s.product_id
         group by  product_category
         order by total_revenue;
         
         
         
         select 
            order_status,
            count(order_id) as order_count 
            from orders_s
           group by order_status 
           order by order_count desc;
           
           
           
           select 
           product_name,
           sum(quantity) as top_sold 
           from products_s
         join ororderitems_s
         on products_s.product_id = ororderitems_s.product_id
         group by product_name
         order by top_sold desc limit 10;
         
         
         
         select 
            monthname(signup_date) as month_,
            count(customer_id) as customer_count
            from customers_s
            group by signup_date
               order by customer_count desc;
               
               
               
               select 
                 city,
                 count(customer_id) as total_count 
                 from customers_s
                 group by city
                 order by total_count desc;
                 
                 
                 
                 select 
                 year(order_date) as year_,
                 monthname(order_date) as month_,
                   round(sum(quantity * unit_price),2) as total_revenue
                 from orders_s
                 join ororderitems_s
                 on orders_s.order_id = ororderitems_s.order_id
                 where year(order_date) between 2022 and 2023
                 group by  year_,month_
                 order by year_ asc, month_ asc;
                 
                 
          
            
         select
               city,
              round( sum(quantity * unit_price),2) as total_revenue
               from customers_s
               join orders_s
               on customers_s.customer_id = orders_s.customer_id
               join ororderitems_s
               on orders_s.order_id = ororderitems_s.order_id
               group by city 
               order by total_revenue desc;
               
               
               with order_ as (
                  select 
                  orders_s.order_id,
                 round( sum(quantity* unit_price),2) as total_revenue
                  from orders_s
                  join ororderitems_s
                  on orders_s.order_id = ororderitems_s.order_id
                  group by orders_s.order_id 
                  ) 
                  select 
                  round(avg(total_revenue),2) as avg_order_value
                  from order_;
                  
                  
                  select 
                   customers_s.customer_id,
                   count(order_id) as total_count
                   from customers_s
                   join orders_s
                   on customers_s.customer_id = orders_s.customer_id
                   group by  customers_s.customer_id
                   order by total_count desc;
                   
				
         
         
         
         SELECT 
    product_category,
    COUNT(*) AS total_orders,
     SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)as returned_count,
    ROUND(
        (SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
    2) AS return_rate_percentage
FROM orders_s
JOIN ororderitems_s 
ON orders_s.order_id = ororderitems_s.order_id
JOIN products_s 
ON ororderitems_s.product_id = products_s.product_id
GROUP BY product_category
ORDER BY return_rate_percentage DESC;





              select 
              gender,
              round(sum(quantity * unit_price),2) as total_revenue, 
              ROUND(SUM(quantity * unit_price) / COUNT(DISTINCT customers_s.customer_id), 2) AS avg_per_customer
              from customers_s
               join orders_s
               on customers_s.customer_id = orders_s.customer_id
               join ororderitems_s
               on orders_s.order_id = ororderitems_s.order_id
               group by gender 
                 order by total_revenue desc ;
                 
                 
                 
                 select 
                 product_category,
                 round(avg(unit_price),2) as avg_unit_price 
                   from products_s
         join ororderitems_s
         on products_s.product_id = ororderitems_s.product_id
         group by product_category
         order by avg_unit_price desc;
         
         
         
          
         select 
            order_status,
             SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) as returned_count,
              SUM(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END)as cancelled_count,
              round(sum(quantity * unit_price),2) as total_revenue
              FROM orders_s
                         JOIN ororderitems_s  
                             ON orders_s.order_id = ororderitems_s.order_id
                             group by order_status;
                             
                             
                             SELECT 
    order_status,
    COUNT(*) AS order_count,
    ROUND(SUM(quantity * unit_price), 2) AS lost_revenue
FROM orders_s
JOIN ororderitems_s ON orders_s.order_id = ororderitems_s.order_id
WHERE order_status IN ('Returned', 'Cancelled') -- This filters for just those two
GROUP BY order_status;
                            
			
               
               
            (SELECT 
    MONTHNAME(orders_s.order_date) AS month_name, 
    ROUND(coalesce(SUM(ororderitems_s.quantity * ororderitems_s.unit_price),0), 2) AS sales_amount,
    'HIGHEST' AS record_type
 FROM orders_s
 JOIN ororderitems_s ON orders_s.order_id = ororderitems_s.order_id
 GROUP BY MONTHNAME(orders_s.order_date)
 ORDER BY sales_amount DESC
 LIMIT 1)

UNION ALL

(SELECT 
    MONTHNAME(orders_s.order_date) AS month_name, 
    ROUND(coalesce(SUM(ororderitems_s.quantity * ororderitems_s.unit_price),0), 2) AS sales_amount,
    'LOWEST' AS record_type
 FROM orders_s
 JOIN ororderitems_s ON orders_s.order_id = ororderitems_s.order_id
 GROUP BY MONTHNAME(orders_s.order_date)
 ORDER BY sales_amount ASC
 LIMIT 1);
 
 
       SELECT 
    (SELECT COUNT(*) FROM orders_s) AS total_orders,
    (SELECT COUNT(*) FROM ororderitems_s) AS total_items,
    (SELECT COUNT(*) 
     FROM orders_s o 
     JOIN ororderitems_s oi ON o.order_id = oi.order_id) AS matched_rows;
     
     
     SELECT 
    MONTHNAME(o.order_date) AS month_name, 
    SUM(oi.quantity) AS total_qty,
    AVG(oi.unit_price) AS avg_price,
    ROUND(COALESCE(SUM(oi.quantity * oi.unit_price), 0), 2) AS sales_amount
FROM orders_s o
JOIN ororderitems_s oi ON o.order_id = oi.order_id
GROUP BY 1
ORDER BY sales_amount DESC;

      
    with order_ as(
      select 
        city,
              round( sum(quantity * unit_price),2) as total_revenue
               from customers_s
               join orders_s
               on customers_s.customer_id = orders_s.customer_id
               join ororderitems_s
               on orders_s.order_id = ororderitems_s.order_id
               group by city )
              select  city,
                  round(avg(total_revenue),2) as avg_order_value
                  from order_
                  group by 1
                  order by avg_order_value desc ;
                  
                  
                  
                  
                  with product_revenue as ( 
                  select 
                    product_category,
                      product_name,
                      round(sum(quantity * unit_price),2) as total_revenue
                      from products_s
         join ororderitems_s
         on products_s.product_id = ororderitems_s.product_id
         group by 1,2
                      ),  ranked_product as (
                      select product_category,
                      product_name,
                      total_revenue,
                      row_number() over(partition by product_category order by total_revenue desc )
                      as product_rank
                      from product_revenue
                      )
                      select * from ranked_product
                      where product_rank <= 3;
                      
                      
                      
                      select 
                      customers_s.customer_id,
                        order_id
                        from customers_s
                        left join orders_s
                        on customers_s.customer_id = orders_s.customer_id
                        where order_id is null;
                        
                        
                        select 
                           year(orders_s.order_date) as year_,
                          round( sum(quantity * unit_price),2) as total_revenue
                              from orders_s
                              join ororderitems_s
                              on orders_s.order_id = ororderitems_s.order_id
                              where  year(orders_s.order_date)  between 2022 and 2023
                              group by year_;  
                              
                              
                              
                              
                              SELECT 
    ROUND(SUM(CASE WHEN YEAR(order_date) = 2022 
    THEN quantity * unit_price ELSE 0 END), 2) AS revenue_2022,
    ROUND(SUM(CASE WHEN YEAR(order_date) = 2023 
    THEN quantity * unit_price ELSE 0 END), 2) AS revenue_2023,
    ROUND((SUM(CASE WHEN YEAR(order_date) = 2023
    THEN quantity * unit_price ELSE 0 END) - 
           SUM(CASE WHEN YEAR(order_date) = 2022
           THEN quantity * unit_price ELSE 0 END)) / 
           SUM(CASE WHEN YEAR(order_date) = 2022 
           THEN quantity * unit_price ELSE 0 END) * 100, 2) AS percentage_growth
FROM orders_s
JOIN ororderitems_s ON orders_s.order_id = ororderitems_s.order_id;
                              
                        
               with year_over_year as ( 
               select 
                      ROUND(SUM(CASE WHEN YEAR(order_date) = 2022 
        THEN quantity * unit_price ELSE 0 END), 2) AS revenue_2022,
            ROUND(SUM(CASE WHEN YEAR(order_date) = 2023 
           THEN quantity * unit_price ELSE 0 END), 2) AS revenue_2023
             FROM orders_s
          JOIN ororderitems_s ON orders_s.order_id = ororderitems_s.order_id
  )
                select revenue_2022,
                        revenue_2023,
                        round((( revenue_2023 - revenue_2022) / revenue_2022) * 100,2)
                        as percentage_growth
                        from year_over_year;
                        
                         
                        select 
                        customers_s.customer_id,
                        count( orders_s.order_id) as order_count
                        from customers_s
                        join orders_s
                        on customers_s.customer_id = orders_s.customer_id
                            group by customer_id
                            having  count(orders_s.order_id) > 2
                            order by order_count desc; 
                        
                             
                          
                              WITH customer_counts AS (
                              SELECT 
                                   customer_id,
                                       COUNT(order_id) AS order_count
                                           FROM orders_s
                                      GROUP BY customer_id
                         )
             SELECT 
    COUNT(CASE WHEN order_count > 1 THEN 1 END) AS repeat_customers,
    COUNT(*) AS total_customers,
    ROUND(COUNT(CASE WHEN order_count > 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS repeat_rate_pct
             FROM customer_counts;
             
             
             
                            
                              
              
                        
                  
                  
                  
                  
                                 
           
           
           
         
         