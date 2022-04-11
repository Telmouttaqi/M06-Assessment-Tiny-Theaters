
create database TinyTheaters ;
	use TinyTheaters ;
    
create table customer (

customer_id int primary key auto_increment,
first_name varchar(25) not null,
last_name varchar(25) not null,
phone varchar(25) default null,
email varchar(50)default null,
address varchar(50) default null
);

create table theater (

theater_id int primary key auto_increment,
address varchar(50) not null,
phone varchar(50) not null,
name varchar(50) not null,
email varchar(50) not null

);

create table `show` (
show_id int primary key auto_increment,
title varchar(100) not null
);

create table performance (
performance_id int primary key auto_increment,
show_id int not null,
theater_id int not null,
date date not null,
price decimal(4,2) not null,

constraint fk_performance_show_id foreign key(show_id) references `show`(show_id),
constraint fk_performance_theater_id foreign key(theater_id) references theater(theater_id)

);


create table ticket (
ticket_id int primary key auto_increment,
customer_id int not null,
performance_id int not null,
seat varchar(5) not null,
constraint fk_ticket_customer_id foreign key (customer_id) references customer(customer_id),
constraint fk_ticket_performance_id foreign key (performance_id) references performance(performance_id)
);