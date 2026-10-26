using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace MiniLMS.Student
{
    public partial class StudentDashboard : Page
    {
        // Database connection configured in Web.config.
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["EMiniLMSConnection"]
                    .ConnectionString;
            }
        }

        private int StudentID
        {
            get { return Convert.ToInt32(Session["UserID"]); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null ||
                Convert.ToString(Session["Role"]) != "Student")
            {
                RedirectToLogin();
                return;
            }

            if (!LoadStudentProfile())
                return;

            if (!IsPostBack)
                LoadCourses();
        }

        private void RedirectToLogin()
        {
            Response.Redirect("~/Account/Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        // Existing procedure validates the student and returns their first name.
        private bool LoadStudentProfile()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EUsers_StudentProfileGet", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = StudentID;

                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        Session.Clear();
                        Session.Abandon();
                        RedirectToLogin();
                        return false;
                    }

                    lblWelcomeName.Text = Convert.ToString(reader["FirstName"]);
                }
            }

            return true;
        }

        // New procedure returns assigned, published courses and cover images.
        private void LoadCourses()
        {
            DataTable courses = new DataTable();

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EStudentDashboard_GetAssignedCourses", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@StudentID", SqlDbType.Int).Value = StudentID;

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(courses);
                }
            }

            rptCourses.DataSource = courses;
            rptCourses.DataBind();
            pnlNoCourses.Visible = courses.Rows.Count == 0;
        }

        // Keep existing image-path validation and fallback behavior.
        protected string GetCourseImageUrl(object value)
        {
            string defaultImage =
                "~/ImagesUploads/Courses/default-course.png";

            string path = Convert.ToString(value);
            if (string.IsNullOrWhiteSpace(path))
                return ResolveUrl(defaultImage);

            path = path.Trim();

            bool validPath = Regex.IsMatch(
                path,
                @"^~/(Images/Courses|ImagesUploads/Courses)/[a-zA-Z0-9_-]+\.(jpg|jpeg|png|webp)$",
                RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);

            if (!validPath)
                return ResolveUrl(defaultImage);

            if (!File.Exists(Server.MapPath(path)))
                return ResolveUrl(defaultImage);

            return ResolveUrl(path);
        }
    }
}
