-----------------------------------Aisles---------------------------------------------

select 
try_cast(aisle_id as int) as aisle_id,
aisle
into Silver.[aisles]
from Bronze.aisles


alter table Silver.[aisles]
alter column aisle_id int not null
alter table Silver.[aisles]
add constraint PK_silve_aisles primary key(aisle_id)


-----------------------------------Departments---------------------------------------------

select 
try_cast([department_id] as int) as [department_id],
[department]
into Silver.[departments]
from [Bronze].[departments]


alter table Silver.[departments]
alter column [department_id] int not null
alter table Silver.departments
add constraint PK_silve_departments primary key([department_id])


-----------------------------------Order_products__prior---------------------------------------------


select 
try_cast([order_id] as int) as [order_id],
try_cast([product_id] as int) as [product_id],
try_cast([add_to_cart_order] as int) as [add_to_cart_order],
try_cast([reordered] as int) as [reordered]
into Silver.[order_products__prior]
from [Bronze].[order_products__prior]


alter table Silver.[order_products__prior]
alter column [order_id] int not null

alter table Silver.[order_products__prior]
alter column [product_id] int not null

ALTER TABLE Silver.[order_products__prior]
ADD CONSTRAINT PK_order_products_prior PRIMARY KEY (order_id, product_id);


select [product_id],[order_id],
count(*) as cnt
from [Silver].[order_products__prior]
group by [product_id],[order_id]
having count(*) >1



-----------------------------------Order_products__TRAIN---------------------------------------------



select 
try_cast([order_id] as int) as [order_id],
try_cast([product_id] as int) as [product_id],
try_cast([add_to_cart_order] as int) as [add_to_cart_order],
try_cast([reordered] as int) as [reordered]
into Silver.[order_products__train]
from [Bronze].[order_products__train]


alter table Silver.[order_products__train]
alter column [order_id] int not null

alter table Silver.[order_products__train]
alter column [product_id] int not null

ALTER TABLE Silver.[order_products__train]
ADD CONSTRAINT PK_order_products_train PRIMARY KEY (order_id, product_id);


select [product_id],[order_id],
count(*) as cnt
from [Silver].[order_products__prior]
group by [product_id],[order_id]
having count(*) >1


-----------------------------------Orders---------------------------------------------

select 
try_cast([order_id] as int) as [order_id],
try_cast([user_id] as int) as [user_id],
[eval_set],
try_cast(order_number as int) as order_number,
try_cast([order_dow] as int) as [order_dow],
try_cast([order_hour_of_day] as int) as [order_hour_of_day],
try_cast([days_since_prior_order] as int) as [days_since_prior_order]

into Silver.[orders]
from Bronze.orders


alter table [Silver].[orders]
alter column [order_id] int not null
alter table [Silver].[orders]
add constraint PK_silve_orders primary key([order_id])


select [order_id],
count(*) as cnt
from [Silver].[orders]
group by [order_id]
having count(*) >1




-----------------------------------Products---------------------------------------------

select 
try_cast([product_id] as int) as [product_id],
[product_name],
try_cast([aisle_id] as int) as [aisle_id],
try_cast(department_id as int) as department_id
into Silver.[products]
from [Bronze].[products]


alter table [Silver].[products]
alter column [product_id] int not null
alter table [Silver].[products]
add constraint PK_silve_products primary key(product_id)

