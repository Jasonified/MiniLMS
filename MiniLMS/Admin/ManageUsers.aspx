<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="MiniLMS.ManageUsers" %>

<asp:Content ID="ManageUsersHead" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .mu {
            width: 100%;
            max-width: none;
            margin: 0;
            color: #183451
        }

            .mu * {
                box-sizing: border-box
            }

        .mu-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 23px;
            gap: 12px
        }

        .mu h1 {
            font-size: 28px;
            margin: 0 0 5px;
            color: #102e50
        }

        .mu-sub {
            font-size: 13px;
            color: #78879a;
            margin: 0
        }

        .mu-tag {
            font-size: 12px;
            background: #eaf2fb;
            color: #174c83;
            padding: 9px 14px;
            border-radius: 20px
        }

        .mu-stats {
            display: grid;
            grid-template-columns: repeat(4,1fr);
            gap: 14px;
            margin-bottom: 22px
        }

        .mu-stat {
            padding: 19px 21px;
            background: white;
            border: 1px solid #e3eaf2;
            border-radius: 13px
        }

            .mu-stat span {
                font-size: 12px;
                color: #72849a
            }

            .mu-stat strong {
                display: block;
                font-size: 27px;
                color: #102e50;
                margin-top: 6px
            }

        .mu-shell {
            display: grid;
            grid-template-columns: minmax(0,1fr) 350px;
            gap: 18px;
            align-items: start
        }

        .mu-panel {
            background: white;
            border: 1px solid #e1e8f0;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(20,50,80,.035)
        }

        .mu-panel-header {
            padding: 23px;
            border-bottom: 1px solid #edf1f6
        }

            .mu-panel-header h2 {
                margin: 0 0 6px;
                font-size: 18px
            }

        .mu-toolbar {
            display: grid;
            grid-template-columns: 1fr 135px 145px;
            gap: 8px;
            padding: 16px;
            border-bottom: 1px solid #edf1f6
        }

        .mu-input {
            width: 100%;
            min-width: 0;
            border: 1px solid #dce5ee;
            background: #fff;
            border-radius: 8px;
            padding: 10px 11px;
            font: inherit;
            font-size: 12px;
            color: #193b5d
        }

            .mu-input:focus {
                outline: 2px solid #c4dbf5
            }

        .mu-table-wrap {
            overflow: auto;
            max-height: 670px
        }

        .mu-table {
            width: 100%;
            border-collapse: collapse
        }

            .mu-table th {
                padding: 13px 15px;
                text-align: left;
                background: #f8fafc;
                color: #77879a;
                font-size: 10px;
                letter-spacing: 1px;
                text-transform: uppercase
            }

            .mu-table td {
                padding: 13px 15px;
                border-top: 1px solid #eef2f6;
                font-size: 12px
            }

            .mu-table tr.mu-row:hover {
                background: #f2f7fd
            }

            .mu-table tr.mu-selected {
                background: #e9f3ff
            }

        .mu-name-button {
            background: none;
            border: 0;
            padding: 0;
            text-align: left;
            cursor: pointer;
            color: #123d70;
            font: inherit;
            font-weight: 700
        }

            .mu-name-button:hover {
                text-decoration: underline
            }

        .mu-email {
            display: block;
            font-size: 11px;
            color: #8290a1;
            margin-top: 4px;
            word-break: break-all
        }

        .mu-pill {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            background: #eaf2fb;
            color: #315b87;
            font-size: 11px
        }

            .mu-pill.ok {
                background: #e7f7ee;
                color: #207149
            }

            .mu-pill.off {
                background: #fff0e2;
                color: #aa6328
            }

            .mu-pill.wait {
                background: #f1eafb;
                color: #7954a5
            }

        .mu-detail {
            padding: 24px
        }

        .mu-empty {
            text-align: center;
            padding: 58px 18px;
            color: #8493a4
        }

            .mu-empty svg {
                margin-bottom: 14px
            }

        .mu-profile {
            text-align: center;
            padding-bottom: 18px;
            border-bottom: 1px solid #edf1f6;
            margin-bottom: 20px
        }

        .mu-avatar {
            height: 78px;
            width: 78px;
            border-radius: 50%;
            background: #e8f1fb;
            color: #194b80;
            margin: 0 auto 12px;
            display: grid;
            place-items: center;
            font-size: 29px;
            font-weight: 700;
            overflow: hidden
        }

            .mu-avatar img {
                height: 100%;
                width: 100%;
                object-fit: cover
            }

        .mu-profile h3 {
            margin: 0 0 5px;
            font-size: 19px
        }

        .mu-profile small {
            color: #8190a2
        }

        .mu-field {
            display: block;
            margin-bottom: 13px
        }

            .mu-field > span {
                display: block;
                color: #61758b;
                font-size: 11px;
                font-weight: 700;
                margin-bottom: 6px
            }

            .mu-field .mu-input {
                font-size: 13px
            }

        .mu-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px
        }

        .mu-section {
            font-size: 12px;
            font-weight: 800;
            color: #173f6b;
            margin: 18px 0 13px;
            padding-top: 14px;
            border-top: 1px solid #edf1f6
        }

        .mu-note {
            font-size: 11px;
            color: #8391a0;
            line-height: 1.5
        }

        .mu-save {
            width: 100%;
            background: #102e50;
            border: 0;
            border-radius: 9px;
            padding: 13px;
            color: #fff;
            font-weight: 700;
            cursor: pointer;
            margin-top: 10px
        }

            .mu-save:hover {
                background: #1c5186
            }

            .mu-save:disabled {
                opacity: .5
            }

        .mu-msg {
            display: block;
            padding: 10px 13px;
            font-size: 12px;
            margin-bottom: 15px
        }

        .mu-status-row {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            color: #40566f
        }

            .mu-status-row input {
                accent-color: #194f83
            }

        .mu-footer {
            padding: 15px;
            color: #8190a2;
            font-size: 11px;
            border-top: 1px solid #edf1f6
        }

        .mu-hide {
            display: none !important
        }

        @media(max-width:1100px) {
            .mu-shell {
                grid-template-columns: minmax(0,1fr) 315px
            }
        }

        @media(max-width:850px) {
            .mu-shell {
                grid-template-columns: 1fr
            }

            .mu-stats {
                grid-template-columns: repeat(2,1fr)
            }
        }

        @media(max-width:520px) {
            .mu-toolbar {
                grid-template-columns: 1fr
            }

            .mu-grid {
                grid-template-columns: 1fr
            }

            .mu-head {
                align-items: start
            }

            .mu h1 {
                font-size: 23px
            }
        }
    </style>
</asp:Content>
<asp:Content ID="ManageUsersContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="mu">
        <div class="mu-head">
            <div>
                <h1>Manage Users</h1>
                <p class="mu-sub">Select an account to view and update its details.</p>
            </div>
            <span class="mu-tag">Administrator</span></div>
        <div class="mu-stats">
            <div class="mu-stat"><span>Total accounts</span><strong><asp:Label ID="lblTotalUsers" runat="server" Text="0" /></strong></div>
            <div class="mu-stat"><span>Active</span><strong><asp:Label ID="lblActiveUsers" runat="server" Text="0" /></strong></div>
            <div class="mu-stat"><span>Inactive</span><strong><asp:Label ID="lblInactiveUsers" runat="server" Text="0" /></strong></div>
            <div class="mu-stat"><span>Pending</span><strong><asp:Label ID="lblPendingUsers" runat="server" Text="0" /></strong></div>
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="mu-msg" EnableViewState="false" />
        <div class="mu-shell">
            <section class="mu-panel">
                <div class="mu-panel-header">
                    <h2>User Database</h2>
                    <p class="mu-sub">Click a name to open the account editor.
                        <asp:Label ID="lblUserCount" runat="server" Text="0" />
                        accounts</p>
                </div>
                <div class="mu-toolbar">
                    <input id="muSearch" type="search" class="mu-input" placeholder="Search name, email, ID or program" oninput="muFilter()" /><select id="muRole" class="mu-input" onchange="muFilter()"><option value="">All roles</option>
                        <option>Student</option>
                        <option>Instructor</option>
                        <option>Admin</option>
                    </select><select id="muStatus" class="mu-input" onchange="muFilter()"><option value="">All statuses</option>
                        <option>Active</option>
                        <option>Inactive</option>
                        <option>Pending</option>
                    </select></div>
                <div class="mu-table-wrap">
                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" GridLines="None" CssClass="mu-table" OnRowCommand="gvUsers_RowCommand" OnRowDataBound="gvUsers_RowDataBound" EmptyDataText="No accounts found.">
                        <Columns>
                            <asp:BoundField DataField="UserID" HeaderText="ID" />
                            <asp:TemplateField HeaderText="User">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnSelectUser" runat="server" CssClass="mu-name-button" CommandName="SelectUser" CommandArgument='<%# Eval("UserID") %>' CausesValidation="false" Text='<%#: Eval("FullName") %>' /><span class="mu-email"><%#: Eval("Email") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Program">
                                <ItemTemplate><%#: Eval("ProgramCode") %></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Role">
                                <ItemTemplate><span class="mu-pill"><%#: Eval("Role") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate><span class='<%# !Convert.ToBoolean(Eval("IsApproved")) ? "mu-pill wait" : (Convert.ToBoolean(Eval("IsActive")) ? "mu-pill ok" : "mu-pill off") %>'><%# !Convert.ToBoolean(Eval("IsApproved")) ? "Pending" : (Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive") %></span></ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <div class="mu-footer">Select a user to update details. Email and approval status are not changed here.</div>
            </section>
            <aside class="mu-panel" id="muEditor">
                <asp:Panel ID="pnlNoSelection" runat="server" CssClass="mu-empty">
                    <div style="font-size: 35px">◯</div>
                    <strong>Select a user</strong><p class="mu-sub" style="margin-top: 9px">Their profile and account settings will appear here.</p>
                </asp:Panel>
                <asp:Panel ID="pnlEditUser" runat="server" Visible="false" CssClass="mu-detail">
                    <asp:HiddenField ID="hfSelectedUserID" runat="server" />
                    <div class="mu-profile">
                        <div class="mu-avatar">
                            <asp:Image ID="imgUser" runat="server" Visible="false" AlternateText="User profile" /><asp:Label ID="lblInitial" runat="server" Text="U" /></div>
                        <h3>
                            <asp:Label ID="lblSelectedName" runat="server" /></h3>
                        <small>Account #<asp:Label ID="lblSelectedID" runat="server" /></small></div>
                    <div class="mu-section" style="border: 0; padding: 0; margin-top: 0">Personal information</div>
                    <div class="mu-grid">
                        <label class="mu-field"><span>First name</span><asp:TextBox ID="txtFirstName" runat="server" CssClass="mu-input" MaxLength="50" /></label><label class="mu-field"><span>Middle name</span><asp:TextBox ID="txtMiddleName" runat="server" CssClass="mu-input" MaxLength="50" /></label></div>
                    <label class="mu-field"><span>Last name</span><asp:TextBox ID="txtLastName" runat="server" CssClass="mu-input" MaxLength="50" /></label>
                    <label class="mu-field"><span>Email address (read-only)</span><asp:TextBox ID="txtEmail" runat="server" CssClass="mu-input" ReadOnly="true" /></label>
                    <div class="mu-grid">
                        <label class="mu-field"><span>Program</span><asp:DropDownList ID="ddlProgram" runat="server" CssClass="mu-input" /></label><label class="mu-field"><span>Year level</span><asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="mu-input">
                            <asp:ListItem Text="N/A" Value="" />
                            <asp:ListItem Text="1" Value="1" />
                            <asp:ListItem Text="2" Value="2" />
                            <asp:ListItem Text="3" Value="3" />
                            <asp:ListItem Text="4" Value="4" />
                        </asp:DropDownList></label></div>
                    <label class="mu-field"><span>Profile photo (optional JPG/PNG, max 2 MB)</span><asp:FileUpload ID="fuProfile" runat="server" CssClass="mu-input" accept=".jpg,.jpeg,.png" /></label>
                    <div class="mu-section">Account access</div>
                    <label class="mu-field"><span>Role</span><asp:DropDownList ID="ddlRole" runat="server" CssClass="mu-input">
                        <asp:ListItem>Student</asp:ListItem>
                        <asp:ListItem>Instructor</asp:ListItem>
                        <asp:ListItem>Admin</asp:ListItem>
                    </asp:DropDownList></label>
                    <div class="mu-status-row">
                        <asp:CheckBox ID="chkActive" runat="server" Text="Account active" /></div>
                    <p class="mu-note">
                        <asp:Label ID="lblApprovalNote" runat="server" />
                        Changing an instructor's role requires removing assigned courses first. You cannot remove your own administrator access.</p>
                    <asp:Button ID="btnSaveChanges" runat="server" Text="Save Changes" CssClass="mu-save" OnClick="btnSaveChanges_Click" OnClientClick="return confirm('Save all changes to this user?');" CausesValidation="false" />
                </asp:Panel>
            </aside>
        </div>
    </div>
    <script>
        function muFilter() { var q = document.getElementById('muSearch').value.toLowerCase().trim(), role = document.getElementById('muRole').value, status = document.getElementById('muStatus').value, rows = document.querySelectorAll('#<%= gvUsers.ClientID %> tr'); for (var i = 1; i < rows.length; i++) { var c = rows[i].querySelectorAll('td'); if (c.length < 5) continue; var show = (!q || rows[i].textContent.toLowerCase().indexOf(q) >= 0) && (!role || c[3].textContent.trim() === role) && (!status || c[4].textContent.trim() === status); rows[i].style.display = show ? '' : 'none'; } }
</script>
</asp:Content>
