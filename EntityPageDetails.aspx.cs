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
    public partial class EntityPageDetails : System.Web.UI.Page
    {
        string s = ConfigurationManager.ConnectionStrings["ghostDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string rawId = Request.QueryString["ID"];

                if (string.IsNullOrEmpty(rawId) || !int.TryParse(rawId, out int legendId))
                {
                    Response.Redirect("EntityPage.aspx");
                    return;
                }

                LoadLegendDetails(legendId);
            }
        }
        private void LoadLegendDetails(int legendId)
        {
            using (SqlConnection conn = new SqlConnection(s))
            {
                conn.Open();
                string mainQuery = "SELECT m.LegendId, m.LegendName, m.PlaceName, " +
                   "ISNULL(img.ImageUrl, 'images/ghost.png') AS FirstImage " +
                   "FROM UrbanLegendsMain m " +
                   "LEFT JOIN ( " +
                   "    SELECT LegendId, ImageUrl, " +
                   "    ROW_NUMBER() OVER (PARTITION BY LegendId ORDER BY ImageId) AS rn " +
                   "    FROM UrbanLegendImages " +
                   ") img ON m.LegendId = img.LegendId AND img.rn = 1 " +
                   "WHERE m.LegendId = @LegendId AND m.IsActive = 1";

                using (SqlCommand cmd = new SqlCommand(mainQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@LegendId", legendId);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            litLegendId.Text = dr["LegendId"].ToString();
                            litLegendName.Text = dr["LegendName"].ToString();
                            litPlaceName.Text = dr["PlaceName"].ToString();
                            imgPortrait.ImageUrl = ResolveUrl(Convert.ToString(dr["FirstImage"]));
                            imgPortrait.AlternateText = dr["LegendName"].ToString();
                        }
                        else
                        {
                            Response.Redirect("EntityPage.aspx");
                            return;
                        }
                    }
                }

                BindRepeater(conn,
                    "select Appearance from UrbanLegendAppearance where LegendId = @Id",
                    legendId, rptAppearance, pnlNoAppearance);

                BindRepeater(conn,
                    "select AbilityName from UrbanLegendAbilities where LegendId = @Id",
                    legendId, rptAbilities, pnlNoAbilities);

                BindRepeater(conn,
                    "select SightingDescription from UrbanLegendSightings where LegendId = @Id",
                    legendId, rptSightings, pnlNoSightings);

                BindRepeater(conn,
                    "select TheoriesDescription from UrbanLegendTheories where LegendId = @Id",
                    legendId, rptTheories, pnlNoTheories);

                string imgQuery = "select ImageUrl from UrbanLegendImages where LegendId = @Id";
                using (SqlCommand cmd = new SqlCommand(imgQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", legendId);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptGallery.DataSource = dt;
                        rptGallery.DataBind();
                        pnlNoImages.Visible = false;
                    }
                    else
                    {
                        pnlNoImages.Visible = true;
                    }
                }
            }
        }
        private void BindRepeater(SqlConnection conn, string query, int legendId, Repeater repeater, Panel noDataPanel)
        {
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Id", legendId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    repeater.DataSource = dt;
                    repeater.DataBind();
                    noDataPanel.Visible = false;
                }
                else
                {
                    repeater.DataSource = null;
                    repeater.DataBind();
                    noDataPanel.Visible = true;
                }
            }
        }
    }
}