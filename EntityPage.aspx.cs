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
    public partial class EntityPage : System.Web.UI.Page
    {
        string s = ConfigurationManager.ConnectionStrings["ghostDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string placeName = Request.QueryString["place"];

                if (!string.IsNullOrEmpty(placeName))
                    litStateName.Text = placeName + " — ";

                LoadLegends(placeName);
            }
        }
        private void LoadLegends(string placeName)
        {

            string query = @"
                select m.LegendId,m.LegendName,m.PlaceName,
                    isnull(left(a.Appearance, 150), 'No description available.') as ShortSummary,
                    isnull(img.ImageUrl, '~/images/default-ghost.jpg') as ImageUrl
                from UrbanLegendsMain m
                left join (
                    select LegendId, Appearance,
                           row_number() over (partition by LegendId order by AppearanceId) as rn
                    from UrbanLegendAppearance
                ) a on m.LegendId = a.LegendId and a.rn = 1
                left join (
                    select LegendId, ImageUrl,
                           row_number() over (partition by LegendId order by ImageId) as rn
                    from UrbanLegendImages
                ) img on m.LegendId = img.LegendId and img.rn = 1
                where m.IsActive = 1";

            if (!string.IsNullOrEmpty(placeName))
                query += " and m.PlaceName = @PlaceName";

            query += " order by m.LegendName";

            using (SqlConnection conn = new SqlConnection(s))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (!string.IsNullOrEmpty(placeName))
                    cmd.Parameters.AddWithValue("@PlaceName", placeName);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptGhostCards.DataSource = dt;
                    rptGhostCards.DataBind();
                    pnlNoData.Visible = false;
                }
                else
                {
                    rptGhostCards.DataSource = null;
                    rptGhostCards.DataBind();
                    pnlNoData.Visible = true;
                }
            }
        }
    }
}