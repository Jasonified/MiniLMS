<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="TestAddCourse.aspx.cs"
    Inherits="MiniLMS.TestAddCourse" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Course CRUD</title>

    <style>
        body {
            font-family: Arial;
            background-color: #f5f5f5;
            margin: 0;
            padding: 30px;
        }

        .container {
            width: 800px;
            margin: auto;
            background-color: white;
            padding: 25px;
            border-radius: 8px;
        }

        h2 {
            margin-top: 0;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            cursor: pointer;
            margin-right: 5px;
        }

        .btn-save {
            background-color: #198754;
            color: white;
        }

        .btn-clear {
            background-color: #6c757d;
            color: white;
        }

        .grid {
            width: 100%;
            margin-top: 30px;
            border-collapse: collapse;
        }

        .grid th {
            background-color: #333;
            color: white;
            padding: 10px;
        }

        .grid td {
            padding: 8px;
            border: 1px solid #ddd;
        }

        .message {
            display: block;
            margin-bottom: 15px;
            color: green;
            font-weight: bold;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <div class="container">

        <h2>Course Management</h2>

        <asp:Label ID="lblMessage"
            runat="server"
            CssClass="message">
        </asp:Label>

        <asp:HiddenField ID="hfCourseID" runat="server" />

        <div class="form-group">

            <label>Instructor ID</label>

            <asp:TextBox ID="txtInstructorID"
                runat="server"
                CssClass="form-control">
            </asp:TextBox>

        </div>

        <div class="form-group">

            <label>Course Title</label>

            <asp:TextBox ID="txtCourseTitle"
                runat="server"
                CssClass="form-control">
            </asp:TextBox>

        </div>

        <div class="form-group">

            <label>Course Description</label>

            <asp:TextBox ID="txtCourseDescription"
                runat="server"
                CssClass="form-control"
                TextMode="MultiLine"
                Rows="4">
            </asp:TextBox>

        </div>

        <div class="form-group">

            <label>Announcement</label>

            <asp:TextBox ID="txtAnnouncement"
                runat="server"
                CssClass="form-control"
                TextMode="MultiLine"
                Rows="3">
            </asp:TextBox>

        </div>

        <div class="form-group">

            <asp:CheckBox ID="chkPublished"
                runat="server"
                Text=" Course Published" />

        </div>

        <asp:Button ID="btnSave"
            runat="server"
            Text="Save Course"
            CssClass="btn btn-save"
            OnClick="btnSave_Click" />

        <asp:Button ID="btnClear"
            runat="server"
            Text="Clear"
            CssClass="btn btn-clear"
            OnClick="btnClear_Click" />

        <asp:GridView ID="gvCourses"
            runat="server"
            CssClass="grid"
            AutoGenerateColumns="False"
            OnRowCommand="gvCourses_RowCommand">

            <Columns>

                <asp:BoundField
                    DataField="CourseID"
                    HeaderText="ID" />

                <asp:BoundField
                    DataField="InstructorID"
                    HeaderText="Instructor ID" />

                <asp:BoundField
                    DataField="CourseTitle"
                    HeaderText="Course Title" />

                <asp:BoundField
                    DataField="CourseDescription"
                    HeaderText="Description" />

                <asp:BoundField
                    DataField="Announcement"
                    HeaderText="Announcement" />

                <asp:CheckBoxField
                    DataField="CoursePublished"
                    HeaderText="Published" />

                <asp:TemplateField HeaderText="Actions">

                    <ItemTemplate>

                        <asp:Button
                            ID="btnEdit"
                            runat="server"
                            Text="Edit"
                            CommandName="EditCourse"
                            CommandArgument='<%# Eval("CourseID") %>'
                            CssClass="btn" />

                        <asp:Button
                            ID="btnDelete"
                            runat="server"
                            Text="Delete"
                            CommandName="DeleteCourse"
                            CommandArgument='<%# Eval("CourseID") %>'
                            CssClass="btn"
                            OnClientClick="return confirm('Are you sure you want to delete this course?');" />

                    </ItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

</form>

</body>
</html>