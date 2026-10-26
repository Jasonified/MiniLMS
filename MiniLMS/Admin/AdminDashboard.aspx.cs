using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MiniLMS
{
    public partial class AdminDashboard : Page
    {
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["EMiniLMSConnection"]
                    .ConnectionString;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null ||
                Convert.ToString(Session["Role"]) != "Admin")
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
                LoadDashboard();
        }

        private void LoadDashboard()
        {
            LoadOverview();
            LoadPendingCount();
            LoadPendingUsers();
        }

        private void LoadOverview()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.EAdmin_GetOverview", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblTotalUsers.Text = reader["TotalUsers"].ToString();
                        lblTotalInstructors.Text = reader["TotalInstructors"].ToString();
                        lblTotalCourses.Text = reader["TotalCourses"].ToString();
                    }
                }
            }
        }

        private void LoadPendingCount()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.EUsers_GetPending", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@CountOnly", SqlDbType.Bit).Value = true;
                con.Open();
                object result = cmd.ExecuteScalar();
                lblPendingCount.Text = Convert.ToString(result);
            }
        }

        private void LoadPendingUsers()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.EUsers_GetPending", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@CountOnly", SqlDbType.Bit).Value = false;
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    DataTable table = new DataTable();
                    adapter.Fill(table);
                    gvPendingUsers.DataSource = table;
                    gvPendingUsers.DataBind();
                }
            }
        }

        protected void gvPendingUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "ApproveUser") return;
            int userID;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out userID))
            {
                lblMessage.Text = "Invalid user ID.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand("dbo.EUsers_Approve", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                LoadDashboard();
                lblMessage.Text = "User approved successfully.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
            }
            catch (Exception ex)
            {
                lblMessage.Text = Server.HtmlEncode("Unable to approve user: " + ex.Message);
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}
