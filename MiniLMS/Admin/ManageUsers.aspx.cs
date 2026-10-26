using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MiniLMS
{
    public partial class ManageUsers : Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["EMiniLMSConnection"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsCurrentAdmin())
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("~/Account/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            if (!IsPostBack)
            {
                LoadPrograms();
                LoadUsers();
            }
        }

        private DataTable GetData(string procedure, params SqlParameter[] parameters)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(procedure, con))
            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                if (parameters != null) cmd.Parameters.AddRange(parameters);
                adapter.Fill(dt);
            }
            return dt;
        }

        private bool IsCurrentAdmin()
        {
            int id;
            if (!int.TryParse(Convert.ToString(Session["UserID"]), out id)) return false;
            DataTable dt = GetData("dbo.EUsers_IsActiveAdmin", new SqlParameter("@UserID", id));
            return dt.Rows.Count > 0 && Convert.ToInt32(dt.Rows[0][0]) == 1;
        }

        private void LoadPrograms()
        {
            DataTable dt = GetData("dbo.EPrograms_GetActive");
            ddlProgram.Items.Clear();
            ddlProgram.Items.Add(new ListItem("Not applicable", ""));
            foreach (DataRow row in dt.Rows)
                ddlProgram.Items.Add(new ListItem(Convert.ToString(row["ProgramCode"]), Convert.ToString(row["ProgramID"])));
        }

        private void LoadUsers()
        {
            DataTable dt = GetData("dbo.EUsers_ManageList");
            gvUsers.DataSource = dt;
            gvUsers.DataBind();
            int active = 0, inactive = 0, pending = 0;
            foreach (DataRow row in dt.Rows)
            {
                if (!Convert.ToBoolean(row["IsApproved"])) pending++;
                else if (Convert.ToBoolean(row["IsActive"])) active++;
                else inactive++;
            }
            lblTotalUsers.Text = dt.Rows.Count.ToString();
            lblUserCount.Text = dt.Rows.Count.ToString();
            lblActiveUsers.Text = active.ToString();
            lblInactiveUsers.Text = inactive.ToString();
            lblPendingUsers.Text = pending.ToString();
        }

        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;
            int selected;
            if (int.TryParse(hfSelectedUserID.Value, out selected) &&
                Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "UserID")) == selected)
                e.Row.CssClass = "mu-row mu-selected";
            else e.Row.CssClass = "mu-row";
            LinkButton select = e.Row.FindControl("btnSelectUser") as LinkButton;
            if (select != null)
            {
                e.Row.Style["cursor"] = "pointer";
                e.Row.Attributes["onclick"] =
                    "if(event.target.closest('a'))return;document.getElementById('" +
                    select.ClientID + "').click();";
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "SelectUser") return;
            int id;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;
            LoadSelectedUser(id);
            LoadUsers();
        }

        private void SelectValue(DropDownList dropdown, object value)
        {
            string key = value == DBNull.Value || value == null ? "" : Convert.ToString(value);
            ListItem item = dropdown.Items.FindByValue(key);
            dropdown.ClearSelection();
            if (item != null) item.Selected = true;
        }

        private void LoadSelectedUser(int userID)
        {
            DataTable dt = GetData("dbo.EUsers_ManageGet", new SqlParameter("@UserID", userID));
            if (dt.Rows.Count == 0)
            {
                pnlNoSelection.Visible = true;
                pnlEditUser.Visible = false;
                ShowMessage("User not found.", false);
                return;
            }
            DataRow r = dt.Rows[0];
            hfSelectedUserID.Value = userID.ToString();
            pnlNoSelection.Visible = false;
            pnlEditUser.Visible = true;
            txtFirstName.Text = Convert.ToString(r["FirstName"]);
            txtMiddleName.Text = Convert.ToString(r["MiddleName"]);
            txtLastName.Text = Convert.ToString(r["LastName"]);
            txtEmail.Text = Convert.ToString(r["Email"]);
            SelectValue(ddlProgram, r["ProgramID"]);
            SelectValue(ddlYearLevel, r["YearLevel"]);
            SelectValue(ddlRole, r["Role"]);
            chkActive.Checked = Convert.ToBoolean(r["IsActive"]);
            bool approved = Convert.ToBoolean(r["IsApproved"]);
            chkActive.Enabled = approved;
            lblApprovalNote.Text = approved ? "Approved account." : "Pending approval: account status cannot be changed here.";
            int actor = Convert.ToInt32(Session["UserID"]);
            if (actor == userID)
            {
                chkActive.Enabled = false;
                ddlRole.Enabled = false;
            }
            else ddlRole.Enabled = true;
            lblSelectedName.Text = HttpUtility.HtmlEncode((txtFirstName.Text + " " + txtLastName.Text).Trim());
            lblSelectedID.Text = userID.ToString();
            string image = Convert.ToString(r["ProfileImageUrl"]);
            imgUser.Visible = false;
            lblInitial.Visible = true;
            lblInitial.Text = HttpUtility.HtmlEncode(txtFirstName.Text.Length > 0 ? txtFirstName.Text.Substring(0, 1).ToUpperInvariant() : "U");
            if (System.Text.RegularExpressions.Regex.IsMatch(image ?? "", @"^~/Images/Profiles/[a-f0-9]{32}\.(jpg|png)$", System.Text.RegularExpressions.RegexOptions.IgnoreCase)
                && File.Exists(Server.MapPath(image)))
            {
                imgUser.ImageUrl = ResolveUrl(image);
                imgUser.Visible = true;
                lblInitial.Visible = false;
            }
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            int id, program, year;
            if (!int.TryParse(hfSelectedUserID.Value, out id)) { ShowMessage("Select a user first.", false); return; }
            string role = ddlRole.SelectedValue;
            string first = txtFirstName.Text.Trim(), middle = txtMiddleName.Text.Trim(), last = txtLastName.Text.Trim();
            if (first.Length == 0 || last.Length == 0 || first.Length > 50 || middle.Length > 50 || last.Length > 50)
            { ShowMessage("Enter valid first and last names (up to 50 characters).", false); return; }
            object programValue = DBNull.Value, yearValue = DBNull.Value;
            if (role == "Student")
            {
                if (!int.TryParse(ddlProgram.SelectedValue, out program) || !int.TryParse(ddlYearLevel.SelectedValue, out year))
                { ShowMessage("Select a program and year level for students.", false); return; }
                programValue = program;
                yearValue = year;
            }
            // Always retrieve the stored image path: never trust a browser-supplied hidden value.
            DataTable existing = GetData("dbo.EUsers_ManageGet", new SqlParameter("@UserID", id));
            if (existing.Rows.Count == 0) { ShowMessage("User no longer exists.", false); return; }
            string imagePath = Convert.ToString(existing.Rows[0]["ProfileImageUrl"]);
            string savedFile = null;
            try
            {
                if (fuProfile.HasFile)
                {
                    if (fuProfile.PostedFile.ContentLength <= 0 || fuProfile.PostedFile.ContentLength > 2 * 1024 * 1024)
                        throw new InvalidOperationException("Photo must be 2 MB or smaller.");
                    string ext = Path.GetExtension(fuProfile.FileName).ToLowerInvariant();
                    if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
                        throw new InvalidOperationException("Only JPG and PNG photos are allowed.");
                    byte[] signature = new byte[8];
                    using (Stream stream = fuProfile.PostedFile.InputStream)
                    {
                        if (stream.Read(signature, 0, signature.Length) < signature.Length)
                            throw new InvalidOperationException("Invalid image file.");
                    }
                    bool jpg = signature[0] == 0xFF && signature[1] == 0xD8 && signature[2] == 0xFF;
                    bool png = signature[0] == 0x89 && signature[1] == 0x50 && signature[2] == 0x4E && signature[3] == 0x47 && signature[4] == 0x0D && signature[5] == 0x0A && signature[6] == 0x1A && signature[7] == 0x0A;
                    if (!(jpg && (ext == ".jpg" || ext == ".jpeg")) && !(png && ext == ".png"))
                        throw new InvalidOperationException("The selected file is not a valid JPG or PNG image.");
                    string folder = Server.MapPath("~/Images/Profiles/");
                    Directory.CreateDirectory(folder);
                    string filename = Guid.NewGuid().ToString("N") + (png ? ".png" : ".jpg");
                    savedFile = Path.Combine(folder, filename);
                    fuProfile.SaveAs(savedFile);
                    imagePath = "~/Images/Profiles/" + filename;
                }
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand("dbo.EUsers_ManageSave", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ActorID", SqlDbType.Int).Value = Convert.ToInt32(Session["UserID"]);
                    cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = id;
                    cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, 50).Value = first;
                    cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar, 50).Value = middle.Length == 0 ? (object)DBNull.Value : middle;
                    cmd.Parameters.Add("@LastName", SqlDbType.VarChar, 50).Value = last;
                    cmd.Parameters.Add("@ProgramID", SqlDbType.Int).Value = programValue;
                    cmd.Parameters.Add("@YearLevel", SqlDbType.Int).Value = yearValue;
                    cmd.Parameters.Add("@Role", SqlDbType.VarChar, 20).Value = role;
                    cmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = chkActive.Checked;
                    cmd.Parameters.Add("@ProfileImageUrl", SqlDbType.NVarChar, 500).Value = string.IsNullOrEmpty(imagePath) ? (object)DBNull.Value : imagePath;
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                LoadSelectedUser(id);
                LoadUsers();
                ShowMessage("User changes saved successfully.", true);
            }
            catch (Exception ex)
            {
                if (savedFile != null && File.Exists(savedFile)) File.Delete(savedFile);
                ShowMessage("Changes were not saved: " + ex.Message, false);
            }
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Text = HttpUtility.HtmlEncode(message);
            lblMessage.ForeColor = success ? Color.DarkGreen : Color.DarkRed;
        }
    }
}
