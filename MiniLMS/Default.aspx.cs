using System;
using System.Web.UI;

namespace MiniLMS
{
    // Public landing page. Authentication and role-based redirects
    // remain in Account/Login.aspx and its existing code-behind.
    public partial class Landing : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No database access is required for this public page.
        }
    }
}
