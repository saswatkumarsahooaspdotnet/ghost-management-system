using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ghost_series
{
    public partial class AdminPage : System.Web.UI.Page
    {
        string s = ConfigurationManager.ConnectionStrings["ghostDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {


            if (!IsPostBack)
                BindPlaces();


        }

        [WebMethod, ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> AddImage(string imagePath)
        {
            var list = HttpContext.Current.Session["Images"] as List<string> ?? new List<string>();
            list.Add(imagePath);
            HttpContext.Current.Session["Images"] = list;
            return list;
        }

        [WebMethod]
        public static List<string> DeleteImage(int index)
        {
            var list = HttpContext.Current.Session["Images"] as List<string> ?? new List<string>();

            if (index >= 0 && index < list.Count)
            {
                string physical = HttpContext.Current.Server.MapPath(list[index]);
                if (File.Exists(physical)) File.Delete(physical);
                list.RemoveAt(index);
            }

            HttpContext.Current.Session["Images"] = list;
            return list;
        }

        [WebMethod, ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> AddClaim(string claim, int index)
        {
            var list = HttpContext.Current.Session["Claims"] as List<string> ?? new List<string>();

            if (index >= 0 && index < list.Count) list[index] = claim;
            else list.Add(claim);

            HttpContext.Current.Session["Claims"] = list;
            return list;
        }

        [WebMethod]
        public static List<string> DeleteClaim(int index)
        {
            var list = HttpContext.Current.Session["Claims"] as List<string> ?? new List<string>();
            if (index >= 0 && index < list.Count) list.RemoveAt(index);
            HttpContext.Current.Session["Claims"] = list;
            return list;
        }

        [WebMethod, ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> AddYoutube(string link)
        {
            var list = HttpContext.Current.Session["Youtube"] as List<string> ?? new List<string>();
            list.Add(link);
            HttpContext.Current.Session["Youtube"] = list;
            return list;
        }

        [WebMethod]
        public static List<string> DeleteYoutube(int index)
        {
            var list = HttpContext.Current.Session["Youtube"] as List<string> ?? new List<string>();
            if (index >= 0 && index < list.Count) list.RemoveAt(index);
            HttpContext.Current.Session["Youtube"] = list;
            return list;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            using (var con = new SqlConnection(s))
            {
                con.Open();
                var tr = con.BeginTransaction();

                try
                {
                    int placeId;

                    if (!string.IsNullOrEmpty(hfPlaceID.Value))
                    {
                        placeId = Convert.ToInt32(hfPlaceID.Value);

                        var update = new SqlCommand(@"
                            update tbl_GMSData set
                            State=@State, PlaceName=@Place, ShortSummary=@Short, Description=@Desc,
                            BuildrPeriodTime=@Period, MapLink=@Map, Settings=@Settings,
                            ArchStateToday=@Arch, IsActive=@Active where PlaceId=@Id", con, tr);

                        FillMainParams(update);
                        update.Parameters.AddWithValue("@Id", placeId);
                        update.ExecuteNonQuery();

                        Execute(con, tr, "delete from tbl_GMSImages where PlaceId=@Id", placeId);
                        Execute(con, tr, "delete from tbl_GMSHauntedClaims where PlaceId=@Id", placeId);
                        Execute(con, tr, "delete from tbl_GMSYtLinks where PlaceId=@Id", placeId);
                    }
                    else
                    {
                        var insert = new SqlCommand(@"
                            insert into tbl_GMSData
                            (State,PlaceName,ShortSummary,Description,BuildrPeriodTime,MapLink,Settings,ArchStateToday,IsActive)
                            OUTPUT INSERTED.PlaceId
                            values(@State,@Place,@Short,@Desc,@Period,@Map,@Settings,@Arch,@Active)", con, tr);

                        FillMainParams(insert);
                        placeId = (int)insert.ExecuteScalar();
                    }

                    InsertList(con, tr, "insert into tbl_GMSImages (PlaceId,ImageUrl) values (@Id,@Val)", placeId, Session["Images"]);
                    InsertList(con, tr, "insert into tbl_GMSHauntedClaims (PlaceId,ClaimDescription) values (@Id,@Val)", placeId, Session["Claims"]);
                    InsertList(con, tr, "insert into tbl_GMSYtLinks (PlaceId,YtUrl) values (@Id,@Val)", placeId, Session["Youtube"]);

                    tr.Commit();

                    ClearForm();
                    BindPlaces();
                    ShowAlert("Success!", "Data saved successfully!", "success");
                }
                catch
                {
                    tr.Rollback();
                    ShowAlert("Error!", "Save failed.", "error");
                }
            }
        }

        void FillMainParams(SqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@State", ddlAddState.SelectedValue);
            cmd.Parameters.AddWithValue("@Place", txtPlace.Text.Trim());
            cmd.Parameters.AddWithValue("@Short", txtShort.Text.Trim());
            cmd.Parameters.AddWithValue("@Desc", txtDescription.Text.Trim());
            cmd.Parameters.AddWithValue("@Period", txtPeriod.Text.Trim());
            cmd.Parameters.AddWithValue("@Map", txtLocation.Text.Trim());
            cmd.Parameters.AddWithValue("@Settings", txtSeting.Text.Trim());
            cmd.Parameters.AddWithValue("@Arch", txtState.Text.Trim());
            cmd.Parameters.AddWithValue("@Active", chkActive.Checked);
        }

        void InsertList(SqlConnection con, SqlTransaction tr, string sql, int id, object listObj)
        {
            var list = listObj as List<string>;
            if (list == null) return;

            foreach (var val in list)
            {
                var cmd = new SqlCommand(sql, con, tr);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.Parameters.AddWithValue("@Val", val);
                cmd.ExecuteNonQuery();
            }
        }

        void Execute(SqlConnection con, SqlTransaction tr, string sql, int id)
        {
            var cmd = new SqlCommand(sql, con, tr);
            cmd.Parameters.AddWithValue("@Id", id);
            cmd.ExecuteNonQuery();
        }



        void BindPlaces()
        {
            using (var con = new SqlConnection(s))
            {
                var da = new SqlDataAdapter("select PlaceId,PlaceName,State,ShortSummary from tbl_GMSData order by PlaceId DESC", con);
                var dt = new DataTable();
                da.Fill(dt);
                gvPlaces.DataSource = dt;
                gvPlaces.DataBind();
            }
        }

        protected void gvPlaces_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "EditRow") LoadPlace(id);
            if (e.CommandName == "DeleteRow") DeletePlace(id);
        }

        void LoadPlace(int id)
        {
            hfPlaceID.Value = id.ToString();

            using (var con = new SqlConnection(s))
            {
                con.Open();

                var cmd = new SqlCommand("select * from tbl_GMSData where PlaceId=@Id", con);
                cmd.Parameters.AddWithValue("@Id", id);

                var r = cmd.ExecuteReader();
                if (r.Read())
                {
                    ddlAddState.SelectedValue = r["State"].ToString();
                    txtPlace.Text = r["PlaceName"].ToString();
                    txtShort.Text = r["ShortSummary"].ToString();
                    txtDescription.Text = r["Description"].ToString();
                    txtPeriod.Text = r["BuildrPeriodTime"].ToString();
                    txtLocation.Text = r["MapLink"].ToString();
                    txtSeting.Text = r["Settings"].ToString();
                    txtState.Text = r["ArchStateToday"].ToString();
                    chkActive.Checked = Convert.ToBoolean(r["IsActive"]);
                }
                r.Close();

                Session["Images"] = GetList(con, "select ImageUrl from tbl_GMSImages where PlaceId=@Id", id);
                Session["Claims"] = GetList(con, "select ClaimDescription from tbl_GMSHauntedClaims where PlaceId=@Id", id);
                Session["Youtube"] = GetList(con, "select YtUrl from tbl_GMSYtLinks where PlaceId=@Id", id);
            }

            RenderAllDivs();
        }

        List<string> GetList(SqlConnection con, string q, int id)
        {
            var list = new List<string>();
            var cmd = new SqlCommand(q, con);
            cmd.Parameters.AddWithValue("@Id", id);
            var r = cmd.ExecuteReader();
            while (r.Read()) list.Add(r[0].ToString());
            r.Close();
            return list;
        }

        void RenderAllDivs()
        {
            var js = new JavaScriptSerializer();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "render", $@"
                renderImages({js.Serialize(Session["Images"] ?? new List<string>())});
                renderClaims({js.Serialize(Session["Claims"] ?? new List<string>())});
                renderYoutube({js.Serialize(Session["Youtube"] ?? new List<string>())});", true);
        }

        void DeletePlace(int id)
        {
            using (var con = new SqlConnection(s))
            {
                con.Open();
                var cmd = new SqlCommand("delete from tbl_GMSData where PlaceId=@Id", con);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.ExecuteNonQuery();
            }

            BindPlaces();
            ShowAlert("Deleted!", "Place removed successfully.", "success");
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            ShowAlert("Cleared", "Form reset.", "info");
        }

        void ClearForm()
        {
            hfPlaceID.Value = "";
            ddlAddState.SelectedIndex = -1;
            txtPlace.Text = txtShort.Text = txtDescription.Text = txtPeriod.Text = "";
            txtLocation.Text = txtSeting.Text = txtState.Text = txtClaims.Text = txtYoutube.Text = "";
            chkActive.Checked = false;

            Session["Images"] = Session["Claims"] = Session["Youtube"] = null;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "clr",
                "imagesContainer.innerHTML='';claimsContainer.innerHTML='';youtubeContainer.innerHTML='';", true);
        }

        void ShowAlert(string title, string msg, string type)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "swal",
                $"Swal.fire('{title}','{msg}','{type}')", true);
        }
    }
}
