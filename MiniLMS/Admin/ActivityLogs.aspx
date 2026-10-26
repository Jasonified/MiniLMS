<%@ Page Title="Activity Logs" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ActivityLogs.aspx.cs" Inherits="MiniLMS.Admin.ActivityLogs" %>
<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
<style>
.al{max-width:1300px;margin:auto;color:#193553;font-family:inherit}.al *{box-sizing:border-box}.al h1{font-size:28px;margin:0 0 5px}.al p{color:#6b7e90;margin:0 0 22px}.al-panel{background:white;border:1px solid #e1e9f1;border-radius:14px;padding:20px;margin-bottom:18px;box-shadow:0 3px 12px #19355309}.al-filters{display:flex;flex-wrap:wrap;gap:12px;align-items:end}.al-field{display:flex;flex-direction:column;gap:5px;min-width:140px;flex:1}.al-field label{font-size:12px;font-weight:700;color:#405a70}.al-input{width:100%;border:1px solid #d5e1ec;border-radius:8px;padding:10px 12px;background:#fff;color:#173450;min-height:42px}.al-btn{border:0;border-radius:8px;background:#164c7a;color:#fff;padding:11px 17px;cursor:pointer;font-weight:600}.al-btn-alt{background:#e9f1f7;color:#17456b}.al-tablewrap{overflow:auto}.al-table{width:100%;border-collapse:collapse;min-width:850px}.al-table th{text-align:left;background:#f3f7fb;color:#486176;font-size:12px;padding:13px}.al-table td{padding:13px;border-bottom:1px solid #edf1f5;vertical-align:top;font-size:13px}.al-desc{max-width:330px;overflow-wrap:anywhere}.al-status{font-weight:700}.al-pages{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-top:15px}.al-details{max-width:380px;white-space:pre-wrap;overflow-wrap:anywhere;color:#486176;font-size:12px}.al-error{color:#a42121;font-weight:600;margin-bottom:12px}.al-muted{color:#738599;font-size:12px}
</style>
</asp:Content>
<asp:Content ID="Body" ContentPlaceHolderID="MainContent" runat="server">
<div class="al">
 <h1>Activity Logs</h1><p>Review actions performed by MiniLMS users.</p>
 <div class="al-panel">
  <div class="al-filters">
   <div class="al-field"><label>Search description / user ID</label><asp:TextBox ID="txtSearch" runat="server" CssClass="al-input" MaxLength="100" /></div>
   <div class="al-field"><label>Role</label><asp:DropDownList ID="ddlRole" runat="server" CssClass="al-input"><asp:ListItem Text="All roles" Value=""/><asp:ListItem Text="Admin"/><asp:ListItem Text="Instructor"/><asp:ListItem Text="Student"/></asp:DropDownList></div>
   <div class="al-field"><label>Action</label><asp:DropDownList ID="ddlAction" runat="server" CssClass="al-input" /></div>
   <div class="al-field"><label>From date</label><asp:TextBox ID="txtFrom" runat="server" TextMode="Date" CssClass="al-input" /></div>
   <div class="al-field"><label>To date</label><asp:TextBox ID="txtTo" runat="server" TextMode="Date" CssClass="al-input" /></div>
   <asp:Button ID="btnFilter" runat="server" Text="Apply filters" CssClass="al-btn" OnClick="btnFilter_Click" />
   <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="al-btn al-btn-alt" OnClick="btnReset_Click" />
  </div>
 </div>
 <div class="al-panel">
  <asp:Label ID="lblError" runat="server" CssClass="al-error" />
  <div class="al-tablewrap"><asp:GridView ID="gvLogs" runat="server" AutoGenerateColumns="false" CssClass="al-table" GridLines="None" EmptyDataText="No activity logs match your filters.">
  <Columns>
   <asp:BoundField DataField="LogID" HeaderText="Log #" />
   <asp:BoundField DataField="CreatedAt" HeaderText="Date / Time" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" HtmlEncode="false" />
   <asp:BoundField DataField="UserID" HeaderText="User ID" />
   <asp:BoundField DataField="UserRole" HeaderText="Role" />
   <asp:BoundField DataField="ActionType" HeaderText="Action" />
   <asp:BoundField DataField="EntityType" HeaderText="Entity" />
   <asp:BoundField DataField="EntityID" HeaderText="Entity ID" />
   <asp:TemplateField HeaderText="Description"><ItemTemplate><div class="al-desc"><%#: Eval("Description") %></div></ItemTemplate></asp:TemplateField>
   <asp:BoundField DataField="Status" HeaderText="Status" />
   <asp:TemplateField HeaderText="Changes"><ItemTemplate><details><summary>View</summary><div class="al-details"><b>Before:</b> <%#: Eval("OldValues") %><br/><b>After:</b> <%#: Eval("NewValues") %></div></details></ItemTemplate></asp:TemplateField>
  </Columns></asp:GridView></div>
  <div class="al-pages">
   <asp:Label ID="lblCount" runat="server" CssClass="al-muted" />
   <div><asp:Button ID="btnPrevious" runat="server" Text="Previous" CssClass="al-btn al-btn-alt" OnClick="btnPrevious_Click" /> <asp:Label ID="lblPage" runat="server" /> <asp:Button ID="btnNext" runat="server" Text="Next" CssClass="al-btn al-btn-alt" OnClick="btnNext_Click" /></div>
  </div>
 </div>
</div>
</asp:Content>
