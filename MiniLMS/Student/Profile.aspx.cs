using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace MiniLMS.Student
{
    public partial class Profile : Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["EMiniLMSConnection"].ConnectionString; }
        }

        private int StudentID
        {
            get { return Convert.ToInt32(Session["UserID"]); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null ||
                Convert.ToString(Session["Role"]) != "Student" ||
                !int.TryParse(Convert.ToString(Session["UserID"]), out int id) || id <= 0)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
                LoadStudentProfile();
        }

        // EUsers_Web currently has no parameters and returns all users.
        // Keep the full result on the server; only bind the signed-in student's fields.
        private DataRow GetCurrentStudent()
        {
            DataTable users = new DataTable();
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.EUsers_Web", con))
            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                adapter.Fill(users);
            }

            return users.AsEnumerable().FirstOrDefault(row =>
                row.Field<int>("UserID") == StudentID &&
                string.Equals(Convert.ToString(row["Role"]), "Student", StringComparison.OrdinalIgnoreCase) &&
                Convert.ToBoolean(row["IsApproved"]) &&
                Convert.ToBoolean(row["IsActive"]));
        }

        private void LoadStudentProfile()
        {
            pnlProfile.Visible = false;
            DataRow student = GetCurrentStudent();
            if (student == null)
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            string firstName = Convert.ToString(student["FirstName"]);
            string lastName = Convert.ToString(student["LastName"]);
            lblFirstName.Text = firstName;
            lblLastName.Text = lastName;
            lblFullName.Text = (firstName + " " + lastName).Trim();
            lblEmail.Text = Convert.ToString(student["Email"]);
            lblRole.Text = Convert.ToString(student["Role"]);
            lblCreatedAt.Text = student["CreatedAt"] == DBNull.Value
                ? "Not available"
                : Convert.ToDateTime(student["CreatedAt"]).ToString("MMMM dd, yyyy");

            string imagePath = Convert.ToString(student["ProfileImageUrl"]);
            lblAvatarInitial.Text = firstName.Length > 0 ? firstName.Substring(0, 1).ToUpperInvariant() : "S";
            lblAvatarInitial.Visible = true;
            imgProfile.Visible = false;

            if (Regex.IsMatch(imagePath ?? "", @"^~/Images/Profiles/[a-f0-9]{32}\.(jpg|png)$",
                RegexOptions.IgnoreCase | RegexOptions.CultureInvariant) &&
                File.Exists(Server.MapPath(imagePath)))
            {
                imgProfile.ImageUrl = ResolveUrl(imagePath);
                imgProfile.Visible = true;
                lblAvatarInitial.Visible = false;
            }

            pnlProfile.Visible = true;
        }

        protected void btnUploadPhoto_Click(object sender, EventArgs e)
        {
            if (!fuProfilePhoto.HasFile)
            {
                ShowMessage("Please select a JPG or PNG picture.", false);
                LoadStudentProfile();
                return;
            }

            const int maxBytes = 2 * 1024 * 1024;
            if (fuProfilePhoto.PostedFile.ContentLength <= 0 ||
                fuProfilePhoto.PostedFile.ContentLength > maxBytes)
            {
                ShowMessage("Please choose an image no larger than 2 MB.", false);
                LoadStudentProfile();
                return;
            }

            // Validate the actual file signature, not only the extension/content type.
            string extension = Path.GetExtension(fuProfilePhoto.FileName).ToLowerInvariant();
            if (extension != ".jpg" && extension != ".jpeg" && extension != ".png")
            {
                ShowMessage("Only JPG and PNG pictures are supported.", false);
                LoadStudentProfile();
                return;
            }

            byte[] header = new byte[8];
            Stream stream = fuProfilePhoto.PostedFile.InputStream;
            int read = stream.Read(header, 0, header.Length);
            stream.Position = 0;
            bool jpeg = read >= 3 && header[0] == 0xFF && header[1] == 0xD8 && header[2] == 0xFF;
            bool png = read >= 8 && header.SequenceEqual(new byte[] { 137, 80, 78, 71, 13, 10, 26, 10 });
            if (!((extension == ".jpg" || extension == ".jpeg") && jpeg) &&
                !(extension == ".png" && png))
            {
                ShowMessage("The selected file is not a valid JPG or PNG picture.", false);
                LoadStudentProfile();
                return;
            }

            // Check account status again before allowing the update.
            DataRow currentStudent = GetCurrentStudent();
            if (currentStudent == null)
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            string previousImagePath = Convert.ToString(currentStudent["ProfileImageUrl"]);
            string folder = Server.MapPath("~/Images/Profiles/");
            Directory.CreateDirectory(folder);
            string fileName = Guid.NewGuid().ToString("N") + (png ? ".png" : ".jpg");
            string savedPath = Path.Combine(folder, fileName);
            string virtualPath = "~/Images/Profiles/" + fileName;

            try
            {
                fuProfilePhoto.SaveAs(savedPath);
                // The profile update and its audit log commit together.
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();
                    using (SqlTransaction transaction = con.BeginTransaction())
                    {
                        try
                        {
                            using (SqlCommand cmd = new SqlCommand("dbo.EUsers_StudentProfilePhotoSave", con, transaction))
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = StudentID;
                                cmd.Parameters.Add("@ProfileImageUrl", SqlDbType.NVarChar, 500).Value = virtualPath;
                                cmd.ExecuteNonQuery();
                            }
                            using (SqlCommand log = new SqlCommand("dbo.EActivityLogs_WebSave", con, transaction))
                            {
                                log.CommandType = CommandType.StoredProcedure;
                                log.Parameters.Add("@UserID", SqlDbType.Int).Value = StudentID;
                                log.Parameters.Add("@UserRole", SqlDbType.VarChar, 20).Value = "Student";
                                log.Parameters.Add("@ActionType", SqlDbType.VarChar, 50).Value = "UPDATE_PROFILE_PHOTO";
                                log.Parameters.Add("@EntityType", SqlDbType.VarChar, 50).Value = "User";
                                log.Parameters.Add("@EntityID", SqlDbType.Int).Value = StudentID;
                                log.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value =
                                    "Student updated profile photo (user #" + StudentID + ").";
                                log.Parameters.Add("@OldValues", SqlDbType.NVarChar, -1).Value =
                                    string.IsNullOrEmpty(previousImagePath) ? (object)DBNull.Value : previousImagePath;
                                log.Parameters.Add("@NewValues", SqlDbType.NVarChar, -1).Value = virtualPath;
                                log.Parameters.Add("@Status", SqlDbType.VarChar, 20).Value = "SUCCESS";
                                log.ExecuteNonQuery();
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

                ShowMessage("Profile picture updated successfully.", true);
            }
            catch (Exception)
            {
                if (File.Exists(savedPath)) File.Delete(savedPath);
                ShowMessage("Unable to update your profile picture. Please try again.", false);
            }

            LoadStudentProfile();
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "student-profile-message " + (success ? "success" : "error");
            lblMessage.Visible = true;
        }
    }
}
