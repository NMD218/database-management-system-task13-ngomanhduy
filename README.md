# Personal Finance Management System

## 1. Project Overview
This project develops a Personal Finance Management System, a centralized web application designed to help users effectively store, track, and analyze personal income and expenses. The system securely manages user authentication, transaction records, and account balances while providing interactive dashboards for financial analytics and optimizing savings through data-driven reports.

## 2. Objectives
The main objectives of this project are:
- Design a relational database to store user accounts, bank accounts, categories, and financial transactions.
- Build a Python backend to interact seamlessly with the database.
- Implement an interactive web interface using Streamlit for intuitive user experience.
- Apply advanced SQL features including Views, Stored Procedures, Functions, and Triggers to ensure data consistency.
- Provide data-driven reports and analytics (e.g., Net Worth, Income/Expense distributions).

## 3. System Architecture
The application is structured as follows:

**Frontend & Backend (Python/Streamlit)**
- Authentication (Login/Register)
- Transaction Management
- Analytics Dashboard (Pandas, Plotly)
- Admin Controls
- Database Interaction (`mysql-connector-python`)

**Database (MySQL)**
- **Tables:** `user`, `bankaccount`, `category`, `income`, `expenses`
- **Views:** `view_categoryspending` (spending summaries by category)
- **Stored Procedures:** `MonthlyOperations` (monthly financial overview)
- **Functions:** `GetTotalNetWorth` (calculate total net worth)
- **Triggers:** Automatic balance updates upon income/expense insertion
- **Roles:** `admin_role`, `user_role` for access control

## 4. Project Structure
```text
PersonalFinanceManagement/
│
├── sql_python/
│   ├── SQL-web.py           # Main Streamlit app and authentication logic
│   ├── page_main.py         # Dashboard for transactions and analytics
│   ├── page_login.py        # Login UI and logic
│   └── SQLAlchemy.py        # Database connection layer and query functions
│
├── SQLAlchemy/
│   ├── final_test.sql       # Complete SQL script: schema, sample data, procedures, triggers
│   ├── schema.sql           # Database schema definitions
│   └── EER_diagram.png      # Entity-Relationship diagram
│
└── README.md
```

## 5. System Features
- **User Authentication:** Register new accounts and log in securely. Differentiates between regular `user` and `admin` roles.
- **Transaction Management:** Add new income and expenses, including details such as amount, date, and description/category.
- **Automated Balance Tracking:** Trigger-based updates to bank account balances whenever an income or expense is recorded.
- **Analytics Dashboard:**
  - View current Net Worth.
  - Interactive Pie Charts using Plotly for Income Distribution and Expense Allocation.
  - Monthly tabular reports for incomes and expenses.
- **Admin Controls:** Admins can view and delete any transactions from any user to maintain data integrity.

## 6. Setup & Installation
**Step 1: Database Setup**
- Ensure MySQL Server is running.
- Run the script `SQLAlchemy/final_test.sql` in your MySQL environment to create the `mydb` database, tables, and sample data.
- Adjust the database credentials in `sql_python/SQLAlchemy.py` inside the `get_connection()` function to match your local MySQL setup (username, password, etc.).

**Step 2: Python Dependencies**
- Install the required packages via `pip`:
  ```bash
  pip install streamlit pandas plotly mysql-connector-python
  ```

**Step 3: Start the Application**
- Navigate to the `sql_python` directory.
- Run the Streamlit app:
  ```bash
  cd sql_python
  streamlit run SQL-web.py
  ```

## 7. Evaluation Coverage
This project satisfies core database management and application development requirements:
- Relational Database schema design (EER Diagram)
- Frontend Web Application integration (Streamlit)
- Advanced SQL elements (Views, Triggers, Procedures, Functions)
- User role management, security, and authentication
- Automated data consistency and validation

