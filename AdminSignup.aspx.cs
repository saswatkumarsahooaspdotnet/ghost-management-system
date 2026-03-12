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
    public partial class AdminSignup : System.Web.UI.Page
    {
        string s = ConfigurationManager.ConnectionStrings["ghostDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnSignup_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtRecheck.Text.Trim();

            if (username == "" || password == "" || confirmPassword == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(),
                                                    "required",
                                                    @"Swal.fire({
                                                        title: 'Missing Fields!',
                                                        text: 'All fields are required.',
                                                        icon: 'warning',
                                                        confirmButtonText: 'OK'
                                                    });",
                                                    true);
                return;
            }

            if (password != confirmPassword)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(),
                                                                "mismatch",
                                                                @"Swal.fire({
                                                                    title: 'Oops!',
                                                                    text: 'Password doesn\'t match!',
                                                                    icon: 'error',
                                                                    confirmButtonText: 'OK'
                                                                });",
                                                                true);

                return;
            }

            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("select count(*) from tbl_LoginCred where username=@Username", con);
                cmd.Parameters.AddWithValue("@Username", username);

                int exists = (int)cmd.ExecuteScalar();
                if (exists > 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(),
                        "alert",
                        @"Swal.fire({
                                title: 'Admin Already Exists!',
                                text: 'Please try with another username.',
                                icon: 'info',
                                confirmButtonText: 'OK'
                            });",
                        true);

                    return;
                }

                SqlCommand cmd1 = new SqlCommand("insert into tbl_LoginCred (username, password) values (@Username, @Password)", con);

                cmd1.Parameters.AddWithValue("@Username", username);
                cmd1.Parameters.AddWithValue("@Password", password);

                cmd1.ExecuteNonQuery();
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(),
                                    "success",
                                    @"Swal.fire({
                                            title: 'Signup Successful!',
                                            text: 'Please login now.',
                                            icon: 'success',
                                            confirmButtonText: 'Go to Login'
                                        }).then(() => {
                                            window.location = 'AdminLogin.aspx';
                                        });",
                                    true);
        }
    }
}