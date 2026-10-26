<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="ManageCourses.aspx.cs" Inherits="MiniLMS.Admin.ManageCourses" %>

<asp:Content ID="ManageCoursesHead" ContentPlaceHolderID="HeadContent" runat="server">
    <title>MiniLMS | Manage Courses</title>
    <style>
        .mc {
            width: 100%;
            max-width: none;
            margin: 0;
            padding: 0 0 36px;
            color: #18314f;
            font-family: Segoe UI,Arial,sans-serif
        }

            .mc * {
                box-sizing: border-box
            }

        .mc-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 22px
        }

        .mc h1 {
            margin: 0 0 6px;
            font-size: 29px;
            color: #112c4f
        }

        .mc p {
            margin: 0;
            color: #72839a;
            font-size: 13px
        }

        .mc-stats {
            display: grid;
            grid-template-columns: repeat(3,1fr);
            gap: 14px;
            margin-bottom: 20px
        }

        .mc-stat {
            border: 1px solid #e3eaf3;
            background: white;
            border-radius: 12px;
            padding: 18px 20px
        }

            .mc-stat small {
                color: #72839a
            }

            .mc-stat strong {
                display: block;
                font-size: 29px;
                color: #15365d;
                margin-top: 8px
            }

        .mc-layout {
            display: grid;
            grid-template-columns: minmax(0,1.2fr) minmax(390px,0.95fr);
            gap: 18px;
            align-items: start
        }

        .mc-panel {
            background: #fff;
            border: 1px solid #e1e9f3;
            border-radius: 13px;
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(19,48,82,.04)
        }

        .mc-panelhead {
            padding: 20px;
            border-bottom: 1px solid #e9eef4
        }

            .mc-panelhead h2 {
                margin: 0 0 5px;
                font-size: 17px
            }

        .mc-toolbar {
            display: flex;
            gap: 10px;
            padding: 14px 18px;
            border-bottom: 1px solid #e9eef4
        }

        .mc-input, .mc select, .mc textarea {
            width: 100%;
            border: 1px solid #dbe4ee;
            border-radius: 8px;
            padding: 10px 12px;
            font: 13px Segoe UI,Arial,sans-serif;
            background: #fff;
            color: #19334f;
            min-width: 0
        }

        .mc textarea {
            resize: vertical
        }

        .mc-toolbar .mc-input {
            flex: 1
        }

        .mc-toolbar select {
            width: 170px
        }

        .mc-tablewrap {
            overflow-x: auto
        }

        .mc-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 650px
        }

            .mc-table th {
                text-align: left;
                background: #f8fafc;
                color: #657b94;
                font-size: 11px;
                padding: 14px 12px
            }

            .mc-table td {
                border-top: 1px solid #eef1f5;
                padding: 13px 12px;
                font-size: 12px
            }

            .mc-table tr:hover td {
                background: #f2f7ff
            }

        .mc-course-link {
            border: 0;
            background: transparent;
            color: #185b9e;
            font: 600 12px Segoe UI,Arial;
            cursor: pointer;
            text-align: left;
            padding: 0
        }

            .mc-course-link:hover {
                text-decoration: underline
            }

        .mc-status {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            background: #e9f6ee;
            color: #25814e;
            font-size: 11px
        }

            .mc-status.draft {
                background: #fff1dc;
                color: #a56919
            }

        .mc-editor {
            padding: 19px
        }

        .mc-tabs {
            display: flex;
            gap: 5px;
            border-bottom: 1px solid #e5ebf2;
            margin-bottom: 18px
        }

        .mc-tab {
            border: 0;
            background: transparent;
            padding: 12px 9px;
            font-size: 12px;
            color: #6b7c90;
            cursor: pointer
        }

            .mc-tab.active {
                border-bottom: 2px solid #1764bc;
                color: #1764bc;
                font-weight: 700
            }

        .mc-tabpane[hidden] {
            display: none !important
        }

        .mc-field {
            margin-bottom: 15px
        }

            .mc-field label {
                display: block;
                font-size: 12px;
                font-weight: 600;
                color: #496078;
                margin-bottom: 6px
            }

        .mc-grid2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px
        }

        .mc-btn {
            border: 0;
            border-radius: 8px;
            padding: 11px 16px;
            background: #145dc2;
            color: white;
            font-weight: 600;
            cursor: pointer;
            font-size: 12px
        }

            .mc-btn.alt {
                background: #edf2f8;
                color: #315274
            }

        .mc-assigned-section { margin-top: 22px; border-top: 1px solid #e6ebf1; padding-top: 16px; }
        .mc-assigned-section h3 { margin: 0 0 6px; font-size: 15px; color: #18314f; }
        .mc-assigned-table { min-width: 0; }
        .mc-remove-btn { color: #b42318; font-weight: 600; text-decoration: none; }
        .mc-remove-btn:hover { text-decoration: underline; }

        .mc-instructor-assignment {
            margin-top: 18px;
            padding: 16px;
            border: 1px solid #e1e9f3;
            border-radius: 10px;
            background: #f8fafc;
        }

            .mc-instructor-assignment .mc-field {
                margin-bottom: 8px;
            }

        .mc-footer {
            display: flex;
            gap: 10px;
            margin-top: 18px;
            padding-top: 18px;
            border-top: 1px solid #e6ebf1
        }

            .mc-footer .mc-btn:first-child {
                flex: 1
            }

        .mc-hint {
            color: #72839a;
            font-size: 12px;
            line-height: 1.5
        }

        .mc-student-list {
            max-height: 330px;
            overflow: auto;
            border: 1px solid #e4eaf1;
            border-radius: 8px;
            padding: 10px
        }

            .mc-student-list span {
                display: block;
                padding: 7px 4px;
                font-size: 12px
            }

            .mc-student-list input {
                margin-right: 8px
            }

        .mc-subsection {
            margin-top: 22px
        }

        .mc-alert {
            margin: 0 0 14px;
            display: block;
            font-size: 13px
        }

        .mc-hidden {
            display: none
        }

        .mc-bulk {
            margin-top: 22px
        }

            .mc-bulk .bulk-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 18px
            }

            .mc-bulk .bulk-list {
                max-height: 250px;
                overflow: auto;
                border: 1px solid #e1e8f0;
                padding: 10px
            }

            .mc-bulk .bulk-filters {
                display: flex;
                gap: 8px;
                margin-bottom: 10px
            }

                .mc-bulk .bulk-filters input {
                    flex: 1
                }

                .mc-bulk .bulk-filters select {
                    width: 130px
                }

            .mc-bulk .bulk-item-row {
                display: flex;
                gap: 8px;
                padding: 7px;
                border-bottom: 1px solid #eef2f6
            }

            .mc-bulk .assignment-toolbar {
                display: flex;
                gap: 8px;
                margin: 10px 0
            }

            .mc-bulk .assignment-footer {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-top: 15px
            }

            .mc-bulk .assignment-count {
                font-size: 12px;
                color: #416286
            }

            .mc-bulk .hint {
                font-size: 12px;
                color: #72839a
            }

            .mc-bulk .btn {
                border: 0;
                border-radius: 8px;
                padding: 10px 13px;
                cursor: pointer
            }

            .mc-bulk .btn-primary {
                background: #145dc2;
                color: white
            }

            .mc-bulk .btn-secondary {
                background: #edf2f8;
                color: #315274
            }

            .mc-bulk .form-control {
                border: 1px solid #dbe4ee;
                border-radius: 8px;
                padding: 10px
            }

            .mc-bulk #pane-students[hidden] {
                display: none !important
            }

        @media(max-width:1100px) {
            .mc-layout {
                grid-template-columns: 1fr
            }

            .mc-toolbar select {
                width: 180px
            }
        }

        @media(max-width:650px) {
            .mc {
                padding: 18px 10px
            }

            .mc-stats {
                grid-template-columns: 1fr
            }

            .mc-grid2, .mc-bulk .bulk-grid {
                grid-template-columns: 1fr
            }

            .mc-header {
                flex-wrap: wrap
            }
        }
    </style>
</asp:Content>
<asp:Content ID="ManageCoursesMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="mc">
        <div class="mc-header">
            <div>
                <h1>Manage Courses</h1>
                <p>View courses, edit details, and manage instructor and student assignments.</p>
            </div>
            <asp:Button ID="btnNewCourse" runat="server" Text="+ Add Course" CssClass="mc-btn" OnClick="btnNewCourse_Click" CausesValidation="false" />
        </div>
        <div class="mc-stats">
            <div class="mc-stat"><small>Total Courses</small><asp:Label ID="lblTotalCourses" runat="server" Text="0" /></div>
            <div class="mc-stat"><small>Published Courses</small><asp:Label ID="lblPublishedCourses" runat="server" Text="0" /></div>
            <div class="mc-stat"><small>Student Assignments</small><asp:Label ID="lblTotalEnrollments" runat="server" Text="0" /></div>
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="mc-alert" EnableViewState="false" />
        <div class="mc-layout">
            <section class="mc-panel">
                <div class="mc-panelhead">
                    <h2>All Courses</h2>
                    <p>Click a course title to edit it in the right panel.</p>
                </div>
                <div class="mc-toolbar">
                    <input type="search" id="allCoursesSearch" class="mc-input" placeholder="Search course or instructor..." oninput="filterCoursesByProgram()" /><asp:DropDownList ID="ddlAllCoursesProgram" runat="server" onchange="filterCoursesByProgram()" />
                </div>
                <div class="mc-tablewrap">
                    <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="False" CssClass="mc-table" GridLines="None" EmptyDataText="No courses available." OnRowCommand="gvCourses_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="CourseID" HeaderText="ID" />
                            <asp:TemplateField HeaderText="Course">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnOpenCourse" runat="server" CssClass="mc-course-link" Text='<%# Eval("CourseTitle") %>' CommandName="EditCourse" CommandArgument='<%# Eval("CourseID") %>' CausesValidation="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="ProgramCode" HeaderText="Program" />
                            <asp:BoundField DataField="InstructorName" HeaderText="Instructor" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate><span class='<%# Convert.ToBoolean(Eval("CoursePublished")) ? "mc-status" : "mc-status draft" %>'><%# Convert.ToBoolean(Eval("CoursePublished")) ? "Published" : "Draft" %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="StudentCount" HeaderText="Students" />
                        </Columns>
                    </asp:GridView>
                </div>
            </section>
            <section class="mc-panel" id="courseDetailsPanel">
                <div class="mc-panelhead">
                    <h2>
                        <asp:Label ID="lblEditorHeading" runat="server" Text="Select a course" /></h2>
                    <p>
                        <asp:Label ID="lblCourseStatus" runat="server" Text="Select a row or click Add Course." />
                    </p>
                </div>
                <div class="mc-editor">
                    <asp:HiddenField ID="hfCourseID" runat="server" Value="0" />
                    <asp:HiddenField ID="hfSemester" runat="server" Value="1" />
                    <asp:HiddenField ID="hfSelectedTab" runat="server" Value="details" />
                    <div class="mc-tabs">
                        <button type="button" class="mc-tab active" data-paneltab="details">Course Details</button>
                        <button type="button" class="mc-tab" data-paneltab="students">Students</button>
                    </div>
                    <div class="mc-tabpane" data-panelpane="details">
                        <div class="mc-field">
                            <label>Course Title</label><asp:TextBox ID="txtCourseTitle" runat="server" MaxLength="50" />
                        </div>
                        <div class="mc-field">
                            <label>Description</label><asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" />
                        </div>
                        <div class="mc-field">
                            <label>Announcement</label><asp:TextBox ID="txtAnnouncement" runat="server" TextMode="MultiLine" Rows="3" />
                        </div>
                        <div class="mc-grid2">
                            <div class="mc-field">
                                <label>Program</label><asp:DropDownList ID="ddlProgram" runat="server" />
                            </div>
                            <div class="mc-field">
                                <label>Year Level (information only)</label><asp:DropDownList ID="ddlYearLevel" runat="server">
                                    <asp:ListItem Text="Select Year" Value="" />
                                    <asp:ListItem Text="1st Year" Value="1" />
                                    <asp:ListItem Text="2nd Year" Value="2" />
                                    <asp:ListItem Text="3rd Year" Value="3" />
                                    <asp:ListItem Text="4th Year" Value="4" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <p class="mc-hint">Publication status is read-only. Only the instructor can publish or unpublish a course.</p>
                    </div>
                    <div class="mc-tabpane" data-panelpane="students" hidden="hidden">
                        <p class="mc-hint">Select students who should be assigned to this course. Uncheck an assigned student to remove their assignment when saving. Students with submissions cannot be removed.</p>
                        <div class="mc-field" style="margin-top: 12px">
                            <input id="panelStudentSearch" class="mc-input" type="search" placeholder="Search students..." oninput="filterPanelStudents()" />
                        </div>
                        <div class="mc-student-list">
                            <asp:CheckBoxList ID="cblPanelStudents" runat="server" RepeatLayout="Flow" RepeatDirection="Vertical" />
                        </div>
                        <asp:Label ID="lblPanelStudentInfo" runat="server" CssClass="mc-hint" />
                        <div class="mc-assigned-section">
                            <h3>Currently Assigned Students</h3>
                            <p class="mc-hint">Remove a student from this course only. This does not delete the student account.</p>
                            <div class="mc-tablewrap">
                                <asp:GridView ID="gvAssignedStudents" runat="server" AutoGenerateColumns="False"
                                    CssClass="mc-table mc-assigned-table" GridLines="None"
                                    EmptyDataText="No students assigned to this course."
                                    OnRowCommand="gvAssignedStudents_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="StudentName" HeaderText="Student" />
                                        <asp:TemplateField HeaderText="Action">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnRemoveStudent" runat="server"
                                                    Text="Remove" CssClass="mc-remove-btn"
                                                    CommandName="RemoveStudent"
                                                    CommandArgument='<%# Eval("StudentID") %>'
                                                    CausesValidation="false"
                                                    OnClientClick="return confirm('Remove this student from the selected course?');" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                    <div class="mc-instructor-assignment">
                        <div class="mc-field">
                            <label>Assigned Instructor</label>
                            <asp:DropDownList ID="ddlInstructor" runat="server" />
                        </div>
                        <p class="mc-hint">Changing the instructor transfers management of this course's modules and lessons to the newly assigned instructor.</p>
                    </div>
                    <div class="mc-footer">
                        <asp:Button ID="btnSaveCourse" runat="server" Text="Save Changes" CssClass="mc-btn" OnClick="btnSaveCourse_Click" CausesValidation="false" OnClientClick="return confirm('Save course details and student assignments?');" /><asp:Button ID="btnClear" runat="server" Text="Cancel" CssClass="mc-btn alt" OnClick="btnClear_Click" CausesValidation="false" />
                    </div>
                </div>
            </section>
        </div>
        <div class="mc-bulk mc-panel">
            <div class="mc-panelhead">
                <h2>Bulk Assign Courses</h2>
                <p>Optional: assign multiple courses to multiple students at once.</p>
            </div>
            <div style="padding: 18px">
                <button type="button" class="mc-btn alt" onclick="var p=document.getElementById('pane-students');p.hidden=!p.hidden;">Show / Hide Bulk Assignment</button>
                <!-- BULK ASSIGNMENT: multiple courses and multiple students -->
                <div id="pane-students" hidden="hidden">
                    <section class="panel">
                        <div class="panel-head">
                            <div>
                                <h2>Assign Courses to Students</h2>
                                <p class="muted">Select one or more courses and one or more approved, active students. No year-level or semester restrictions.</p>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="bulk-grid">
                                <div>
                                    <div class="assignment-list-heading">
                                        <h3>1. Select courses</h3>
                                        <span id="bulkCourseCount" class="assignment-count">0 selected</span>
                                    </div>
                                    <div class="bulk-filters">
                                        <input type="search" class="form-control" id="bulkCourseSearch" placeholder="Search courses (updates instantly)..." oninput="filterBulkList('bulkCourseList','bulkCourseSearch')" />
                                        <asp:DropDownList ID="ddlBulkCourseProgram" runat="server" ClientIDMode="Static" CssClass="form-control" aria-label="Filter courses by program" onchange="filterBulkList('bulkCourseList','bulkCourseSearch')" />
                                    </div>
                                    <div class="assignment-toolbar" style="margin-top: 10px">
                                        <button type="button" class="btn btn-secondary" onclick="toggleBulkList('bulkCourseList',true)">Select visible</button>
                                        <button type="button" class="btn btn-secondary" onclick="toggleBulkList('bulkCourseList',false)">Clear visible</button>
                                    </div>
                                    <div id="bulkCourseList" class="bulk-list">
                                        <asp:CheckBoxList ID="cblAssignmentCourses" runat="server" RepeatLayout="Flow" RepeatDirection="Vertical" />
                                    </div>
                                </div>
                                <div>
                                    <div class="assignment-list-heading">
                                        <h3>2. Select students</h3>
                                        <span id="selectedStudentCount" class="assignment-count">0 selected</span>
                                    </div>
                                    <div class="bulk-filters">
                                        <input type="search" class="form-control" id="assignmentStudentSearch" placeholder="Search students (updates instantly)..." oninput="filterBulkList('eligibleStudentList','assignmentStudentSearch')" />
                                        <asp:DropDownList ID="ddlBulkStudentProgram" runat="server" ClientIDMode="Static" CssClass="form-control" aria-label="Filter students by program" onchange="filterBulkList('eligibleStudentList','assignmentStudentSearch')" />
                                    </div>
                                    <div class="assignment-toolbar" style="margin-top: 10px">
                                        <button type="button" class="btn btn-secondary" onclick="toggleBulkList('eligibleStudentList',true)">Select visible</button>
                                        <button type="button" class="btn btn-secondary" onclick="toggleBulkList('eligibleStudentList',false)">Clear visible</button>
                                    </div>
                                    <div id="eligibleStudentList" class="bulk-list">
                                        <asp:CheckBoxList ID="cblEligibleStudents" runat="server" RepeatLayout="Flow" RepeatDirection="Vertical" />
                                    </div>
                                    <asp:Label ID="lblEligibleInfo" runat="server" CssClass="hint" />
                                </div>
                            </div>
                            <div class="assignment-footer">
                                <div>
                                    <strong id="assignmentPreview">0 assignments selected</strong>
                                    <p class="hint">Each selected student receives every selected course. Existing assignments are skipped.</p>
                                </div>
                                <asp:Button ID="btnEnroll" runat="server" Text="Assign Selected Courses" CssClass="btn btn-primary" CausesValidation="false" OnClick="btnEnroll_Click" OnClientClick="return confirmStudentAssignments();" />
                            </div>
                        </div>
                    </section>

                </div>

            </div>
        </div>
    </div>
    <script type="text/javascript">
        // Normalize Web Forms CheckBoxList markup into one row per item.
        // ASP.NET Flow layout can leave line breaks / wrapper spans behind
        // when items are hidden, causing the blank area seen in BSIT.
        function normalizeBulkList(id) {
            var container = document.getElementById(id);
            if (!container || container.dataset.normalized === '1') return;
            var boxes = Array.prototype.slice.call(container.querySelectorAll('input[type="checkbox"]'));
            var rows = document.createDocumentFragment();
            boxes.forEach(function (box) {
                var label = document.querySelector('label[for="' + box.id + '"]');
                if (!label && box.nextElementSibling && box.nextElementSibling.tagName === 'LABEL') label = box.nextElementSibling;
                var row = document.createElement('div');
                row.className = 'bulk-item-row';
                row.appendChild(box);
                if (label) row.appendChild(label);
                rows.appendChild(row);
            });
            container.textContent = '';
            container.appendChild(rows);
            container.dataset.normalized = '1';
        }
        function bulkBoxes(id) { return Array.prototype.slice.call(document.querySelectorAll('#' + id + ' input[type="checkbox"]')); }
        function updateStudentPreview() {
            var s = bulkBoxes('eligibleStudentList').filter(function (x) { return x.checked; }).length;
            var c = bulkBoxes('bulkCourseList').filter(function (x) { return x.checked; }).length;
            document.getElementById('selectedStudentCount').textContent = s + ' selected';
            document.getElementById('bulkCourseCount').textContent = c + ' selected';
            document.getElementById('assignmentPreview').textContent = (s * c) + ' assignments (' + s + ' students × ' + c + ' courses)';
        }
        // Each CheckBoxList item may render as input + label, with or without
        // a per-item span. Never hide the entire CheckBoxList container.
        function bulkItem(box) {
            var label = document.querySelector('label[for="' + box.id + '"]');
            var parent = box.parentElement;
            var wrapper = (parent && parent.tagName === 'SPAN' &&
                parent.querySelectorAll('input[type="checkbox"]').length === 1) ? parent : null;
            return { box: box, label: label, wrapper: wrapper };
        }
        function bulkItemText(box) {
            var item = bulkItem(box);
            return (item.label ? item.label.textContent :
                (item.wrapper ? item.wrapper.textContent : box.parentElement.textContent)).trim();
        }
        function setBulkItemVisible(box, visible) {
            var row = box.closest('.bulk-item-row');
            if (row) row.style.display = visible ? 'flex' : 'none';
            box.dataset.filterVisible = visible ? '1' : '0';
        }
        function filterBulkList(id, searchId) {
            var search = document.getElementById(searchId);
            var q = search ? search.value.trim().toLowerCase() : '';
            var isCourse = id === 'bulkCourseList';
            var select = document.getElementById(isCourse ? 'ddlBulkCourseProgram' : 'ddlBulkStudentProgram');
            var program = select ? select.value.trim().toLowerCase() : '';
            bulkBoxes(id).forEach(function (box) {
                var text = bulkItemText(box);
                var match = /\[\s*Program\s*:\s*([^|\]]+)/i.exec(text);
                var code = match ? match[1].trim().toLowerCase() : '';
                setBulkItemVisible(box, (!program || code === program) &&
                    (!q || text.toLowerCase().indexOf(q) !== -1));
            });
        }
        function toggleBulkList(id, checked) {
            bulkBoxes(id).forEach(function (box) {
                if (box.dataset.filterVisible !== '0') box.checked = checked;
            });
            updateStudentPreview();
        }
        function confirmStudentAssignments() {
            var s = bulkBoxes('eligibleStudentList').filter(function (x) { return x.checked; }).length;
            var c = bulkBoxes('bulkCourseList').filter(function (x) { return x.checked; }).length;
            if (!s || !c) { alert('Select at least one student and one course.'); return false; }
            return confirm('Assign ' + c + ' course(s) to ' + s + ' student(s)?');
        }
        document.addEventListener('DOMContentLoaded', function () {
            ['eligibleStudentList', 'bulkCourseList'].forEach(function (id) { normalizeBulkList(id); var el = document.getElementById(id); if (el) el.addEventListener('change', updateStudentPreview); });
            filterBulkList('bulkCourseList', 'bulkCourseSearch');
            filterBulkList('eligibleStudentList', 'assignmentStudentSearch');
            updateStudentPreview();
        });
    </script>
    <script>
        function setPanelTab(name) { document.getElementById('<%= hfSelectedTab.ClientID %>').value = name; document.querySelectorAll('[data-paneltab]').forEach(function (b) { b.classList.toggle('active', b.dataset.paneltab === name) }); document.querySelectorAll('[data-panelpane]').forEach(function (p) { p.hidden = p.dataset.panelpane !== name }); }
        document.addEventListener('DOMContentLoaded', function () { document.querySelectorAll('[data-paneltab]').forEach(function (b) { b.addEventListener('click', function () { setPanelTab(b.dataset.paneltab) }) }); setPanelTab(document.getElementById('<%= hfSelectedTab.ClientID %>').value || 'details'); filterCoursesByProgram(); document.querySelectorAll('#<%= gvCourses.ClientID %> tr').forEach(function (row) { var link = row.querySelector('.mc-course-link'); if (link) { row.style.cursor = 'pointer'; row.addEventListener('click', function (e) { if (!e.target.closest('a')) link.click(); }); } }); });
        function filterCoursesByProgram() { var t = document.getElementById('<%= gvCourses.ClientID %>'); var f = document.getElementById('<%= ddlAllCoursesProgram.ClientID %>'); var q = (document.getElementById('allCoursesSearch').value || '').toLowerCase(); if (!t) return; Array.prototype.slice.call(t.querySelectorAll('tr')).slice(1).forEach(function (r) { var c = r.cells; var program = c.length > 2 ? c[2].innerText.trim() : ''; r.style.display = (!f.value || program === f.value) && (!q || r.innerText.toLowerCase().includes(q)) ? '' : 'none'; }); }
        function filterPanelStudents() { var q = document.getElementById('panelStudentSearch').value.toLowerCase(); document.querySelectorAll('.mc-student-list span').forEach(function (s) { s.style.display = s.innerText.toLowerCase().includes(q) ? '' : 'none' }); }
</script>
</asp:Content>
