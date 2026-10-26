
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;

namespace MiniLMS
{
    public partial class InstructorCourses : System.Web.UI.Page
    {
        private const int MaxMaterialBytes = 10 * 1024 * 1024;
        private const string MaterialFolder =
            "~/App_Data/Uploads/LessonMaterials/";

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
            get { return Convert.ToInt32(Session["UserID"]); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null ||
                Convert.ToString(Session["Role"]) != "Instructor")
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCourses();
                pnlCourseList.Visible = true;
                pnlCourseWorkspace.Visible = false;

                int selectedCourseID = ParseID(Convert.ToString(Session["SelectedCourseID"]));
                Session.Remove("SelectedCourseID");
                if (selectedCourseID > 0)
                    OpenCourse(selectedCourseID);
            }
            else
            {
                bool managingCourse = ParseID(hfCourseID.Value) > 0;
                pnlCourseList.Visible = !managingCourse;
                pnlCourseWorkspace.Visible = managingCourse;
                if (managingCourse)
                    lblWorkspaceCourse.Text = lblSelectedCourse.Text;
            }


        }

        // =========================================
        // DATABASE HELPERS
        // =========================================

        private DataTable GetProcedureData(
            string procedure, params SqlParameter[] parameters)
        {
            DataTable table = new DataTable();

            using (SqlConnection connection =
                new SqlConnection(ConnectionString))
            using (SqlCommand command =
                new SqlCommand(procedure, connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                if (parameters != null && parameters.Length > 0)
                    command.Parameters.AddRange(parameters);

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(command))
                {
                    adapter.Fill(table);
                }
            }

            return table;
        }

        private void ExecuteProcedure(
            string procedure, params SqlParameter[] parameters)
        {
            using (SqlConnection connection =
                new SqlConnection(ConnectionString))
            using (SqlCommand command =
                new SqlCommand(procedure, connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                if (parameters != null && parameters.Length > 0)
                    command.Parameters.AddRange(parameters);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        // Executes the original operation and its audit record in one SQL transaction.
        private void ExecuteLoggedProcedure(string procedure, string action,
            string entity, int? entityID, string description,
            params SqlParameter[] parameters)
        {
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        using (SqlCommand operation = new SqlCommand(procedure, connection, transaction))
                        {
                            operation.CommandType = CommandType.StoredProcedure;
                            if (parameters != null && parameters.Length > 0)
                                operation.Parameters.AddRange(parameters);
                            operation.ExecuteNonQuery();
                        }
                        using (SqlCommand audit = new SqlCommand("dbo.EActivityLogs_WebSave", connection, transaction))
                        {
                            audit.CommandType = CommandType.StoredProcedure;
                            audit.Parameters.Add("@UserID", SqlDbType.Int).Value = InstructorID;
                            audit.Parameters.Add("@UserRole", SqlDbType.VarChar, 20).Value = "Instructor";
                            audit.Parameters.Add("@ActionType", SqlDbType.VarChar, 50).Value = action;
                            audit.Parameters.Add("@EntityType", SqlDbType.VarChar, 50).Value = entity;
                            audit.Parameters.Add("@EntityID", SqlDbType.Int).Value = entityID.HasValue ? (object)entityID.Value : DBNull.Value;
                            audit.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value = description.Length > 500 ? description.Substring(0, 500) : description;
                            audit.Parameters.Add("@Status", SqlDbType.VarChar, 20).Value = "SUCCESS";
                            audit.ExecuteNonQuery();
                        }
                        transaction.Commit();
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        private static SqlParameter IntParam(string name, int value)
        {
            return new SqlParameter(name, SqlDbType.Int)
            {
                Value = value
            };
        }

        private static SqlParameter TextParam(
            string name, string value, int size)
        {
            return new SqlParameter(name, SqlDbType.VarChar, size)
            {
                Value = value
            };
        }

        private static int ParseID(string value)
        {
            int id;
            return int.TryParse(value, out id) && id > 0 ? id : 0;
        }

        // =========================================
        // COURSES
        // =========================================

        private void LoadCourses()
        {
            // Include publishing status and restrict the list to assigned courses.
            DataTable courses = GetProcedureData(
                "dbo.EInstructorCourses_Web",
                IntParam("@InstructorID", InstructorID));
            gvCourses.DataSource = courses;
            gvCourses.DataBind();
        }

        private bool LoadSelectedCourse(int courseID)
        {
            DataTable table = GetProcedureData(
                "dbo.EInstructorCourses_WebOne",
                IntParam("@CourseID", courseID),
                IntParam("@InstructorID", InstructorID));

            if (table.Rows.Count == 0)
            {
                lblSelectedCourse.Text = "";
                return false;
            }

            lblSelectedCourse.Text = Server.HtmlEncode(
                Convert.ToString(table.Rows[0]["CourseTitle"]));

            return true;
        }

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int courseID = ParseID(Convert.ToString(e.CommandArgument));
            if (e.CommandName == "SelectCourse")
            {
                OpenCourse(courseID);
                return;
            }
            if (e.CommandName != "PublishCourse" && e.CommandName != "UnpublishCourse")
                return;
            if (courseID == 0)
            {
                ShowError("Invalid course selection.");
                return;
            }
            bool publish = e.CommandName == "PublishCourse";
            try
            {
                ExecuteLoggedProcedure("dbo.EInstructorCourses_WebSave", publish ? "PUBLISH_COURSE" : "UNPUBLISH_COURSE", "Course", courseID, publish ? "Instructor published course #" + courseID : "Instructor unpublished course #" + courseID,
                    IntParam("@CourseID", courseID),
                    IntParam("@InstructorID", InstructorID),
                    new SqlParameter("@CoursePublished", SqlDbType.Bit)
                    { Value = publish });
                LoadCourses();
                ShowSuccess(publish ? "Course published successfully." : "Course unpublished successfully.");
            }
            catch (SqlException)
            {
                ShowError("Unable to update course publication status.");
            }
        }

        private void OpenCourse(int courseID)
        {
            // LoadSelectedCourse checks ownership through EInstructorCourses_WebOne.
            if (courseID == 0 || !LoadSelectedCourse(courseID))
            {
                hfCourseID.Value = "";
                hfModuleID.Value = "";
                hfMaterialLessonID.Value = "";
                pnlCourseList.Visible = true;
                pnlCourseWorkspace.Visible = false;
                pnlModules.Visible = false;
                pnlLessons.Visible = false;
                pnlLessonDetails.Visible = false;
                pnlAssignments.Visible = false;
                ShowError("Course not found or access denied.");
                return;
            }

            pnlAssignments.Visible = false;
            ResetAssignmentEditor();
            hfCourseID.Value = courseID.ToString();
            hfModuleID.Value = "";
            hfMaterialLessonID.Value = "";
            lblSelectedModule.Text = "";
            ResetModuleEditor();
            ResetLessonEditor();
            pnlCourseList.Visible = false;
            pnlCourseWorkspace.Visible = true;
            lblWorkspaceCourse.Text = lblSelectedCourse.Text;
            pnlLessonDetails.Visible = false;
            pnlLessons.Visible = false;
            pnlModules.Visible = true;
            gvLessons.DataSource = null;
            gvLessons.DataBind();
            LoadModules(courseID);
            lblMessage.Text = "";
        }

        protected void btnBackToCourses_Click(object sender, EventArgs e)
        {
            pnlAssignments.Visible = false;
            ResetAssignmentEditor();
            hfCourseID.Value = "";
            hfModuleID.Value = "";
            hfMaterialLessonID.Value = "";
            lblSelectedCourse.Text = "";
            lblSelectedModule.Text = "";
            lblWorkspaceCourse.Text = "";
            ResetModuleEditor();
            ResetLessonEditor();
            pnlModules.Visible = false;
            pnlLessons.Visible = false;
            pnlLessonDetails.Visible = false;
            pnlCourseWorkspace.Visible = false;
            pnlCourseList.Visible = true;
            LoadCourses();
            lblMessage.Text = "";
        }

        // =========================================
        // MODULES
        // =========================================

        private bool InstructorOwnsModule(
            int moduleID, int courseID)
        {
            DataTable table = GetProcedureData(
                "dbo.EInstructorModule_Owns",
                IntParam("@ModuleID", moduleID),
                IntParam("@CourseID", courseID),
                IntParam("@InstructorID", InstructorID));

            return table.Rows.Count > 0 &&
                Convert.ToInt32(table.Rows[0][0]) == 1;
        }

        private void LoadModules(int courseID)
        {
            gvModules.DataSource = GetProcedureData(
                "dbo.EInstructorModules_Web",
                IntParam("@CourseID", courseID),
                IntParam("@InstructorID", InstructorID));

            gvModules.DataBind();
        }

        private DataTable ReadOwnedModule(int moduleID)
        {
            return GetProcedureData(
                "dbo.EInstructorModules_WebOne",
                IntParam("@ModuleID", moduleID),
                IntParam("@InstructorID", InstructorID));
        }

        private bool LoadSelectedModule(int moduleID)
        {
            DataTable table = ReadOwnedModule(moduleID);

            if (table.Rows.Count == 0)
            {
                lblSelectedModule.Text = "";
                return false;
            }

            lblSelectedModule.Text = Server.HtmlEncode(
                Convert.ToString(table.Rows[0]["ModuleTitle"]));

            return true;
        }

        protected void btnAddModule_Click(
            object sender, EventArgs e)
        {
            if (sender == btnCancelModuleEdit)
            {
                ResetModuleEditor();
                pnlModules.Visible = true;
                lblMessage.Text = "";
                return;
            }

            int courseID = ParseID(hfCourseID.Value);
            int moduleID = ParseID(hfEditModuleID.Value);
            int moduleOrder;

            if (courseID == 0 || !LoadSelectedCourse(courseID))
            {
                ShowError("Select an assigned course first.");
                return;
            }

            if (!string.IsNullOrEmpty(hfEditModuleID.Value) &&
                moduleID == 0)
            {
                ShowError("Invalid module edit request.");
                return;
            }

            string title = txtModuleTitle.Text.Trim();

            if (string.IsNullOrWhiteSpace(title) ||
                title.Length > 150 ||
                !int.TryParse(txtModuleOrder.Text, out moduleOrder) ||
                moduleOrder < 1)
            {
                ShowError("Enter a valid module title and order.");
                return;
            }

            if (moduleID > 0 &&
                !InstructorOwnsModule(moduleID, courseID))
            {
                ShowError("You cannot edit this module.");
                return;
            }

            try
            {
                ExecuteLoggedProcedure(
                    "dbo.EModules_WebSave", moduleID > 0 ? "UPDATE_MODULE" : "CREATE_MODULE", "Module", moduleID > 0 ? (int?)moduleID : null, "Instructor saved module: " + title,
                    IntParam("@ModuleID", moduleID),
                    IntParam("@CourseID", courseID),
                    TextParam("@ModuleTitle", title, 150),
                    IntParam("@ModuleOrder", moduleOrder));

                bool editing = moduleID > 0;

                ResetModuleEditor();
                LoadModules(courseID);
                pnlModules.Visible = true;

                ShowSuccess(editing
                    ? "Module updated successfully."
                    : "Module added successfully.");
            }
            catch (SqlException)
            {
                ShowError("Unable to save module.");
            }
        }

        protected void gvModules_RowCommand(
            object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "SelectModule" &&
                e.CommandName != "EditModule" &&
                e.CommandName != "DeleteModule")
                return;

            int moduleID = ParseID(
                Convert.ToString(e.CommandArgument));

            int courseID = ParseID(hfCourseID.Value);

            if (moduleID == 0 || courseID == 0 ||
                !InstructorOwnsModule(moduleID, courseID))
            {
                ShowError("Module not found or access denied.");
                return;
            }

            if (e.CommandName == "SelectModule")
            {
                if (!LoadSelectedModule(moduleID))
                {
                    ShowError("Module not found.");
                    return;
                }

                hfModuleID.Value = moduleID.ToString();
                hfMaterialLessonID.Value = "";

                ResetLessonEditor();
                pnlLessonDetails.Visible = false;

                LoadLessons(moduleID);
                ResetAssignmentEditor();
                LoadAssignments(moduleID);
                pnlAssignments.Visible = true;
                lblAssignmentModule.Text = lblSelectedModule.Text;

                pnlModules.Visible = true;
                pnlLessons.Visible = true;
            }
            else if (e.CommandName == "EditModule")
            {
                DataTable table = ReadOwnedModule(moduleID);

                if (table.Rows.Count == 0)
                {
                    ShowError("Module not found.");
                    return;
                }

                DataRow row = table.Rows[0];

                hfEditModuleID.Value = moduleID.ToString();
                txtModuleTitle.Text =
                    Convert.ToString(row["ModuleTitle"]);
                txtModuleOrder.Text =
                    Convert.ToString(row["ModuleOrder"]);

                btnAddModule.Text = "Save Module";
                btnCancelModuleEdit.Visible = true;
                pnlModules.Visible = true;
            }
            else
            {
                try
                {
                    ExecuteLoggedProcedure(
                        "dbo.EModules_WebDelete", "DELETE_MODULE", "Module", moduleID, "Instructor deleted module #" + moduleID,
                        IntParam("@ModuleID", moduleID));

                    LoadModules(courseID);
                    ResetModuleEditor();

                    if (hfModuleID.Value == moduleID.ToString())
                    {
                        hfModuleID.Value = "";
                        hfMaterialLessonID.Value = "";

                        lblSelectedModule.Text = "";

                        pnlLessons.Visible = false;
                        pnlLessonDetails.Visible = false;
                        pnlAssignments.Visible = false;
                        ResetAssignmentEditor();

                        ResetLessonEditor();
                    }

                    pnlModules.Visible = true;
                    ShowSuccess("Module deleted successfully.");
                }
                catch (SqlException)
                {
                    ShowError(
                        "Unable to delete module. It may have related records.");
                }
            }
        }

        private void ResetModuleEditor()
        {
            hfEditModuleID.Value = "";
            txtModuleTitle.Text = "";
            txtModuleOrder.Text = "1";
            btnAddModule.Text = "Add Module";
            btnCancelModuleEdit.Visible = false;
        }

        // =========================================
        // LESSONS
        // =========================================

        private bool InstructorOwnsLesson(
            int lessonID, int moduleID)
        {
            DataTable table = GetProcedureData(
                "dbo.EInstructorLesson_Owns",
                IntParam("@LessonID", lessonID),
                IntParam("@ModuleID", moduleID),
                IntParam("@InstructorID", InstructorID));

            return table.Rows.Count > 0 &&
                Convert.ToInt32(table.Rows[0][0]) == 1;
        }

        private void LoadLessons(int moduleID)
        {
            gvLessons.DataSource = GetProcedureData(
                "dbo.EInstructorLessons_Web",
                IntParam("@ModuleID", moduleID),
                IntParam("@InstructorID", InstructorID));

            gvLessons.DataBind();
        }

        private DataTable ReadOwnedLesson(int lessonID)
        {
            return GetProcedureData(
                "dbo.EInstructorLessons_WebOne",
                IntParam("@LessonID", lessonID),
                IntParam("@InstructorID", InstructorID));
        }

        protected void btnAddLesson_Click(
            object sender, EventArgs e)
        {
            if (sender == btnCancelLessonEdit)
            {
                ResetLessonEditor();
                pnlModules.Visible = true;
                pnlLessons.Visible = true;
                lblMessage.Text = "";
                return;
            }

            if (sender == btnCloseLessonDetails)
            {
                pnlLessonDetails.Visible = false;
                hfMaterialLessonID.Value = "";

                pnlModules.Visible = true;
                pnlLessons.Visible = true;
                return;
            }

            int courseID = ParseID(hfCourseID.Value);
            int moduleID = ParseID(hfModuleID.Value);
            int lessonID = ParseID(hfEditLessonID.Value);

            int lessonOrder;
            int duration;

            if (courseID == 0 || moduleID == 0 ||
                !InstructorOwnsModule(moduleID, courseID))
            {
                ShowError("Select an assigned module first.");
                return;
            }

            if (!string.IsNullOrEmpty(hfEditLessonID.Value) &&
                lessonID == 0)
            {
                ShowError("Invalid lesson edit request.");
                return;
            }

            if (lessonID > 0 &&
                !InstructorOwnsLesson(lessonID, moduleID))
            {
                ShowError("You cannot edit this lesson.");
                return;
            }

            string title = txtLessonTitle.Text.Trim();
            string description = txtLessonDescription.Text.Trim();

            if (string.IsNullOrWhiteSpace(title) ||
                title.Length > 150 ||
                string.IsNullOrWhiteSpace(description) ||
                !int.TryParse(txtLessonOrder.Text, out lessonOrder) ||
                lessonOrder < 1 ||
                !int.TryParse(txtDuration.Text, out duration) ||
                duration < 1)
            {
                ShowError(
                    "Enter a valid lesson title, description, order, and duration.");
                return;
            }

            try
            {
                ExecuteLoggedProcedure(
                    "dbo.ELessons_WebSave", lessonID > 0 ? "UPDATE_LESSON" : "CREATE_LESSON", "Lesson", lessonID > 0 ? (int?)lessonID : null, "Instructor saved lesson: " + title,
                    IntParam("@LessonID", lessonID),
                    IntParam("@ModuleID", moduleID),
                    TextParam("@LessonTitle", title, 150),
                    TextParam("@LessonDescription", description, -1),
                    IntParam("@LessonOrder", lessonOrder),
                    IntParam("@DurationMinutes", duration));

                bool editing = lessonID > 0;

                ResetLessonEditor();
                LoadLessons(moduleID);

                pnlModules.Visible = true;
                pnlLessons.Visible = true;
                pnlLessonDetails.Visible = false;
                hfMaterialLessonID.Value = "";

                ShowSuccess(editing
                    ? "Lesson updated successfully."
                    : "Lesson added successfully.");
            }
            catch (SqlException)
            {
                ShowError("Unable to save lesson.");
            }
        }

        protected void gvLessons_RowCommand(
            object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "EditLesson" &&
                e.CommandName != "LessonDetails" &&
                e.CommandName != "DeleteLesson")
                return;

            int lessonID = ParseID(
                Convert.ToString(e.CommandArgument));

            int moduleID = ParseID(hfModuleID.Value);
            int courseID = ParseID(hfCourseID.Value);

            if (lessonID == 0 || moduleID == 0 ||
                courseID == 0 ||
                !InstructorOwnsModule(moduleID, courseID) ||
                !InstructorOwnsLesson(lessonID, moduleID))
            {
                ShowError("Lesson not found or access denied.");
                return;
            }

            if (e.CommandName == "DeleteLesson")
            {
                try
                {
                    ExecuteLoggedProcedure(
                        "dbo.ELessons_WebDelete", "DELETE_LESSON", "Lesson", lessonID, "Instructor deleted lesson #" + lessonID,
                        IntParam("@LessonID", lessonID));

                    LoadLessons(moduleID);

                    if (hfEditLessonID.Value == lessonID.ToString())
                        ResetLessonEditor();

                    if (hfMaterialLessonID.Value == lessonID.ToString())
                    {
                        hfMaterialLessonID.Value = "";
                        pnlLessonDetails.Visible = false;
                    }

                    pnlModules.Visible = true;
                    pnlLessons.Visible = true;

                    ShowSuccess("Lesson deleted successfully.");
                }
                catch (SqlException)
                {
                    ShowError(
                        "Unable to delete lesson. It may have related records.");
                }

                return;
            }

            DataTable table = ReadOwnedLesson(lessonID);

            if (table.Rows.Count == 0)
            {
                ShowError("Lesson not found.");
                return;
            }

            DataRow row = table.Rows[0];

            if (e.CommandName == "EditLesson")
            {
                hfEditLessonID.Value = lessonID.ToString();

                txtLessonTitle.Text =
                    Convert.ToString(row["LessonTitle"]);

                txtLessonDescription.Text =
                    Convert.ToString(row["LessonDescription"]);

                txtLessonOrder.Text =
                    Convert.ToString(row["LessonOrder"]);

                txtDuration.Text =
                    Convert.ToString(row["DurationMinutes"]);

                btnAddLesson.Text = "Save Lesson";
                btnCancelLessonEdit.Visible = true;

                pnlLessonDetails.Visible = false;
            }
            else if (e.CommandName == "LessonDetails")
            {
                lblDetailTitle.Text = Server.HtmlEncode(
                    Convert.ToString(row["LessonTitle"]));

                lblDetailMeta.Text = Server.HtmlEncode(
                    "Lesson " +
                    Convert.ToString(row["LessonOrder"]) +
                    " - " +
                    Convert.ToString(row["DurationMinutes"]) +
                    " minutes");

                litDetailDescription.Text = Server.HtmlEncode(
                    Convert.ToString(row["LessonDescription"]));

                hfMaterialLessonID.Value = lessonID.ToString();

                LoadLessonMaterials(lessonID);

                lblMaterialMessage.Text = "";
                pnlLessonDetails.Visible = true;
            }

            pnlModules.Visible = true;
            pnlLessons.Visible = true;
        }

        private void ResetLessonEditor()
        {
            hfEditLessonID.Value = "";

            txtLessonTitle.Text = "";
            txtLessonDescription.Text = "";
            txtLessonOrder.Text = "1";
            txtDuration.Text = "1";

            btnAddLesson.Text = "Add Lesson";
            btnCancelLessonEdit.Visible = false;
        }

        // =========================================
        // LEARNING MATERIALS
        // =========================================

        private void LoadLessonMaterials(int lessonID)
        {
            gvLessonMaterials.DataSource = GetProcedureData(
                "dbo.ELessonMaterials_Web",
                IntParam("@LessonID", lessonID),
                IntParam("@InstructorID", InstructorID));

            gvLessonMaterials.DataBind();
        }

        private DataTable GetOwnedMaterial(int materialID)
        {
            return GetProcedureData(
                "dbo.ELessonMaterials_WebOne",
                IntParam("@MaterialID", materialID),
                IntParam("@InstructorID", InstructorID));
        }

        private bool CanManageMaterialLesson(int lessonID)
        {
            int courseID = ParseID(hfCourseID.Value);
            int moduleID = ParseID(hfModuleID.Value);

            return lessonID > 0 &&
                courseID > 0 &&
                moduleID > 0 &&
                InstructorOwnsModule(moduleID, courseID) &&
                InstructorOwnsLesson(lessonID, moduleID);
        }

        // Validates allowed extensions, file size, and basic file signatures.
        // Note: DOCX/PPTX ZIP signatures do not prove that Office content is valid.
        private bool IsValidMaterial(HttpPostedFile file)
        {
            if (file == null || file.ContentLength <= 0 ||
                file.ContentLength > MaxMaterialBytes)
                return false;

            string originalName = Path.GetFileName(file.FileName);
            if (string.IsNullOrWhiteSpace(originalName) || originalName.Length > 255)
                return false;

            string extension = Path.GetExtension(originalName).ToLowerInvariant();
            if (extension != ".pdf" && extension != ".docx" && extension != ".pptx")
                return false;

            Stream stream = file.InputStream;
            if (stream == null || !stream.CanSeek)
                return false;

            long originalPosition = stream.Position;
            try
            {
                stream.Position = 0;
                byte[] header = new byte[8];
                int bytesRead = stream.Read(header, 0, header.Length);

                if (extension == ".pdf")
                {
                    return bytesRead >= 5 &&
                        header[0] == 0x25 && header[1] == 0x50 &&
                        header[2] == 0x44 && header[3] == 0x46 &&
                        header[4] == 0x2D;
                }

                // DOCX and PPTX are ZIP-based containers.
                return bytesRead >= 4 &&
                    header[0] == 0x50 && header[1] == 0x4B &&
                    header[2] == 0x03 && header[3] == 0x04;
            }
            catch (IOException)
            {
                return false;
            }
            finally
            {
                // Restore the upload stream position when possible.
                if (stream.CanSeek)
                {
                    try { stream.Position = originalPosition; }
                    catch (IOException) { /* The upload will fail validation if unreadable. */ }
                }
            }
        }

        protected void btnUploadMaterials_Click(
            object sender, EventArgs e)
        {
            int lessonID = ParseID(hfMaterialLessonID.Value);

            pnlModules.Visible = true;
            pnlLessons.Visible = true;
            pnlLessonDetails.Visible = true;

            if (!CanManageMaterialLesson(lessonID))
            {
                ShowMaterialError(
                    "Select a lesson you own before uploading.");
                return;
            }

            if (!fuLearningMaterials.HasFiles)
            {
                ShowMaterialError("Please select at least one file.");
                return;
            }

            // Validate every file before starting the upload.
            foreach (HttpPostedFile file
                in fuLearningMaterials.PostedFiles)
            {
                if (!IsValidMaterial(file))
                {
                    ShowMaterialError(
                        "Invalid file. Use PDF, DOCX, or PPTX, " +
                        "maximum 10 MB per file.");
                    return;
                }
            }

            string folder = Server.MapPath(MaterialFolder);
            Directory.CreateDirectory(folder);

            int uploaded = 0;

            foreach (HttpPostedFile file
                in fuLearningMaterials.PostedFiles)
            {
                string extension = Path.GetExtension(
                    file.FileName).ToLowerInvariant();

                string originalName = Path.GetFileName(file.FileName);

                if (originalName.Length > 255)
                {
                    ShowMaterialError("Filename is too long.");
                    return;
                }

                string storedName =
                    Guid.NewGuid().ToString("N") + extension;

                string virtualPath = MaterialFolder + storedName;
                string physicalPath = Path.Combine(folder, storedName);

                try
                {
                    file.SaveAs(physicalPath);

                    ExecuteLoggedProcedure(
                        "dbo.ELessonMaterials_WebSave", "UPLOAD_MATERIAL", "LessonMaterial", null, "Instructor uploaded material: " + originalName + " for lesson #" + lessonID,
                        IntParam("@LessonID", lessonID),
                        IntParam("@InstructorID", InstructorID),
                        new SqlParameter("@FileName",
                            SqlDbType.NVarChar, 255)
                        {
                            Value = originalName
                        },
                        new SqlParameter("@FilePath",
                            SqlDbType.NVarChar, 500)
                        {
                            Value = virtualPath
                        },
                        new SqlParameter("@FileSize",
                            SqlDbType.BigInt)
                        {
                            Value = file.ContentLength
                        });

                    uploaded++;
                }
                catch (Exception)
                {
                    if (File.Exists(physicalPath))
                        File.Delete(physicalPath);

                    LoadLessonMaterials(lessonID);

                    ShowMaterialError(
                        uploaded + " file(s) uploaded, " +
                        "but another file failed.");
                    return;
                }
            }

            LoadLessonMaterials(lessonID);

            lblMaterialMessage.ForeColor = Color.Green;
            lblMaterialMessage.Text =
                uploaded + " material(s) uploaded successfully.";
        }

        protected void gvLessonMaterials_RowCommand(
            object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "DownloadMaterial" &&
                e.CommandName != "DeleteMaterial")
                return;

            int materialID = ParseID(
                Convert.ToString(e.CommandArgument));

            int lessonID = ParseID(hfMaterialLessonID.Value);

            pnlModules.Visible = true;
            pnlLessons.Visible = true;
            pnlLessonDetails.Visible = true;

            if (materialID == 0 ||
                !CanManageMaterialLesson(lessonID))
            {
                ShowMaterialError("Access denied.");
                return;
            }

            DataTable table = GetOwnedMaterial(materialID);

            if (table.Rows.Count == 0 ||
                Convert.ToInt32(table.Rows[0]["LessonID"]) != lessonID)
            {
                ShowMaterialError("Material not found.");
                return;
            }

            DataRow row = table.Rows[0];

            string virtualPath =
                Convert.ToString(row["FilePath"]);

            string storedName = Path.GetFileName(virtualPath);

            bool validName = Regex.IsMatch(
                storedName ?? "",
                @"^[a-f0-9]{32}\.(pdf|docx|pptx)$",
                RegexOptions.IgnoreCase |
                RegexOptions.CultureInvariant);

            if (!validName ||
                !string.Equals(
                    virtualPath,
                    MaterialFolder + storedName,
                    StringComparison.Ordinal))
            {
                ShowMaterialError("Invalid stored file path.");
                return;
            }

            string physicalPath = Path.Combine(
                Server.MapPath(MaterialFolder), storedName);

            if (e.CommandName == "DownloadMaterial")
            {
                if (!File.Exists(physicalPath))
                {
                    ShowMaterialError("File does not exist.");
                    return;
                }

                string extension =
                    Path.GetExtension(storedName).ToLowerInvariant();

                // Generated download filename prevents
                // header injection from original filenames.
                Response.Clear();
                Response.ContentType = "application/octet-stream";
                Response.AddHeader(
                    "Content-Disposition",
                    "attachment; filename=\"material_" +
                    materialID + extension + "\"");

                Response.AddHeader(
                    "X-Content-Type-Options", "nosniff");

                Response.TransmitFile(physicalPath);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (e.CommandName == "DeleteMaterial")
            {
                try
                {
                    ExecuteLoggedProcedure(
                        "dbo.ELessonMaterials_WebDelete", "DELETE_MATERIAL", "LessonMaterial", materialID, "Instructor deleted material #" + materialID,
                        IntParam("@MaterialID", materialID),
                        IntParam("@InstructorID", InstructorID));

                    // Delete file after database authorization.
                    if (File.Exists(physicalPath))
                        File.Delete(physicalPath);

                    LoadLessonMaterials(lessonID);

                    lblMaterialMessage.ForeColor = Color.Green;
                    lblMaterialMessage.Text =
                        "Learning material deleted successfully.";
                }
                catch (Exception)
                {
                    LoadLessonMaterials(lessonID);
                    ShowMaterialError(
                        "Could not complete deletion. " +
                        "Please check the server logs.");
                }
            }
        }

        private void ShowMaterialError(string message)
        {
            lblMaterialMessage.ForeColor = Color.Red;
            lblMaterialMessage.Text = Server.HtmlEncode(message);
        }


        // =========================================
        // PHASE 2: MODULE ASSIGNMENTS
        // =========================================
        private bool CanManageAssignmentModule()
        {
            int moduleID = ParseID(hfModuleID.Value);
            int courseID = ParseID(hfCourseID.Value);
            return moduleID > 0 && courseID > 0 &&
                InstructorOwnsModule(moduleID, courseID);
        }

        private DataTable ReadOwnedAssignment(int assignmentID)
        {
            return GetProcedureData("dbo.EAssignments_WebOne",
                IntParam("@AssignmentID", assignmentID),
                IntParam("@ModuleID", ParseID(hfModuleID.Value)),
                IntParam("@CourseID", ParseID(hfCourseID.Value)),
                IntParam("@InstructorID", InstructorID));
        }

        private void LoadAssignments(int moduleID)
        {
            if (!CanManageAssignmentModule()) { pnlAssignments.Visible = false; return; }
            DataTable table = GetProcedureData("dbo.EAssignments_Web",
                IntParam("@ModuleID", moduleID),
                IntParam("@CourseID", ParseID(hfCourseID.Value)),
                IntParam("@InstructorID", InstructorID));
            gvAssignments.DataSource = table;
            gvAssignments.DataBind();
            pnlAssignments.Visible = true;
        }

        private void ResetAssignmentEditor()
        {
            hfEditAssignmentID.Value = "";
            hfViewAssignmentID.Value = "";
            txtAssignmentTitle.Text = "";
            txtAssignmentDescription.Text = "";
            txtAssignmentDueDate.Text = "";
            txtAssignmentMaxScore.Text = "100";
            btnSaveAssignment.Text = "Add Assignment";
            btnCancelAssignment.Visible = false;
            pnlAssignmentSubmissions.Visible = false;
        }

        protected void btnCancelAssignment_Click(object sender, EventArgs e)
        {
            ResetAssignmentEditor();
            pnlAssignments.Visible = CanManageAssignmentModule();
        }

        protected void btnSaveAssignment_Click(object sender, EventArgs e)
        {
            if (!CanManageAssignmentModule()) { ShowError("Module access denied."); return; }
            int moduleID = ParseID(hfModuleID.Value);
            int assignmentID = ParseID(hfEditAssignmentID.Value);
            if (!string.IsNullOrEmpty(hfEditAssignmentID.Value) && assignmentID == 0)
            { ShowError("Invalid assignment ID."); return; }
            if (assignmentID > 0 && ReadOwnedAssignment(assignmentID).Rows.Count == 0)
            { ShowError("Assignment access denied."); return; }

            string title = txtAssignmentTitle.Text.Trim();
            string description = txtAssignmentDescription.Text.Trim();
            decimal maxScore;
            if (string.IsNullOrWhiteSpace(title) || title.Length > 150 ||
                description.Length > 10000 ||
                !decimal.TryParse(txtAssignmentMaxScore.Text, out maxScore) ||
                maxScore <= 0 || maxScore > 100)
            { ShowError("Enter a title, instructions (max 10,000 characters), and a score from 1 to 100."); return; }

            DateTime dueDate;
            object dueValue = DBNull.Value;
            if (!string.IsNullOrWhiteSpace(txtAssignmentDueDate.Text))
            {
                if (!DateTime.TryParseExact(txtAssignmentDueDate.Text,
                    "yyyy-MM-ddTHH:mm", System.Globalization.CultureInfo.InvariantCulture,
                    System.Globalization.DateTimeStyles.None, out dueDate))
                { ShowError("Invalid due date and time."); return; }
                dueValue = dueDate;
            }
            try
            {
                ExecuteLoggedProcedure("dbo.EAssignments_WebSave", assignmentID > 0 ? "UPDATE_ASSIGNMENT" : "CREATE_ASSIGNMENT", "Assignment", assignmentID > 0 ? (int?)assignmentID : null, "Instructor saved assignment: " + title,
                    IntParam("@AssignmentID", assignmentID),
                    IntParam("@ModuleID", moduleID),
                    TextParam("@AssignmentTitle", title, 150),
                    TextParam("@AssignmentDescription", description, -1),
                    new SqlParameter("@DueDate", SqlDbType.DateTime) { Value = dueValue },
                    new SqlParameter("@MaxScore", SqlDbType.Decimal)
                    { Precision = 7, Scale = 2, Value = maxScore });
                ResetAssignmentEditor();
                LoadAssignments(moduleID);
                ShowSuccess(assignmentID > 0 ? "Assignment updated." : "Assignment created.");
            }
            catch (SqlException) { ShowError("Unable to save assignment. Check the Phase 1 procedure."); }
        }

        protected void gvAssignments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "EditAssignment" && e.CommandName != "DeleteAssignment" &&
                e.CommandName != "ViewSubmissions") return;
            if (!CanManageAssignmentModule()) { ShowError("Module access denied."); return; }
            int assignmentID = ParseID(Convert.ToString(e.CommandArgument));
            DataTable table = ReadOwnedAssignment(assignmentID);
            if (table.Rows.Count == 0) { ShowError("Assignment not found or access denied."); return; }
            DataRow row = table.Rows[0];
            if (e.CommandName == "EditAssignment")
            {
                hfEditAssignmentID.Value = assignmentID.ToString();
                txtAssignmentTitle.Text = Convert.ToString(row["AssignmentTitle"]);
                txtAssignmentDescription.Text = Convert.ToString(row["AssignmentDescription"]);
                txtAssignmentMaxScore.Text = Convert.ToDecimal(row["MaxScore"]).ToString("0.##", System.Globalization.CultureInfo.InvariantCulture);
                txtAssignmentDueDate.Text = row["DueDate"] == DBNull.Value ? "" :
                    Convert.ToDateTime(row["DueDate"]).ToString("yyyy-MM-ddTHH:mm");
                btnSaveAssignment.Text = "Save Assignment";
                btnCancelAssignment.Visible = true;
                pnlAssignmentSubmissions.Visible = false;
            }
            else if (e.CommandName == "DeleteAssignment")
            {
                try
                {
                    ExecuteLoggedProcedure("dbo.EAssignments_WebDelete", "DELETE_ASSIGNMENT", "Assignment", assignmentID, "Instructor deleted assignment #" + assignmentID,
                        IntParam("@AssignmentID", assignmentID),
                        IntParam("@ModuleID", ParseID(hfModuleID.Value)),
                        IntParam("@CourseID", ParseID(hfCourseID.Value)),
                        IntParam("@InstructorID", InstructorID));
                    ResetAssignmentEditor();
                    LoadAssignments(ParseID(hfModuleID.Value));
                    ShowSuccess("Assignment deleted.");
                }
                catch (SqlException) { ShowError("Unable to delete assignment; it may have submissions."); }
            }
            else
            {
                hfViewAssignmentID.Value = assignmentID.ToString();
                hfGradeSubmissionID.Value = "";
                pnlGradeSubmission.Visible = false;
                lblSubmissionAssignment.Text = Server.HtmlEncode(Convert.ToString(row["AssignmentTitle"]));
                LoadAssignmentSubmissions(assignmentID);
                pnlAssignmentSubmissions.Visible = true;
            }
            pnlAssignments.Visible = true;
        }

        private void LoadAssignmentSubmissions(int assignmentID)
        {
            DataTable table = GetProcedureData("dbo.EAssignmentSubmissions_Web",
                IntParam("@AssignmentID", assignmentID),
                IntParam("@ModuleID", ParseID(hfModuleID.Value)),
                IntParam("@CourseID", ParseID(hfCourseID.Value)),
                IntParam("@InstructorID", InstructorID));
            gvAssignmentSubmissions.DataSource = table;
            gvAssignmentSubmissions.DataBind();
        }

        // Phase 4: authorized submission download and grading.
        protected void gvAssignmentSubmissions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "DownloadSubmission" && e.CommandName != "GradeSubmission") return;
            if (!CanManageAssignmentModule()) { ShowError("Module access denied."); return; }
            int assignmentID = ParseID(hfViewAssignmentID.Value);
            int submissionID = ParseID(Convert.ToString(e.CommandArgument));
            if (assignmentID == 0 || submissionID == 0 || ReadOwnedAssignment(assignmentID).Rows.Count == 0)
            { ShowError("Submission access denied."); return; }

            if (e.CommandName == "DownloadSubmission")
            {
                try
                {
                    DataTable table = GetProcedureData("dbo.EAssignmentSubmissions_WebOne",
                        IntParam("@SubmissionID", submissionID), IntParam("@AssignmentID", assignmentID),
                        IntParam("@InstructorID", InstructorID));
                    if (table.Rows.Count == 0) { ShowError("Submission not found."); return; }
                    string virtualPath = Convert.ToString(table.Rows[0]["FileUrl"]);
                    const string allowedFolder = "~/App_Data/Uploads/AssignmentSubmissions/";
                    string fileName = System.IO.Path.GetFileName(virtualPath.Replace('\\', '/'));
                    if (string.IsNullOrWhiteSpace(fileName) ||
                        !virtualPath.StartsWith(allowedFolder, StringComparison.OrdinalIgnoreCase) ||
                        !string.Equals(virtualPath, allowedFolder + fileName, StringComparison.OrdinalIgnoreCase))
                    { ShowError("Invalid submission file path."); return; }
                    string physical = Server.MapPath(allowedFolder + fileName);
                    if (!File.Exists(physical)) { ShowError("The submitted file was not found."); return; }
                    Response.Clear();
                    Response.ContentType = "application/octet-stream";
                    Response.AddHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                    Response.TransmitFile(physical);
                    Response.Flush();
                    Context.ApplicationInstance.CompleteRequest();
                }
                catch (Exception) { ShowError("Unable to download this submission."); }
                return;
            }

            DataTable selected = GetProcedureData("dbo.EAssignmentSubmissions_WebOne",
                IntParam("@SubmissionID", submissionID), IntParam("@AssignmentID", assignmentID),
                IntParam("@InstructorID", InstructorID));
            if (selected.Rows.Count == 0) { ShowError("Submission not found."); return; }
            hfGradeSubmissionID.Value = submissionID.ToString();
            txtSubmissionGrade.Text = selected.Rows[0]["Grade"] == DBNull.Value ? "" :
                Convert.ToDecimal(selected.Rows[0]["Grade"]).ToString("0.##", System.Globalization.CultureInfo.InvariantCulture);
            txtSubmissionFeedback.Text = Convert.ToString(selected.Rows[0]["Feedback"]);
            lblGradeStudent.Text = Server.HtmlEncode(Convert.ToString(selected.Rows[0]["StudentName"]));
            pnlGradeSubmission.Visible = true;
            pnlAssignmentSubmissions.Visible = true;
        }

        protected void btnSaveSubmissionGrade_Click(object sender, EventArgs e)
        {
            if (!CanManageAssignmentModule()) { ShowError("Module access denied."); return; }
            int assignmentID = ParseID(hfViewAssignmentID.Value);
            int submissionID = ParseID(hfGradeSubmissionID.Value);
            decimal grade;
            if (assignmentID == 0 || submissionID == 0 || ReadOwnedAssignment(assignmentID).Rows.Count == 0 ||
                !decimal.TryParse(txtSubmissionGrade.Text, System.Globalization.NumberStyles.Number,
                    System.Globalization.CultureInfo.InvariantCulture, out grade) || grade < 0 || grade > 100)
            { ShowError("Enter a grade between 0 and 100."); return; }
            try
            {
                ExecuteLoggedProcedure("dbo.EAssignmentSubmissions_WebSave",
                    "GRADE_SUBMISSION", "AssignmentSubmission", submissionID,
                    "Instructor graded submission #" + submissionID + " for assignment #" + assignmentID,
                    IntParam("@SubmissionID", submissionID),
                    IntParam("@AssignmentID", assignmentID),
                    IntParam("@InstructorID", InstructorID),
                    new SqlParameter("@Grade", SqlDbType.Decimal) { Precision = 5, Scale = 2, Value = grade },
                    new SqlParameter("@Feedback", SqlDbType.NVarChar, 2000) { Value = txtSubmissionFeedback.Text.Trim() });
                pnlGradeSubmission.Visible = false;
                hfGradeSubmissionID.Value = "";
                LoadAssignmentSubmissions(assignmentID);
                pnlAssignmentSubmissions.Visible = true;
                ShowSuccess("Grade and feedback saved.");
            }
            catch (SqlException) { ShowError("Could not save grade. Check submission access and grade limit."); }
        }

        protected void btnCancelSubmissionGrade_Click(object sender, EventArgs e)
        {
            pnlGradeSubmission.Visible = false;
            hfGradeSubmissionID.Value = "";
            pnlAssignmentSubmissions.Visible = true;
        }

        protected void btnCloseAssignmentSubmissions_Click(object sender, EventArgs e)
        {
            hfViewAssignmentID.Value = "";
            hfGradeSubmissionID.Value = "";
            pnlGradeSubmission.Visible = false;
            pnlAssignmentSubmissions.Visible = false;
            pnlAssignments.Visible = CanManageAssignmentModule();
        }

        // =========================================
        // MESSAGES
        // =========================================

        private void ShowSuccess(string message)
        {
            lblMessage.ForeColor = Color.Green;
            lblMessage.Text = Server.HtmlEncode(message);
        }

        private void ShowError(string message)
        {
            lblMessage.ForeColor = Color.Red;
            lblMessage.Text = Server.HtmlEncode(message);
        }


    }
}
