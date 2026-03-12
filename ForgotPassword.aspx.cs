using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ghost_series
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        string s = ConfigurationManager.ConnectionStrings["ghostDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnReset_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtRecheck.Text.Trim();

            if (string.IsNullOrEmpty(username))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "Swal.fire('Error','Please enter username/email!','error');", true);
                return;
            }

            if (string.IsNullOrEmpty(password))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "Swal.fire('Error','Please enter new password!','error');", true);
                return;
            }

            if (string.IsNullOrEmpty(confirmPassword))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "Swal.fire('Error','Please confirm your password!','error');", true);
                return;
            }

            if (password.Length < 6)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "Swal.fire('Error','Password must be at least 6 characters long!','error');", true);
                return;
            }
            if (password != confirmPassword)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "Swal.fire('Error','Passwords do not match!','error');", true);
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(s))
                {
                    con.Open();

                    string checkUser = "select count(*) from tbl_LoginCred where username=@Username";
                    SqlCommand cmdCheck = new SqlCommand(checkUser, con);
                    cmdCheck.Parameters.AddWithValue("@Username", username);

                    int userExists = Convert.ToInt32(cmdCheck.ExecuteScalar());

                    if (userExists == 0)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                            "Swal.fire('Error','User not found!','error');", true);
                        return;
                    }

                    string updateQuery = "update tbl_LoginCred set password=@Password where username=@Username";
                    SqlCommand cmdUpdate = new SqlCommand(updateQuery, con);
                    cmdUpdate.Parameters.AddWithValue("@Password", password);
                    cmdUpdate.Parameters.AddWithValue("@Username", username);

                    cmdUpdate.ExecuteNonQuery();

                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        "Swal.fire('Success','Password reset successfully!','success')" +
                        ".then(()=>{window.location='AdminLogin.aspx';});", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "Swal.fire('Error','Something went wrong: " + ex.Message + "','error');", true);
            }
        }

    }
}