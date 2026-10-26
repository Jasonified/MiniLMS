using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;

namespace MiniLMS.Student
{
    public partial class DownloadMaterial : Page
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
            int studentID;
            if (Session["UserID"] == null ||
                Convert.ToString(Session["Role"]) != "Student" ||
                !int.TryParse(Convert.ToString(Session["UserID"]), out studentID) ||
                studentID <= 0)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            int materialID;
            if (!int.TryParse(Request.QueryString["MaterialID"], out materialID) ||
                materialID <= 0)
            {
                ShowError(400, "Invalid material ID.");
                return;
            }

            // The existing procedure enforces student access to this material.
            string fileName = null;
            string filePath = null;
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.EStudentMaterial_GetDownload", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@StudentID", SqlDbType.Int).Value = studentID;
                cmd.Parameters.Add("@MaterialID", SqlDbType.Int).Value = materialID;
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        fileName = Convert.ToString(reader["FileName"]);
                        filePath = Convert.ToString(reader["FilePath"]);
                    }
                }
            }

            if (string.IsNullOrWhiteSpace(filePath))
            {
                ShowError(404, "PDF not found or you are not assigned to this course.");
                return;
            }

            const string allowedFolder = "~/App_Data/Uploads/LessonMaterials/";
            filePath = filePath.Replace('\\', '/');
            if (!filePath.StartsWith(allowedFolder, StringComparison.OrdinalIgnoreCase))
            {
                ShowError(404, "The PDF storage path does not match the configured folder.");
                return;
            }

            string storedName = filePath.Substring(allowedFolder.Length);
            if (!Regex.IsMatch(storedName, @"^[a-zA-Z0-9_-]+\.pdf$",
                RegexOptions.IgnoreCase | RegexOptions.CultureInvariant))
            {
                ShowError(404, "The stored PDF filename is invalid.");
                return;
            }

            string fullPath = Server.MapPath(filePath);
            if (!File.Exists(fullPath))
            {
                ShowError(404, "PDF record found, but the actual file is missing.");
                return;
            }

            string safeName = Path.GetFileName(fileName ?? "");
            if (string.IsNullOrWhiteSpace(safeName) ||
                !safeName.EndsWith(".pdf", StringComparison.OrdinalIgnoreCase))
            {
                safeName = "LessonMaterial.pdf";
            }
            safeName = Regex.Replace(safeName, @"[^a-zA-Z0-9._-]", "_");

            // Phase 6B: best-effort audit logging after authorization and file checks.
            // A log failure must not block an otherwise authorized PDF download.
            // This records the start of a valid download response, not proof that
            // the browser received the entire file.
            try
            {
                using (SqlConnection logCon = new SqlConnection(ConnectionString))
                using (SqlCommand logCmd = new SqlCommand("dbo.EActivityLogs_WebSave", logCon))
                {
                    logCmd.CommandType = CommandType.StoredProcedure;
                    logCmd.Parameters.Add("@UserID", SqlDbType.Int).Value = studentID;
                    logCmd.Parameters.Add("@UserRole", SqlDbType.VarChar, 20).Value = "Student";
                    logCmd.Parameters.Add("@ActionType", SqlDbType.VarChar, 50).Value = "DOWNLOAD_MATERIAL";
                    logCmd.Parameters.Add("@EntityType", SqlDbType.VarChar, 50).Value = "LessonMaterial";
                    logCmd.Parameters.Add("@EntityID", SqlDbType.Int).Value = materialID;
                    logCmd.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value =
                        "Student requested PDF download: " + safeName + " (material #" + materialID + ")";
                    logCmd.Parameters.Add("@OldValues", SqlDbType.NVarChar, -1).Value = DBNull.Value;
                    logCmd.Parameters.Add("@NewValues", SqlDbType.NVarChar, -1).Value = DBNull.Value;
                    logCmd.Parameters.Add("@Status", SqlDbType.VarChar, 20).Value = "SUCCESS";
                    logCon.Open();
                    logCmd.ExecuteNonQuery();
                }
            }
            catch (SqlException)
            {
                // Best effort: don't deny a valid file because audit storage is unavailable.
            }
            catch (InvalidOperationException)
            {
                // Best effort: don't deny a valid file because audit storage is unavailable.
            }

            Response.Clear();
            Response.BufferOutput = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("X-Content-Type-Options", "nosniff");
            Response.AddHeader("Cache-Control", "no-store, private");
            Response.AddHeader("Content-Disposition", "attachment; filename=\"" + safeName + "\"");
            Response.AddHeader("Content-Length", new FileInfo(fullPath).Length.ToString());
            Response.TransmitFile(fullPath);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void ShowError(int statusCode, string message)
        {
            Response.Clear();
            Response.StatusCode = statusCode;
            Response.ContentType = "text/plain";
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.Write(message);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
