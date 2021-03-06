use TinyTheaters;

-- Complete the following queries.

-- Find all performances in the last quarter of 2021 (Oct. 1, 2021 - Dec. 31 2021).

select 	p.date as Date,
		s.title as `show`, 
        t.name as teather_Name
from performance p 
inner join `show` s on p.show_id = s.show_id
inner join theater t on p.theater_id = t.theater_id
where date between "2021-10-01" and "2021-12-31";

-- List customers without duplication.

select distinct * from customer;

-- Find all customers without a `.com` email address.

select distinct * from customer 
where email not like "%.com";

-- Find the three cheapest shows.

select 	s.title,
		p.price
from performance p 
inner join `show` s on p.show_id = s.show_id
order by p.price asc
limit 3;

-- List customers and the show they're attending with no duplication.

select 	distinct 	c.first_name,
					c.last_name,
					s.title
from customer c
inner join ticket t on c.customer_id = t.customer_id
inner join performance p on t.performance_id = p.performance_id
inner join `show` s ON p.show_id = s.show_id;


-- List customer, show, theater, and seat number in one query.

select 	c.first_name, 
		c.last_name,
		s.title,
		th.name as theater_name ,
		t.seat
from customer c
inner join ticket t on c.customer_id = t.customer_id
inner join performance p on t.performance_id = p.performance_id
inner join `show` s on s.show_id = p.show_id
inner join theater th on p.theater_id = th.theater_id;
 


-- Find customers without an address.
select * from customer 
where address = "";

-- Recreate the spreadsheet data with a single query.

select 	c.first_name, 
		c.last_name,
        c.email,
        c.phone,
        c.address,
        t.seat,
        s.title,
        p.price,
        p.date,
        th.name as theater_name ,
        th.address,
        th.phone,
        th.email
from customer c
inner join ticket t on c.customer_id = t.customer_id
inner join performance p on t.performance_id = p.performance_id
inner join `show` s on s.show_id = p.show_id
inner join theater th on p.theater_id = th.theater_id;


-- Count total tickets purchased per customer.

select 	c.first_name,
		c.last_name, 
        count(t.seat) as ticketsPurchasedPerCustomer
from customer c
inner join ticket t on c.customer_id = t.customer_id
group by c.customer_id
order by count(t.seat) desc;


-- Calculate the total revenue per show based on tickets sold.

select s.title as `Show`, sum(p.price) as total
from `show` s 
inner join performance p ON s.show_id = p.show_id
inner join ticket t ON p.performance_id = t.performance_id
group by s.title
order by total desc;

-- Calculate the total revenue per theater based on tickets sold.

select th.name as theater , sum(p.price) as total
from theater th
inner join performance p on th.theater_id = p.theater_id
inner join ticket t on p.performance_id = t.performance_id 
group by p.theater_id
order by total desc;



-- Who is the biggest supporter of RCTTC? Who spent the most in 2021?

select 	c.first_name,
		c.last_name,
        sum(p.price) as total
        from customer c 
        inner join ticket t on c.customer_id = t.customer_id
        inner join performance p on t.performance_id = p.performance_id
        group by c.customer_id
        order by total desc limit 1;
