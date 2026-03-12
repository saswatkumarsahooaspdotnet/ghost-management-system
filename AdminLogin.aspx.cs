using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ghost_series
{
    public partial class AdminLogin : System.Web.UI.Page
    {
        string s = ConfigurationManager.ConnectionStrings["ghostDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (username == "" || password == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(),
                "empty",
                @"Swal.fire({
            title: 'Missing Fields!',
            text: 'Please enter both Username and Password.',
            icon: 'warning',
            confirmButtonText: 'OK'
        });",
                true);
                return;
            }
            try
            {
                using (SqlConnection con = new SqlConnection(s))
                {
                    con.Open();

                    string query = "select * from tbl_LoginCred where username=@Username and password=@Password";
                    SqlCommand cmd = new SqlCommand(query, con);

                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", password);

                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.HasRows)
                    {
                        dr.Read();
                        Session["username"] = dr["username"].ToString();
                        Session["Admin"] = "true";
                        ScriptManager.RegisterStartupScript(this, this.GetType(),
                        "success",
                        @"Swal.fire({
                            title: 'Login Successful!',
                            text: 'Welcome Admin 😊',
                            icon: 'success',
                            confirmButtonText: 'Continue'
                        }).then(() => {
                            window.location = 'AdminCards.aspx';
                        });",
                        true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(),
                                            "invalid",
                                            @"Swal.fire({
                                        title: 'Login Failed!',
                                        text: 'Invalid Username or Password.',
                                        icon: 'error',
                                        confirmButtonText: 'Try Again'
                                    });",
                        true);
                    }
                }
            }
            catch (SqlException)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(),
                "dbError",
                @"Swal.fire({
            title: 'Database Error!',
            text: 'Something went wrong while connecting.',
            icon: 'error',
            confirmButtonText: 'OK'
        });",
                true);
            }
            catch (Exception ex)
            {
                string msg = ex.Message.Replace("'", "\\'");

                ScriptManager.RegisterStartupScript(this, this.GetType(),
                "exception",
                $@"Swal.fire({{
            title: 'Unexpected Error!',
            text: '{msg}',
            icon: 'error',
            confirmButtonText: 'OK'
        }});",
                true);
            }
        }

    }
}