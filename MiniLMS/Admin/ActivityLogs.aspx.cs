using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MiniLMS.Admin
{
    public partial class ActivityLogs : Page
    {
        private const int PageSize = 20;
        private string ConnectionString { get { return ConfigurationManager.ConnectionStrings["EMiniLMSConnection"].ConnectionString; } }
        private int CurrentPage { get { return ViewState["ActivityLogPage"] == null ? 1 : (int)ViewState["ActivityLogPage"]; } set { ViewState["ActivityLogPage"] = value; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || !string.Equals(Convert.ToString(Session["Role"]), "Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Account/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            if (!IsPostBack)
            {
                LoadActions();
                LoadLogs();
            }
        }

        private void LoadActions()
        {
            ddlAction.Items.Clear();
            ddlAction.Items.Add(new ListItem("All actions", ""));
            using (var connection = new SqlConnection(ConnectionString))
            using (var command = new SqlCommand("SELECT DISTINCT ActionType FROM dbo.EActivityLogs ORDER BY ActionType", connection))
            {
                connection.Open();
                using (var reader = command.ExecuteReader())
                    while (reader.Read())
                    {
                        string action = Convert.ToString(reader[0]);
                        ddlAction.Items.Add(new ListItem(action, action));
                    }
            }
        }

        private bool TryDate(string raw, out DateTime? date)
        {
            date = null;
            if (string.IsNullOrWhiteSpace(raw)) return true;
            DateTime parsed;
            if (!DateTime.TryParseExact(raw, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed)) return false;
            date = parsed.Date;
            return true;
        }

        private void LoadLogs()
        {
            lblError.Text = "";
            DateTime? from, to;
            if (!TryDate(txtFrom.Text, out from) || !TryDate(txtTo.Text, out to) || (from.HasValue && to.HasValue && from > to))
            {
                lblError.Text = "Please enter a valid date range.";
                return;
            }
            string search = txtSearch.Text.Trim();
            string sql = @"
SELECT LogID, UserID, UserRole, ActionType, EntityType, EntityID, Description, OldValues, NewValues, Status, CreatedAt
FROM dbo.EActivityLogs
WHERE (@Role = '' OR UserRole = @Role)
  AND (@Action = '' OR ActionType = @Action)
  AND (@FromDate IS NULL OR CreatedAt >= @FromDate)
  AND (@ToDate IS NULL OR CreatedAt < DATEADD(day, 1, @ToDate))
  AND (@Search = '' OR Description LIKE '%' + @Search + '%' OR CONVERT(varchar(20), UserID) = @Search)
ORDER BY CreatedAt DESC, LogID DESC
OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY;
SELECT COUNT(*) FROM dbo.EActivityLogs
WHERE (@Role = '' OR UserRole = @Role)
  AND (@Action = '' OR ActionType = @Action)
  AND (@FromDate IS NULL OR CreatedAt >= @FromDate)
  AND (@ToDate IS NULL OR CreatedAt < DATEADD(day, 1, @ToDate))
  AND (@Search = '' OR Description LIKE '%' + @Search + '%' OR CONVERT(varchar(20), UserID) = @Search);";
            try
            {
                using (var connection = new SqlConnection(ConnectionString))
                using (var command = new SqlCommand(sql, connection))
                {
                    command.Parameters.Add("@Role", SqlDbType.VarChar, 20).Value = ddlRole.SelectedValue;
                    command.Parameters.Add("@Action", SqlDbType.VarChar, 50).Value = ddlAction.SelectedValue;
                    command.Parameters.Add("@FromDate", SqlDbType.Date).Value = (object)from ?? DBNull.Value;
                    command.Parameters.Add("@ToDate", SqlDbType.Date).Value = (object)to ?? DBNull.Value;
                    command.Parameters.Add("@Search", SqlDbType.NVarChar, 100).Value = search;
                    command.Parameters.Add("@Skip", SqlDbType.Int).Value = (CurrentPage - 1) * PageSize;
                    command.Parameters.Add("@Take", SqlDbType.Int).Value = PageSize;
                    connection.Open();
                    var results = new DataSet();
                    using (var adapter = new SqlDataAdapter(command)) adapter.Fill(results);
                    var table = results.Tables[0];
                    int total = Convert.ToInt32(results.Tables[1].Rows[0][0]);
                    int pages = Math.Max(1, (total + PageSize - 1) / PageSize);
                    if (CurrentPage > pages) { CurrentPage = pages; LoadLogs(); return; }
                    gvLogs.DataSource = table;
                    gvLogs.DataBind();
                    lblCount.Text = total + " matching activities";
                    lblPage.Text = "Page " + CurrentPage + " of " + pages;
                    btnPrevious.Enabled = CurrentPage > 1;
                    btnNext.Enabled = CurrentPage < pages;
                }
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Trace.TraceError("ActivityLogs query failed: " + ex);
                lblError.Text = "Unable to load activity logs. Check the server error log.";
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e) { CurrentPage = 1; LoadLogs(); }
        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = ""; txtFrom.Text = ""; txtTo.Text = "";
            ddlRole.SelectedIndex = 0; ddlAction.SelectedIndex = 0;
            CurrentPage = 1; LoadLogs();
        }
        protected void btnPrevious_Click(object sender, EventArgs e) { if (CurrentPage > 1) CurrentPage--; LoadLogs(); }
        protected void btnNext_Click(object sender, EventArgs e) { CurrentPage++; LoadLogs(); }
    }
}
