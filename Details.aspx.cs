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
    public partial class Details : System.Web.UI.Page
    {
        string s = ConfigurationManager.ConnectionStrings["ghostDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string placeId = Request.QueryString["ID"];

                if (!string.IsNullOrEmpty(placeId))
                {
                    LoadPlaceDetails(placeId);
                    LoadHauntedClaims(placeId);
                    LoadVideoEvidence(placeId);

                    int pid;
                    if (int.TryParse(placeId, out pid))
                    {
                        LoadImages(pid);
                    }
                }
                else
                {
                    Response.Redirect("Home.aspx");
                }
            }
        }
        private void LoadPlaceDetails(string id)
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                string query = @"
                    select G.*, I.ImageUrl 
                    from tbl_GMSData G
                    left join (
                        select PlaceId, min(ImageUrl) as ImageUrl from tbl_GMSImages group by PlaceId
                    ) I on G.PlaceId = I.PlaceId
                    where G.PlaceId = @ID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        litPlaceId.Text = dr["PlaceId"].ToString();
                        litPlaceName.Text = dr["PlaceName"].ToString();
                        litState.Text = dr["State"].ToString();
                        litShortSummary.Text = dr["ShortSummary"].ToString();
                        litDescription.Text = dr["Description"].ToString();
                        litPeriod.Text = dr["BuildrPeriodTime"].ToString();
                        litMap.Text = $"<iframe src='{dr["MapLink"]}' style='width:100%;height:100%;border:0;' loading='lazy'></iframe>";
                        if (dr["MapLink"] == DBNull.Value || string.IsNullOrWhiteSpace(dr["MapLink"].ToString()))
                        {
                            plcLocation.Visible = false;
                        }
                        else
                        {
                            plcLocation.Visible = true;
                        }
                        var img = Convert.ToString(dr["ImageUrl"]);

                        imgMain.ImageUrl = ResolveUrl(string.IsNullOrWhiteSpace(img) ? "~/images/ghost.png" : img
                        );
                    }
                }
            }
        }

        private void LoadHauntedClaims(string id)
        {
            BindRepeater(id, "select ClaimDescription from tbl_GMSHauntedClaims where PlaceId = @ID", rptClaims);
            rptClaims.Visible = rptClaims.Items.Count > 0;
        }

        private void LoadVideoEvidence(string id)
        {
            BindRepeater(id, "select YtUrl from tbl_GMSYtLinks where PlaceId = @ID", rptVideos);
            plcYtLinks.Visible = rptVideos.Items.Count > 0;
            phNoVideos.Visible = rptVideos.Items.Count == 0;
        }
        private void BindRepeater(string id, string query, System.Web.UI.WebControls.Repeater rpt)
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ID", id);
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                rpt.DataSource = dt;
                rpt.DataBind();
                rpt.Visible = dt.Rows.Count > 0;
            }
        }
        void LoadImages(int placeId)
        {
            using (var con = new SqlConnection(s))
            {
                var cmd = new SqlCommand("select ImageUrl from tbl_GMSImages where PlaceId=@Id", con);
                cmd.Parameters.AddWithValue("@Id", placeId);
                con.Open();
                var da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptImages.DataSource = dt;
                rptImages.DataBind();
                rptImages.Visible = dt.Rows.Count > 0;
            }
        }
    }
}