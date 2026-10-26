using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Net.Mail;
using System.Web.UI.WebControls;

namespace MiniLMS.Account
{
    public partial class Register : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["EMiniLMSConnection"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) LoadPrograms();
        }

        private void LoadPrograms()
        {
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            using (SqlCommand command = new SqlCommand("dbo.EPrograms_GetActive", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                DataTable table = new DataTable();
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    adapter.Fill(table);

                ddlProgram.DataSource = table;
                ddlProgram.DataTextField = "ProgramCode";
                ddlProgram.DataValueField = "ProgramID";
                ddlProgram.DataBind();
                ddlProgram.Items.Insert(0, new ListItem("Select program", ""));
            }
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.ForeColor = success ? Color.Green : Color.Red;
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;
            int programID;
            int yearLevel;

            if (firstName == "" || lastName == "" || email == "" ||
                password == "" || confirmPassword == "" ||
                ddlProgram.SelectedValue == "" || ddlYearLevel.SelectedValue == "")
            {
                ShowMessage("Please complete all fields.", false);
                return;
            }

            if (firstName.Length > 50 || lastName.Length > 50 || email.Length > 50)
            {
                ShowMessage("One or more fields are too long.", false);
                return;
            }

            try
            {
                MailAddress address = new MailAddress(email);
                if (!string.Equals(address.Address, email, StringComparison.OrdinalIgnoreCase))
                {
                    ShowMessage("Enter a valid email address.", false);
                    return;
                }
            }
            catch (FormatException)
            {
                ShowMessage("Enter a valid email address.", false);
                return;
            }

            if (!int.TryParse(ddlProgram.SelectedValue, out programID))
            {
                ShowMessage("Please select a valid program.", false);
                return;
            }

            if (!int.TryParse(ddlYearLevel.SelectedValue, out yearLevel) ||
                yearLevel < 1 || yearLevel > 4)
            {
                ShowMessage("Please select a valid year level.", false);
                return;
            }

            if (password.Length < 8 || password.Length > 50)
            {
                ShowMessage("Password must be 8 to 50 characters.", false);
                return;
            }

            if (password != confirmPassword)
            {
                ShowMessage("Passwords do not match.", false);
                return;
            }

            using (SqlConnection connection = new SqlConnection(ConnectionString))
            using (SqlCommand command = new SqlCommand("dbo.EUsers_WebSave", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@FirstName", SqlDbType.VarChar, 50).Value = firstName;
                command.Parameters.Add("@LastName", SqlDbType.VarChar, 50).Value = lastName;
                command.Parameters.Add("@Email", SqlDbType.VarChar, 50).Value = email;
                command.Parameters.Add("@Password", SqlDbType.VarChar, 50).Value = password;
                command.Parameters.Add("@ProgramID", SqlDbType.Int).Value = programID;
                command.Parameters.Add("@YearLevel", SqlDbType.Int).Value = yearLevel;

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    ShowMessage("Account created successfully. Please wait for admin approval.", true);
                    txtFirstName.Text = "";
                    txtLastName.Text = "";
                    txtEmail.Text = "";
                    ddlProgram.SelectedIndex = 0;
                    ddlYearLevel.SelectedIndex = 0;
                    txtPassword.Text = "";
                    txtConfirmPassword.Text = "";
                }
                catch (SqlException ex)
                {
                    if (ex.Number == 50002 ||
                        ((ex.Number == 2601 || ex.Number == 2627) &&
                         ex.Message.IndexOf("Email", StringComparison.OrdinalIgnoreCase) >= 0))
                    {
                        ShowMessage("This email is already registered.", false);
                    }
                    else if (ex.Number == 50003)
                    {
                        ShowMessage("Invalid or inactive program or year level.", false);
                    }
                    else
                    {
                        // Do not expose database details or passwords to visitors.
                        System.Diagnostics.Trace.TraceError("Registration SQL error {0}: {1}", ex.Number, ex.Message);
                        ShowMessage("Registration failed. Please contact the administrator.", false);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Registration error: {0}", ex);
                    ShowMessage("Something went wrong. Please try again.", false);
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Account/Login.aspx");
        }
    }
}
