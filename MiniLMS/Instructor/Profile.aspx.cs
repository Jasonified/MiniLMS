
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing.Imaging;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace MiniLMS
{
    public partial class InstructorProfile : Page
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

        private int UserID
        {
            get
            {
                return Convert.ToInt32(Session["UserID"]);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null ||
                !string.Equals(
                    Convert.ToString(Session["Role"]),
                    "Instructor",
                    StringComparison.Ordinal))
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
                LoadProfile();
        }

        // ==========================================
        // LOAD INSTRUCTOR PROFILE
        // ==========================================
        private void LoadProfile()
        {
            using (SqlConnection connection =
                new SqlConnection(ConnectionString))
            using (SqlCommand command =
                new SqlCommand(
                    "dbo.EUsers_InstructorProfileGet",
                    connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add(
                    "@UserID", SqlDbType.Int).Value = UserID;

                connection.Open();

                using (SqlDataReader reader =
                    command.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        lblMessage.Text =
                            "Instructor account not found or inactive.";

                        btnUploadPhoto.Enabled = false;
                        return;
                    }

                    string firstName =
                        Convert.ToString(reader["FirstName"]);

                    string lastName =
                        Convert.ToString(reader["LastName"]);

                    lblInstructorName.Text = firstName;

                    lblFullName.Text =
                        (firstName + " " + lastName).Trim();

                    lblEmail.Text =
                        Convert.ToString(reader["Email"]);

                    lblRole.Text =
                        Convert.ToString(reader["Role"]);

                    lblCreatedAt.Text =
                        reader["CreatedAt"] == DBNull.Value
                            ? "—"
                            : Convert.ToDateTime(
                                reader["CreatedAt"])
                                .ToString("MMMM dd, yyyy");

                    string imagePath =
                        Convert.ToString(
                            reader["ProfileImageUrl"]);

                    bool validStoredPath = Regex.IsMatch(
                        imagePath ?? "",
                        @"^~/Images/Profiles/[a-f0-9]{32}\.(jpg|png)$",
                        RegexOptions.IgnoreCase |
                        RegexOptions.CultureInvariant
                    ) && File.Exists(Server.MapPath(imagePath));

                    // Profile page photo.
                    // Navigation avatar is managed by Site.Master.
                    imgProfilePhoto.Visible = validStoredPath;
                    pnlPhotoPlaceholder.Visible = !validStoredPath;

                    if (validStoredPath)
                    {
                        imgProfilePhoto.ImageUrl =
                            ResolveUrl(imagePath);
                    }

                    btnUploadPhoto.Enabled = true;
                }
            }
        }

        // ==========================================
        // UPLOAD PROFILE PHOTO
        // ==========================================
        protected void btnUploadPhoto_Click(
            object sender, EventArgs e)
        {
            if (!fuProfilePhoto.HasFile)
            {
                lblMessage.Text =
                    "Please choose a profile photo first.";
                return;
            }

            if (fuProfilePhoto.PostedFile.ContentLength <= 0 ||
                fuProfilePhoto.PostedFile.ContentLength >
                    2 * 1024 * 1024)
            {
                lblMessage.Text =
                    "Choose a JPG or PNG photo of 2 MB or less.";
                return;
            }

            string extension =
                Path.GetExtension(fuProfilePhoto.FileName)
                    .ToLowerInvariant();

            if (extension != ".jpg" &&
                extension != ".jpeg" &&
                extension != ".png")
            {
                lblMessage.Text =
                    "Only JPG and PNG files are allowed.";
                return;
            }

            string savedExtension =
                extension == ".png" ? ".png" : ".jpg";

            string folder =
                Server.MapPath("~/Images/Profiles/");

            string fileName =
                Guid.NewGuid().ToString("N") +
                savedExtension;

            string physicalPath =
                Path.Combine(folder, fileName);

            string databasePath =
                "~/Images/Profiles/" + fileName;

            try
            {
                Directory.CreateDirectory(folder);

                // Decode and re-encode the image.
                using (System.Drawing.Image image =
                    System.Drawing.Image.FromStream(
                        fuProfilePhoto.PostedFile.InputStream,
                        false,
                        true))
                {
                    if (image.Width < 1 ||
                        image.Height < 1 ||
                        image.Width > 4000 ||
                        image.Height > 4000)
                    {
                        lblMessage.Text =
                            "Unsupported image dimensions " +
                            "(maximum 4000 × 4000).";
                        return;
                    }

                    image.Save(
                        physicalPath,
                        savedExtension == ".png"
                            ? ImageFormat.Png
                            : ImageFormat.Jpeg);
                }

                using (SqlConnection connection =
                    new SqlConnection(ConnectionString))
                using (SqlCommand command =
                    new SqlCommand(
                        "dbo.EUsers_InstructorProfilePhotoSave",
                        connection))
                {
                    command.CommandType =
                        CommandType.StoredProcedure;

                    command.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value = UserID;

                    command.Parameters.Add(
                        "@ProfileImageUrl",
                        SqlDbType.NVarChar,
                        500).Value = databasePath;

                    connection.Open();
                    command.ExecuteNonQuery();
                }

                LoadProfile();

                lblMessage.Text =
                    "Profile photo updated successfully.";
            }
            catch (ArgumentException)
            {
                DeleteFailedUpload(physicalPath);
                lblMessage.Text =
                    "The selected file is not a valid image.";
            }
            catch (OutOfMemoryException)
            {
                DeleteFailedUpload(physicalPath);
                lblMessage.Text =
                    "The selected file could not be read as an image.";
            }
            catch (SqlException)
            {
                DeleteFailedUpload(physicalPath);
                lblMessage.Text =
                    "Unable to update your profile photo " +
                    "in the database.";
            }
            catch (IOException)
            {
                DeleteFailedUpload(physicalPath);
                lblMessage.Text =
                    "Unable to save the photo. Check " +
                    "the Images/Profiles folder.";
            }
            catch (UnauthorizedAccessException)
            {
                DeleteFailedUpload(physicalPath);
                lblMessage.Text =
                    "The website does not have permission " +
                    "to save profile photos.";
            }
            catch (
                System.Runtime.InteropServices.ExternalException)
            {
                DeleteFailedUpload(physicalPath);
                lblMessage.Text =
                    "Unable to process the image file.";
            }
        }

        // ==========================================
        // DELETE FAILED UPLOAD
        // ==========================================
        private static void DeleteFailedUpload(string filePath)
        {
            try
            {
                if (File.Exists(filePath))
                    File.Delete(filePath);
            }
            catch (IOException) { }
            catch (UnauthorizedAccessException) { }
        }
    }
}
