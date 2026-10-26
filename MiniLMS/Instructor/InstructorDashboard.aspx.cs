
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.IO;
using System.Drawing.Imaging;

namespace MiniLMS
{
    public partial class InstructorDashboard : System.Web.UI.Page
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

        private int InstructorID
        {
            get
            {
                return Convert.ToInt32(Session["UserID"]);
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

            if (Session["Role"].ToString() != "Instructor")
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblWelcomeName.Text =
                    Convert.ToString(Session["FirstName"]);

                if (string.IsNullOrWhiteSpace(lblWelcomeName.Text))
                    lblWelcomeName.Text = "Instructor";

                LoadCourses();
            }
        }

        // LOAD ASSIGNED COURSES
        private void LoadCourses()
        {
            using (SqlConnection connection =
                new SqlConnection(ConnectionString))
            {
                // Retrieve the instructor's assigned courses using the existing stored procedure.
                using (SqlCommand command = new SqlCommand(
                    "dbo.ECourses_GetInstructorCourses", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.Add(
                        "@InstructorID",
                        SqlDbType.Int
                    ).Value = InstructorID;

                    connection.Open();

                    DataTable table = new DataTable();

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(command))
                    {
                        adapter.Fill(table);
                    }

                    rptCourses.DataSource = table;
                    rptCourses.DataBind();

                    pnlNoCourses.Visible =
                        table.Rows.Count == 0;
                }
            }
        }

        // COURSE IMAGE FALLBACK
        protected string GetCourseImageUrl(object imageUrl)
        {
            string path = Convert.ToString(imageUrl);

            if (string.IsNullOrWhiteSpace(path))
                return ResolveUrl(
                    "~/ImagesUploads/Courses/default-course.png");

            path = path.Trim();

            if (!path.StartsWith(
                    "~/Images/Courses/",
                    StringComparison.OrdinalIgnoreCase) &&
                !path.StartsWith(
                    "~/ImagesUploads/Courses/",
                    StringComparison.OrdinalIgnoreCase))
            {
                return ResolveUrl(
                    "~/ImagesUploads/Courses/default-course.png");
            }

            return ResolveUrl(path);
        }

        // COURSE CARD COMMANDS
        protected void rptCourses_ItemCommand(
            object source,
            RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "UploadImage")
            {
                int courseID;

                if (int.TryParse(
                    Convert.ToString(e.CommandArgument),
                    out courseID))
                {
                    UploadCourseImage(courseID, e.Item);
                }

                return;
            }

            if (e.CommandName == "ManageCourse")
            {
                int courseID =
                    Convert.ToInt32(e.CommandArgument);

                Session["SelectedCourseID"] = courseID;

                Response.Redirect(
                    "~/Instructor/Courses.aspx");
            }
        }

        // UPLOAD COURSE COVER IMAGE
        private void UploadCourseImage(
            int courseID,
            RepeaterItem item)
        {
            FileUpload upload =
                item.FindControl("fuCourseImage") as FileUpload;

            if (upload == null || !upload.HasFile)
            {
                lblUploadMessage.Text =
                    "Please select an image.";
                return;
            }

            const int maxBytes = 5 * 1024 * 1024;

            if (upload.PostedFile.ContentLength <= 0 ||
                upload.PostedFile.ContentLength > maxBytes)
            {
                lblUploadMessage.Text =
                    "Please choose an image smaller than 5 MB.";
                return;
            }

            string ext =
                Path.GetExtension(upload.FileName)
                    .ToLowerInvariant();

            if (ext != ".jpg" &&
                ext != ".jpeg" &&
                ext != ".png")
            {
                lblUploadMessage.Text =
                    "Only JPG and PNG images are supported.";
                return;
            }

            string savedPath = null;

            try
            {
                using (SqlConnection connection =
                    new SqlConnection(ConnectionString))
                {
                    connection.Open();

                    // Verify instructor ownership.
                    using (SqlCommand check =
                        new SqlCommand(@"
                            SELECT COUNT(*)
                            FROM dbo.ECourses
                            WHERE CourseID = @CourseID
                              AND InstructorID = @InstructorID",
                            connection))
                    {
                        check.Parameters.Add(
                            "@CourseID",
                            SqlDbType.Int).Value = courseID;

                        check.Parameters.Add(
                            "@InstructorID",
                            SqlDbType.Int).Value = InstructorID;

                        if (Convert.ToInt32(
                            check.ExecuteScalar()) != 1)
                        {
                            lblUploadMessage.Text =
                                "You cannot edit this course image.";
                            return;
                        }
                    }

                    string directory =
                        Server.MapPath("~/Images/Courses/");

                    Directory.CreateDirectory(directory);

                    string fileName =
                        Guid.NewGuid().ToString("N") +
                        (ext == ".png" ? ".png" : ".jpg");

                    savedPath =
                        Path.Combine(directory, fileName);

                    // Decode and re-encode uploaded image.
                    using (System.Drawing.Image image =
                        System.Drawing.Image.FromStream(
                            upload.PostedFile.InputStream,
                            false,
                            true))
                    {
                        if (image.Width < 1 ||
                            image.Height < 1 ||
                            image.Width > 6000 ||
                            image.Height > 6000)
                        {
                            throw new InvalidDataException(
                                "Invalid image dimensions.");
                        }

                        image.Save(
                            savedPath,
                            ext == ".png"
                                ? ImageFormat.Png
                                : ImageFormat.Jpeg);
                    }

                    using (SqlCommand update =
                        new SqlCommand(@"
                            UPDATE dbo.ECourses
                            SET CourseImageUrl = @ImageUrl
                            WHERE CourseID = @CourseID
                              AND InstructorID = @InstructorID",
                            connection))
                    {
                        update.Parameters.Add(
                            "@ImageUrl",
                            SqlDbType.NVarChar,
                            500).Value =
                                "~/Images/Courses/" + fileName;

                        update.Parameters.Add(
                            "@CourseID",
                            SqlDbType.Int).Value = courseID;

                        update.Parameters.Add(
                            "@InstructorID",
                            SqlDbType.Int).Value = InstructorID;

                        if (update.ExecuteNonQuery() != 1)
                        {
                            throw new InvalidOperationException(
                                "Course image could not be updated.");
                        }
                    }
                }

                lblUploadMessage.Text =
                    "Course image updated successfully.";

                LoadCourses();
            }
            catch (Exception)
            {
                if (savedPath != null &&
                    File.Exists(savedPath))
                {
                    File.Delete(savedPath);
                }

                lblUploadMessage.Text =
                    "Upload failed. Check that the image is valid, " +
                    "the Images/Courses folder is writable, " +
                    "and the database column exists.";
            }
        }
    }
}
