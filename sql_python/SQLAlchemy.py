import mysql.connector
import pandas as pd

def get_connection():
    # Điều chỉnh password nếu MySQL của bạn dùng mật khẩu khác
    return mysql.connector.connect(
        host="localhost", user="root", password="Duy2182006@", database="mydb"
    )

def check_login(user_name_input, password_input):
    conn = get_connection()
    query = "SELECT user_id, user_name FROM users WHERE user_name = %s AND password = %s"
    df = pd.read_sql(query, conn, params=(user_name_input, password_input))
    conn.close()
    return df.iloc[0].to_dict() if not df.empty else None

def register_user(full_name_input, email_input, phone_input, password_input):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE user_name = %s", (full_name_input,))
    if cursor.fetchone():
        conn.close(); return False 
    cursor.execute("INSERT INTO users (user_name, email, phone_number, password) VALUES (%s, %s, %s, %s)", 
                   (full_name_input, email_input, phone_input, password_input))
    conn.commit()
    conn.close()
    return True

def get_user_profile(user_id):
    conn = get_connection()
    df = pd.read_sql("SELECT user_name as 'Full Name', email as 'Email', phone_number as 'Phone Number' FROM users WHERE user_id = %s", conn, params=(user_id,))
    conn.close()
    return df.fillna('N/A')

def get_all_users():
    conn = get_connection()
    df = pd.read_sql("SELECT user_id, user_name FROM users WHERE user_name != 'admin'", conn)
    conn.close()
    return df

def get_expense_categories_list():
    conn = get_connection()
    # Dùng DISTINCT để MySQL tự động lọc trùng
    df = pd.read_sql("SELECT DISTINCT category_name FROM expensecategories", conn)
    conn.close()
    if not df.empty:
        categories = df['category_name'].tolist()
        # Dùng set() để lọc trùng lần 2 ở Python và sorted() để sắp xếp A-Z
        return sorted(list(set(categories))) 
    return []

def get_income_descriptions_list():
    conn = get_connection()
    df = pd.read_sql("SELECT DISTINCT description FROM income WHERE description IS NOT NULL AND description != ''", conn)
    conn.close()
    if not df.empty:
        descriptions = df['description'].tolist()
        return sorted(list(set(descriptions)))
    return []

def add_income(user_id, amount, date, description):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO income (user_id, amount, income_date, description) VALUES (%s, %s, %s, %s)", (user_id, amount, date, description))
    conn.commit()
    conn.close()

def get_incomes(user_id, role):
    conn = get_connection()
    if role == 'admin':
        query = "SELECT i.income_id as 'ID', u.user_name as 'User', i.amount as 'Amount', i.income_date as 'Date', i.description as 'Description' FROM income i JOIN users u ON i.user_id = u.user_id ORDER BY i.income_date DESC"
        df = pd.read_sql(query, conn)
    else:
        query = "SELECT income_id as 'ID', amount as 'Amount', income_date as 'Date', description as 'Description' FROM income WHERE user_id = %s ORDER BY income_date DESC"
        df = pd.read_sql(query, conn, params=(user_id,))
    conn.close()
    return df

def add_expense(user_id, amount, category, date, description):
    conn = get_connection()
    cursor = conn.cursor()
    
    # Kiểm tra xem danh mục có tồn tại chưa, nếu chưa thì thêm mới vào DB
    cursor.execute("SELECT category_id FROM expensecategories WHERE category_name = %s", (category,))
    cat_result = cursor.fetchone()
    
    if cat_result: 
        cat_id = cat_result[0]
    else:
        cursor.execute("INSERT INTO expensecategories (category_name) VALUES (%s)", (category,))
        cat_id = cursor.lastrowid
        
    cursor.execute("INSERT INTO expenses (user_id, category_id, amount, expense_date, description) VALUES (%s, %s, %s, %s, %s)", (user_id, cat_id, amount, date, description))
    conn.commit()
    conn.close()

def get_expenses(user_id, role):
    conn = get_connection()
    if role == 'admin':
        query = "SELECT e.expense_id as 'ID', u.user_name as 'User', c.category_name as 'Category', e.amount as 'Amount', e.expense_date as 'Date', e.description as 'Description' FROM expenses e JOIN expensecategories c ON e.category_id = c.category_id JOIN users u ON e.user_id = u.user_id ORDER BY e.expense_date DESC"
        df = pd.read_sql(query, conn)
    else:
        query = "SELECT e.expense_id as 'ID', c.category_name as 'Category', e.amount as 'Amount', e.expense_date as 'Date', e.description as 'Description' FROM expenses e JOIN expensecategories c ON e.category_id = c.category_id WHERE e.user_id = %s ORDER BY e.expense_date DESC"
        df = pd.read_sql(query, conn, params=(user_id,))
    conn.close()
    return df

def get_net_worth(user_id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT SUM(balance) FROM bankAccounts WHERE user_id = %s", (user_id,))
    res = cursor.fetchone()
    conn.close()
    return float(res[0]) if res and res[0] else 0.0

def get_monthly_operations(user_id, month, year):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.callproc('MonthlyOperations', (user_id, month, year))
        results = []
        for rs in cursor.stored_results():
            results.extend(rs.fetchall())
        df = pd.DataFrame(results) if results else pd.DataFrame(columns=['Transaction Type', 'Amount'])
    except Exception as e: 
        df = pd.DataFrame(columns=['Transaction Type', 'Amount'])
    finally: 
        cursor.close()
        conn.close()
    return df

def get_expense_summary(user_id, role):
    conn = get_connection()
    if role == 'admin':
        df = pd.read_sql("SELECT `Category` as category, SUM(`Payment`) as total FROM view_categoryspending GROUP BY `Category`", conn)
    else:
        df = pd.read_sql("SELECT `Category` as category, `Payment` as total FROM view_categoryspending WHERE `User` = (SELECT user_name FROM users WHERE user_id = %s)", conn, params=(user_id,))
    conn.close()
    return df

def get_income_summary(user_id, role):
    conn = get_connection()
    if role == 'admin':
        df = pd.read_sql("SELECT description, SUM(amount) as total FROM income GROUP BY description", conn)
    else:
        df = pd.read_sql("SELECT description, SUM(amount) as total FROM income WHERE user_id = %s GROUP BY description", conn, params=(user_id,))
    conn.close()
    return df

def delete_income(id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM income WHERE income_id = %s", (id,))
    conn.commit()
    conn.close()

def delete_expense(id):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM expenses WHERE expense_id = %s", (id,))
    conn.commit()
    conn.close()