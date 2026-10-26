using System;
using System.Configuration;
using System.Data.SqlClient;

namespace MiniLMS
{
    public partial class TestDatabase : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connectionString =
                ConfigurationManager
                .ConnectionStrings["EMiniLMSConnection"]
                .ConnectionString;

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    con.Open();

                    lblMessage.Text =
                        "Database connection successful!";
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text =
                    "Connection failed: " + ex.Message;
            }
        }
    }
}