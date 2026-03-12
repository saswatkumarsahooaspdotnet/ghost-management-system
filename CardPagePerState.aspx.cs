using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ghost_series
{
    public partial class CardPagePerState : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["ghostDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get the state name from the URL query string (e.g., CardPagePerState.aspx?state=Odisha)
                string selectedState = Request.QueryString["state"];

                if (!string.IsNullOrEmpty(selectedState))
                {
                    litStateName.Text = selectedState;
                    LoadGhostData(selectedState);
                }
                else
                {
                    Response.Redirect("Home.aspx");
                }
            }
        }
        private void LoadGhostData(string stateName)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
                        select a.PlaceId, a.State, a.PlaceName, a.ShortSummary, 
                               isnull(b.ImageUrl, '~/images/default-ghost.png') as ImageUrl
                        from tbl_GMSData a
                        left join (
                            select PlaceId, min(ImageUrl) as ImageUrl 
                            from tbl_GMSImages 
                            group by PlaceId
                        ) b on a.PlaceId = b.PlaceId
                        where a.State = @StateName";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@StateName", stateName);

                try
                {
                    SqlDataAdapter sda = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    sda.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptGhostCards.DataSource = dt;
                        rptGhostCards.DataBind();
                    }
                    else
                    {
                        pnlNoData.Visible = true;
                    }
                }
                catch (Exception)
                {
                    litStateName.Text = "ERROR ACCESSING ARCHIVES";
                }
            }
        }
    }   
}
