<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="MiniLMS.AdminDashboard" %>

<asp:Content ID="AdminHead" ContentPlaceHolderID="HeadContent" runat="server">
<style>

        * { box-sizing: border-box; }

        .wrap { width: 100%; margin: auto; }

        .heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        h1 {
            margin: 0 0 7px;
            font-size: 29px;
            letter-spacing: -.8px;
            color: #0b2d55;
        }

        .muted {
            color: #71839b;
            font-size: 13px;
            line-height: 1.6;
            margin: 0;
        }

        .admin-tag {
            padding: 9px 14px;
            background: #e7eff9;
            border: 1px solid #d6e4f3;
            color: #174577;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 700;
        }

        .section-title {
            font-size: 17px;
            font-weight: 700;
            margin: 0 0 17px;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 17px;
            margin-bottom: 34px;
        }

        .stat {
            background: white;
            border: 1px solid #e1e9f2;
            border-radius: 13px;
            padding: 24px;
            box-shadow: 0 3px 12px #12365d05;
        }

        .stat-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .stat-icon {
            width: 42px;
            height: 42px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #edf4fd;
            border-radius: 11px;
            color: #18538f;
        }

        .stat-icon svg {
            width: 21px;
            height: 21px;
            fill: none;
            stroke: currentColor;
            stroke-width: 1.8;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .stat-label {
            font-size: 13px;
            color: #71839b;
            font-weight: 600;
        }

        .stat-value {
            display: block;
            margin-top: 8px;
            font-size: 34px;
            line-height: 1.2;
            font-weight: 800;
            color: #0b2d55;
        }

        .content-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 290px;
            gap: 22px;
            align-items: start;
        }

        .panel {
            background: white;
            border: 1px solid #e1e9f2;
            border-radius: 13px;
            overflow: hidden;
            box-shadow: 0 3px 12px #12365d05;
        }

        .panel-head {
            padding: 23px;
            border-bottom: 1px solid #e8eef5;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
        }

        .panel-head h2 {
            margin: 0 0 5px;
            font-size: 18px;
        }

        .count-pill {
            color: #174577;
            background: #e5effb;
            padding: 8px 13px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .table-wrap {
            overflow-x: auto;
            width: 100%;
        }

        .data-table {
            width: 100%;
            min-width: 730px;
            border-collapse: collapse;
        }

        .data-table th {
            background: #f8fafc;
            color: #60738b;
            padding: 15px 14px;
            font-size: 11px;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: .4px;
            white-space: nowrap;
        }

        .data-table td {
            padding: 15px 14px;
            border-top: 1px solid #edf1f6;
            font-size: 13px;
            vertical-align: middle;
        }

        .data-table tr:hover td {
            background: #f9fbfe;
        }

        .approve {
            background: #0b2d55;
            color: white;
            padding: 9px 13px;
            border: none;
            border-radius: 7px;
            font: inherit;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
        }

        .approve:hover { background: #164f8c; }

        .side-body { padding: 20px; }

        .quick-link {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 15px;
            margin-bottom: 12px;
            border: 1px solid #e1e9f2;
            border-radius: 10px;
            text-decoration: none;
            color: #142c49;
            transition: background .15s;
        }

        .quick-link:last-child { margin-bottom: 0; }

        .quick-link:hover {
            background: #f3f7fc;
            border-color: #cbdced;
        }

        .quick-icon {
            width: 38px;
            height: 38px;
            border-radius: 9px;
            background: #edf4fd;
            color: #18538f;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .quick-icon svg {
            width: 19px;
            height: 19px;
            fill: none;
            stroke: currentColor;
            stroke-width: 1.8;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .quick-link strong {
            display: block;
            font-size: 13px;
            margin-bottom: 3px;
        }

        .quick-link small {
            display: block;
            font-size: 11px;
            color: #71839b;
            line-height: 1.5;
        }

        .message {
            display: block;
            font-size: 13px;
            margin-bottom: 16px;
        }

        @media (max-width: 1000px) {
            .content-layout { grid-template-columns: 1fr; }
            .stats { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 600px) {
            
            
            .stats { gap: 10px; }
            .stat { padding: 16px; }
            .stat-value { font-size: 28px; }
            h1 { font-size: 25px; }
            .panel-head { padding: 18px; }
        }

        /* Option E: minimal, task-focused workspace */
        
        .wrap { width:100%; }
        .heading { margin-bottom:22px; }
        .panel { border-radius:12px; box-shadow:0 2px 12px rgba(20,44,73,.035); }
        .workspace-hero { display:grid; grid-template-columns:minmax(0,1.15fr) minmax(310px,.85fr); gap:20px; margin-bottom:24px; }
        .workspace-intro { padding:36px; border:1px solid #dae5f0; border-radius:14px; background:linear-gradient(135deg,#fff 10%,#eef5ff 100%); }
        .eyebrow { display:inline-block; font-size:11px; letter-spacing:1.3px; font-weight:800; color:#35639a; margin-bottom:16px; }
        .workspace-intro h2 { max-width:490px; font-size:29px; line-height:1.22; letter-spacing:-.9px; margin:0 0 12px; color:#102d50; }
        .workspace-intro p { max-width:490px; color:#657a94; font-size:14px; line-height:1.7; margin:0 0 24px; }
        .hero-link { display:inline-flex; align-items:center; gap:14px; background:#123a68; color:white; text-decoration:none; padding:12px 17px; border-radius:8px; font-size:13px; font-weight:700; }
        .hero-link:hover { background:#1d548e; }
        .workspace-actions { display:flex; flex-direction:column; gap:10px; }
        .workspace-action { display:flex; align-items:center; gap:15px; flex:1; padding:18px 20px; background:white; border:1px solid #e0e8f1; border-radius:12px; text-decoration:none; color:#1d3653; transition:border-color .15s, transform .15s; }
        .workspace-action:hover { border-color:#9dbbdb; transform:translateY(-1px); }
        .action-symbol { width:43px; height:43px; display:flex; justify-content:center; align-items:center; border-radius:11px; background:#edf4fc; color:#245e9b; font-size:22px; flex-shrink:0; }
        .workspace-action strong { display:block; font-size:14px; margin-bottom:5px; }
        .workspace-action small { display:block; color:#71839b; font-size:12px; line-height:1.4; }
        .action-arrow { margin-left:auto; color:#8296ad; font-size:18px; }
        .content-layout { grid-template-columns:minmax(0,1fr) 285px; }
        .data-table th { background:#f7f9fc; }
        .quick-link { border-radius:9px; }
        @media(max-width:950px) { .workspace-hero { grid-template-columns:1fr; } .workspace-actions { display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); } .workspace-action { align-items:flex-start; flex-direction:column; } .action-arrow { display:none; } }
        @media(max-width:700px) { .workspace-actions { grid-template-columns:1fr; } .workspace-action { flex-direction:row; align-items:center; } .workspace-intro { padding:25px; } .workspace-intro h2 { font-size:24px; } .content-layout { grid-template-columns:1fr; } }
    

</style>
</asp:Content>

<asp:Content ID="AdminMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="wrap">

        <div class="heading">
            <div>
                <h1>Admin Dashboard</h1>
                <p class="muted">
                    Overview of your learning management system.
                </p>
            </div>

            <span class="admin-tag">Administrator</span>
        </div>

        <!-- WORKSPACE: task-focused replacement for overview statistics -->
        <section class="workspace-hero" aria-label="Administration workspace">
            <div class="workspace-intro">
                <span class="eyebrow">YOUR WORKSPACE</span>
                <h2>Everything you need to manage MiniLMS.</h2>
                <p>Review new registrations, organize your courses, and manage account access—all from one place.</p>
                <a class="hero-link" href="<%= ResolveUrl("~/Admin/ManageUsers.aspx") %>">Open user directory <span aria-hidden="true">→</span></a>
            </div>
            <div class="workspace-actions">
                <a class="workspace-action" href="#pending-approvals"><span class="action-symbol">✓</span><span><strong>Review requests</strong><small>Approve new accounts below</small></span><span class="action-arrow">↗</span></a>
                <a class="workspace-action" href="<%= ResolveUrl("~/Admin/ManageCourses.aspx") %>"><span class="action-symbol">▤</span><span><strong>Organize courses</strong><small>Courses, instructors and students</small></span><span class="action-arrow">↗</span></a>
                <a class="workspace-action" href="<%= ResolveUrl("~/Admin/ManageUsers.aspx") %>"><span class="action-symbol">◎</span><span><strong>Manage accounts</strong><small>Roles, access and account status</small></span><span class="action-arrow">↗</span></a>
            </div>
        </section>

        <!-- Keep existing server controls for compatibility with AdminDashboard.aspx.cs. -->
        <div style="display:none" aria-hidden="true">
            <asp:Label ID="lblTotalUsers" runat="server" Text="0" />
            <asp:Label ID="lblTotalInstructors" runat="server" Text="0" />
            <asp:Label ID="lblTotalCourses" runat="server" Text="0" />
            <asp:Label ID="lblPendingCount" runat="server" Text="0" />
        </div>

        <div class="content-layout">

            <!-- PENDING APPROVALS -->

            <section class="panel" id="pending-approvals">

                <div class="panel-head">
                    <div>
                        <h2>Pending Approvals</h2>
                        <p class="muted">
                            Review and approve newly registered users.
                        </p>
                    </div>

                    <span class="count-pill">Account Requests</span>
                </div>

                <div style="padding: 16px 20px 0;">
                    <asp:Label
                        ID="lblMessage"
                        runat="server"
                        CssClass="message"
                        EnableViewState="false" />
                </div>

                <div class="table-wrap">
                    <asp:GridView
                        ID="gvPendingUsers"
                        runat="server"
                        AutoGenerateColumns="False"
                        CssClass="data-table"
                        GridLines="None"
                        EmptyDataText="No pending user approvals."
                        OnRowCommand="gvPendingUsers_RowCommand">

                        <Columns>

                            <asp:BoundField
                                DataField="UserID"
                                HeaderText="ID" />

                            <asp:BoundField
                                DataField="FirstName"
                                HeaderText="First Name" />

                            <asp:BoundField
                                DataField="LastName"
                                HeaderText="Last Name" />

                            <asp:BoundField
                                DataField="Email"
                                HeaderText="Email" />

                            <asp:BoundField
                                DataField="ProgramCode"
                                HeaderText="Program"
                                NullDisplayText="—" />

                            <asp:BoundField
                                DataField="YearLevel"
                                HeaderText="Year"
                                NullDisplayText="—" />

                            <asp:BoundField
                                DataField="Role"
                                HeaderText="Role" />

                            <asp:BoundField
                                DataField="CreatedAt"
                                HeaderText="Registered"
                                DataFormatString="{0:MMM dd, yyyy}" />

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:Button
                                        ID="btnApprove"
                                        runat="server"
                                        Text="Approve"
                                        CssClass="approve"
                                        CommandName="ApproveUser"
                                        CommandArgument='<%# Eval("UserID") %>'
                                        CausesValidation="false" />
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>

            </section>

            <!-- QUICK ACTIONS -->

            <aside class="panel">
                <div class="panel-head">
                    <div>
                        <h2>Quick Actions</h2>
                        <p class="muted">
                            Common administrative tasks.
                        </p>
                    </div>
                </div>

                <div class="side-body">

                    <a class="quick-link"
                       href="<%= ResolveUrl("~/Admin/ManageUsers.aspx") %>">
                        <span class="quick-icon">
                            <svg viewBox="0 0 24 24">
                                <circle cx="9" cy="8" r="3"/>
                                <path d="M3 20v-2a6 6 0 0 1 12 0v2"/>
                                <path d="M17 5a3 3 0 0 1 0 6"/>
                                <path d="M18 14a5 5 0 0 1 3 5"/>
                            </svg>
                        </span>
                        <span>
                            <strong>Manage Users</strong>
                            <small>Update accounts and roles</small>
                        </span>
                    </a>

                    <a class="quick-link"
                       href="<%= ResolveUrl("~/Admin/ManageCourses.aspx") %>">
                        <span class="quick-icon">
                            <svg viewBox="0 0 24 24">
                                <path d="M4 4h7a3 3 0 0 1 3 3v13H7a3 3 0 0 0-3 2z"/>
                                <path d="M20 4h-3a3 3 0 0 0-3 3v13h3a3 3 0 0 1 3 2z"/>
                            </svg>
                        </span>
                        <span>
                            <strong>Manage Courses</strong>
                            <small>Courses and assignments</small>
                        </span>
                    </a>

                </div>
            </aside>

        </div>


</div>
</asp:Content>
