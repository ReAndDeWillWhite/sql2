drop database Market;

create database Market;
use Market;

create table Users(
    name varchar(25) unique primary key,
    email varchar(25) unique not null,
    phone varchar(15) unique not null,
    registration_date date not null
);

create index idx_email
    on Users (email);
    
create table Orders(
    orderId int primary key auto_increment,
    name varchar(25) not null,
    amount int not null check(amount > 0),
    order_date date not null,
    order_status varchar(25) not null check(order_status in ("В пути", "Готов к выдаче", "Отменен")),
    foreign key (name) references Users(name)
);

create index idx_order_date
    on Orders (order_date);

insert into
    Users(name, email, phone, registration_date)
values
    ("user1","user1@mail.com","123-456-7890","2000-01-01"),
    ("user2","user2@mail.com","987-654-3210","2005-05-05"),
    ("user3","user3@mail.com","555-1212-1212","2010-10-10"),
    ("user4","user4@mail.com","111-222-3333","2015-01-01"),
    ("user5","user5@mail.com","777-888-9999","2020-02-02");

insert into
    Orders(name, amount, order_date, order_status)
values
    ("user1", 100,"2000-01-01","В пути"),
    ("user1", 200,"2005-02-02","В пути"),
    ("user2", 3000,"2010-03-03","В пути"),
    ("user2", 4000,"2015-04-04","Готов к выдаче"),
    ("user3", 1000,"2020-05-05","Готов к выдаче"),
    ("user3", 2000,"2016-06-06","Готов к выдаче"),
    ("user4", 3000,"2024-12-12","В пути"),
    ("user4", 4000,"2018-08-08","Отменен");
    
select Users.name, email, phone, registration_date, amount, order_date, order_status, orderId from Users inner join Orders on Users.name = Orders.name order by order_date desc;

select Users.name, email, phone, registration_date from Users left join Orders on Users.name = Orders.name where orderId is null order by registration_date desc;

select Users.name, count(orderId) as 'Кол. заказов' from Users inner join Orders on Users.name = Orders.name group by Users.name;

select * from Users inner join Orders on Users.name = Orders.name order by order_status, order_date desc;

select Users.name, sum(amount) as 'Общая сумма' from Users inner join Orders on Users.name = Orders.name group by Users.name having sum(amount) > 1000;

select Users.name from Users inner join Orders on Users.name = Orders.name where order_status = "Отменен" group by name;

select Users.name, min(amount) from Users inner join Orders on Users.name = Orders.name group by Users.name having min(amount) < 500;

select Users.name, email, phone, registration_date from Users inner join Orders on Users.name = Orders.name where order_date between registration_date and adddate(registration_date, interval 1 month) group by Users.name;

select Users.name, registration_date, order_date from Users inner join Orders on Users.name = Orders.name where adddate(registration_date, interval 1 year) < curdate() and adddate(order_date, interval 6 month) < curdate();

select Users.name, order_date from Users inner join Orders on Users.name = Orders.name where adddate(order_date, interval 28 day) > curdate();