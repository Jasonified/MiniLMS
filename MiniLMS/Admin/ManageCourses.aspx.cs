
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MiniLMS.Admin
{
    public partial class ManageCourses : Page
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
                !string.Equals(
                    Convert.ToString(Session["Role"]),
                    "Admin",
                    StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Account/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadPrograms();
                LoadAssignmentPrograms();
                LoadBulkCourses();
                LoadInstructors();
                LoadCourses();
                LoadStudents();
                LoadPanelStudents();
                LoadStatistics();
                ClearCourseForm();
            }
        }

        // =====================================
        // DATABASE HELPERS
        // =====================================

        private DataTable GetProcedureData(
            string procedure,
            params SqlParameter[] parameters)
        {
            DataTable table = new DataTable();

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                new SqlCommand(procedure, con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(table);
                }
            }

            return table;
        }

        private void ExecuteProcedure(
            string procedure,
            params SqlParameter[] parameters)
        {
            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                new SqlCommand(procedure, con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // Phase 4B: log a successful change within the existing SQL transaction.
        private static void SaveActivityLog(SqlConnection con, SqlTransaction tx,
            int actorID, string action, string entityType, int entityID,
            string description, string oldValues = null, string newValues = null)
        {
            using (var cmd = new SqlCommand("dbo.EActivityLogs_WebSave", con, tx))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = actorID;
                cmd.Parameters.Add("@UserRole", SqlDbType.VarChar, 20).Value = "Admin";
                cmd.Parameters.Add("@ActionType", SqlDbType.VarChar, 50).Value = action;
                cmd.Parameters.Add("@EntityType", SqlDbType.VarChar, 50).Value = entityType;
                cmd.Parameters.Add("@EntityID", SqlDbType.Int).Value = entityID;
                cmd.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value = description;
                cmd.Parameters.Add("@OldValues", SqlDbType.NVarChar, -1).Value =
                    (object)oldValues ?? DBNull.Value;
                cmd.Parameters.Add("@NewValues", SqlDbType.NVarChar, -1).Value =
                    (object)newValues ?? DBNull.Value;
                cmd.Parameters.Add("@Status", SqlDbType.VarChar, 20).Value = "SUCCESS";
                cmd.ExecuteNonQuery();
            }
        }

        private static bool SameValue(object oldValue, object newValue)
        {
            string a = oldValue == null || oldValue == DBNull.Value ? null : Convert.ToString(oldValue);
            string b = newValue == null || newValue == DBNull.Value ? null : Convert.ToString(newValue);
            return string.Equals(a, b, StringComparison.Ordinal);
        }

        private static SqlParameter P(
            string name,
            object value)
        {
            return new SqlParameter(
                name,
                value ?? DBNull.Value);
        }

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.Text =
                HttpUtility.HtmlEncode(message);

            lblMessage.ForeColor = success
                ? System.Drawing.Color.DarkGreen
                : System.Drawing.Color.DarkRed;
        }

        private void SelectIfExists(
            DropDownList dropdown,
            object value)
        {
            string selected =
                value == null || value == DBNull.Value
                    ? ""
                    : Convert.ToString(value);

            ListItem item =
                dropdown.Items.FindByValue(selected);

            if (item != null)
            {
                dropdown.ClearSelection();
                item.Selected = true;
            }
        }

        // =====================================
        // PROGRAMS
        // =====================================




        // Load active programs for the Create/Edit Course dropdown.
        // Value = ProgramID, displayed text = ProgramCode.
        private void LoadPrograms()
        {
            DataTable dt = GetProcedureData("dbo.EPrograms_Web");
            string previous = ddlProgram.SelectedValue;

            ddlProgram.Items.Clear();
            ddlProgram.Items.Add(new ListItem("-- Select Program --", ""));

            foreach (DataRow row in dt.Rows)
            {
                ddlProgram.Items.Add(new ListItem(
                    Convert.ToString(row["ProgramCode"]),
                    Convert.ToString(row["ProgramID"])));
            }

            SelectIfExists(ddlProgram, previous);
        }

        protected override void OnPreRender(EventArgs e)
        {
            if (Session["UserID"] != null &&
                string.Equals(
                    Convert.ToString(Session["Role"]),
                    "Admin",
                    StringComparison.OrdinalIgnoreCase) &&
                ddlProgram.Items.Count <= 1)
            {
                LoadPrograms();
            }

            base.OnPreRender(e);
        }


        // =====================================
        // INSTRUCTORS
        // =====================================

        private void LoadInstructors()
        {
            DataTable dt = GetProcedureData("dbo.EUsers_GetActiveInstructors");

            ddlInstructor.DataSource = dt;
            ddlInstructor.DataTextField =
                "InstructorName";
            ddlInstructor.DataValueField = "UserID";
            ddlInstructor.DataBind();

            ddlInstructor.Items.Insert(
                0,
                new ListItem("-- Select Instructor --", ""));
        }

        // =====================================
        // COURSES
        // =====================================

        private void LoadCourses()
        {
            // Phase 4A: course list is retrieved using a stored procedure.
            DataTable dt = GetProcedureData("dbo.EAdminCourses_GetAll");
            gvCourses.DataSource = dt;
            gvCourses.DataBind();
        }

        // Both filters use the same active-program stored procedure.
        // All Courses: ProgramCode value for client-side filtering.
        // Assign Students: ProgramID value for SQL course filtering.
        // Find controls by ID without requiring generated designer declarations.
        private static T FindNestedControl<T>(Control root, string id) where T : Control
        {
            if (root == null) return null;
            if (root.ID == id) return root as T;
            foreach (Control child in root.Controls)
            {
                T found = FindNestedControl<T>(child, id);
                if (found != null) return found;
            }
            return null;
        }

        private void LoadAssignmentPrograms()
        {
            DataTable dt = GetProcedureData("dbo.EPrograms_ActiveFilters");
            DropDownList bulkCourses = FindNestedControl<DropDownList>(this, "ddlBulkCourseProgram");
            DropDownList bulkStudents = FindNestedControl<DropDownList>(this, "ddlBulkStudentProgram");

            var dropdowns = new List<DropDownList> { ddlAllCoursesProgram };
            if (bulkCourses != null) dropdowns.Add(bulkCourses);
            if (bulkStudents != null) dropdowns.Add(bulkStudents);

            foreach (DropDownList dropdown in dropdowns)
            {
                string previous = dropdown.SelectedValue;
                dropdown.Items.Clear();
                dropdown.Items.Add(new ListItem("All Programs", ""));
                foreach (DataRow row in dt.Rows)
                {
                    string code = Convert.ToString(row["ProgramCode"]);
                    dropdown.Items.Add(new ListItem(code, code));
                }
                SelectIfExists(dropdown, previous);
            }
        }

        private void LoadBulkCourses()
        {
            DataTable dt = GetProcedureData("dbo.ECourses_AssignmentList");
            cblAssignmentCourses.DataSource = dt;
            cblAssignmentCourses.DataTextField = "CourseDisplay";
            cblAssignmentCourses.DataValueField = "CourseID";
            cblAssignmentCourses.DataBind();
        }

        // =====================================
        // ELIGIBLE STUDENTS
        // =====================================

        private void LoadStudents()
        {
            // Bulk assignment permits approved and active students of any program/year.
            DataTable dt = GetProcedureData("dbo.EUsers_AssignmentEligibleStudents");
            cblEligibleStudents.DataSource = dt;
            cblEligibleStudents.DataTextField = "StudentName";
            cblEligibleStudents.DataValueField = "StudentID";
            cblEligibleStudents.DataBind();
            lblEligibleInfo.Text = dt.Rows.Count + " approved, active student(s) available.";
        }

        // =====================================
        // ASSIGNED STUDENTS
        // =====================================


        private void LoadPanelStudents(int? courseID = null)
        {
            DataTable dt = GetProcedureData("dbo.EUsers_AssignmentEligibleStudents");
            cblPanelStudents.Items.Clear();
            foreach (DataRow row in dt.Rows)
                cblPanelStudents.Items.Add(new ListItem(Convert.ToString(row["StudentName"]), Convert.ToString(row["StudentID"])));
            if (courseID.HasValue && courseID.Value > 0)
            {
                DataTable assigned = GetProcedureData("dbo.EAdminCourses_GetAssignedStudents", P("@CourseID", courseID.Value));
                foreach (DataRow row in assigned.Rows)
                {
                    ListItem item = cblPanelStudents.Items.FindByValue(Convert.ToString(row["StudentID"]));
                    if (item != null) item.Selected = true;
                }
                // Also show assigned students who are no longer eligible, so they can be retained or removed.
                foreach (DataRow row in assigned.Rows)
                {
                    string id = Convert.ToString(row["StudentID"]);
                    if (cblPanelStudents.Items.FindByValue(id) == null)
                    {
                        var item = new ListItem(Convert.ToString(row["StudentName"]) + " (inactive/pending)", id);
                        item.Selected = true;
                        cblPanelStudents.Items.Add(item);
                    }
                }
            }
            // Show explicit removal actions for students assigned to this course.
            if (courseID.HasValue && courseID.Value > 0)
            {
                gvAssignedStudents.DataSource = GetProcedureData(
                    "dbo.EAdminCourses_GetAssignedStudents", P("@CourseID", courseID.Value));
            }
            else
            {
                gvAssignedStudents.DataSource = null;
            }
            gvAssignedStudents.DataBind();
            lblPanelStudentInfo.Text = cblPanelStudents.Items.Count + " student(s) shown.";
        }

        // Remove one student's assignment from the selected course.
        protected void gvAssignedStudents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "RemoveStudent") return;

            int courseID, studentID;
            if (!int.TryParse(hfCourseID.Value, out courseID) || courseID <= 0 ||
                !int.TryParse(Convert.ToString(e.CommandArgument), out studentID))
            {
                ShowMessage("Select an existing course and student first.", false);
                return;
            }

            hfSelectedTab.Value = "students";
            try
            {
                int actorID = Convert.ToInt32(Session["UserID"]);
                using (var con = new SqlConnection(ConnectionString))
                {
                    con.Open();
                    using (var tx = con.BeginTransaction())
                    {
                        try
                        {
                            // Confirm that this student is currently assigned.
                            bool assigned = false;
                            using (var check = new SqlCommand("dbo.EAdminCourses_GetAssignedStudents", con, tx))
                            {
                                check.CommandType = CommandType.StoredProcedure;
                                check.Parameters.Add("@CourseID", SqlDbType.Int).Value = courseID;
                                using (var reader = check.ExecuteReader())
                                {
                                    while (reader.Read())
                                    {
                                        if (Convert.ToInt32(reader["StudentID"]) == studentID)
                                        {
                                            assigned = true;
                                            break;
                                        }
                                    }
                                }
                            }
                            if (!assigned)
                                throw new InvalidOperationException("This student is not assigned to the course.");

                            // The existing procedure enforces assignment removal rules.
                            using (var cmd = new SqlCommand("dbo.ECourseStudents_Remove", con, tx))
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.Add("@CourseID", SqlDbType.Int).Value = courseID;
                                cmd.Parameters.Add("@StudentID", SqlDbType.Int).Value = studentID;
                                cmd.ExecuteNonQuery();
                            }

                            SaveActivityLog(con, tx, actorID, "REMOVE_STUDENT", "Course", courseID,
                                "Administrator removed student " + studentID + " from course " + courseID + ".",
                                "StudentID=" + studentID);
                            tx.Commit();
                        }
                        catch
                        {
                            tx.Rollback();
                            throw;
                        }
                    }
                }

                RefreshAll();
                EditCourse(courseID);
                hfSelectedTab.Value = "students";
                ShowMessage("Student removed from the course successfully.", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Unable to remove student: " + ex.Message, false);
            }
        }

        // =====================================
        // STATISTICS
        // =====================================

        private void LoadStatistics()
        {
            DataTable dt = GetProcedureData("dbo.ECourses_GetStatistics");

            if (dt.Rows.Count == 0)
                return;

            DataRow row = dt.Rows[0];

            lblTotalCourses.Text = "<strong>" + row["TotalCourses"] + "</strong>";

            lblPublishedCourses.Text = "<strong>" + row["PublishedCourses"] + "</strong>";

            lblTotalEnrollments.Text = "<strong>" + row["TotalEnrollments"] + "</strong>";
        }

        private void RefreshAll()
        {
            LoadPrograms();
            LoadCourses();
            LoadAssignmentPrograms();
            LoadBulkCourses();
            LoadStudents();
            LoadPanelStudents();
            LoadStatistics();
        }

        // =====================================
        // CLEAR COURSE FORM
        // =====================================

        private void ClearCourseForm()
        {
            hfCourseID.Value = "0";

            txtCourseTitle.Text = "";
            txtDescription.Text = "";
            txtAnnouncement.Text = "";


            ddlInstructor.ClearSelection();
            ddlProgram.ClearSelection();
            ddlYearLevel.ClearSelection();
            hfSemester.Value = "1";

            btnSaveCourse.Text = "Save Changes";
            lblEditorHeading.Text = "Add New Course";
            lblCourseStatus.Text = "New courses start unpublished.";
            hfSelectedTab.Value = "details";
            LoadPanelStudents();
        }

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            ClearCourseForm();
            hfSelectedTab.Value = "details";
        }

        // =====================================
        // SAVE COURSE
        // =====================================

        protected void btnNewCourse_Click(object sender, EventArgs e)
        {
            ClearCourseForm();
        }

        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            int courseID, instructorID, programID, yearLevel, semester;
            int.TryParse(hfCourseID.Value, out courseID);
            if (string.IsNullOrWhiteSpace(txtCourseTitle.Text) ||
                !int.TryParse(ddlInstructor.SelectedValue, out instructorID) ||
                !int.TryParse(ddlProgram.SelectedValue, out programID) ||
                !int.TryParse(ddlYearLevel.SelectedValue, out yearLevel) ||
                !int.TryParse(hfSemester.Value, out semester))
            {
                ShowMessage("Enter a course title and select an instructor, program, and year level.", false);
                return;
            }
            try
            {
                int actorID = Convert.ToInt32(Session["UserID"]);
                using (var con = new SqlConnection(ConnectionString))
                {
                    con.Open();
                    using (var tx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        try
                        {
                            bool published = false;
                            bool creating = courseID == 0;
                            DataRow previousCourse = null;
                            if (courseID > 0)
                            {
                                // Read the original course within the same transaction.
                                using (var oldCmd = new SqlCommand("dbo.ECourses_GetByID", con, tx))
                                {
                                    oldCmd.CommandType = CommandType.StoredProcedure;
                                    oldCmd.Parameters.Add("@CourseID", SqlDbType.Int).Value = courseID;
                                    var oldTable = new DataTable();
                                    using (var adapter = new SqlDataAdapter(oldCmd))
                                        adapter.Fill(oldTable);
                                    if (oldTable.Rows.Count == 0)
                                        throw new InvalidOperationException("Course no longer exists.");
                                    previousCourse = oldTable.Rows[0];
                                }
                            }
                            if (courseID > 0)
                            {
                                using (var check = new SqlCommand("dbo.ECourses_GetPublishingStatus", con, tx))
                                {
                                    check.CommandType = CommandType.StoredProcedure;
                                    check.Parameters.Add("@CourseID", SqlDbType.Int).Value = courseID;
                                    object result = check.ExecuteScalar();
                                    if (result == null || result == DBNull.Value)
                                        throw new InvalidOperationException("Course no longer exists.");
                                    published = Convert.ToBoolean(result);
                                }
                            }
                            if (courseID == 0)
                            {
                                using (var cmd = new SqlCommand("dbo.ECourses_WebSave", con, tx))
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.Parameters.AddWithValue("@CourseID", 0);
                                    cmd.Parameters.AddWithValue("@CoursePublished", false);
                                    cmd.Parameters.AddWithValue("@InstructorID", instructorID);
                                    cmd.Parameters.AddWithValue("@CourseTitle", txtCourseTitle.Text.Trim());
                                    cmd.Parameters.AddWithValue("@CourseDescription", txtDescription.Text.Trim());
                                    cmd.Parameters.AddWithValue("@Announcement", txtAnnouncement.Text.Trim());
                                    cmd.Parameters.AddWithValue("@ProgramID", programID);
                                    cmd.Parameters.AddWithValue("@YearLevel", yearLevel);
                                    cmd.Parameters.AddWithValue("@Semester", semester);
                                    courseID = Convert.ToInt32(cmd.ExecuteScalar());
                                }
                            }
                            else
                            {
                                using (var cmd = new SqlCommand("dbo.ECourses_WebSave", con, tx))
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.Parameters.AddWithValue("@CourseID", courseID);
                                    cmd.Parameters.AddWithValue("@InstructorID", instructorID);
                                    cmd.Parameters.AddWithValue("@CourseTitle", txtCourseTitle.Text.Trim());
                                    cmd.Parameters.AddWithValue("@CourseDescription", txtDescription.Text.Trim());
                                    cmd.Parameters.AddWithValue("@Announcement", txtAnnouncement.Text.Trim());
                                    cmd.Parameters.AddWithValue("@CoursePublished", published);
                                    cmd.Parameters.AddWithValue("@ProgramID", programID);
                                    cmd.Parameters.AddWithValue("@YearLevel", yearLevel);
                                    cmd.Parameters.AddWithValue("@Semester", semester);
                                    cmd.ExecuteNonQuery();
                                }
                            }
                            var desired = new HashSet<int>();
                            foreach (ListItem item in cblPanelStudents.Items)
                            {
                                int studentID;
                                if (item.Selected && int.TryParse(item.Value, out studentID)) desired.Add(studentID);
                            }
                            var existing = new HashSet<int>();
                            using (var cmd = new SqlCommand("dbo.EAdminCourses_GetAssignedStudents", con, tx))
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.AddWithValue("@CourseID", courseID);
                                using (var reader = cmd.ExecuteReader())
                                    while (reader.Read()) existing.Add(Convert.ToInt32(reader["StudentID"]));
                            }
                            // Only log a course update when its editable details changed.
                            if (creating)
                            {
                                SaveActivityLog(con, tx, actorID, "CREATE_COURSE", "Course", courseID,
                                    "Administrator created course: " + txtCourseTitle.Text.Trim());
                            }
                            else if (!SameValue(previousCourse["CourseTitle"], txtCourseTitle.Text.Trim()) ||
                                     !SameValue(previousCourse["CourseDescription"], txtDescription.Text.Trim()) ||
                                     !SameValue(previousCourse["Announcement"], txtAnnouncement.Text.Trim()) ||
                                     !SameValue(previousCourse["InstructorID"], instructorID) ||
                                     !SameValue(previousCourse["ProgramID"], programID) ||
                                     !SameValue(previousCourse["YearLevel"], yearLevel) ||
                                     !SameValue(previousCourse["Semester"], semester))
                            {
                                SaveActivityLog(con, tx, actorID, "UPDATE_COURSE", "Course", courseID,
                                    "Administrator updated course: " + txtCourseTitle.Text.Trim());
                            }

                            foreach (int studentID in desired.Except(existing))
                            {
                                using (var cmd = new SqlCommand("dbo.ECourseStudents_Assign", con, tx))
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.Parameters.AddWithValue("@CourseID", courseID);
                                    cmd.Parameters.AddWithValue("@StudentID", studentID);
                                    cmd.ExecuteNonQuery();
                                }
                                SaveActivityLog(con, tx, actorID, "ASSIGN_STUDENT", "Course", courseID,
                                    "Administrator assigned student " + studentID + " to course " + courseID + ".",
                                    null, "StudentID=" + studentID);
                            }
                            foreach (int studentID in existing.Except(desired))
                            {
                                using (var cmd = new SqlCommand("dbo.ECourseStudents_Remove", con, tx))
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.Parameters.AddWithValue("@CourseID", courseID);
                                    cmd.Parameters.AddWithValue("@StudentID", studentID);
                                    cmd.ExecuteNonQuery();
                                }
                                SaveActivityLog(con, tx, actorID, "REMOVE_STUDENT", "Course", courseID,
                                    "Administrator removed student " + studentID + " from course " + courseID + ".",
                                    "StudentID=" + studentID);
                            }
                            tx.Commit();
                        }
                        catch { tx.Rollback(); throw; }
                    }
                }
                RefreshAll();
                EditCourse(courseID);
                ShowMessage("Course and student assignments saved successfully.", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Unable to save changes: " + ex.Message, false);
            }
        }

        // =====================================
        // COURSE GRID ACTIONS
        // =====================================

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int courseID;
            if (e.CommandName != "EditCourse" || !int.TryParse(Convert.ToString(e.CommandArgument), out courseID)) return;
            try { EditCourse(courseID); }
            catch (Exception ex) { ShowMessage("Unable to load course: " + ex.Message, false); }
        }

        // =====================================
        // EDIT COURSE
        // =====================================

        private void EditCourse(int courseID)
        {
            DataTable dt = GetProcedureData("dbo.ECourses_GetByID",
                P("@CourseID", courseID));

            if (dt.Rows.Count == 0)
            {
                ShowMessage(
                    "Course not found.",
                    false);
                return;
            }

            DataRow row = dt.Rows[0];

            hfCourseID.Value =
                row["CourseID"].ToString();

            txtCourseTitle.Text =
                row["CourseTitle"].ToString();

            txtDescription.Text =
                row["CourseDescription"].ToString();

            txtAnnouncement.Text =
                row["Announcement"].ToString();


            SelectIfExists(
                ddlInstructor,
                row["InstructorID"]);

            SelectIfExists(
                ddlProgram,
                row["ProgramID"]);

            SelectIfExists(
                ddlYearLevel,
                row["YearLevel"]);

            hfSemester.Value = row["Semester"] == DBNull.Value
                ? "1" : Convert.ToString(row["Semester"]);

            btnSaveCourse.Text = "Save Changes";
            lblEditorHeading.Text = txtCourseTitle.Text;
            lblCourseStatus.Text = "Course ID: " + courseID + " | Publication managed by instructor";
            hfSelectedTab.Value = "details";
            LoadPanelStudents(courseID);

            ShowMessage(
                "Editing: " + txtCourseTitle.Text,
                true);
        }

        // =====================================
        // ASSIGN STUDENT
        // =====================================

        protected void btnEnroll_Click(object sender, EventArgs e)
        {
            var students = new HashSet<int>();
            var courses = new HashSet<int>();
            int id;
            foreach (ListItem item in cblEligibleStudents.Items)
                if (item.Selected && int.TryParse(item.Value, out id)) students.Add(id);
            foreach (ListItem item in cblAssignmentCourses.Items)
                if (item.Selected && int.TryParse(item.Value, out id)) courses.Add(id);

            if (students.Count == 0 || courses.Count == 0)
            {
                ShowMessage("Select at least one student and one course.", false);
                hfSelectedTab.Value = "students";
                return;
            }

            int added = 0, skipped = 0;
            int actorID = Convert.ToInt32(Session["UserID"]);
            try
            {
                using (var con = new SqlConnection(ConnectionString))
                {
                    con.Open();
                    using (var tx = con.BeginTransaction())
                    {
                        try
                        {
                            foreach (int courseID in courses)
                                foreach (int studentID in students)
                                {
                                    // Validate eligibility and duplicate assignments server-side.
                                    using (var check = new SqlCommand(
                                        "dbo.ECourseStudents_CheckAssignmentEligibility", con, tx))
                                    {
                                        check.CommandType = CommandType.StoredProcedure;
                                        check.Parameters.Add("@CourseID", SqlDbType.Int).Value = courseID;
                                        check.Parameters.Add("@StudentID", SqlDbType.Int).Value = studentID;
                                        if (Convert.ToInt32(check.ExecuteScalar()) != 1)
                                        {
                                            skipped++;
                                            continue;
                                        }
                                    }
                                    using (var cmd = new SqlCommand("dbo.ECourseStudents_Assign", con, tx))
                                    {
                                        cmd.CommandType = CommandType.StoredProcedure;
                                        cmd.Parameters.Add("@CourseID", SqlDbType.Int).Value = courseID;
                                        cmd.Parameters.Add("@StudentID", SqlDbType.Int).Value = studentID;
                                        cmd.ExecuteNonQuery();
                                        SaveActivityLog(con, tx, actorID, "ASSIGN_STUDENT", "Course", courseID,
                                            "Administrator assigned student " + studentID + " to course " + courseID + ".",
                                            null, "StudentID=" + studentID);
                                        added++;
                                    }
                                }
                            tx.Commit();
                        }
                        catch { tx.Rollback(); throw; }
                    }
                }
                RefreshAll();
                ShowMessage(added + " assignment(s) created; " + skipped + " already assigned or ineligible.", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Unable to assign courses: " + ex.Message, false);
            }
            hfSelectedTab.Value = "students";
        }

    }
}
    