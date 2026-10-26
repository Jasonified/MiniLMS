using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace MiniLMS
{
    public partial class TestAddCourse : System.Web.UI.Page
    {
        // Get connection string from Web.config
        string connectionString =
            ConfigurationManager.ConnectionStrings["MiniLMSDb"].ConnectionString;


        // Runs when page loads
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
            }
        }


        // ==========================================
        // READ - Load all courses
        // ==========================================
        private void LoadCourses()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("ECourses_Web", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();

                        da.Fill(dt);

                        gvCourses.DataSource = dt;
                        gvCourses.DataBind();
                    }
                }
            }
        }


        // ==========================================
        // CREATE / UPDATE - Save Course
        // ==========================================
        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Basic validation
            if (string.IsNullOrWhiteSpace(txtInstructorID.Text))
            {
                lblMessage.Text = "Please enter Instructor ID.";
                return;
            }

            if (string.IsNullOrWhiteSpace(txtCourseTitle.Text))
            {
                lblMessage.Text = "Please enter Course Title.";
                return;
            }


            int instructorID;

            if (!int.TryParse(txtInstructorID.Text, out instructorID))
            {
                lblMessage.Text = "Instructor ID must be a number.";
                return;
            }


            int courseID = 0;

            // If HiddenField contains an ID, we are editing
            if (!string.IsNullOrWhiteSpace(hfCourseID.Value))
            {
                int.TryParse(hfCourseID.Value, out courseID);
            }


            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("ECourses_WebSave", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@CourseID", courseID);
                    cmd.Parameters.AddWithValue("@InstructorID", instructorID);
                    cmd.Parameters.AddWithValue("@CourseTitle", txtCourseTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseDescription", txtCourseDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@Announcement", txtAnnouncement.Text.Trim());
                    cmd.Parameters.AddWithValue("@CoursePublished", chkPublished.Checked);

                    con.Open();

                    cmd.ExecuteNonQuery();
                }
            }


            if (courseID == 0)
            {
                lblMessage.Text = "Course added successfully.";
            }
            else
            {
                lblMessage.Text = "Course updated successfully.";
            }


            ClearForm();
            LoadCourses();
        }


        // ==========================================
        // CLEAR FORM
        // ==========================================
        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            lblMessage.Text = "";
        }


        private void ClearForm()
        {
            hfCourseID.Value = "";

            txtInstructorID.Text = "";
            txtCourseTitle.Text = "";
            txtCourseDescription.Text = "";
            txtAnnouncement.Text = "";

            chkPublished.Checked = false;

            btnSave.Text = "Save Course";
        }


        // ==========================================
        // EDIT / DELETE
        // ==========================================
        protected void gvCourses_RowCommand(object sender,
            System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int courseID;

            if (!int.TryParse(e.CommandArgument.ToString(), out courseID))
            {
                lblMessage.Text = "Invalid Course ID.";
                return;
            }


            // EDIT
            if (e.CommandName == "EditCourse")
            {
                LoadCourse(courseID);
            }


            // DELETE
            else if (e.CommandName == "DeleteCourse")
            {
                DeleteCourse(courseID);
            }
        }


        // ==========================================
        // READ ONE COURSE
        // ==========================================
        private void LoadCourse(int courseID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("ECourses_WebOne", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@CourseID", courseID);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            hfCourseID.Value =
                                reader["CourseID"].ToString();

                            txtInstructorID.Text =
                                reader["InstructorID"].ToString();

                            txtCourseTitle.Text =
                                reader["CourseTitle"].ToString();

                            txtCourseDescription.Text =
                                reader["CourseDescription"].ToString();

                            txtAnnouncement.Text =
                                reader["Announcement"].ToString();

                            chkPublished.Checked =
                                Convert.ToBoolean(reader["CoursePublished"]);


                            btnSave.Text = "Update Course";

                            lblMessage.Text =
                                "Editing Course ID: " + courseID;
                        }
                    }
                }
            }
        }


        // ==========================================
        // DELETE COURSE
        // ==========================================
        private void DeleteCourse(int courseID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("ECourses_WebDelete", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@CourseID", courseID);

                    con.Open();

                    cmd.ExecuteNonQuery();
                }
            }


            lblMessage.Text = "Course deleted successfully.";

            ClearForm();

            LoadCourses();
        }
    }
}