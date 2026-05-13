import streamlit as st
import SQLAlchemy

def show():
    _, col, _ = st.columns([1, 2, 1])
    with col:
        st.title("🔑 Finance Manager")
        with st.form("login_form"):
            username = st.text_input("Username")
            password = st.text_input("Password", type="password")
            if st.form_submit_button("Login", use_container_width=True):
                user = SQLAlchemy.check_login(username, password)
                if user:
                    st.session_state.is_logged_in = True
                    st.session_state.user_id = user['user_id']
                    st.session_state.username = user['user_name']
                    st.session_state.role = user['role']
                    st.rerun()
                else:
                    st.error("❌ Invalid username or password!")