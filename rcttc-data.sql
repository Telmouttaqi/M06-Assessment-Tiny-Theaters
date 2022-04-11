use TinyTheaters;

-- Write **INSERT** from-select statements to move the data from the denormalized table to the normalized tables

 -- 1) Customer Table
insert into customer (first_name, last_name, email, phone, address)
select distinct customer_first,
				customer_last,
                customer_email,
				customer_phone, 
                customer_address
from rcttc_data;

-- Test, if all the data sent to the customer table and verify 74 customer available.
select * from customer;

-- 2) Theater Table
insert into theater (address,phone,name, email)
select distinct 	theater_address,
					theater_phone,
                    theater,
                    theater_email
from rcttc_data;

-- Test, if all the data sent to the theater table correct should be 3 

select * from theater;

-- 3) Show Table
insert into `show` (title)
select distinct `show` from rcttc_data;

-- adding 3 missing shows
	insert into `show` (title)
	values 	("High School Musical"),
	("Ocean: the life of Frank Ocean as performed by Frank Ocean"),
	("Wen");

select * from `show`;

 -- 3) Performance Table 
 -- show_id , theater_id and pull date, price from rcttc_data
select 	date,
		ticket_price
        from rcttc_data;
        
insert into performance (show_id, theater_id, date, price)
select distinct s.show_id ,
				t.theater_id,
                rd.date,
                rd.ticket_price
                
                from rcttc_data rd
inner join `show` s on rd.show = s.title
inner join theater t on rd.theater = t.name;

select * from performance;

-- 4) Ticket Table

insert into ticket (customer_id, performance_id, seat)
select distinct c.customer_id,
				p.performance_id,
                rd.seat
from rcttc_data rd
inner join customer c on rd.customer_email  = c.email
inner join performance p 
on rd.date = p.date 
and rd.ticket_price = p.price;


-- display all of the table to make sure all the tables works well.
select * from customer;
select * from performance;
select * from `show`;
select * from theater;
select * from ticket;

-- updates
-- 1) 
-- The Little Fitz's 2021-03-01 performance of *The Sky Lit Up* is listed with a $20 ticket price. 
-- The actual price is $22.25 because of a visiting celebrity actor. (Customers were notified.) 
-- Update the ticket price for that performance only.

select distinct * from performance
where date = "2021-03-01";
-- performance id-5

update performance
set price = 22.25
where performance_id = 5;

select * from performance 
where performance_id = 5; -- check the price change from $20.00 to $22.25.


-- 2)

-- In the Little Fitz's 2021-03-01 performance of *The Sky Lit Up*, Pooh Bedburrow and Cullen Guirau seat reservations aren't 
-- in the same row. Adjust seating so all groups are seated together in a row. This may require updates to all reservations 
-- for that performance. Confirm that no seat is double-booked and that everyone 
-- who has a ticket is as close to their original seat as possible.

select 	p.performance_id ,
		c.customer_id ,
        c.first_name, 
        c.last_name ,
        th.name as theater_name,
        p.date,
        s.title, 
        p.price, 
        t.seat

from ticket t 
inner join customer c on t.customer_id = c.customer_id
inner join performance p on t.performance_id = p.performance_id 
inner join `show` s on p.show_id = s.show_id
inner join theater th on p.theater_id = th.theater_id
where date = "2021-03-01" and p.performance_id = 5
order by t.seat asc;

update ticket 
set seat = 'B4'
where performance_id = 5
and customer_id = 37 
and seat = 'A4';

update ticket 
set seat = 'C2'
where performance_id = 5
and customer_id = 38
and seat = 'B4';

update ticket 
set seat = 'A4'
where performance_id = 5
and customer_id = 39
and seat = 'C2';

-- 3) Update Jammie Swindles's phone number from "801-514-8648" to "1-801-EAT-CAKE".

select  customer_id,
		first_name, 
		last_name,
        phone
from customer 
where first_name = "Jammie";

update customer
set phone = "1-801-EAT-CAKE"
where customer_id = 48;

-- 4) Deletes

-- Delete *all* single-ticket reservations at the 10 Pin. (You don't have to do it with one query.)

select 	p.performance_id ,
		c.customer_id ,
        c.first_name, 
        c.last_name ,
        th.name,
        p.date,
        s.title, 
        p.price, 
        count(t.seat)

from ticket t 
inner join customer c on t.customer_id = c.customer_id
inner join performance p on t.performance_id = p.performance_id 
inner join `show` s on p.show_id = s.show_id
inner join theater th on p.theater_id = th.theater_id
where th.name = "10 pin"
group by customer_id , p.performance_id
having count(t.seat) = 1;


-- list of the customer should be delete 
-- performance_id ,customer id , full name , theater name , date , show name , price and the count of the seats

-- 1	7	Hertha	Glendining	10 Pin	2021-03-01	Send in the Clowns		15.00			1

delete from ticket where performance_id = 1 and customer_id = 7;

-- 2	8	Flinn	Crowcher	10 Pin	2021-09-24	Send in the Clowns		15.00			1

delete from ticket where performance_id = 2 and customer_id = 8;

-- 2	10	Lucien	Playdon		10 Pin	2021-09-24	Send in the Clowns		15.00			1
delete from ticket where performance_id = 2 and customer_id = 10;

-- 2	15	Brian	Bake		10 Pin	2021-09-24	Send in the Clowns		15.00			1
delete from ticket where performance_id = 2 and customer_id = 15;

-- 3	18	Loralie	Rois		10 Pin	2021-01-04	The Dress				14.85			1
delete from ticket where performance_id = 3 and customer_id = 18;

-- 3	19	Emily	Duffree		10 Pin	2021-01-04	The Dress				14.85			1
delete from ticket where performance_id = 3 and customer_id = 19;

-- 3	22	Giraud	Bachmann	10 Pin	2021-01-04	The Dress				14.85			1
delete from ticket where performance_id = 3 and customer_id = 22;

-- 3	25	Melamie	Feighry		10 Pin	2021-01-04	The Dress				14.85			1
delete from ticket where performance_id = 3 and customer_id = 25;

-- 4	26	Caye	Treher		10 Pin	2021-12-21	Tell Me What To Think	6.25 			1
delete from ticket where performance_id = 4 and customer_id = 26;


-- run to check the list == > return 0 row .

select 	p.performance_id ,
		c.customer_id ,
        c.first_name, 
        c.last_name ,
        th.name,
        p.date,
        s.title, 
        p.price, 
        count(t.seat)

from ticket t 
inner join customer c on t.customer_id = c.customer_id
inner join performance p on t.performance_id = p.performance_id 
inner join `show` s on p.show_id = s.show_id
inner join theater th on p.theater_id = th.theater_id
where th.name = "10 pin"
group by customer_id , p.performance_id
having count(t.seat) = 1;


-- 2) Delete the customer Liv Egle of Germany. It appears their reservations were an elaborate joke.

select 	p.performance_id ,
		c.customer_id ,
        c.first_name, 
        c.last_name ,
        th.name,
        p.date,
        s.title, 
        p.price, 
        t.seat

from ticket t 
inner join customer c on t.customer_id = c.customer_id
inner join performance p on t.performance_id = p.performance_id 
inner join `show` s on p.show_id = s.show_id
inner join theater th on p.theater_id = th.theater_id
where c.first_name = "Liv";

-- customer_id 		= 65
-- performance_id 	= 11

-- delete
delete from ticket where customer_id = 65 and performance_id = 11;

-- check if the reservation for the customer_id 65 still available 
select * from ticket
where customer_id = 65































        










                





                
 
 
 


        


