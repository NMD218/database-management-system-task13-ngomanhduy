import streamlit as st
import SQLAlchemy
import page_main

st.set_page_config(page_title="Finance Manager", layout="wide")

if 'logged_in' not in st.session_state:
    st.session_state.logged_in = False

if not st.session_state.logged_in:
    st.title("Welcome to Personal Finance 💰")
    tab_login, tab_register = st.tabs(["🔒 Login", "📝 Register New Account"])
    
    with tab_login:
        with st.form("login_form"):
            st.subheader("Sign In")
            login_user = st.text_input("User Name (e.g., admin, Ngô Mạnh Duy...)")
            login_pass = st.text_input("Password", type="password")
            if st.form_submit_button("Login", use_container_width=True):
                if login_user and login_pass:
                    user = SQLAlchemy.check_login(login_user, login_pass)
                    if user:
                        st.session_state.logged_in = True
                        st.session_state.username = user['user_name']
                        st.session_state.user_id = user['user_id']
                        st.session_state.role = 'admin' if user['user_name'].lower() == 'admin' else 'user'
                        st.rerun()
                    else:
                        st.error("❌ Incorrect username or password! Please try again.")
                else:
                    st.warning("⚠️ Please enter both User Name and Password!")

    with tab_register:
        with st.form("register_form", clear_on_submit=True):
            st.subheader("Create a New Account")
            new_fullname = st.text_input("User Name *")
            new_pass = st.text_input("Password *", type="password")
            new_email = st.text_input("Email *")
            new_phone = st.text_input("Phone Number *")
            if st.form_submit_button("Create Account", use_container_width=True):
                if all([new_fullname, new_pass, new_email, new_phone]):
                    if SQLAlchemy.register_user(new_fullname, new_email, new_phone, new_pass):
                        st.success("✅ Registration successful! Please switch to the Login tab.")
                    else:
                        st.error("❌ User Name already exists!")
                else:
                    st.warning("⚠️ Please fill in all required fields!")
else:
    with st.sidebar:
        st.write(f"Hello, **{st.session_state.username}** 👋")
        st.caption(f"Role: {'🛡️ Admin' if st.session_state.role == 'admin' else '👤 User'}")
        st.divider()
        if st.button("🚪 Logout", use_container_width=True, type="primary"):
            st.session_state.clear()
            st.rerun()
    page_main.show()