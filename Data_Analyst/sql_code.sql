create table Users (userId INT PRIMARY KEY AUTO_INCREMENT, 
                    age int);
create table Items (itemId INT PRIMARY KEY AUTO_INCREMENT, 
                    price DECIMAL(8, 2));
create table Purchases (purchaseId INT PRIMARY KEY AUTO_INCREMENT, 
                        userId INT not null, 
                        itemId int not null, 
                        date_1 DATE,
                        FOREIGN KEY (userId)  REFERENCES Users (userId),
                        FOREIGN KEY (itemId)  REFERENCES Items (itemId)); 
                        
insert into Users (userId, age)
values (1, 34),
(2, 26),
(3, 56),
(4, 38),
(5, 21),
(6, 33);

insert into Items (itemId, price)
values (1, 345.00),
(2, 1001.20),
(3, 666.00),
(4, 1020.45),
(5, 225.00),
(6, 54.00);

insert into Purchases (purchaseId, userId, itemId, date_1) 
values (1, 4, 3, '2020-09-21'),
(2, 5, 2, '2020-07-03'),
(3, 6, 6, '2020-06-19'),
(4, 1, 3, '2020-07-13'),
(5, 2, 5, '2020-09-23'),
(6, 1, 3, '2020-08-09'),
(7, 4, 2, '2021-09-15'),
(8, 5, 5, '2021-04-11');

# А) какую сумму в среднем в месяц тратит:
# - пользователи в возрастном диапазоне от 18 до 25 лет включительно
# - пользователи в возрастном диапазоне от 26 до 35 лет включительно

select avg(price), month(date_1) as monthDate 
from Users u join 
Purchases p on u.userId = p.userId join 
Items i on p.itemId = i.itemID
where age between 18 and 25
group by month(date_1);

# avg(price)	monthDate
# 1001.200000	 7
# 225.000000	 4

select avg(price), month(date_1) as monthDate 
from Users u join 
Purchases p on u.userId = p.userId join 
Items i on p.itemId = i.itemID
where age between 26 and 35
group by month(date_1);

# avg(price)	monthDate
# 666.000000	7
# 666.000000	8
# 225.000000	9
# 54.000000	6

# Б) в каком месяце года выручка от пользователей в возрастном диапазоне 35+ самая большая

select sum(price),  month(date_1) as monthDate 
from Users u join 
Purchases p on u.userId = p.userId join 
Items i on p.itemId = i.itemID
where age >= 35
group by month(date_1)
order by sum(price) desc
limit 1;

# sum(price)	monthDate
# 1667.20	   9

# В) какой товар обеспечивает дает наибольший вклад в выручку за последний год

select p.itemId, sum(i.price) 
from Users u join 
Purchases p on u.userId = p.userId join 
Items i on p.itemId = i.itemID
where date_1 > '2021-01-01'
group by p.itemId 
order by sum(i.price) desc;

# itemId   sum(i.price)
# 2	    1001.20
# 5	    225.00

# Г) топ-3 товаров по выручке и их доля в общей выручке за любой год

select p.itemId, sum(i.price), sum(i.price)/ (
select sum(i.price) 
from Purchases p join 
Items i on p.itemId = i.itemId
where year(date_1) = '2020') as part
from Users u join 
Purchases p on u.userId = p.userId join 
Items i on p.itemId = i.itemID
where year(date_1) = '2020'
group by p.itemID
order by sum(i.price) desc
limit 3;

# itemId	sum(i.price)	part
# 3	      1998.00	      0.609481
# 2	      1001.20	      0.305412
# 5	      225.00	      0.068635
