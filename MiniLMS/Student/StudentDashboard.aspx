
<%@ Page Title="Student Dashboard"
    Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="StudentDashboard.aspx.cs"
    Inherits="MiniLMS.Student.StudentDashboard" %>

<asp:Content ID="HeadContent1"
    ContentPlaceHolderID="HeadContent"
    runat="server">

    <style type="text/css">
        .student-workspace {
            max-width: 1160px;
            margin: 0 auto;
        }

        .student-page-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 27px;
        }

        .student-eyebrow {
            display: block;
            margin-bottom: 7px;
            color: #8a9ab0;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
        }

        .student-page-heading h1 {
            margin: 0;
            font-size: 25px;
            font-weight: 700;
            color: #17375e;
        }

        .student-subtitle {
            margin: 7px 0 0;
            color: #72849a;
            font-size: 13px;
        }

        .student-workspace-label {
            padding: 9px 13px;
            background: white;
            border: 1px solid #e1e9f2;
            border-radius: 8px;
            color: #526b85;
            font-size: 12px;
            font-weight: 600;
        }

        .student-welcome {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 24px;
            min-height: 170px;
            padding: 30px 34px;
            background: white;
            border: 1px solid #e1e9f2;
            border-radius: 14px;
            margin-bottom: 38px;
        }

        .student-welcome-copy {
            max-width: 640px;
        }

        .student-welcome-kicker {
            display: inline-block;
            margin-bottom: 13px;
            color: #2369b5;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .student-welcome-title {
            margin: 0 0 12px;
            color: #15365b;
            font-size: 27px;
            font-weight: 700;
            line-height: 1.35;
        }

        .student-welcome-description {
            margin: 0;
            color: #708399;
            font-size: 13px;
            line-height: 1.8;
        }

        .student-welcome-icon {
            display: grid;
            place-items: center;
            width: 94px;
            height: 94px;
            flex-shrink: 0;
            border-radius: 22px;
            background: #f0f6fd;
            color: #3678bd;
            font-size: 42px;
        }

        .student-section-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 21px;
        }

        .student-section-heading h2 {
            margin: 0 0 7px;
            color: #17375e;
            font-size: 20px;
            font-weight: 700;
        }

        .student-section-heading p {
            margin: 0;
            color: #72849a;
            font-size: 13px;
            line-height: 1.6;
        }

        .student-assigned-label {
            display: inline-flex;
            align-items: center;
            flex-shrink: 0;
            padding: 8px 12px;
            border: 1px solid #dce8f5;
            border-radius: 7px;
            background: #f1f6fc;
            color: #356da9;
            font-size: 11px;
            font-weight: 700;
        }

        .student-courses-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .student-course-card {
            display: flex;
            align-items: stretch;
            min-height: 172px;
            background: white;
            border: 1px solid #e1e9f2;
            border-radius: 12px;
            overflow: hidden;
            color: inherit;
            text-decoration: none;
            transition: border-color .2s ease,
                        box-shadow .2s ease,
                        transform .2s ease;
        }

        .student-course-card:hover {
            border-color: #b6d0ed;
            box-shadow: 0 7px 22px rgba(23,55,94,.08);
            transform: translateY(-2px);
        }

        .student-course-image {
            width: 220px;
            min-height: 172px;
            flex-shrink: 0;
            background: #153d6a;
            overflow: hidden;
        }

        .student-course-image img {
            display: block;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .student-course-body {
            display: flex;
            flex-direction: column;
            flex: 1;
            min-width: 0;
            padding: 22px 25px;
        }

        .student-course-type {
            display: inline-block;
            margin-bottom: 8px;
            color: #3573b6;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .student-course-title {
            margin: 0 0 8px;
            color: #183b61;
            font-size: 17px;
            font-weight: 700;
            line-height: 1.4;
            overflow-wrap: anywhere;
        }

        .student-course-description {
            margin: 0 0 14px;
            color: #75879b;
            font-size: 12px;
            line-height: 1.7;
            overflow: hidden;
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
            overflow-wrap: anywhere;
        }

        .student-course-bottom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            margin-top: auto;
        }

        .student-course-instructor {
            color: #75879b;
            font-size: 12px;
        }

        .student-course-link {
            color: #2369b5;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .student-empty-courses {
            padding: 52px 24px;
            background: white;
            border: 1px dashed #cbd9e8;
            border-radius: 12px;
            text-align: center;
        }

        .student-empty-courses h3 {
            margin: 0 0 10px;
            color: #183451;
            font-size: 17px;
        }

        .student-empty-courses p {
            margin: 0;
            color: #72849a;
            font-size: 13px;
            line-height: 1.7;
        }

        .student-message {
            display: block;
            margin-bottom: 18px;
            padding: 13px 16px;
            background: #eaf3fd;
            border-left: 4px solid #3678b5;
            border-radius: 7px;
        }

        @media screen and (max-width: 768px) {
            .student-welcome {
                padding: 25px;
            }

            .student-course-image {
                width: 175px;
            }

            .student-course-body {
                padding: 19px;
            }
        }

        @media screen and (max-width: 560px) {
            .student-page-heading,
            .student-section-heading {
                align-items: flex-start;
                flex-direction: column;
            }

            .student-welcome {
                align-items: flex-start;
            }

            .student-welcome-icon {
                display: none;
            }

            .student-welcome-title {
                font-size: 23px;
            }

            .student-course-card {
                flex-direction: column;
            }

            .student-course-image {
                width: 100%;
                height: 155px;
                min-height: 0;
            }

            .student-course-body {
                padding: 20px;
            }

            .student-course-bottom {
                align-items: flex-start;
                flex-direction: column;
                gap: 12px;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="MainContent1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="student-workspace">

        <!-- PAGE HEADING -->
        <header class="student-page-heading">
            <div>
                <span class="student-eyebrow">
                    Student Portal
                </span>

                <h1>Dashboard</h1>

                <p class="student-subtitle">
                    Your personal learning workspace
                </p>
            </div>

            <span class="student-workspace-label">
                Student Workspace
            </span>
        </header>

        <!-- WELCOME PANEL -->
        <section class="student-welcome">

            <div class="student-welcome-copy">

                <span class="student-welcome-kicker">
                    Welcome to MiniLMS
                </span>

                <h2 class="student-welcome-title">
                    Hello,
                    <asp:Label
                        ID="lblWelcomeName"
                        runat="server" />!
                </h2>

                <p class="student-welcome-description">
                    Ready to continue learning?
                    All your assigned courses are
                    organized below. Select a course
                    to view its modules, lessons,
                    and learning materials.
                </p>

            </div>

            <div class="student-welcome-icon"
                 aria-hidden="true">
                &#128218;
            </div>

        </section>

        <!-- ASSIGNED COURSES -->
        <section id="my-courses">

            <div class="student-section-heading">

                <div>
                    <h2>My Courses</h2>
                </div>

                <span class="student-assigned-label">
                    Assigned Courses
                </span>

            </div>

            <asp:Label
                ID="lblMessage"
                runat="server"
                CssClass="student-message"
                Visible="false" />

            <div class="student-courses-list">

                <asp:Repeater
                    ID="rptCourses"
                    runat="server">

                    <ItemTemplate>

                        <a class="student-course-card"
                           href='<%# ResolveUrl("~/Student/CourseDetails.aspx?CourseID=" + Eval("CourseID")) %>'
                           aria-label='<%# System.Web.HttpUtility.HtmlAttributeEncode("Open course: " + Convert.ToString(Eval("CourseTitle"))) %>'>

                            <div class="student-course-image">

                                <asp:Image
                                    ID="imgCourse"
                                    runat="server"
                                    ImageUrl='<%# GetCourseImageUrl(Eval("CourseImageUrl")) %>'
                                    AlternateText="Course cover" />

                            </div>

                            <div class="student-course-body">

                                <span class="student-course-type">
                                    Assigned Course
                                </span>

                                <h3 class="student-course-title">
                                    <%#: Eval("CourseTitle") %>
                                </h3>

                                <p class="student-course-description">
                                    <%#: Eval("CourseDescription") %>
                                </p>

                                <div class="student-course-bottom">

                                    <span class="student-course-instructor">
                                        Instructor:
                                        <%#: Eval("InstructorName") %>
                                    </span>

                                    <span class="student-course-link">
                                        View Course &#8594;
                                    </span>

                                </div>

                            </div>

                        </a>

                    </ItemTemplate>

                </asp:Repeater>

                <asp:Panel
                    ID="pnlNoCourses"
                    runat="server"
                    Visible="false"
                    CssClass="student-empty-courses">

                    <h3>No Courses Yet</h3>

                    <p>
                        No published courses have been
                        assigned to you yet.
                    </p>

                </asp:Panel>

            </div>

        </section>

    </div>

</asp:Content>
