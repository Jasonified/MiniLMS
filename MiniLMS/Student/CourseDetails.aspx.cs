using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MiniLMS.Student
{
    public partial class CourseDetails : Page
    {
        private const int MaxAssignmentBytes = 10 * 1024 * 1024;
        private const string AssignmentFolder = "~/App_Data/Uploads/AssignmentSubmissions/";
        private string ConnectionString { get { return ConfigurationManager.ConnectionStrings["EMiniLMSConnection"].ConnectionString; } }
        private int StudentID { get { return Convert.ToInt32(Session["UserID"]); } }
        private DataTable lessons, materials, assignments;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Convert.ToString(Session["Role"]) != "Student")
            {
                Response.Redirect("~/Account/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            if (!IsPostBack)
            {
                if (string.IsNullOrWhiteSpace(Request.QueryString["CourseID"])) LoadAssignedCourses();
                else { pnlCourseDirectory.Visible = false; pnlCourseDetailsView.Visible = true; LoadPageData(); }
            }
        }

        private DataTable ExecuteProcedure(string procedureName, int? courseID = null)
        {
            DataTable table = new DataTable();
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(procedureName, con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@StudentID", SqlDbType.Int).Value = StudentID;
                if (courseID.HasValue) cmd.Parameters.Add("@CourseID", SqlDbType.Int).Value = courseID.Value;
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd)) adapter.Fill(table);
            }
            return table;
        }

        private void LoadAssignedCourses()
        {
            pnlCourseDirectory.Visible = true;
            pnlCourseDetailsView.Visible = false;
            DataTable courses = ExecuteProcedure("dbo.EStudentCourses_GetAssigned");
            rptAssignedCourses.DataSource = courses;
            rptAssignedCourses.DataBind();
            pnlNoAssignedCourses.Visible = courses.Rows.Count == 0;
        }

        private int SelectedCourseID()
        {
            int id;
            return int.TryParse(Request.QueryString["CourseID"], out id) && id > 0 ? id : 0;
        }

        private bool CanAccessCourse(int courseID)
        {
            return courseID > 0 && ExecuteProcedure("dbo.EStudentCourse_GetDetails", courseID).Rows.Count > 0;
        }

        private void LoadPageData()
        {
            pnlCourse.Visible = false;
            int courseID = SelectedCourseID();
            if (courseID == 0) { ShowMessage("Invalid course selection."); return; }
            DataTable course = ExecuteProcedure("dbo.EStudentCourse_GetDetails", courseID);
            if (course.Rows.Count == 0) { ShowMessage("Course not found or not assigned to your account."); return; }
            DataRow row = course.Rows[0];
            lblCourseTitle.Text = Convert.ToString(row["CourseTitle"]);
            lblCourseDescription.Text = Convert.ToString(row["CourseDescription"]);
            lblInstructor.Text = Convert.ToString(row["InstructorName"]);
            DataTable modules = ExecuteProcedure("dbo.EStudentCourse_GetModules", courseID);
            lessons = ExecuteProcedure("dbo.EStudentCourse_GetLessons", courseID);
            materials = ExecuteProcedure("dbo.EStudentCourse_GetMaterials", courseID);
            assignments = ExecuteProcedure("dbo.EStudentAssignments_Web", courseID);
            pnlCourse.Visible = true;
            rptModules.DataSource = modules;
            rptModules.DataBind();
            pnlNoModules.Visible = modules.Rows.Count == 0;

            // Record an authorized course view only on the first page request.
            // Logging failure must not prevent the student from opening the course.
            if (!IsPostBack)
                LogCourseView(courseID, Convert.ToString(row["CourseTitle"]));
        }

        // Read-only activity: best-effort logging after access has been verified.
        private void LogCourseView(int courseID, string courseTitle)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand("dbo.EActivityLogs_WebSave", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = StudentID;
                    cmd.Parameters.Add("@UserRole", SqlDbType.VarChar, 20).Value = "Student";
                    cmd.Parameters.Add("@ActionType", SqlDbType.VarChar, 50).Value = "VIEW_COURSE";
                    cmd.Parameters.Add("@EntityType", SqlDbType.VarChar, 50).Value = "Course";
                    cmd.Parameters.Add("@EntityID", SqlDbType.Int).Value = courseID;
                    cmd.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value =
                        "Student opened course: " + courseTitle;
                    cmd.Parameters.Add("@Status", SqlDbType.VarChar, 20).Value = "SUCCESS";
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (SqlException)
            {
                // Viewing course content must remain available if audit logging fails.
                System.Diagnostics.Trace.TraceWarning("VIEW_COURSE activity log could not be saved.");
            }
        }

        protected void rptModules_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
            int moduleID = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "ModuleID"));
            DataRow[] rows = lessons.Select("ModuleID = " + moduleID);
            Repeater rptLessons = e.Item.FindControl("rptLessons") as Repeater;
            Label lblNoLessons = e.Item.FindControl("lblNoLessons") as Label;
            if (rptLessons != null) { rptLessons.DataSource = rows.Length > 0 ? rows.CopyToDataTable() : null; rptLessons.DataBind(); }
            if (lblNoLessons != null) lblNoLessons.Visible = rows.Length == 0;

            DataRow[] assignmentRows = assignments.Select("ModuleID = " + moduleID);
            Repeater rptAssignments = e.Item.FindControl("rptAssignments") as Repeater;
            Label lblNoAssignments = e.Item.FindControl("lblNoAssignments") as Label;
            if (rptAssignments != null)
            {
                rptAssignments.DataSource = assignmentRows.Length > 0 ? assignmentRows.CopyToDataTable() : null;
                rptAssignments.DataBind();
            }
            if (lblNoAssignments != null) lblNoAssignments.Visible = assignmentRows.Length == 0;
        }

        protected void rptLessons_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
            int lessonID = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "LessonID"));
            DataRow[] rows = materials.Select("LessonID = " + lessonID);
            Repeater rptMaterials = e.Item.FindControl("rptMaterials") as Repeater;
            Label lblNoMaterials = e.Item.FindControl("lblNoMaterials") as Label;
            if (rptMaterials != null) { rptMaterials.DataSource = rows.Length > 0 ? rows.CopyToDataTable() : null; rptMaterials.DataBind(); }
            if (lblNoMaterials != null) lblNoMaterials.Visible = rows.Length == 0;
        }

        protected void rptAssignments_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
            DataRowView row = e.Item.DataItem as DataRowView;
            if (row == null) return;
            bool submitted = row["SubmittedAt"] != DBNull.Value;
            bool expired = row["DueDate"] != DBNull.Value && Convert.ToDateTime(row["DueDate"]) <= DateTime.Now;
            Label status = e.Item.FindControl("lblSubmissionStatus") as Label;
            Button button = e.Item.FindControl("btnSubmitAssignment") as Button;
            FileUpload upload = e.Item.FindControl("fuAssignment") as FileUpload;
            bool graded = submitted && row["Grade"] != DBNull.Value;
            if (status != null)
            {
                status.Text = graded ? "Graded" : submitted ? "Awaiting Grade" : expired ? "Past Due" : "Not Submitted";
                status.CssClass = "student-grade-status" + (graded ? " graded" : (!submitted && expired ? " late" : ""));
                if (submitted)
                    status.Text += " · Submitted " + Convert.ToDateTime(row["SubmittedAt"]).ToString("MMM dd, yyyy hh:mm tt");
            }
            Panel gradePanel = e.Item.FindControl("pnlGradeDetails") as Panel;
            Label gradeScore = e.Item.FindControl("lblGradeScore") as Label;
            Label gradeFeedback = e.Item.FindControl("lblGradeFeedback") as Label;
            if (gradePanel != null) gradePanel.Visible = graded;
            if (graded)
            {
                if (gradeScore != null)
                    gradeScore.Text = Server.HtmlEncode(Convert.ToDecimal(row["Grade"]).ToString("0.##") + " / " + Convert.ToDecimal(row["MaxScore"]).ToString("0.##") + " points");
                if (gradeFeedback != null)
                {
                    string feedback = row.Row.Table.Columns.Contains("Feedback") && row["Feedback"] != DBNull.Value
                        ? Convert.ToString(row["Feedback"]) : "";
                    gradeFeedback.Text = "<div>" + Server.HtmlEncode(string.IsNullOrWhiteSpace(feedback) ? "No feedback provided yet." : feedback) + "</div>";
                }
            }
            if (button != null) { button.Enabled = !expired; button.Text = submitted ? "Replace Submission" : "Submit File"; }
            if (upload != null) upload.Enabled = !expired;
        }

        // File validation is performed server-side, not only by the HTML accept attribute.
        private bool ValidSubmission(HttpPostedFile file)
        {
            if (file == null || file.ContentLength <= 0 || file.ContentLength > MaxAssignmentBytes) return false;
            string extension = Path.GetExtension(Path.GetFileName(file.FileName)).ToLowerInvariant();
            if (extension != ".pdf" && extension != ".docx" && extension != ".zip") return false;
            Stream stream = file.InputStream;
            if (stream == null || !stream.CanSeek) return false;
            long pos = stream.Position;
            try
            {
                stream.Position = 0;
                byte[] header = new byte[5];
                int count = stream.Read(header, 0, header.Length);
                if (extension == ".pdf") return count >= 5 && header[0] == 0x25 && header[1] == 0x50 && header[2] == 0x44 && header[3] == 0x46 && header[4] == 0x2D;
                return count >= 4 && header[0] == 0x50 && header[1] == 0x4B && (header[2] == 0x03 || header[2] == 0x05 || header[2] == 0x07);
            }
            catch (IOException) { return false; }
            finally { stream.Position = pos; }
        }

        protected void btnSubmitAssignment_Click(object sender, EventArgs e)
        {
            Button button = sender as Button;
            RepeaterItem item = button == null ? null : button.NamingContainer as RepeaterItem;
            FileUpload upload = item == null ? null : item.FindControl("fuAssignment") as FileUpload;
            int assignmentID;
            if (button == null || !int.TryParse(button.CommandArgument, out assignmentID) || assignmentID <= 0 || upload == null || !upload.HasFile)
            { ShowMessage("Choose a file to submit."); return; }
            int courseID = SelectedCourseID();
            if (!CanAccessCourse(courseID)) { ShowMessage("Course access denied."); return; }
            if (!ValidSubmission(upload.PostedFile)) { ShowMessage("Invalid file. Upload a PDF, DOCX or ZIP, maximum 10 MB."); return; }
            // Authorization and deadline are checked again inside the submission procedure.
            string extension = Path.GetExtension(upload.FileName).ToLowerInvariant();
            string storedName = Guid.NewGuid().ToString("N") + extension;
            string virtualPath = AssignmentFolder + storedName;
            string folder = Server.MapPath(AssignmentFolder);
            string physicalPath = Path.Combine(folder, storedName);
            try
            {
                Directory.CreateDirectory(folder);
                upload.SaveAs(physicalPath);
                // Keep the submission and audit record in the same database transaction.
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();
                    using (SqlTransaction tx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        try
                        {
                            bool replacing;
                            int? submissionID = null;
                            string previousFile = null;

                            // Serializable isolation protects the first-submit vs replace decision.
                            using (SqlCommand check = new SqlCommand(
                                @"SELECT SubmissionID, FileUrl FROM dbo.EAssignmentSubmissions WITH (UPDLOCK, HOLDLOCK)
                                  WHERE AssignmentID = @AssignmentID AND StudentID = @StudentID", con, tx))
                            {
                                check.Parameters.Add("@AssignmentID", SqlDbType.Int).Value = assignmentID;
                                check.Parameters.Add("@StudentID", SqlDbType.Int).Value = StudentID;
                                using (SqlDataReader reader = check.ExecuteReader())
                                {
                                    replacing = reader.Read();
                                    if (replacing)
                                    {
                                        submissionID = Convert.ToInt32(reader["SubmissionID"]);
                                        previousFile = Convert.ToString(reader["FileUrl"]);
                                    }
                                }
                            }

                            // The existing stored procedure enforces enrollment and deadline rules.
                            using (SqlCommand cmd = new SqlCommand("dbo.EAssignmentSubmissions_Submit", con, tx))
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.Add("@AssignmentID", SqlDbType.Int).Value = assignmentID;
                                cmd.Parameters.Add("@StudentID", SqlDbType.Int).Value = StudentID;
                                cmd.Parameters.Add("@FileUrl", SqlDbType.VarChar, -1).Value = virtualPath;
                                cmd.ExecuteNonQuery();
                            }

                            // Resolve the actual submission ID after the procedure completes.
                            using (SqlCommand lookup = new SqlCommand(
                                @"SELECT SubmissionID FROM dbo.EAssignmentSubmissions
                                  WHERE AssignmentID = @AssignmentID AND StudentID = @StudentID", con, tx))
                            {
                                lookup.Parameters.Add("@AssignmentID", SqlDbType.Int).Value = assignmentID;
                                lookup.Parameters.Add("@StudentID", SqlDbType.Int).Value = StudentID;
                                object result = lookup.ExecuteScalar();
                                if (result == null || result == DBNull.Value)
                                    throw new InvalidOperationException("Submission was not saved.");
                                submissionID = Convert.ToInt32(result);
                            }

                            using (SqlCommand log = new SqlCommand("dbo.EActivityLogs_WebSave", con, tx))
                            {
                                log.CommandType = CommandType.StoredProcedure;
                                log.Parameters.Add("@UserID", SqlDbType.Int).Value = StudentID;
                                log.Parameters.Add("@UserRole", SqlDbType.VarChar, 20).Value = "Student";
                                log.Parameters.Add("@ActionType", SqlDbType.VarChar, 50).Value =
                                    replacing ? "UPDATE_SUBMISSION" : "SUBMIT_ASSIGNMENT";
                                log.Parameters.Add("@EntityType", SqlDbType.VarChar, 50).Value = "AssignmentSubmission";
                                log.Parameters.Add("@EntityID", SqlDbType.Int).Value = submissionID.Value;
                                log.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value =
                                    (replacing ? "Student replaced" : "Student submitted") +
                                    " assignment #" + assignmentID + " (submission #" + submissionID.Value + ").";
                                log.Parameters.Add("@OldValues", SqlDbType.NVarChar, -1).Value =
                                    replacing ? (object)(previousFile ?? "") : DBNull.Value;
                                log.Parameters.Add("@NewValues", SqlDbType.NVarChar, -1).Value = virtualPath;
                                log.Parameters.Add("@Status", SqlDbType.VarChar, 20).Value = "SUCCESS";
                                log.ExecuteNonQuery();
                            }
                            tx.Commit();
                        }
                        catch
                        {
                            // The submission procedure may already have rolled back the outer transaction.
                            try { tx.Rollback(); } catch (InvalidOperationException) { } catch (SqlException) { }
                            throw;
                        }
                    }
                }
                ShowMessage("Assignment submitted successfully.");
            }
            catch (SqlException ex)
            {
                if (File.Exists(physicalPath)) File.Delete(physicalPath);
                ShowMessage(ex.Number == 50018 ? "The submission deadline has passed." : "Submission failed. Verify that you are assigned to this course and try again.");
            }
            catch (IOException)
            {
                if (File.Exists(physicalPath)) File.Delete(physicalPath);
                ShowMessage("File upload failed. Please try again.");
            }
            catch (Exception)
            {
                if (File.Exists(physicalPath)) File.Delete(physicalPath);
                ShowMessage("Submission failed. Please try again.");
            }
            // Rebind to refresh the submission status and keep the course page visible.
            pnlCourseDirectory.Visible = false;
            pnlCourseDetailsView.Visible = true;
            LoadPageData();
        }

        private void ShowMessage(string message)
        {
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.Visible = true;
        }
    }
}
