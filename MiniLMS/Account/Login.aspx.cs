using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace MiniLMS.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            // Check email
            if (string.IsNullOrEmpty(email))
            {
                lblMessage.Text = "Please enter your email.";
                return;
            }

            // Check password
            if (string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter your password.";
                return;
            }

            string connectionString =
                ConfigurationManager
                .ConnectionStrings["EMiniLMSConnection"]
                .ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("EUsers_WebOne", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Explicitly specify the parameter type
                    cmd.Parameters.Add("@Email", SqlDbType.VarChar, 50).Value = email;

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        // No account found
                        if (!reader.Read())
                        {
                            lblMessage.Text = "Invalid email or password.";
                            return;
                        }

                        string dbPassword = reader["Password"].ToString();

                        // Wrong password
                        if (password != dbPassword)
                        {
                            lblMessage.Text = "Invalid email or password.";
                            return;
                        }

                        // Check approval
                        bool isApproved =
                            Convert.ToBoolean(reader["IsApproved"]);

                        if (!isApproved)
                        {
                            lblMessage.Text =
                                "Your account has not been approved yet.";
                            return;
                        }

                        // Check active status
                        bool isActive =
                            Convert.ToBoolean(reader["IsActive"]);

                        if (!isActive)
                        {
                            lblMessage.Text =
                                "Your account is inactive.";
                            return;
                        }

                        // Get user information
                        int userID =
                            Convert.ToInt32(reader["UserID"]);

                        string firstName =
                            reader["FirstName"].ToString();

                        string userEmail =
                            reader["Email"].ToString();

                        string role =
                            reader["Role"].ToString();

                        // Save login information
                        Session["UserID"] = userID;
                        Session["Email"] = userEmail;
                        Session["FirstName"] = firstName;
                        Session["Role"] = role;

                        // Redirect based on role
                        if (role == "Instructor")
                        {
                            Response.Redirect(
                                "~/Instructor/InstructorDashboard.aspx");
                        }
                        else if (role == "Student")
                        {
                            Response.Redirect(
                                "~/Student/StudentDashboard.aspx");
                        }
                        else if (role == "Admin")
                        {
                            Response.Redirect(
                                "~/Admin/AdminDashboard.aspx");
                        }
                        else
                        {
                            lblMessage.Text =
                                "Invalid account role.";
                        }
                    }
                }
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Account/Register.aspx");
        }
    }
}