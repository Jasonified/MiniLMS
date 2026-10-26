
<%@ Page Title="Course Manager"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Courses.aspx.cs"
    Inherits="MiniLMS.InstructorCourses" %>

<asp:Content ID="CoursesHead"
    ContentPlaceHolderID="HeadContent"
    runat="server">

<style>
    /* =====================================
       GENERAL LAYOUT
       ===================================== */

    .courses-workspace {
        width: 100%;
        color: #243449;
        font-family: "Segoe UI", Arial, sans-serif;
    }

    .courses-workspace *,
    .courses-workspace *::before,
    .courses-workspace *::after {
        box-sizing: border-box;
    }

    .page-header {
        margin-bottom: 27px;
    }

    .page-header::before {
        content: "INSTRUCTOR PORTAL";
        display: block;
        color: #8a9ab0;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 1.2px;
        margin-bottom: 8px;
    }

    .page-header h1 {
        font-size: 27px;
        font-weight: 720;
        color: #1e3047;
        margin: 0 0 8px;
    }

    .page-header p {
        color: #72849a;
        font-size: 13px;
        line-height: 1.7;
        margin: 0;
    }

    .card {
        background: #fff;
        border: 1px solid #e3eaf2;
        border-radius: 13px;
        padding: 27px 30px;
        margin-bottom: 20px;
        box-shadow: none;
    }

    .card-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 15px;
        margin-bottom: 20px;
    }

    .card-header h2 {
        font-size: 20px;
        color: #17375e;
        margin: 0;
    }

    .card-header p {
        color: #7b8a9b;
        font-size: 13px;
        margin: 6px 0 0;
    }

    .message {
        display: block;
        margin: 12px 0 16px;
        font-size: 13px;
        font-weight: 600;
    }

    .message:empty {
        display: none;
    }

    /* =====================================
       BUTTONS
       ===================================== */

    .courses-workspace .btn {
        display: inline-block;
        padding: 10px 16px;
        border: 1px solid transparent;
        border-radius: 8px;
        background: #2563a6;
        color: #fff;
        font-family: "Segoe UI", Arial, sans-serif;
        font-size: 13px;
        font-weight: 650;
        text-decoration: none;
        cursor: pointer;
        transition: background .2s, border-color .2s,
                    transform .2s;
    }

    .courses-workspace .btn:hover {
        background: #195692;
    }

    .courses-workspace .btn:focus-visible {
        outline: 3px solid #93c5fd;
        outline-offset: 2px;
    }

    .courses-workspace .btn-secondary {
        background: #edf3fa;
        color: #2b5985;
    }

    .courses-workspace .btn-secondary:hover {
        background: #dbeafb;
    }

    .courses-workspace .btn-danger {
        background: #fff0f0;
        color: #ad4242;
    }

    .courses-workspace .btn-danger:hover {
        background: #ffe4e4;
    }

    .courses-workspace .btn-small {
        padding: 8px 12px;
        font-size: 12px;
        margin: 2px;
    }

    .actions {
        display: flex;
        gap: 9px;
        flex-wrap: wrap;
    }

    /* =====================================
       FORM ELEMENTS
       ===================================== */

    .form-grid {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 16px;
        margin-bottom: 17px;
    }

    .lesson-form {
        grid-template-columns: 2fr 1fr 1fr;
    }

    .field {
        display: flex;
        flex-direction: column;
        gap: 7px;
    }

    .field.full {
        grid-column: 1 / -1;
    }

    .field label {
        font-size: 13px;
        font-weight: 600;
        color: #4b5d70;
    }

    .form-control {
        width: 100%;
        padding: 11px 12px;
        border: 1px solid #dce4ed;
        border-radius: 8px;
        background: #fff;
        color: #243449;
        font: 14px "Segoe UI", Arial, sans-serif;
        outline: none;
    }

    .form-control:focus {
        border-color: #2563a6;
        box-shadow: 0 0 0 3px rgba(35, 105, 181, .10);
    }

    textarea.form-control {
        min-height: 110px;
        resize: vertical;
    }

    /* =====================================
       DESIGN C - COMPACT COURSE LIST
       ===================================== */

    .course-list-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 16px;
        margin-bottom: 18px;
    }

    .course-list-header h2 {
        margin: 0 0 6px;
        color: #17375e;
        font-size: 20px;
    }

    .course-list-header p {
        margin: 0;
        color: #72849a;
        font-size: 13px;
    }

    .course-list-label {
        display: inline-flex;
        align-items: center;
        gap: 7px;
        padding: 8px 12px;
        background: #f1f6fc;
        border: 1px solid #e0eaf5;
        border-radius: 8px;
        color: #4776a9;
        font-size: 12px;
        font-weight: 650;
        white-space: nowrap;
    }

    .course-list-label::before {
        content: "";
        width: 7px;
        height: 7px;
        background: #2563a6;
        border-radius: 50%;
    }

    .course-search-wrapper {
        position: relative;
        margin-bottom: 20px;
    }

    .course-search-wrapper .form-control {
        padding: 12px 15px 12px 43px;
        background: #fbfcfe;
        border-radius: 10px;
    }

    .course-search-icon {
        position: absolute;
        top: 50%;
        left: 15px;
        transform: translateY(-50%);
        width: 17px;
        height: 17px;
        color: #8091a5;
        pointer-events: none;
    }

    .course-search-empty {
        display: none;
        margin: 12px 0;
        padding: 15px;
        background: #f8fafc;
        border-radius: 9px;
        color: #72849a;
        font-size: 13px;
        text-align: center;
    }

    /*
       The original GridView is retained.
       CSS transforms each data row into a card.
       This preserves ASP.NET RowCommand behavior.
    */

    .course-list-scroll {
        width: 100%;
    }

    .course-list-grid {
        display: block;
        width: 100%;
        border: 0;
        border-collapse: separate;
        font-size: 13px;
    }

    .course-list-grid tbody {
        display: flex;
        flex-direction: column;
        gap: 12px;
        width: 100%;
    }

    .course-list-grid tr {
        display: grid;
        grid-template-columns: 56px minmax(0, 1fr) auto;
        grid-template-areas:
            "icon title status"
            "icon description status"
            "actions actions actions";
        column-gap: 14px;
        row-gap: 5px;
        align-items: center;
        width: 100%;
        padding: 18px 20px;
        background: #fff;
        border: 1px solid #e4eaf2;
        border-radius: 12px;
        transition: border-color .2s, box-shadow .2s;
    }

    .course-list-grid tr:hover {
        border-color: #c9d9ea;
        box-shadow: 0 4px 15px rgba(27, 51, 80, .05);
    }

    /* Hide the GridView's original column headings. */
    .course-list-grid tr:has(th) {
        display: none;
    }

    .course-list-grid td {
        border: 0;
        padding: 0;
        min-width: 0;
    }

    /* Course ID becomes a book icon tile. */
    .course-list-grid td:nth-child(1) {
        grid-area: icon;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 48px;
        height: 48px;
        overflow: hidden;
        border-radius: 11px;
        background: #eaf2fb;
        color: transparent;
        font-size: 0;
        position: relative;
    }

    .course-list-grid td:nth-child(1)::after {
        content: "";
        width: 23px;
        height: 23px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: contain;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%232563a6' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M4 19.5A2.5 2.5 0 0 1 6.5 17H20'/%3E%3Cpath d='M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2Z'/%3E%3C/svg%3E");
    }

    /* Course title */
    .course-list-grid td:nth-child(2) {
        grid-area: title;
        align-self: end;
        color: #17375e;
        font-size: 15px;
        font-weight: 700;
        overflow-wrap: anywhere;
    }

    /* Course description */
    .course-list-grid td:nth-child(3) {
        grid-area: description;
        align-self: start;
        color: #7b8a9b;
        font-size: 12px;
        line-height: 1.6;
        overflow-wrap: anywhere;
    }

    /* Publishing status */
    .course-list-grid td:nth-child(4) {
        grid-area: status;
        align-self: start;
        justify-self: end;
    }

    .course-status {
        display: inline-flex;
        align-items: center;
        gap: 7px;
        padding: 7px 11px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 700;
        white-space: nowrap;
    }

    .course-status::before {
        content: "";
        width: 7px;
        height: 7px;
        border-radius: 50%;
        background: currentColor;
    }

    .course-status.published {
        background: #e8f7ef;
        color: #218451;
    }

    .course-status.unpublished {
        background: #f1f4f8;
        color: #6d7d90;
    }

    /* Course actions */
    .course-list-grid td:nth-child(5) {
        grid-area: actions;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 9px;
        padding-top: 13px;
        margin-top: 10px;
        border-top: 1px solid #edf1f6;
    }

    .course-list-grid .course-manage-btn {
        background: #2563a6;
        color: white;
        padding: 10px 17px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 650;
        margin: 0;
    }

    .course-list-grid .course-manage-btn:hover {
        background: #195692;
    }

    .course-list-grid .course-publish-btn {
        background: #f1f6fc;
        color: #2b5985;
        border: 1px solid #e0eaf5;
        padding: 10px 15px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 650;
        margin: 0;
    }

    .course-list-grid .course-publish-btn:hover {
        background: #e5effa;
    }

    /*
       GridView empty-data row:
       keep it visible without the card layout.
    */

    .course-list-grid tr:has(td:only-child) {
        display: block;
        padding: 25px;
        text-align: center;
    }

    .course-list-grid tr:has(td:only-child) td {
        display: block;
        width: auto;
        height: auto;
        background: transparent;
        color: #72849a;
        font-size: 13px;
    }

    .course-list-grid tr:has(td:only-child) td::after {
        display: none;
    }

    /* =====================================
       SELECTED COURSE WORKSPACE
       ===================================== */

    .course-workspace-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 20px;
        padding: 26px 30px;
        margin-bottom: 22px;
        background: #fff;
        border: 1px solid #e1e9f2;
        border-radius: 13px;
    }

    .workspace-eyebrow {
        display: block;
        margin-bottom: 9px;
        color: #2369b5;
        font-size: 11px;
        font-weight: 750;
        letter-spacing: 1px;
    }

    .course-workspace-header h2 {
        margin: 0 0 8px;
        color: #17375e;
        font-size: 23px;
        font-weight: 750;
    }

    .course-workspace-header p {
        margin: 0;
        color: #72849a;
        font-size: 13px;
        line-height: 1.6;
    }

    .course-workspace-header .btn {
        flex-shrink: 0;
        white-space: nowrap;
    }

    .selected-name {
        display: inline-block;
        background: #f1f6fc;
        color: #356da9;
        padding: 7px 12px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
    }

    /* =====================================
       MODULES / LESSONS TABLES
       ===================================== */

    .table-scroll {
        width: 100%;
        overflow-x: auto;
    }

    .data-grid {
        width: 100%;
        border-collapse: collapse;
        font-size: 13px;
    }

    .data-grid th {
        background: #f8fafc;
        color: #52647a;
        text-align: left;
        font-weight: 700;
        padding: 14px;
        white-space: nowrap;
        border-bottom: 1px solid #e3eaf2;
    }

    .data-grid td {
        padding: 15px 14px;
        border-bottom: 1px solid #edf1f6;
        vertical-align: middle;
    }

    .data-grid tr:hover td {
        background: #fafcff;
    }

    /* =====================================
       LESSON DETAILS / MATERIALS
       ===================================== */

    .details-panel {
        background: #f8fbff;
        border: 1px solid #e0eaf4;
        border-radius: 12px;
        padding: 20px;
        margin-top: 20px;
    }

    .details-panel h3 {
        margin: 0 0 10px;
        font-size: 17px;
        color: #17375e;
    }

    .details-meta {
        color: #7c8b9c;
        font-size: 13px;
    }

    .details-description {
        white-space: pre-wrap;
        overflow-wrap: anywhere;
        line-height: 1.7;
        margin-top: 15px;
        font-size: 14px;
    }

    .upload-area {
        border: 2px dashed #cbdced;
        background: #fff;
        padding: 22px;
        border-radius: 12px;
        margin: 15px 0;
    }

    .upload-area input[type=file] {
        display: block;
        max-width: 100%;
        margin: 12px 0;
    }

    .upload-help {
        font-size: 12px;
        color: #718096;
        line-height: 1.6;
    }

    /* =====================================
       RESPONSIVE DESIGN
       ===================================== */

    @media (max-width: 850px) {
        .form-grid,
        .lesson-form {
            grid-template-columns: 1fr;
        }

        .card {
            padding: 20px;
        }

        .card-header {
            flex-direction: column;
            align-items: flex-start;
        }
    }

    @media (max-width: 600px) {
        .course-workspace-header {
            flex-direction: column;
            align-items: flex-start;
            padding: 22px;
        }

        .course-workspace-header .btn {
            width: 100%;
        }

        .course-list-header {
            align-items: flex-start;
            flex-direction: column;
        }

        .course-list-grid tr {
            grid-template-columns: 46px minmax(0, 1fr);
            grid-template-areas:
                "icon title"
                "icon description"
                "status status"
                "actions actions";
            padding: 15px;
            column-gap: 12px;
        }

        .course-list-grid td:nth-child(1) {
            width: 44px;
            height: 44px;
        }

        .course-list-grid td:nth-child(4) {
            justify-self: start;
            margin-top: 9px;
        }

        .course-list-grid td:nth-child(5) {
            justify-content: stretch;
            flex-wrap: wrap;
        }

        .course-list-grid td:nth-child(5) .btn {
            flex: 1 1 120px;
            text-align: center;
        }
    }

    @media (max-width: 400px) {
        .card {
            padding: 15px;
        }

        .course-list-grid td:nth-child(2) {
            font-size: 14px;
        }

        .course-list-grid td:nth-child(5) {
            flex-direction: column;
            align-items: stretch;
        }

        .course-list-grid td:nth-child(5) .btn {
            width: 100%;
            flex: auto;
        }
    }

    /* DESIGN 2: MODULE AND LESSON CARDS */
    .module-entry-form,.lesson-entry-form{background:#f4f8fd;border-radius:12px;padding:22px;margin-bottom:24px}
    .module-entry-form .form-grid{grid-template-columns:minmax(0,2.5fr) minmax(130px,.8fr) auto;align-items:end;margin-bottom:0}
    .module-entry-form .actions{align-self:end;align-items:center}
    .module-entry-form .actions .btn{min-height:43px;white-space:nowrap}
    .lesson-entry-form .actions{margin-top:16px}
    .module-cards,.lesson-cards{overflow:visible;margin-top:0!important}
    .module-cards .data-grid,.lesson-cards .data-grid{display:block;width:100%;border:0;border-collapse:separate}
    .module-cards .data-grid tbody,.lesson-cards .data-grid tbody{display:flex;flex-direction:column;gap:14px}
    .module-cards .data-grid tr,.lesson-cards .data-grid tr{display:grid;grid-template-columns:72px minmax(0,1fr) auto;grid-template-areas:'icon title actions' 'icon meta actions';align-items:center;column-gap:18px;row-gap:6px;border:1px solid #dce7f5;border-radius:14px;padding:22px 24px;background:#fff;min-height:132px}
    .module-cards .data-grid tr:has(th),.lesson-cards .data-grid tr:has(th){display:none}
    .module-cards .data-grid td,.lesson-cards .data-grid td{padding:0!important;border:0!important;background:transparent!important;min-width:0}
    .module-cards .data-grid td:first-child,.lesson-cards .data-grid td:first-child{grid-area:title;color:#17375e;font-size:17px;font-weight:700;overflow-wrap:anywhere}
    .module-cards .data-grid td:nth-child(2),.lesson-cards .data-grid td:nth-child(2){grid-area:meta;color:#6c83a1;font-size:13px}
    .module-cards .data-grid td:nth-child(2)::before,.lesson-cards .data-grid td:nth-child(2)::before{content:'Order: ';font-weight:500}
    .module-cards .data-grid td:last-child,.lesson-cards .data-grid td:last-child{grid-area:actions;display:flex;gap:9px;align-items:center;justify-content:flex-end;flex-wrap:wrap}
    .module-cards .data-grid td:first-child::before,.lesson-cards .data-grid td:first-child::before{content:'▤';position:absolute;left:24px;top:50%;transform:translateY(-50%);width:60px;height:60px;border-radius:14px;background:#e4efff;color:#1e65c0;font-size:34px;font-weight:400;display:flex;align-items:center;justify-content:center}
    .module-cards .data-grid tr,.lesson-cards .data-grid tr{position:relative}
    .lesson-cards .data-grid tr{grid-template-areas:'icon title actions' 'icon meta actions' 'icon duration actions';min-height:142px}
    .lesson-cards .data-grid td:nth-child(3){grid-area:duration;color:#6c83a1;font-size:13px}
    .lesson-cards .data-grid td:nth-child(3)::after{content:' min'}
    .module-cards .data-grid .btn,.lesson-cards .data-grid .btn{margin:0;padding:10px 15px;white-space:nowrap}
    .module-cards .data-grid tr:has(td:only-child),.lesson-cards .data-grid tr:has(td:only-child){display:block;min-height:0;text-align:center;color:#718096}
    .module-cards .data-grid tr:has(td:only-child) td::before,.lesson-cards .data-grid tr:has(td:only-child) td::before{display:none}
    @media(max-width:900px){.module-entry-form .form-grid{grid-template-columns:minmax(0,1fr) 160px}.module-entry-form .actions{grid-column:1/-1}.module-cards .data-grid tr,.lesson-cards .data-grid tr{grid-template-columns:62px minmax(0,1fr);grid-template-areas:'icon title' 'icon meta' 'actions actions';padding:18px}.lesson-cards .data-grid tr{grid-template-areas:'icon title' 'icon meta' 'icon duration' 'actions actions'}.module-cards .data-grid td:last-child,.lesson-cards .data-grid td:last-child{border-top:1px solid #edf1f6!important;padding-top:14px!important;margin-top:10px;justify-content:flex-start}.module-cards .data-grid td:first-child::before,.lesson-cards .data-grid td:first-child::before{left:18px;top:18px;transform:none;width:50px;height:50px}}
    @media(max-width:600px){.module-entry-form .form-grid{grid-template-columns:1fr}.module-entry-form,.lesson-entry-form{padding:15px}.module-cards .data-grid td:last-child,.lesson-cards .data-grid td:last-child{flex-wrap:wrap}.module-cards .data-grid .btn,.lesson-cards .data-grid .btn{flex:1 1 auto;text-align:center}}


/* PHASE 2: MODULE ASSIGNMENTS */
.assignment-entry{background:#f4f8fd;border:1px solid #e2ecf7;border-radius:12px;padding:22px;margin-bottom:22px}
.assignment-fields{display:grid;grid-template-columns:2fr 1fr;gap:15px}
.assignment-fields .full{grid-column:1/-1}
.assignment-list .data-grid{display:block;border:0}
.assignment-list .data-grid tbody{display:flex;flex-direction:column;gap:12px}
.assignment-list .data-grid tr{display:grid;grid-template-columns:minmax(0,2fr) minmax(120px,1fr) minmax(90px,.5fr) auto;align-items:center;gap:14px;border:1px solid #dce7f5;border-radius:12px;padding:18px;background:#fff}
.assignment-list .data-grid tr:has(th){display:none}
.assignment-list .data-grid td{padding:0;border:0;overflow-wrap:anywhere}
.assignment-list .data-grid td:first-child{font-weight:700;color:#17375e}
.assignment-list .data-grid td:last-child{display:flex;gap:6px;flex-wrap:wrap;justify-content:flex-end}
.assignment-list .data-grid tr:has(td:only-child){display:block;text-align:center}
.assignment-list .data-grid tr:has(td:only-child) td{font-weight:400}
@media(max-width:850px){.assignment-fields{grid-template-columns:1fr}.assignment-list .data-grid tr{grid-template-columns:1fr 1fr}.assignment-list .data-grid td:last-child{grid-column:1/-1;justify-content:flex-start}}
@media(max-width:520px){.assignment-list .data-grid tr{grid-template-columns:1fr}.assignment-list .data-grid td:last-child{grid-column:auto}}


/* OPTION A: focused, accessible course workspace tabs */
.course-tabbar{display:flex;flex-wrap:wrap;gap:8px;margin:0 0 18px;padding:8px;background:#f0f5fb;border:1px solid #e0e9f3;border-radius:12px}
.course-tab{appearance:none;border:1px solid transparent;background:transparent;color:#4b6480;border-radius:9px;padding:12px 18px;font:650 13px "Segoe UI",Arial,sans-serif;cursor:pointer;display:inline-flex;align-items:center;gap:9px}
.course-tab:hover{background:#e2edf9;color:#17375e}
.course-tab[aria-selected="true"]{background:#2563a6;color:white;box-shadow:0 2px 6px rgba(25,74,132,.14)}
.course-tab:focus-visible{outline:3px solid #93c5fd;outline-offset:2px}
.course-tab-content{min-height:110px}
.course-tab-help{display:none;background:white;border:1px dashed #c4d5e8;border-radius:12px;padding:28px;margin-bottom:18px;color:#647b96;font-size:13px;line-height:1.7}
.course-tab-help strong{display:block;color:#17375e;font-size:16px;margin-bottom:6px}
.course-tab-help .btn{margin-top:12px}
.course-tabbar[hidden],.course-tab-help[hidden]{display:none!important}
@media(max-width:600px){.course-tabbar{display:grid;grid-template-columns:1fr 1fr}.course-tab{justify-content:center;padding:11px 7px;font-size:12px}}

</style>

</asp:Content>

<asp:Content ID="CoursesContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <!-- =====================================
         EXISTING HIDDEN FIELDS
         ===================================== -->

    <asp:HiddenField ID="hfCourseID" runat="server" />
    <asp:HiddenField ID="hfModuleID" runat="server" />
    <asp:HiddenField ID="hfEditModuleID" runat="server" />
    <asp:HiddenField ID="hfEditLessonID" runat="server" />
    <asp:HiddenField ID="hfMaterialLessonID" runat="server" />
    <asp:HiddenField ID="hfGradeSubmissionID" runat="server" />
    <asp:HiddenField ID="hfEditAssignmentID" runat="server" />
    <asp:HiddenField ID="hfViewAssignmentID" runat="server" />

    <div class="courses-workspace">

        <!-- =====================================
             PAGE HEADER
             ===================================== -->

        <div class="page-header">
            <h1>Course Manager</h1>
            <p>
                Create and organize modules, lessons, assignments,
                and learning materials for your assigned courses.
            </p>
        </div>

        <asp:Label ID="lblMessage"
            runat="server"
            CssClass="message" />

        <!-- =====================================
             DESIGN C - ASSIGNED COURSES
             ===================================== -->

        <asp:Panel ID="pnlCourseList"
            runat="server"
            CssClass="card">

            <div class="course-list-header">
                <div>
                    <h2>My Courses</h2>
                    <p>
                        Manage your course content and publishing status.
                    </p>
                </div>

                <span class="course-list-label">
                    Assigned Courses
                </span>
            </div>

           

            <div class="course-search-wrapper">

                <svg class="course-search-icon"
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    aria-hidden="true">

                    <circle cx="11" cy="11" r="8" />
                    <path d="m21 21-4.35-4.35" />

                </svg>

                <input type="search"
                    id="instructorCoursesSearch"
                    class="form-control"
                    placeholder="Search course ID or title..."
                    aria-label="Search assigned courses"
                    oninput="filterInstructorCourses()" />

            </div>

            <div id="instructorCoursesNoMatch"
                class="course-search-empty">
                No courses match your search.
            </div>

            

            <div class="course-list-scroll">

                <asp:GridView ID="gvCourses"
                    runat="server"
                    AutoGenerateColumns="false"
                    CssClass="course-list-grid"
                    GridLines="None"
                    ShowHeader="false"
                    OnRowCommand="gvCourses_RowCommand"
                    EmptyDataText="No assigned courses found.">

                    <Columns>

                        

                        <asp:BoundField
                            DataField="CourseID"
                            HeaderText="ID" />

                        

                        <asp:TemplateField HeaderText="Course">
                            <ItemTemplate>

                                <div>
                                    <%# Eval("CourseTitle") %>
                                </div>

                                <div style="
                                    font-size: 11px;
                                    color: #8a9aab;
                                    font-weight: 500;
                                    margin-top: 4px;">

                                    Course #<%# Eval("CourseID") %>

                                </div>

                            </ItemTemplate>
                        </asp:TemplateField>

                        

                        <asp:BoundField
                            DataField="CourseDescription"
                            HeaderText="Description" />

                       

                        <asp:TemplateField HeaderText="Publishing">
                            <ItemTemplate>

                                <span class='<%# Convert.ToBoolean(Eval("CoursePublished"))
                                    ? "course-status published"
                                    : "course-status unpublished" %>'>

                                    <%# Convert.ToBoolean(Eval("CoursePublished"))
                                        ? "Published"
                                        : "Unpublished" %>

                                </span>

                            </ItemTemplate>
                        </asp:TemplateField>

                        

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>

                               

                                <asp:Button
                                    runat="server"
                                    Text='<%# Convert.ToBoolean(Eval("CoursePublished"))
                                        ? "Unpublish"
                                        : "Publish" %>'
                                    CssClass="btn course-publish-btn"
                                    CausesValidation="false"
                                    CommandName='<%# Convert.ToBoolean(Eval("CoursePublished"))
                                        ? "UnpublishCourse"
                                        : "PublishCourse" %>'
                                    CommandArgument='<%# Eval("CourseID") %>'
                                    OnClientClick="return confirm('Change the publication status of this course?');" />

                                
                                <asp:Button
                                    runat="server"
                                    Text="Manage Course →"
                                    CssClass="btn course-manage-btn"
                                    CausesValidation="false"
                                    CommandName="SelectCourse"
                                    CommandArgument='<%# Eval("CourseID") %>' />

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

        </asp:Panel>

        <!-- =====================================
             SELECTED COURSE WORKSPACE
             ===================================== -->

        <asp:Panel ID="pnlCourseWorkspace"
            runat="server"
            Visible="false">

            <div class="course-workspace-header">

                <div>
                    <span class="workspace-eyebrow">
                        COURSE MANAGEMENT
                    </span>

                    <h2>
                        <asp:Label ID="lblWorkspaceCourse"
                            runat="server" />
                    </h2>

                    <p>
                        Manage modules, lessons, assignments, and learning
                        materials for this course.
                    </p>
                </div>

                <asp:Button ID="btnBackToCourses"
                    runat="server"
                    Text="← Back to Courses"
                    CssClass="btn btn-secondary"
                    CausesValidation="false"
                    OnClick="btnBackToCourses_Click" />

            </div>

        </asp:Panel>

        <!-- =====================================
             MODULES
             ===================================== -->

        <!-- OPTION A: visual navigation only. Existing ASP.NET panels and handlers stay intact. -->
        <div id="instructorCourseTabs" class="course-tabbar" role="tablist" aria-label="Course management sections" style="display:none">
            <button type="button" class="course-tab" role="tab" data-course-tab="modules" aria-selected="true">Modules</button>
            <button type="button" class="course-tab" role="tab" data-course-tab="lessons" aria-selected="false">Lessons &amp; Materials</button>
            <button type="button" class="course-tab" role="tab" data-course-tab="assignments" aria-selected="false">Assignments</button>
            <button type="button" class="course-tab" role="tab" data-course-tab="submissions" aria-selected="false">Submissions &amp; Grading</button>
        </div>
        <div id="courseTabHelp" class="course-tab-help" role="status" aria-live="polite"></div>

        <asp:Panel ID="pnlModules"
            runat="server"
            Visible="false"
            CssClass="card">

            <div class="card-header">
                <div>
                    <h2>Modules</h2>
                    <p>Create and organize course modules.</p>
                </div>

                <asp:Label ID="lblSelectedCourse"
                    runat="server"
                    CssClass="selected-name" />
            </div>

            

            <div class="module-entry-form">
            <div class="form-grid">

                <div class="field">
                    <label>Module Title</label>

                    <asp:TextBox ID="txtModuleTitle"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="150"
                        placeholder="Enter module title"
                        onkeydown="if (event.key === 'Enter') { event.preventDefault(); document.getElementById('<%= btnAddModule.ClientID %>').click(); return false; }" />
                </div>

                <div class="field">
                    <label>Module Order</label>

                    <asp:TextBox ID="txtModuleOrder"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Number"
                        Text="1" />
                </div>

            <div class="actions">

                <asp:Button ID="btnAddModule"
                    runat="server"
                    Text="Add Module"
                    CssClass="btn"
                    CausesValidation="false"
                    OnClick="btnAddModule_Click" />

                <asp:Button ID="btnCancelModuleEdit"
                    runat="server"
                    Text="Cancel Edit"
                    CssClass="btn btn-secondary"
                    CausesValidation="false"
                    Visible="false"
                    OnClick="btnAddModule_Click" />

            </div>
            </div>
            </div>


            <div class="table-scroll module-cards">

                <asp:GridView ID="gvModules"
                    runat="server"
                    AutoGenerateColumns="false"
                    CssClass="data-grid"
                    GridLines="None"
                    OnRowCommand="gvModules_RowCommand"
                    EmptyDataText="No modules found.">

                    <Columns>

                        <asp:BoundField
                            DataField="ModuleTitle"
                            HeaderText="Module" />

                        <asp:BoundField
                            DataField="ModuleOrder"
                            HeaderText="Order" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>

                                <asp:Button
                                    runat="server"
                                    Text="Lessons"
                                    CssClass="btn btn-small"
                                    CausesValidation="false"
                                    CommandName="SelectModule"
                                    CommandArgument='<%# Eval("ModuleID") %>' />

                                <asp:Button
                                    runat="server"
                                    Text="Edit"
                                    CssClass="btn btn-secondary btn-small"
                                    CausesValidation="false"
                                    CommandName="EditModule"
                                    CommandArgument='<%# Eval("ModuleID") %>' />

                                <asp:Button
                                    runat="server"
                                    Text="Delete"
                                    CssClass="btn btn-danger btn-small"
                                    CausesValidation="false"
                                    CommandName="DeleteModule"
                                    CommandArgument='<%# Eval("ModuleID") %>'
                                    OnClientClick="return confirm('Delete this module?');" />

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

        </asp:Panel>

        <!-- =====================================
             LESSONS
             ===================================== -->

        <asp:Panel ID="pnlLessons"
            runat="server"
            Visible="false"
            CssClass="card">

            <div class="card-header">
                <div>
                    <h2>Lessons</h2>
                    <p>Manage learning content for this module.</p>
                </div>

                <asp:Label ID="lblSelectedModule"
                    runat="server"
                    CssClass="selected-name" />
            </div>


            <div class="lesson-entry-form">
            <div class="form-grid lesson-form">

                <div class="field">
                    <label>Lesson Title</label>

                    <asp:TextBox ID="txtLessonTitle"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="150"
                        placeholder="Enter lesson title" />
                </div>

                <div class="field">
                    <label>Lesson Order</label>

                    <asp:TextBox ID="txtLessonOrder"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Number"
                        Text="1" />
                </div>

                <div class="field">
                    <label>Duration (minutes)</label>

                    <asp:TextBox ID="txtDuration"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Number"
                        Text="1" />
                </div>

                <div class="field full">
                    <label>Lesson Description / Content</label>

                    <asp:TextBox ID="txtLessonDescription"
                        runat="server"
                        CssClass="form-control"
                        TextMode="MultiLine"
                        Rows="5"
                        placeholder="Enter lesson content" />
                </div>

            </div>


            <div class="actions">

                <asp:Button ID="btnAddLesson"
                    runat="server"
                    Text="Add Lesson"
                    CssClass="btn"
                    CausesValidation="false"
                    OnClick="btnAddLesson_Click" />

                <asp:Button ID="btnCancelLessonEdit"
                    runat="server"
                    Text="Cancel Edit"
                    CssClass="btn btn-secondary"
                    CausesValidation="false"
                    Visible="false"
                    OnClick="btnAddLesson_Click" />

            </div>
            </div>


            <div class="table-scroll lesson-cards">

                <asp:GridView ID="gvLessons"
                    runat="server"
                    AutoGenerateColumns="false"
                    CssClass="data-grid"
                    GridLines="None"
                    OnRowCommand="gvLessons_RowCommand"
                    EmptyDataText="No lessons found.">

                    <Columns>

                        <asp:BoundField
                            DataField="LessonTitle"
                            HeaderText="Lesson" />

                        <asp:BoundField
                            DataField="LessonOrder"
                            HeaderText="Order" />

                        <asp:BoundField
                            DataField="DurationMinutes"
                            HeaderText="Minutes" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>

                                <asp:Button
                                    runat="server"
                                    Text="Details / Materials"
                                    CssClass="btn btn-secondary btn-small"
                                    CausesValidation="false"
                                    CommandName="LessonDetails"
                                    CommandArgument='<%# Eval("LessonID") %>' />

                                <asp:Button
                                    runat="server"
                                    Text="Edit"
                                    CssClass="btn btn-small"
                                    CausesValidation="false"
                                    CommandName="EditLesson"
                                    CommandArgument='<%# Eval("LessonID") %>' />

                                <asp:Button
                                    runat="server"
                                    Text="Delete"
                                    CssClass="btn btn-danger btn-small"
                                    CausesValidation="false"
                                    CommandName="DeleteLesson"
                                    CommandArgument='<%# Eval("LessonID") %>'
                                    OnClientClick="return confirm('Delete this lesson?');" />

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

            <!-- =====================================
                 LESSON DETAILS
                 ===================================== -->

            <asp:Panel ID="pnlLessonDetails"
                runat="server"
                Visible="false"
                CssClass="details-panel">

                <div class="card-header">

                    <h3>Lesson Details</h3>

                    <asp:Button ID="btnCloseLessonDetails"
                        runat="server"
                        Text="Close"
                        CssClass="btn btn-secondary btn-small"
                        CausesValidation="false"
                        OnClick="btnAddLesson_Click" />

                </div>

                <h3>
                    <asp:Label ID="lblDetailTitle"
                        runat="server" />
                </h3>

                <div class="details-meta">
                    <asp:Label ID="lblDetailMeta"
                        runat="server" />
                </div>

                <div class="details-description">
                    <asp:Literal ID="litDetailDescription"
                        runat="server" />
                </div>

                <!-- =================================
                     LEARNING MATERIALS
                     ================================= -->

                <div class="details-panel"
                    style="margin-top:24px;">

                    <h3>Learning Materials</h3>

                    <p class="upload-help">
                        Upload multiple PDF, DOCX, or PPTX
                        files for this lesson.
                    </p>


                    <div class="upload-area">

                        <strong>Select files</strong>

                        <asp:FileUpload ID="fuLearningMaterials"
                            runat="server"
                            AllowMultiple="true"
                            accept=".pdf,.docx,.pptx" />

                        <div class="upload-help">
                            Maximum 10 MB per file.
                            You can select multiple files.
                        </div>

                    </div>

                    <asp:Button ID="btnUploadMaterials"
                        runat="server"
                        Text="Upload Materials"
                        CssClass="btn"
                        CausesValidation="false"
                        OnClick="btnUploadMaterials_Click" />

                    <asp:Label ID="lblMaterialMessage"
                        runat="server"
                        CssClass="message" />

               

                    <h3 style="margin-top:25px;">
                        Uploaded Materials
                    </h3>

                    <div class="table-scroll">

                        <asp:GridView ID="gvLessonMaterials"
                            runat="server"
                            AutoGenerateColumns="false"
                            CssClass="data-grid"
                            GridLines="None"
                            EmptyDataText="No materials uploaded yet."
                            OnRowCommand="gvLessonMaterials_RowCommand">

                            <Columns>

                                <asp:BoundField
                                    DataField="FileName"
                                    HeaderText="File Name" />

                                <asp:BoundField
                                    DataField="FileSize"
                                    HeaderText="Size (Bytes)" />

                                <asp:BoundField
                                    DataField="UploadedAt"
                                    HeaderText="Uploaded"
                                    DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />

                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>

                                        <asp:Button
                                            runat="server"
                                            Text="Download"
                                            CssClass="btn btn-small"
                                            CausesValidation="false"
                                            CommandName="DownloadMaterial"
                                            CommandArgument='<%# Eval("MaterialID") %>' />

                                        <asp:Button
                                            runat="server"
                                            Text="Delete"
                                            CssClass="btn btn-danger btn-small"
                                            CausesValidation="false"
                                            CommandName="DeleteMaterial"
                                            CommandArgument='<%# Eval("MaterialID") %>'
                                            OnClientClick="return confirm('Delete this material?');" />

                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>

                        </asp:GridView>

                    </div>

                </div>

            </asp:Panel>

        </asp:Panel>

        <!-- MODULE ASSIGNMENTS: visible after selecting a module -->
        <asp:Panel ID="pnlAssignments" runat="server" Visible="false" CssClass="card">
            <div class="card-header"><div><h2>Module Assignments</h2>
                <p>Create and manage assignments for the selected module.</p></div>
                <asp:Label ID="lblAssignmentModule" runat="server" CssClass="selected-name" />
            </div>
            <div class="assignment-entry">
                <div class="assignment-fields">
                    <div class="field"><label>Assignment Title</label>
                        <asp:TextBox ID="txtAssignmentTitle" runat="server" CssClass="form-control" MaxLength="150" placeholder="Assignment title" />
                    </div>
                    <div class="field"><label>Maximum Score</label>
                        <asp:TextBox ID="txtAssignmentMaxScore" runat="server" CssClass="form-control" TextMode="Number" Text="100" />
                    </div>
                    <div class="field full"><label>Instructions</label>
                        <asp:TextBox ID="txtAssignmentDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Explain what students should submit" />
                    </div>
                    <div class="field"><label>Due Date and Time (server local time)</label>
                        <asp:TextBox ID="txtAssignmentDueDate" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                    </div>
                </div>
                <div class="actions" style="margin-top:16px">
                    <asp:Button ID="btnSaveAssignment" runat="server" Text="Add Assignment" CssClass="btn" CausesValidation="false" OnClick="btnSaveAssignment_Click" />
                    <asp:Button ID="btnCancelAssignment" runat="server" Text="Cancel Edit" CssClass="btn btn-secondary" CausesValidation="false" Visible="false" OnClick="btnCancelAssignment_Click" />
                </div>
            </div>
            <div class="table-scroll assignment-list">
                <asp:GridView ID="gvAssignments" runat="server" AutoGenerateColumns="false" CssClass="data-grid" GridLines="None" EmptyDataText="No assignments for this module yet." OnRowCommand="gvAssignments_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="AssignmentTitle" HeaderText="Assignment" HtmlEncode="true" />
                        <asp:BoundField DataField="DueDate" HeaderText="Deadline" DataFormatString="{0:MMM dd, yyyy hh:mm tt}" HtmlEncode="true" NullDisplayText="No deadline" />
                        <asp:BoundField DataField="MaxScore" HeaderText="Points" DataFormatString="{0:0.##}" />
                        <asp:TemplateField HeaderText="Actions"><ItemTemplate>
                            <asp:Button runat="server" Text="Edit" CssClass="btn btn-secondary btn-small" CausesValidation="false" CommandName="EditAssignment" CommandArgument='<%# Eval("AssignmentID") %>' />
                            <asp:Button runat="server" Text="Submissions" CssClass="btn btn-small" CausesValidation="false" CommandName="ViewSubmissions" CommandArgument='<%# Eval("AssignmentID") %>' />
                            <asp:Button runat="server" Text="Delete" CssClass="btn btn-danger btn-small" CausesValidation="false" CommandName="DeleteAssignment" CommandArgument='<%# Eval("AssignmentID") %>' OnClientClick="return confirm('Delete this assignment? Deletion is blocked if students submitted work.');" />
                        </ItemTemplate></asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <asp:Panel ID="pnlAssignmentSubmissions" runat="server" Visible="false" CssClass="details-panel">
                <div class="card-header"><h3>Student Submissions</h3>
                    <asp:Button ID="btnCloseAssignmentSubmissions" runat="server" Text="Close" CssClass="btn btn-secondary btn-small" CausesValidation="false" OnClick="btnCloseAssignmentSubmissions_Click" />
                </div>
                <asp:Label ID="lblSubmissionAssignment" runat="server" CssClass="selected-name" />
                <div class="table-scroll" style="margin-top:15px">
                    <asp:GridView ID="gvAssignmentSubmissions" runat="server" AutoGenerateColumns="false" CssClass="data-grid" GridLines="None" EmptyDataText="No submissions yet." OnRowCommand="gvAssignmentSubmissions_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="StudentName" HeaderText="Student" HtmlEncode="true" />
                            <asp:BoundField DataField="SubmittedAt" HeaderText="Submitted" DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />
                            <asp:BoundField DataField="Grade" HeaderText="Grade" NullDisplayText="Not graded" />
                            <asp:BoundField DataField="Feedback" HeaderText="Feedback" HtmlEncode="true" NullDisplayText="—" />
                            <asp:TemplateField HeaderText="Actions"><ItemTemplate>
                                <asp:Button runat="server" Text="Download" CssClass="btn btn-small" CausesValidation="false" CommandName="DownloadSubmission" CommandArgument='<%# Eval("SubmissionID") %>' />
                                <asp:Button runat="server" Text="Grade / Feedback" CssClass="btn btn-secondary btn-small" CausesValidation="false" CommandName="GradeSubmission" CommandArgument='<%# Eval("SubmissionID") %>' />
                            </ItemTemplate></asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <asp:Panel ID="pnlGradeSubmission" runat="server" Visible="false" CssClass="details-panel">
                    <h3>Grade submission — <asp:Label ID="lblGradeStudent" runat="server" /></h3>
                    <div class="form-grid">
                        <div class="field"><label>Grade (0–100)</label><asp:TextBox ID="txtSubmissionGrade" runat="server" CssClass="form-control" TextMode="Number" /></div>
                        <div class="field full"><label>Feedback</label><asp:TextBox ID="txtSubmissionFeedback" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" MaxLength="2000" /></div>
                    </div>
                    <div class="actions">
                        <asp:Button ID="btnSaveSubmissionGrade" runat="server" Text="Save Grade" CssClass="btn" CausesValidation="false" OnClick="btnSaveSubmissionGrade_Click" />
                        <asp:Button ID="btnCancelSubmissionGrade" runat="server" Text="Cancel" CssClass="btn btn-secondary" CausesValidation="false" OnClick="btnCancelSubmissionGrade_Click" />
                    </div>
                </asp:Panel>
            </asp:Panel>
        </asp:Panel>

    </div>

    <!-- =====================================
         EXISTING COURSE SEARCH
         ===================================== -->

    <script type="text/javascript">

        function filterInstructorCourses() {

            var input = document.getElementById(
                'instructorCoursesSearch'
            );

            var table = document.getElementById(
                '<%= gvCourses.ClientID %>'
            );

            var empty = document.getElementById(
                'instructorCoursesNoMatch'
            );

            if (!input || !table)
                return;

            var query = input.value.toLowerCase().trim();

            var rows = table.querySelectorAll('tr');

            var visible = 0;

            for (var i = 0; i < rows.length; i++) {

                var cells = rows[i].querySelectorAll('td');

                if (cells.length < 5)
                    continue;

                var id = cells[0].textContent.toLowerCase();

                var title = cells[1].textContent.toLowerCase();

                var description =
                    cells[2].textContent.toLowerCase();

                var show =
                    !query ||
                    id.indexOf(query) !== -1 ||
                    title.indexOf(query) !== -1 ||
                    description.indexOf(query) !== -1;

                rows[i].style.display = show ? '' : 'none';

                if (show)
                    visible++;
            }

            if (empty) {
                empty.style.display =
                    visible === 0 && query
                        ? 'block'
                        : 'none';
            }
        }

    </script>


<script type="text/javascript">
/* Option A tab navigation. This only changes what is displayed in the browser;
   it does not modify server-side visibility, stored procedures, or postback handlers. */
(function () {
    function initCourseTabs() {
        var bar = document.getElementById('instructorCourseTabs');
        var help = document.getElementById('courseTabHelp');
        var workspace = document.getElementById('<%= pnlCourseWorkspace.ClientID %>');
        var course = document.getElementById('<%= hfCourseID.ClientID %>');
        var module = document.getElementById('<%= hfModuleID.ClientID %>');
        var assignments = document.getElementById('<%= pnlAssignments.ClientID %>');
        var modules = document.getElementById('<%= pnlModules.ClientID %>');
        var lessons = document.getElementById('<%= pnlLessons.ClientID %>');
        var submissions = document.getElementById('<%= pnlAssignmentSubmissions.ClientID %>');
        var grade = document.getElementById('<%= pnlGradeSubmission.ClientID %>');
        var details = document.getElementById('<%= pnlLessonDetails.ClientID %>');
        if (!bar || !help || !workspace || !course || !course.value) return;
        bar.style.display = '';
        var key = 'minilms-instructor-tab-' + course.value;
        var buttons = bar.querySelectorAll('[data-course-tab]');
        var tab = 'modules';
        try { tab = sessionStorage.getItem(key) || 'modules'; } catch (ignore) {}
        if (!/^(modules|lessons|assignments|submissions)$/.test(tab)) tab = 'modules';
        // Open the most relevant tab after server actions, if it is available.
        if (grade) tab = 'submissions';
        else if (details) tab = 'lessons';
        else if (submissions && tab === 'submissions') tab = 'submissions';
        function show(tabName) {
            tab = tabName;
            try { sessionStorage.setItem(key, tabName); } catch (ignore) {}
            for (var i=0; i<buttons.length; i++) {
                var active = buttons[i].getAttribute('data-course-tab') === tabName;
                buttons[i].setAttribute('aria-selected', active ? 'true' : 'false');
                buttons[i].tabIndex = active ? 0 : -1;
            }
            if (modules) modules.style.display = tabName === 'modules' ? '' : 'none';
            if (lessons) lessons.style.display = tabName === 'lessons' ? '' : 'none';
            // The submissions panel is nested inside assignments; keep its parent visible.
            if (assignments) assignments.style.display = (tabName === 'assignments' || tabName === 'submissions') ? '' : 'none';
            if (assignments) {
                var entry = assignments.querySelector('.assignment-entry');
                var listing = assignments.querySelector('.assignment-list');
                if (entry) entry.style.display = tabName === 'assignments' ? '' : 'none';
                if (listing) listing.style.display = tabName === 'assignments' ? '' : 'none';
                var heading = assignments.querySelector('.card-header');
                if (heading) heading.style.display = tabName === 'assignments' ? '' : 'none';
            }
            if (submissions) submissions.style.display = tabName === 'submissions' ? '' : 'none';
            var message = '';
            if (tabName !== 'modules' && (!module || !module.value || module.value === '0')) {
                message = '<strong>Select a module first</strong>Open the Modules tab, then click Lessons on a module to choose which module to manage.';
            } else if (tabName === 'submissions' && !submissions) {
                message = '<strong>Select an assignment first</strong>Open Assignments, then click Submissions on the assignment you want to review.';
            } else if (tabName === 'assignments' && !assignments) {
                message = '<strong>Choose a module</strong>Select a module in the Modules tab to see its assignments.';
            } else if (tabName === 'lessons' && !lessons) {
                message = '<strong>Choose a module</strong>Select a module in the Modules tab to manage lessons and materials.';
            }
            help.innerHTML = message;
            help.style.display = message ? 'block' : 'none';
        }
        for (var j=0; j<buttons.length; j++) {
            buttons[j].addEventListener('click', function () { show(this.getAttribute('data-course-tab')); });
        }
        // Remember intended destination before ASP.NET postbacks.
        document.addEventListener('click', function (event) {
            var target = event.target;
            if (!target || !target.closest) return;
            var area = target.closest('#<%= gvModules.ClientID %>, #<%= gvLessons.ClientID %>, #<%= gvAssignments.ClientID %>');
            if (!area) return;
            var value = (target.value || target.textContent || '').trim().toLowerCase();
            var destination = null;
            if (area.id === '<%= gvModules.ClientID %>' && value === 'lessons') destination = 'lessons';
            else if (area.id === '<%= gvLessons.ClientID %>' && value.indexOf('details') !== -1) destination = 'lessons';
            else if (area.id === '<%= gvAssignments.ClientID %>' && value === 'submissions') destination = 'submissions';
            if (destination) try { sessionStorage.setItem(key, destination); } catch (ignore) { }
        }, true);
            show(tab);
        }
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initCourseTabs);
        else initCourseTabs();
    })();
</script>

</asp:Content>
