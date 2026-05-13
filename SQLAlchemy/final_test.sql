create database if not exists mydb;
use mydb;

-- 1. DATABASE
insert into users (user_name, email, phone_number) values
('Elon Musk', 'elonmusk@gmail.com', '0912345678'),
('Taylor Swift', 'taylorswift@gmail.com', '0987654321'),
('Lionel Meold_valuessi', 'leonelmessi@gmail.com', '0901234567'),
('Mark Zuckerberg', 'markzuckerberg@gmail.com', '0934567890'),
('Micheal Jackson', 'michealjackson@gmail.co', '0978123456');

insert into expensecategories (category_name) values
('Food & Dining'),
('Transportation'),
('Education & Books'),
('Utilities & Bills'),
('Entertainment & Shopping');

insert into bankAccounts (user_id, bank_name, balance) values
(1, 'Techcombank', 600000000),
(2, 'Momo', 120000000),
(3, 'Vietcombank', 150000000),
(4, 'MBBank', 500000000),
(5, 'TPBank', 840000000);

insert into income (user_id, amount, income_date, description) values
(1, 3000000, '2026-04-01', 'Commission'),
(2, 500000, '2026-04-02', 'Allowance'),
(3, 12000000, '2026-03-25', 'Salary'),
(4, 2000000, '2026-04-01', 'Award'),
(5, 5000000, '2026-03-28', 'Bonus');

insert into expenses (user_id, category_id, amount, expense_date, description) values
(1, 1, 40, '2026-04-01', 'Eating'),
(2, 2, 250, '2026-04-01', 'Repairment'),
(3, 3, 50, '2026-04-02', 'Snacks'),
(4, 4, 120, '2026-04-02', 'Watching movies'),
(5, 5, 350, '2026-03-30', 'Electricity bill');

-- 2. CREATE INDEXES
create index idx_user_name on users (user_name);
create index idx_expense_date on expenses (expense_date);
create index idx_expense_category on expenses (category_id);
create index idx_income_date on income (income_date);

-- 3. CREATE VIEWS
create or replace view view_categoryspending as
select u.user_name as 'User', ec.category_name as 'Category', sum(e.amount) as 'Payment'
from users u
join expenses e on u.user_id = e.user_id
join expensecategories ec on e.category_id = ec.category_id
group by u.user_id, ec.category_id;

-- 4. CREATE STORED PROCEDURES
delimiter $$
drop procedure if exists MonthlyOperations$$
create procedure MonthlyOperations (in p_user int, in p_month int, in p_year int)
begin 
    select 'Total Income' as 'Transaction Type', ifnull(sum(amount),0) as 'Amount'
    from income
    where user_id = p_user and month(income_date) = p_month and year(income_date) = p_year
    union all
    select 'Total Expense' as 'Transaction Type', ifnull(sum(amount),0) as 'Amount'
    from expenses
    where user_id = p_user and month(expense_date) = p_month and year(expense_date) = p_year;
end$$
delimiter ;

-- 5. CREATE FUNCTIONS
delimiter $$
drop function if exists GetTotalNetWorth $$
create function GetTotalNetWorth(p_user_id int) 
returns decimal(15,2)
reads sql data
begin
    declare total_balance decimal(15,2);
    select SUM(balance) into total_balance 
    from bankaccounts 
    where user_id = p_user_id;   
    return ifnull(total_balance, 0);
end$$
delimiter ;

-- 6. CREATE TRIGGERS
delimiter $$
drop trigger if exists after_income_insert $$
create trigger after_income_insert
after insert on income
for each row
begin
    update bankaccounts
    set balance = balance + new.amount
    where user_id = new.user_id
    order by account_id asc 
    limit 1; 
end $$

drop trigger if exists after_expense_insert $$
create trigger after_expense_insert
after insert on expenses
for each row
begin
    update bankaccounts
    set balance = balance - new.amount
    where user_id = new.user_id
    order by account_id asc 
    limit 1;
end $$
delimiter ;

-- 7. CREATE ROLES
create role 'admin_role', 'user_role';
grant all privileges on mydb.* to 'admin_role';

grant select, insert, update on mydb.income to 'user_role';
grant select, insert, update on mydb.expenses to 'user_role';
grant select, update on mydb.bankaccounts to 'user_role';
grant select on mydb.view_categoryspending to 'user_role';

create user 'nganhang_admin'@'localhost' identified by 'admin_mat_khau_123';
grant 'admin_role' to 'nganhang_admin'@'localhost';

create user 'khachhang_app'@'localhost' identified by 'user_mat_khau_456';
grant 'user_role' to 'khachhang_app'@'localhost';

flush privileges;
