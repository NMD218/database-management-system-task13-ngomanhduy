import streamlit as st
import SQLAlchemy
import pandas as pd
import plotly.express as px
from datetime import datetime

def show():
    st.title("📊 Financial Tracking & Reporting")
    is_admin = (st.session_state.role == 'admin')
    
    if not is_admin:
        col_p1, col_p2 = st.columns([2, 1])
        with col_p1:
            st.subheader("👤 Profile Info")
            st.dataframe(SQLAlchemy.get_user_profile(st.session_state.user_id), use_container_width=True, hide_index=True)
        with col_p2:
            st.subheader("💎 Net Worth")
            st.metric(label="Current Balance", value=f"${SQLAlchemy.get_net_worth(st.session_state.user_id):,.0f}")
        st.divider()

    if is_admin: 
        tab_main, tab_admin = st.tabs(["💸 Transactions & Reporting", "🛡️ Admin Controls"])
    else: 
        tab_main = st.container()

    df_inc = SQLAlchemy.get_incomes(st.session_state.user_id, st.session_state.role)
    df_exp = SQLAlchemy.get_expenses(st.session_state.user_id, st.session_state.role)
    
    df_users = SQLAlchemy.get_all_users()
    user_dict = dict(zip(df_users['user_name'], df_users['user_id']))
    
    # Lọc bỏ chữ "Others" nếu nó đã tồn tại trong DB, rồi tự động thêm 1 chữ "Others" duy nhất vào cuối danh sách
    inc_desc_list = [d for d in SQLAlchemy.get_income_descriptions_list() if d.lower() != 'others']
    exp_cat_list = [c for c in SQLAlchemy.get_expense_categories_list() if c.lower() != 'others']

    with tab_main:
        st.subheader("💸 Transactions Management")
        c1, c2 = st.columns(2)
        with c1:
            with st.container(border=True):
                st.write("**💰 Add Income**")
                if is_admin: target_u = st.selectbox("Assign User", list(user_dict.keys()), key="iu")
                amt = st.number_input("Amount", min_value=0.0, key="ia")
                dt = st.date_input("Date", key="id")
                
                # Bỏ Text Box, chỉ dùng Select Box
                final_desc = st.selectbox("Description", inc_desc_list + ["Others"], key="is")
                    
                if st.button("Submit Income", use_container_width=True):
                    t_id = user_dict[target_u] if is_admin else st.session_state.user_id
                    SQLAlchemy.add_income(t_id, amt, dt, final_desc)
                    st.rerun()
                        
            st.write("**📋 Income Report**")
            st.dataframe(df_inc, use_container_width=True, height=250, hide_index=True)
            
        with c2:
            with st.container(border=True):
                st.write("**💸 Add Expense**")
                if is_admin: target_ue = st.selectbox("Assign User", list(user_dict.keys()), key="eu")
                amt_e = st.number_input("Amount", min_value=0.0, key="ea")
                dt_e = st.date_input("Date", key="ed")
                
                # Bỏ Text Box, chỉ dùng Select Box
                final_cat = st.selectbox("Category", exp_cat_list + ["Others"], key="es")
                desc_e = st.text_input("Description", key="edesc")
                
                if st.button("Submit Expense", use_container_width=True):
                    t_id_e = user_dict[target_ue] if is_admin else st.session_state.user_id
                    SQLAlchemy.add_expense(t_id_e, amt_e, final_cat, dt_e, desc_e)
                    st.rerun()
                        
            st.write("**📋 Expense Report**")
            st.dataframe(df_exp, use_container_width=True, height=250, hide_index=True)

        st.divider()
        st.header("📈 Analytics Dashboard")
        st.subheader("📅 Monthly Report")
        m1, m2, m3 = st.columns([1,1,2])
        m = m1.selectbox("Month", range(1, 13), index=datetime.now().month-1)
        y = m2.selectbox("Year", range(2020, 2030), index=6)
        tid = st.session_state.user_id
        if is_admin: 
            tid = user_dict[m3.selectbox("View User", list(user_dict.keys()))]
            
        st.dataframe(SQLAlchemy.get_monthly_operations(tid, m, y), use_container_width=True, hide_index=True)

        r1, r2 = st.columns(2)
        with r1:
            st.write("**Income Distribution**")
            df_si = SQLAlchemy.get_income_summary(st.session_state.user_id, st.session_state.role)
            if not df_si.empty:
                st.plotly_chart(px.pie(df_si, values='total', names='description', hole=0.4), use_container_width=True)
                df_si['total'] = df_si['total'].apply(lambda x: f"{float(x):,.0f}")
                st.table(df_si)
        with r2:
            st.write("**Expense Allocation**")
            df_se = SQLAlchemy.get_expense_summary(st.session_state.user_id, st.session_state.role)
            if not df_se.empty:
                st.plotly_chart(px.pie(df_se, values='total', names='category', hole=0.4), use_container_width=True)
                df_se['total'] = df_se['total'].apply(lambda x: f"{float(x):,.0f}")
                st.table(df_se)

    if is_admin:
        with tab_admin:
            st.subheader("🛡️ Admin Controls")
            d1, d2 = st.columns(2)
            
            with d1:
                if not df_inc.empty:
                    del_inc_id = st.selectbox("Select Income ID to Delete", df_inc['ID'].tolist())
                    if st.button("Delete Selected Income", type="primary", use_container_width=True): 
                        SQLAlchemy.delete_income(del_inc_id)
                        st.rerun()
                else:
                    st.info("No income records available.")
                    
            with d2:
                if not df_exp.empty:
                    del_exp_id = st.selectbox("Select Expense ID to Delete", df_exp['ID'].tolist())
                    if st.button("Delete Selected Expense", type="primary", use_container_width=True): 
                        SQLAlchemy.delete_expense(del_exp_id)
                        st.rerun()
                else:
                    st.info("No expense records available.")