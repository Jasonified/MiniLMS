
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MiniLMS
{
    public partial class SiteMaster : MasterPage
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
                Session["Role"] == null)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            string role = Convert.ToString(Session["Role"]);

            if (role != "Admin" &&
                role != "Instructor" &&
                role != "Student")
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            ConfigureNavigation(role);
            LoadNavigationProfile(role);
            SetActiveNavigation();
        }

        // ==========================================
        // ROLE-BASED NAVIGATION
        // ==========================================

        private void ConfigureNavigation(string role)
        {
            string dashboardUrl = "";
            string coursesUrl = "";
            string profileUrl = "";

            lnkUsers.Visible = false;
            lnkActivityLogs.Visible = false;
            lnkProfileNav.Visible = false;
            lnkProfileDropdown.Visible = true;

            switch (role)
            {
                case "Admin":
                    dashboardUrl =
                        "~/Admin/AdminDashboard.aspx";

                    coursesUrl =
                        "~/Admin/ManageCourses.aspx";

                    lnkUsers.NavigateUrl =
                        "~/Admin/ManageUsers.aspx";

                    lnkUsers.Visible = true;

                    // Admin-only Activity Logs link.
                    lnkActivityLogs.NavigateUrl =
                        "~/Admin/ActivityLogs.aspx";

                    lnkActivityLogs.Visible = true;

                    // No Admin profile page available.
                    lnkProfileDropdown.Visible = false;
                    break;

                case "Instructor":
                    dashboardUrl =
                        "~/Instructor/InstructorDashboard.aspx";

                    coursesUrl =
                        "~/Instructor/Courses.aspx";

                    profileUrl =
                        "~/Instructor/Profile.aspx";
                    break;

                case "Student":
                    dashboardUrl =
                        "~/Student/StudentDashboard.aspx";

                    coursesUrl =
                        "~/Student/CourseDetails.aspx";

                    profileUrl =
                        "~/Student/Profile.aspx";
                    break;

                default:
                    return;
            }

            lnkDashboard.NavigateUrl = dashboardUrl;
            lnkCourses.NavigateUrl = coursesUrl;

            if (!string.IsNullOrEmpty(profileUrl))
            {
                lnkProfileDropdown.NavigateUrl = profileUrl;
            }

            lblNavRole.Text = role;
            lblDropdownRole.Text = role + " account";
        }

        // ==========================================
        // LOAD NAVIGATION PROFILE
        // ==========================================

        private void LoadNavigationProfile(string role)
        {
            int userID = Convert.ToInt32(Session["UserID"]);

            const string query = @"
                SELECT
                    FirstName,
                    LastName,
                    ProfileImageUrl
                FROM dbo.EUsers
                WHERE UserID = @UserID
                  AND Role = @Role
                  AND IsActive = 1
                  AND IsApproved = 1";

            string firstName = "";
            string lastName = "";
            string imagePath = "";

            using (SqlConnection connection =
                new SqlConnection(ConnectionString))
            using (SqlCommand command =
                new SqlCommand(query, connection))
            {
                command.Parameters.Add(
                    "@UserID", SqlDbType.Int
                ).Value = userID;

                command.Parameters.Add(
                    "@Role", SqlDbType.VarChar, 20
                ).Value = role;

                connection.Open();

                using (SqlDataReader reader =
                    command.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        Session.Clear();
                        Session.Abandon();

                        Response.Redirect(
                            "~/Account/Login.aspx");
                        return;
                    }

                    firstName =
                        Convert.ToString(reader["FirstName"]);

                    lastName =
                        Convert.ToString(reader["LastName"]);

                    imagePath =
                        Convert.ToString(reader["ProfileImageUrl"]);
                }
            }

            string fullName =
                (firstName + " " + lastName).Trim();

            if (string.IsNullOrWhiteSpace(fullName))
            {
                fullName = role;
            }

            lblNavName.Text = fullName;
            lblDropdownName.Text = fullName;

            imgNavProfile.Visible = false;

            litAvatar.Text = HttpUtility.HtmlEncode(
                firstName.Length > 0
                    ? firstName.Substring(0, 1)
                        .ToUpperInvariant()
                    : "U"
            );

            bool validPath = Regex.IsMatch(
                imagePath ?? "",
                @"^~/Images/Profiles/[a-f0-9]{32}\.(jpg|png)$",
                RegexOptions.IgnoreCase |
                RegexOptions.CultureInvariant
            );

            if (validPath &&
                File.Exists(Server.MapPath(imagePath)))
            {
                imgNavProfile.ImageUrl =
                    ResolveUrl(imagePath);

                imgNavProfile.Visible = true;
                litAvatar.Text = "";
            }
        }

        // ==========================================
        // ACTIVE NAVIGATION
        // ==========================================

        private void SetActiveNavigation()
        {
            string currentPath =
                Request.AppRelativeCurrentExecutionFilePath;

            SetActive(lnkDashboard, currentPath);
            SetActive(lnkUsers, currentPath);
            SetActive(lnkCourses, currentPath);

            // Highlight Activity Logs when selected.
            SetActive(lnkActivityLogs, currentPath);

            SetActive(lnkProfileNav, currentPath);
        }

        private void SetActive(
            HyperLink link,
            string currentPath)
        {
            if (!link.Visible ||
                string.IsNullOrEmpty(link.NavigateUrl))
            {
                link.CssClass = "";
                return;
            }

            string targetPath = link.NavigateUrl;

            int hashIndex = targetPath.IndexOf('#');

            if (hashIndex >= 0)
            {
                targetPath =
                    targetPath.Substring(0, hashIndex);
            }

            bool isActive = string.Equals(
                VirtualPathUtility.ToAppRelative(targetPath),
                currentPath,
                StringComparison.OrdinalIgnoreCase
            );

            link.CssClass = isActive ? "active" : "";
        }

        // ==========================================
        // LOGOUT
        // ==========================================

        protected void btnMasterLogout_Click(
            object sender,
            EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("~/Account/Login.aspx");
        }
    }
}
