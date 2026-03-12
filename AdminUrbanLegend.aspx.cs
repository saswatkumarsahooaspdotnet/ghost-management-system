using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ghost_series
{
    public partial class AdminUrbanLegend : System.Web.UI.Page
    {
        private const string SK_APPEARANCE = "UL_Appearances";
        private const string SK_ABILITIES = "UL_Abilities";
        private const string SK_SIGHTINGS = "UL_Sightings";
        private const string SK_THEORIES = "UL_Theories";
        private const string SK_IMAGES = "UL_Images";
        string s = ConfigurationManager.ConnectionStrings["ghostDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitSessions();
                BindGrid();
            }
        }
        private void InitSessions()
        {
            if (Session[SK_APPEARANCE] == null) Session[SK_APPEARANCE] = new List<string>();
            if (Session[SK_ABILITIES] == null) Session[SK_ABILITIES] = new List<string>();
            if (Session[SK_SIGHTINGS] == null) Session[SK_SIGHTINGS] = new List<string>();
            if (Session[SK_THEORIES] == null) Session[SK_THEORIES] = new List<string>();
            if (Session[SK_IMAGES] == null) Session[SK_IMAGES] = new List<string>();
        }

        [WebMethod(EnableSession = true)] //Makes method callable from JavaScript AJAX.
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)] //Returns JSON instead of XML.
        public static List<string> AddAppearance(string text, int index) //Static required for WebMethod.
        {
            var list = GetList(SK_APPEARANCE);//Gets current session list.
            if (index >= 0 && index < list.Count) list[index] = text;//If editing existing item → update.
            else list.Add(text);//Otherwise add new item.
            return list; //Return updated list to JS.
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> DeleteAppearance(int index)
        {
            var list = GetList(SK_APPEARANCE);
            if (index >= 0 && index < list.Count) list.RemoveAt(index);
            return list;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> AddAbility(string text, int index)
        {
            var list = GetList(SK_ABILITIES);
            if (index >= 0 && index < list.Count) list[index] = text;
            else list.Add(text);
            return list;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> DeleteAbility(int index)
        {
            var list = GetList(SK_ABILITIES);
            if (index >= 0 && index < list.Count) list.RemoveAt(index);
            return list;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> AddSighting(string text, int index)
        {
            var list = GetList(SK_SIGHTINGS);
            if (index >= 0 && index < list.Count) list[index] = text;
            else list.Add(text);
            return list;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> DeleteSighting(int index)
        {
            var list = GetList(SK_SIGHTINGS);
            if (index >= 0 && index < list.Count) list.RemoveAt(index);
            return list;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> AddTheory(string text, int index)
        {
            var list = GetList(SK_THEORIES);
            if (index >= 0 && index < list.Count) list[index] = text;
            else list.Add(text);
            return list;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> DeleteTheory(int index)
        {
            var list = GetList(SK_THEORIES);
            if (index >= 0 && index < list.Count) list.RemoveAt(index);
            return list;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> AddImage(string imagePath)
        {
            var list = GetList(SK_IMAGES);
            list.Add(imagePath);
            return list;
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static List<string> DeleteImage(int index)
        {
            var list = GetList(SK_IMAGES);
            if (index >= 0 && index < list.Count) list.RemoveAt(index);
            return list;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string legendName = txtLegendName.Text.Trim();
            string placeName = txtPlaceName.Text.Trim();

            if (string.IsNullOrEmpty(legendName) || string.IsNullOrEmpty(placeName))
            {
                // Optionally show SweetAlert via ScriptManager
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "Swal.fire('Validation','Please fill Legend Name and Place Name.','warning');", true);
                return;
            }

            int existingId = 0;
            bool isEdit = !string.IsNullOrEmpty(hfLegendId.Value) &&
                          int.TryParse(hfLegendId.Value, out existingId) &&
                          existingId > 0;//Hidden field contains ID if editing.

            using (SqlConnection conn = new SqlConnection(s))
            {
                conn.Open();

                int legendId;

                if (isEdit)
                {
                    // UPDATE main 
                    legendId = existingId;
                    using (SqlCommand cmd = new SqlCommand(
                        "UPDATE UrbanLegendsMain SET LegendName=@n, PlaceName=@p, IsActive=@a WHERE LegendId=@id", conn))
                    {
                        cmd.Parameters.AddWithValue("@n", legendName);
                        cmd.Parameters.AddWithValue("@p", placeName);
                        cmd.Parameters.AddWithValue("@a", chkActive.Checked);
                        cmd.Parameters.AddWithValue("@id", legendId);
                        cmd.ExecuteNonQuery();
                    }

                    // DELETE child rows then re-insert
                    DeleteChildRows(conn, legendId);
                }
                else
                {
                    // INSERT main 
                    using (SqlCommand cmd = new SqlCommand(
                        "INSERT INTO UrbanLegendsMain (LegendName,PlaceName,IsActive) OUTPUT INSERTED.LegendId VALUES(@n,@p,@a)", conn))
                    {
                        cmd.Parameters.AddWithValue("@n", legendName);
                        cmd.Parameters.AddWithValue("@p", placeName);
                        cmd.Parameters.AddWithValue("@a", chkActive.Checked);
                        legendId = (int)cmd.ExecuteScalar();
                    }
                }

                //  INSERT child rows 
                InsertList(conn, legendId, "INSERT INTO UrbanLegendAppearance(LegendId,Appearance) VALUES(@id,@val)",
                    GetList(SK_APPEARANCE));

                InsertList(conn, legendId, "INSERT INTO UrbanLegendAbilities(LegendId,AbilityName) VALUES(@id,@val)",
                    GetList(SK_ABILITIES));

                InsertList(conn, legendId, "INSERT INTO UrbanLegendSightings(LegendId,SightingDescription) VALUES(@id,@val)",
                    GetList(SK_SIGHTINGS));

                InsertList(conn, legendId, "INSERT INTO UrbanLegendTheories(LegendId,TheoriesDescription) VALUES(@id,@val)",
                    GetList(SK_THEORIES));

                InsertList(conn, legendId, "INSERT INTO UrbanLegendImages(LegendId,ImageUrl) VALUES(@id,@val)",
                    GetList(SK_IMAGES));
            }

            ClearForm();
            BindGrid();

            ScriptManager.RegisterStartupScript(this, GetType(), "saved",
                "Swal.fire('Success!','Urban Legend saved successfully.','success');", true);
        }

        protected void gvLegends_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int legendId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection conn = new SqlConnection(s))
                {
                    conn.Open();
                    DeleteChildRows(conn, legendId);
                    using (SqlCommand cmd = new SqlCommand(
                        "DELETE FROM UrbanLegendsMain WHERE LegendId=@id", conn))
                    {
                        cmd.Parameters.AddWithValue("@id", legendId);
                        cmd.ExecuteNonQuery();
                    }
                }
                BindGrid();
            }
            else if (e.CommandName == "EditRow")
            {
                LoadForEdit(legendId);
            }
        }

        private void LoadForEdit(int legendId)
        {
            using (SqlConnection conn = new SqlConnection(s))
            {
                conn.Open();

                // Main
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT * FROM UrbanLegendsMain WHERE LegendId=@id", conn))
                {
                    cmd.Parameters.AddWithValue("@id", legendId);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hfLegendId.Value = legendId.ToString();
                            txtLegendName.Text = dr["LegendName"].ToString();
                            txtPlaceName.Text = dr["PlaceName"].ToString();
                            chkActive.Checked = Convert.ToBoolean(dr["IsActive"]);
                        }
                    }
                }

                // Child lists into session
                Session[SK_APPEARANCE] = FetchColumn(conn, legendId,
                    "SELECT Appearance FROM UrbanLegendAppearance WHERE LegendId=@id", "Appearance");

                Session[SK_ABILITIES] = FetchColumn(conn, legendId,
                    "SELECT AbilityName FROM UrbanLegendAbilities WHERE LegendId=@id", "AbilityName");

                Session[SK_SIGHTINGS] = FetchColumn(conn, legendId,
                    "SELECT SightingDescription FROM UrbanLegendSightings WHERE LegendId=@id", "SightingDescription");

                Session[SK_THEORIES] = FetchColumn(conn, legendId,
                    "SELECT TheoriesDescription FROM UrbanLegendTheories WHERE LegendId=@id", "TheoriesDescription");

                Session[SK_IMAGES] = FetchColumn(conn, legendId,
                    "SELECT ImageUrl FROM UrbanLegendImages WHERE LegendId=@id", "ImageUrl");
            }

            // Re-render lists via startup script
            string script = $@"
                document.addEventListener('DOMContentLoaded', function() {{
                    fetch('AdminUrbanLegend.aspx/GetAllLists', {{
                        method: 'POST', headers: {{'Content-Type':'application/json'}}, body: '{{}}'
                    }}).then(r=>r.json()).then(d=>{{
                        renderList(d.d.Appearances,'appearanceContainer','deleteAppearance','selectAppearance');
                        renderList(d.d.Abilities,'abilitiesContainer','deleteAbility','selectAbility');
                        renderList(d.d.Sightings,'sightingsContainer','deleteSighting','selectSighting');
                        renderList(d.d.Theories,'theoriesContainer','deleteTheory','selectTheory');
                        renderImages(d.d.Images);
                    }});
                }});";
            ScriptManager.RegisterStartupScript(this, GetType(), "loadEdit", script, true);
        }


        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetAllLists()
        {
            return new
            {
                Appearances = GetList(SK_APPEARANCE),
                Abilities = GetList(SK_ABILITIES),
                Sightings = GetList(SK_SIGHTINGS),
                Theories = GetList(SK_THEORIES),
                Images = GetList(SK_IMAGES)
            };
        }
        protected void btnClear_Click(object sender, EventArgs e) => ClearForm();

        private void ClearForm()
        {
            hfLegendId.Value = "";
            txtLegendName.Text = "";
            txtPlaceName.Text = "";
            chkActive.Checked = true;
            Session[SK_APPEARANCE] = new List<string>();
            Session[SK_ABILITIES] = new List<string>();
            Session[SK_SIGHTINGS] = new List<string>();
            Session[SK_THEORIES] = new List<string>();
            Session[SK_IMAGES] = new List<string>();
        }

        private static List<string> GetList(string key)
        {
            if (System.Web.HttpContext.Current.Session[key] == null)
                System.Web.HttpContext.Current.Session[key] = new List<string>();
            return (List<string>)System.Web.HttpContext.Current.Session[key];
        }

        private void BindGrid()
        {
            using (SqlConnection conn = new SqlConnection(s))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT LegendId, LegendName, PlaceName FROM UrbanLegendsMain ORDER BY LegendId DESC", conn))
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvLegends.DataSource = dt;
                gvLegends.DataBind();
            }
        }

        private void DeleteChildRows(SqlConnection conn, int legendId)
        {
            string[] tables = {
                "UrbanLegendAppearance",
                "UrbanLegendAbilities",
                "UrbanLegendSightings",
                "UrbanLegendTheories",
                "UrbanLegendImages"
            };
            foreach (string t in tables)
            {
                using (SqlCommand cmd = new SqlCommand($"DELETE FROM {t} WHERE LegendId=@id", conn))
                {
                    cmd.Parameters.AddWithValue("@id", legendId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void InsertList(SqlConnection conn, int legendId, string query, List<string> items)
        {
            foreach (string item in items)
            {
                if (string.IsNullOrWhiteSpace(item)) continue;
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@id", legendId);
                    cmd.Parameters.AddWithValue("@val", item);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private List<string> FetchColumn(SqlConnection conn, int legendId, string query, string column)
        {
            var list = new List<string>();
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@id", legendId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                    while (dr.Read()) list.Add(dr[column].ToString());
            }
            return list;
        }
    }
}