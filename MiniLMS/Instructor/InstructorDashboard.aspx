
<%@ Page Title="Instructor Dashboard"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="InstructorDashboard.aspx.cs"
    Inherits="MiniLMS.InstructorDashboard" %>

<asp:Content ID="DashboardHead"
    ContentPlaceHolderID="HeadContent"
    runat="server">

<style>
    /* =====================================
       PAGE HEADING
       ===================================== */

    .page-heading {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 16px;
        margin-bottom: 27px;
    }

    .page-eyebrow {
        display: block;
        margin-bottom: 7px;
        color: #8a9ab0;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 1.2px;
        text-transform: uppercase;
    }

    .page-heading h1 {
        font-size: 27px;
        color: #1e3047;
        margin: 0;
    }

    .page-heading p {
        color: #72849a;
        font-size: 13px;
        margin: 7px 0 0;
    }

    .workspace-label {
        padding: 9px 13px;
        background: white;
        border: 1px solid #e1e9f2;
        border-radius: 8px;
        color: #526b85;
        font-size: 12px;
        font-weight: 600;
    }

    /* =====================================
       DASHBOARD BANNER
       ===================================== */

    .dashboard-banner {
        background: white;
        border: 1px solid #e6eaf0;
        border-radius: 12px;
        min-height: 160px;
        padding: 30px 34px;
        margin-bottom: 36px;
        display: flex;
        align-items: center;
    }

    .banner-title {
        color: #4776a9;
        font-size: 11px;
        font-weight: 750;
        letter-spacing: 1px;
        text-transform: uppercase;
        margin-bottom: 13px;
    }

    .banner-welcome {
        color: #20364f;
        font-size: 27px;
        font-weight: 750;
        margin-bottom: 12px;
    }

    .banner-description {
        color: #64748b;
        font-size: 13px;
        line-height: 1.8;
    }

    /* =====================================
       SECTION HEADER
       ===================================== */

    .section-header {
        margin-bottom: 20px;
    }

    .section-header h2 {
        font-size: 20px;
        color: #17375e;
        margin: 0 0 7px;
    }

    .section-header p {
        font-size: 13px;
        color: #72849a;
        line-height: 1.6;
        margin: 0;
    }

    /* =====================================
       COURSE CARDS
       ===================================== */

    .cards {
        display: flex;
        flex-direction: column;
        gap: 14px;
        margin-bottom: 30px;
    }

    .course-card {
        display: grid;
        grid-template-columns: 220px minmax(0, 1fr);
        grid-template-rows: auto auto;
        min-height: 175px;
        background: white;
        border: 1px solid #e6eaf0;
        border-radius: 12px;
        overflow: hidden;
        transition: 0.2s;
    }

    .course-card:hover {
        border-color: #c5d5e6;
        box-shadow: 0 5px 17px rgba(27, 51, 80, 0.06);
        transform: translateY(-2px);
    }

    /* =====================================
       COURSE IMAGE
       ===================================== */

    .course-image {
        grid-column: 1;
        grid-row: 1 / 3;
        position: relative;
        min-height: 175px;
        overflow: hidden;
        background: #164f8c;
    }

    .course-image > img {
        display: block;
        width: 100%;
        height: 100%;
        object-fit: cover;
        position: absolute;
        inset: 0;
    }

    /* =====================================
       UPDATED IMAGE UPLOAD BUTTON
       ===================================== */

    .image-upload-actions {
        position: absolute;
        right: 12px;
        bottom: 12px;
        z-index: 5;
    }

    .small-image-button {
        display: inline-flex;
        align-items: center;
        justify-content: center;

        width: 42px;
        height: 42px;
        padding: 0;

        background: rgba(255, 255, 255, 0.96);
        color: #245e9b;

        border: 1px solid rgba(220, 231, 242, 0.95);
        border-radius: 11px;

        box-shadow: 0 3px 12px rgba(0, 0, 0, 0.13);

        cursor: pointer;
        transition:
            background 0.2s ease,
            color 0.2s ease,
            transform 0.2s ease,
            box-shadow 0.2s ease;
    }

    .small-image-button:hover {
        background: #ffffff;
        color: #174f8b;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.18);
    }

    .small-image-button:active {
        transform: translateY(0);
    }

    .small-image-button:focus-visible {
        outline: 3px solid #93c5fd;
        outline-offset: 2px;
    }

    .small-image-button svg {
        width: 20px;
        height: 20px;
        flex-shrink: 0;
    }

    /* Keep existing file upload functionality */

    .hidden-image-input,
    .hidden-image-submit {
        position: absolute;
        width: 1px;
        height: 1px;
        opacity: 0;
        overflow: hidden;
        pointer-events: none;
    }

    /* =====================================
       COURSE CONTENT
       ===================================== */

    .course-content {
        grid-column: 2;
        grid-row: 1 / 3;
        padding: 22px 25px;
        display: grid;
        grid-template-columns: 1fr auto;
        column-gap: 16px;
        align-content: start;
    }

    .course-title {
        grid-column: 1;
        font-size: 17px;
        font-weight: 750;
        color: #17375e;
        margin-bottom: 8px;
        overflow-wrap: anywhere;
    }

    .course-description {
        grid-column: 1;
        color: #72849a;
        font-size: 12px;
        line-height: 1.7;
        margin-bottom: 12px;
        max-height: 45px;
        overflow: hidden;
    }

    .course-status {
        grid-column: 2;
        grid-row: 1 / 3;
        justify-self: end;
        align-self: start;
        background: #eaf2fb;
        color: #174b7e;
        border-radius: 7px;
        padding: 6px 11px;
        font-size: 11px;
        font-weight: 700;
    }

    .course-button {
        grid-column: 1;
        justify-self: start;
        border: none;
        border-radius: 7px;
        background: #2563a6;
        color: white;
        padding: 11px 17px;
        font: 650 13px 'Segoe UI', Arial, sans-serif;
        cursor: pointer;
    }

    .course-button:hover {
        background: #195692;
    }

    /* =====================================
       UPLOAD MESSAGE
       ===================================== */

    .upload-message {
        display: block;
        margin-bottom: 16px;
        font-size: 13px;
        color: #205487;
    }

    .upload-message:empty {
        display: none;
    }

    /* =====================================
       EMPTY COURSES
       ===================================== */

    .empty-courses {
        padding: 45px 20px;
        background: white;
        border: 1px dashed #c9d8e8;
        border-radius: 13px;
        text-align: center;
        color: #72849a;
    }

    .empty-icon {
        display: grid;
        place-items: center;
        width: 60px;
        height: 60px;
        margin: 0 auto 15px;
        border-radius: 50%;
        background: #eaf2fb;
        color: #174b7e;
        font-size: 25px;
        font-weight: 800;
    }

    .empty-courses h3 {
        color: #183451;
        margin: 0 0 8px;
    }

    .create-button {
        display: inline-block;
        border: 0;
        border-radius: 7px;
        background: #2563a6;
        color: white;
        padding: 11px 17px;
        cursor: pointer;
        margin-top: 12px;
    }

    /* =====================================
       RESPONSIVE - TABLET
       ===================================== */

    @media (max-width: 850px) {
        .course-card {
            grid-template-columns: 165px minmax(0, 1fr);
        }
    }

    /* =====================================
       RESPONSIVE - MOBILE
       ===================================== */

    @media (max-width: 560px) {
        .page-heading {
            align-items: flex-start;
            flex-direction: column;
        }

        .dashboard-banner {
            padding: 25px;
        }

        .course-card {
            display: flex;
            flex-direction: column;
        }

        .course-image {
            height: 155px;
            min-height: 155px;
        }

        .course-content {
            display: block;
            padding: 19px;
        }

        .course-status {
            display: inline-block;
            margin: 0 0 12px;
        }

        .course-button {
            display: block;
            width: 100%;
        }

        .image-upload-actions {
            right: 10px;
            bottom: 10px;
        }

        .small-image-button {
            width: 40px;
            height: 40px;
            border-radius: 10px;
        }
    }
</style>

</asp:Content>

<asp:Content ID="DashboardContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <!-- =====================================
         PAGE HEADING
         ===================================== -->

    <div class="page-heading">
        <div>
            <span class="page-eyebrow">
                Instructor Portal
            </span>

            <h1>Dashboard</h1>

            <p>Your course management workspace</p>
        </div>

        <span class="workspace-label">
            Instructor Workspace
        </span>
    </div>

    <!-- =====================================
         DASHBOARD BANNER
         ===================================== -->

    <div class="dashboard-banner">
        <div>>
            <div class="banner-welcome">
                Welcome back,
                <asp:Label ID="lblWelcomeName"
                    runat="server" />!
            </div>

            <div class="banner-description">
                Manage learning content for your assigned courses.
                Choose a course below to work on its modules and lessons.
            </div>
        </div>
    </div>

    <!-- =====================================
         ASSIGNED COURSES
         ===================================== -->

    <div class="section-header">
        <h2>Assigned Courses</h2>

        <p>
            Select a course to create and organize its
            modules, lessons, and materials.
        </p>
    </div>

    <asp:Label ID="lblUploadMessage"
        runat="server"
        CssClass="upload-message"
        EnableViewState="false" />

    <div class="cards">

        <asp:Repeater ID="rptCourses"
            runat="server"
            OnItemCommand="rptCourses_ItemCommand">

            <ItemTemplate>

                <div class="course-card">

                    <!-- =================================
                         COURSE IMAGE
                         ================================= -->

                    <div class="course-image">

                        <asp:Image ID="imgCourse"
                            runat="server"
                            ImageUrl='<%# GetCourseImageUrl(Eval("CourseImageUrl")) %>'
                            AlternateText='<%# "Image for " + Convert.ToString(Eval("CourseTitle")) %>' />

                        <!-- UPDATED IMAGE UPLOAD CONTROL -->

                        <div class="image-upload-actions">

                            <asp:FileUpload ID="fuCourseImage"
                                runat="server"
                                CssClass="hidden-image-input"
                                accept=".jpg,.jpeg,.png,image/jpeg,image/png"
                                onchange="var b=this.parentNode.querySelector('.hidden-image-submit'); if(b) b.click();" />

                            <!-- NEW CAMERA ICON BUTTON -->

                            <button type="button"
                                class="small-image-button"
                                title="Add or change course cover image"
                                aria-label="Add or change course cover image"
                                onclick="this.parentNode.querySelector('input[type=file]').click();">

                                <svg xmlns="http://www.w3.org/2000/svg"
                                    viewBox="0 0 24 24"
                                    width="20"
                                    height="20"
                                    fill="none"
                                    stroke="currentColor"
                                    stroke-width="1.8"
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    aria-hidden="true">

                                    <path d="M14.5 4h-5L7.5 7H4
                                             a2 2 0 0 0-2 2v9
                                             a2 2 0 0 0 2 2h16
                                             a2 2 0 0 0 2-2V9
                                             a2 2 0 0 0-2-2h-3.5z" />

                                    <circle cx="12"
                                        cy="13"
                                        r="3.5" />

                                </svg>

                            </button>

                            <!-- EXISTING UPLOAD EVENT -->

                            <asp:Button ID="btnUploadImage"
                                runat="server"
                                Text="Upload"
                                CssClass="hidden-image-submit"
                                CommandName="UploadImage"
                                CommandArgument='<%# Eval("CourseID") %>'
                                CausesValidation="false" />

                        </div>
                    </div>

                    <!-- =================================
                         COURSE INFORMATION
                         ================================= -->

                    <div class="course-content">

                        <div class="course-title">
                            <%# Eval("CourseTitle") %>
                        </div>

                        <div class="course-description">
                            <%# Eval("CourseDescription") %>
                        </div>

                        <div class="course-status">
                            <%# Convert.ToBoolean(Eval("CoursePublished"))
                                ? "Published" : "Draft" %>
                        </div>

                        <asp:Button ID="btnManageCourse"
                            runat="server"
                            Text="Manage Modules &amp; Lessons →"
                            CssClass="course-button"
                            CommandName="ManageCourse"
                            CommandArgument='<%# Eval("CourseID") %>' />

                    </div>

                </div>

            </ItemTemplate>

        </asp:Repeater>

        <!-- =====================================
             EMPTY STATE
             ===================================== -->

        <asp:Panel ID="pnlNoCourses"
            runat="server"
            Visible="false"
            CssClass="empty-courses">

            <div class="empty-icon">C</div>

            <h3>No Courses Yet</h3>

            <p>
                No courses have been assigned to you yet.
            </p>

            <asp:Button ID="btnCreateCourse"
                runat="server"
                Text="Go to Courses"
                CssClass="create-button"
                PostBackUrl="~/Instructor/Courses.aspx" />

        </asp:Panel>

    </div>

</asp:Content>
