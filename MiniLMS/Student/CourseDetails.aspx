<%@ Page Title="Course Details"
    Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="CourseDetails.aspx.cs"
    Inherits="MiniLMS.Student.CourseDetails" %>

<asp:Content ID="HeadContent1"
    ContentPlaceHolderID="HeadContent"
    runat="server">

    <style type="text/css">
        .student-course-details {
            width: 100%;
            max-width: none;
            margin: 0;
        }

        .student-back-link {
            display: inline-block;
            margin-bottom: 22px;
            color: #2369b5;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
        }

            .student-back-link:hover {
                color: #102e50;
            }

        .student-course-banner {
            position: relative;
            min-height: 185px;
            background: #123d70;
            color: white;
            border-radius: 14px;
            padding: 32px 35px;
            margin-bottom: 32px;
            display: flex;
            align-items: center;
            overflow: hidden;
        }

        .student-banner-content {
            position: relative;
            width: 100%;
        }

        .student-banner-eyebrow {
            display: block;
            margin-bottom: 13px;
            color: #c6dcf5;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.3px;
            text-transform: uppercase;
        }

        .student-banner-title {
            font-size: 28px;
            font-weight: 700;
            line-height: 1.35;
            margin-bottom: 12px;
        }

        .student-banner-description {
            color: #dbe8f5;
            line-height: 1.7;
            max-width: 780px;
            white-space: pre-line;
        }

        .student-course-meta {
            display: inline-block;
            margin-top: 17px;
            padding: 9px 13px;
            background: #285584;
            border-radius: 8px;
            color: #e4eef9;
            font-size: 12px;
        }

        .student-section-header {
            margin-bottom: 22px;
        }

            .student-section-header h2 {
                font-size: 21px;
                color: #17375e;
                margin: 0 0 7px;
            }

            .student-section-header p {
                font-size: 13px;
                color: #72849a;
                margin: 0;
                line-height: 1.6;
            }

        .student-module {
            background: white;
            border: 1px solid #e1e9f2;
            border-radius: 13px;
            margin-bottom: 15px;
            overflow: hidden;
            box-shadow: 0 3px 13px rgba(23,55,94,.04);
        }

            .student-module:hover {
                border-color: #c4d8ed;
            }

            .student-module[open] {
                border-color: #bdd5ef;
            }

            .student-module summary {
                position: relative;
                display: flex;
                align-items: center;
                gap: 13px;
                padding: 20px 55px 20px 22px;
                font-size: 15px;
                font-weight: 700;
                color: #17375e;
                cursor: pointer;
                list-style-type: none;
            }

                .student-module summary:hover {
                    background: #f7faff;
                }

        .student-module-icon {
            display: grid;
            place-items: center;
            flex-shrink: 0;
            width: 36px;
            height: 36px;
            background: #eaf2fc;
            border-radius: 9px;
            color: #2369b5;
            font-size: 17px;
        }

        .student-module summary:after {
            content: "+";
            position: absolute;
            right: 22px;
            top: 20px;
            font-size: 23px;
            color: #2369b5;
            font-weight: 400;
        }

        .student-module[open] summary:after {
            content: "-";
        }

        .student-lesson-list {
            padding: 20px 22px 24px;
            border-top: 1px solid #e1e9f2;
            background: #fbfcfe;
        }

        .student-lesson-item {
            background: white;
            border: 1px solid #e2eaf4;
            border-radius: 12px;
            margin-bottom: 16px;
            overflow: hidden;
        }

            .student-lesson-item:last-child {
                margin-bottom: 0;
            }

        .student-lesson-header {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 19px 21px;
            border-bottom: 1px solid #edf1f7;
        }

        .student-lesson-icon {
            display: grid;
            place-items: center;
            flex-shrink: 0;
            width: 39px;
            height: 39px;
            background: #eaf2fc;
            color: #2369b5;
            border-radius: 10px;
            font-size: 18px;
        }

        .student-lesson-caption {
            font-size: 10px;
            font-weight: 700;
            color: #7c8da2;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .student-lesson-title {
            font-size: 15px;
            font-weight: 700;
            color: #17375e;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .student-lesson-body {
            padding: 22px;
        }

        .student-lesson-heading {
            display: flex;
            align-items: center;
            gap: 9px;
            font-size: 13px;
            font-weight: 700;
            color: #17375e;
            margin-bottom: 13px;
        }

        .student-heading-accent {
            display: block;
            width: 4px;
            height: 17px;
            background: #2369b5;
            border-radius: 5px;
        }

        .student-lesson-description {
            color: #526780;
            font-size: 13px;
            line-height: 1.9;
            white-space: pre-line;
            overflow-wrap: anywhere;
        }

        .student-lesson-divider {
            height: 1px;
            background: #e8eef5;
            margin: 22px 0;
        }

        .student-lesson-materials {
            background: #f7faff;
            border: 1px solid #e4ecf6;
            border-radius: 10px;
            padding: 16px;
        }

        .student-materials-heading {
            font-size: 13px;
            font-weight: 700;
            color: #17375e;
            margin-bottom: 5px;
        }

        .student-materials-description {
            font-size: 12px;
            color: #7a8ba0;
            margin-bottom: 15px;
            line-height: 1.6;
        }

        .student-material-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 12px 14px;
            background: white;
            border: 1px solid #e6edf6;
            border-radius: 9px;
            margin-bottom: 9px;
        }

            .student-material-row:last-child {
                margin-bottom: 0;
            }

        .student-material-file {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
        }

        .student-pdf-icon {
            display: grid;
            place-items: center;
            flex-shrink: 0;
            width: 35px;
            height: 39px;
            border-radius: 8px;
            background: #fff0f0;
            color: #c34b4b;
            font-size: 10px;
            font-weight: 800;
        }

        .student-material-name {
            font-size: 12px;
            font-weight: 700;
            color: #183451;
            overflow-wrap: anywhere;
        }

        .student-material-type {
            margin-top: 4px;
            font-size: 11px;
            color: #72849a;
        }

        .student-download-pdf {
            display: inline-block;
            flex-shrink: 0;
            padding: 8px 12px;
            border-radius: 7px;
            background: #2369b5;
            color: white;
            font-size: 11px;
            font-weight: 700;
            text-decoration: none;
            white-space: nowrap;
        }

            .student-download-pdf:hover {
                background: #174b7e;
                color: white;
            }

        .student-empty-text {
            display: block;
            font-size: 12px;
            color: #72849a;
            padding: 9px 0;
        }

        .student-empty-modules {
            background: white;
            border: 1px dashed #c9d8e8;
            border-radius: 13px;
            padding: 40px 20px;
            text-align: center;
            color: #72849a;
        }

            .student-empty-modules h3 {
                color: #183451;
            }

        .student-details-message {
            display: block;
            margin-top: 20px;
            padding: 12px 15px;
            background: #eaf3fd;
            border-left: 4px solid #3678b5;
            border-radius: 7px;
        }

        @media screen and (max-width: 768px) {
            .student-course-banner {
                min-height: 170px;
                padding: 25px 22px;
            }

            .student-lesson-list {
                padding: 13px;
            }
        }

        @media screen and (max-width: 560px) {
            .student-banner-title {
                font-size: 24px;
            }

            .student-lesson-header {
                padding: 15px;
            }

            .student-lesson-body {
                padding: 15px;
            }

            .student-lesson-materials {
                padding: 12px;
            }

            .student-material-row {
                gap: 10px;
                flex-wrap: wrap;
            }

            .student-download-pdf {
                margin-left: auto;
            }

            .student-module summary {
                padding: 16px 48px 16px 14px;
            }
        }

        /* Option E: course directory table (no CourseID in URL) */
        .student-directory-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            margin-bottom: 23px;
            flex-wrap: wrap
        }

        .student-directory-eyebrow {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            color: #7c8da2
        }

        .student-directory-header h1 {
            font-size: 27px;
            color: #17375e;
            margin: 7px 0
        }

        .student-directory-header p {
            font-size: 13px;
            color: #72849a;
            margin: 0;
            line-height: 1.7
        }

        .student-directory-tag {
            border: 1px solid #e1e9f2;
            background: white;
            padding: 9px 13px;
            border-radius: 8px;
            font-size: 12px;
            color: #526b85
        }

        .student-directory-panel {
            background: white;
            border: 1px solid #e1e9f2;
            border-radius: 13px;
            overflow: hidden
        }

        .student-directory-toolbar {
            padding: 20px 22px;
            border-bottom: 1px solid #e1e9f2;
            display: flex;
            justify-content: space-between;
            gap: 14px;
            align-items: center;
            flex-wrap: wrap
        }

            .student-directory-toolbar h2 {
                font-size: 17px;
                color: #17375e;
                margin: 0
            }

        .student-course-search {
            border: 1px solid #d9e4f0;
            border-radius: 8px;
            padding: 10px 12px;
            font: inherit;
            min-width: 240px;
            max-width: 100%;
            outline-offset: 2px
        }

        .student-directory-scroll {
            overflow-x: auto
        }

        .student-directory-table {
            border-collapse: collapse;
            width: 100%;
            min-width: 660px;
            text-align: left
        }

            .student-directory-table th {
                font-size: 11px;
                letter-spacing: .5px;
                text-transform: uppercase;
                color: #7d8da1;
                background: #f8fafc;
                padding: 15px 20px;
                border-bottom: 1px solid #e8eef5
            }

            .student-directory-table td {
                font-size: 13px;
                color: #465d76;
                padding: 17px 20px;
                border-bottom: 1px solid #edf1f6;
                vertical-align: middle
            }

            .student-directory-table tbody tr:last-child td {
                border-bottom: 0
            }

            .student-directory-table tbody tr:hover {
                background: #fafcff
            }

        .student-directory-title {
            font-weight: 700;
            color: #17375e
        }

        .student-directory-status {
            display: inline-block;
            border-radius: 7px;
            background: #eef7f0;
            color: #28784c;
            padding: 6px 9px;
            font-size: 11px;
            font-weight: 700
        }

        .student-directory-action {
            display: inline-block;
            border: 1px solid #c9dcef;
            border-radius: 7px;
            padding: 8px 12px;
            color: #2369b5;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap
        }

            .student-directory-action:hover {
                background: #edf5fe
            }

        .student-directory-empty {
            padding: 38px 20px;
            text-align: center;
            color: #72849a;
            font-size: 13px
        }

        @media(max-width:560px) {
            .student-directory-toolbar {
                align-items: stretch
            }

            .student-course-search {
                width: 100%;
                min-width: 0
            }
        }

        .student-assignment-section {
            margin-top: 22px;
            padding: 18px;
            border: 1px solid #dce8f5;
            background: #f6faff;
            border-radius: 12px
        }

        .student-assignment-card {
            padding: 17px;
            background: #fff;
            border: 1px solid #e0e9f4;
            border-radius: 10px;
            margin: 12px 0
        }

        .student-assignment-title {
            font-weight: 700;
            color: #17375e;
            font-size: 15px
        }

        .student-assignment-desc {
            white-space: pre-wrap;
            color: #526780;
            font-size: 13px;
            margin: 10px 0
        }

        .student-assignment-meta {
            font-size: 12px;
            color: #60758b;
            margin: 9px 0
        }

        .student-assignment-upload {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
            margin-top: 12px
        }

            .student-assignment-upload input[type=file] {
                max-width: 100%;
                font-size: 12px
            }

            .student-assignment-upload .submit-btn {
                background: #2369b5;
                color: #fff;
                border: 0;
                border-radius: 7px;
                padding: 9px 14px;
                font-weight: 700;
                cursor: pointer
            }

                .student-assignment-upload .submit-btn:disabled {
                    background: #b0bdcc;
                    cursor: not-allowed
                }

        .student-assignment-note {
            font-size: 12px;
            color: #6d7e91;
            margin-top: 9px
        }

        .student-grade-panel {
            margin: 13px 0;
            padding: 15px 17px;
            background: #edf7ff;
            border: 1px solid #cbdff2;
            border-radius: 10px
        }

        .student-grade-heading {
            font-weight: 700;
            font-size: 13px;
            color: #17375e;
            margin-bottom: 7px
        }

        .student-grade-score {
            font-weight: 750;
            color: #175d99;
            font-size: 19px
        }

        .student-grade-feedback {
            margin-top: 10px;
            font-size: 13px;
            color: #435b74;
            white-space: pre-wrap;
            overflow-wrap: anywhere
        }

        .student-grade-status {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            background: #e7f1fc;
            color: #2369b5;
            font-size: 12px;
            font-weight: 700
        }

            .student-grade-status.graded {
                background: #e7f6ed;
                color: #237449
            }

            .student-grade-status.late {
                background: #fff2e5;
                color: #985a1a
            }

        /* Option C: module-centered learning workspace (UI only). */
        .student-learning-eyebrow {
            display: block;
            color: #3174b5;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1.3px;
            margin-bottom: 8px
        }

        .student-module-workspace {
            border: 1px solid #d7e4f2;
            border-radius: 16px;
            box-shadow: 0 5px 18px rgba(22,58,98,.05);
            margin-bottom: 18px
        }

            .student-module-workspace[open] {
                border-color: #8eb7e2;
                box-shadow: 0 9px 24px rgba(22,58,98,.09)
            }

            .student-module-workspace > summary {
                background: #fff;
                padding: 21px 58px 21px 22px;
                min-height: 80px
            }

            .student-module-workspace[open] > summary {
                background: #f1f7ff;
                border-bottom: 1px solid #d7e5f4
            }

        .student-module-name {
            display: flex;
            flex-direction: column;
            gap: 6px;
            min-width: 0;
            flex: 1
        }

            .student-module-name small {
                font-size: 10px;
                color: #6c88a6;
                letter-spacing: 1.2px;
                font-weight: 800
            }

            .student-module-name > span {
                overflow-wrap: anywhere
            }

        .student-module-action {
            font-size: 11px;
            font-weight: 700;
            color: #3276b9;
            background: #eaf3fe;
            padding: 7px 11px;
            border-radius: 20px;
            white-space: nowrap
        }

        .student-module-workspace[open] .student-module-action {
            background: #dbeafb
        }

        .student-module-workspace .student-lesson-list {
            background: #f9fbff;
            padding: 23px
        }

        .student-module-content-heading {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 3px 0 17px;
            color: #17375e
        }

            .student-module-content-heading strong {
                display: block;
                font-size: 15px
            }

            .student-module-content-heading p {
                font-size: 12px;
                color: #75869b;
                margin: 5px 0 0;
                line-height: 1.5
            }

        .student-content-symbol {
            flex-shrink: 0;
            width: 37px;
            height: 37px;
            display: grid;
            place-items: center;
            background: #e5f0fc;
            color: #2166aa;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 800
        }

        .student-module-workspace .student-lesson-item {
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(23,55,94,.03)
        }

        .student-module-workspace .student-assignment-section {
            margin-top: 25px;
            background: transparent;
            padding: 22px 0 0;
            border: 0;
            border-top: 1px solid #dce7f3;
            border-radius: 0
        }

        .student-assignment-card {
            padding: 21px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(23,55,94,.04)
        }

        .student-assignment-title {
            font-size: 16px
        }

        .student-assignment-meta {
            display: inline-block;
            background: #f2f7fd;
            border: 1px solid #e3edf7;
            border-radius: 7px;
            padding: 8px 10px;
            line-height: 1.6
        }

        .student-assignment-card .student-grade-status {
            display: table;
            margin: 12px 0
        }

        .student-submission-heading {
            font-size: 11px;
            letter-spacing: 1px;
            color: #6b829b;
            font-weight: 800;
            margin-top: 18px
        }

        .student-assignment-upload {
            background: #f8fbff;
            border: 1px dashed #c8dbed;
            padding: 13px;
            border-radius: 9px
        }

            .student-assignment-upload .submit-btn:hover:enabled {
                background: #174b7e
            }

        .student-grade-panel {
            border-left: 4px solid #2c76b8
        }

        @media(max-width:600px) {
            .student-module-workspace > summary {
                padding: 17px 43px 17px 13px
            }

            .student-module-action {
                display: none
            }

            .student-module-workspace .student-lesson-list {
                padding: 13px
            }

            .student-module-content-heading strong {
                font-size: 13px
            }

            .student-assignment-card {
                padding: 14px
            }
        }

        /* Full-width course workspace redesign. Existing Web Forms controls are preserved. */
        .student-course-details {
            width: 100%;
            max-width: none;
            margin: 0;
            color: #193753;
        }

        .lms-course-switcher {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 16px
        }

        .lms-all-courses {
            font-size: 13px;
            color: #2369b5;
            font-weight: 700;
            text-decoration: none
        }

        .lms-course-switcher-label {
            font-size: 10px;
            letter-spacing: 1px;
            color: #8798ac;
            font-weight: 800;
            margin-left: auto
        }

        .lms-current-course {
            font-size: 12px;
            font-weight: 700;
            color: #1a406b
        }

        .student-back-link {
            display: none
        }

        .student-course-banner {
            border-radius: 14px;
            min-height: 166px;
            margin-bottom: 16px;
            padding: 28px 34px;
            background: linear-gradient(110deg,#102f56 0%,#174f85 65%,#0b2d52 100%)
        }

        .student-banner-title {
            font-size: 30px
        }

        .student-course-meta {
            background: rgba(255,255,255,.13)
        }

        .student-section-header {
            margin: 18px 0
        }

            .student-section-header h2 {
                font-size: 19px
            }

        .lms-workspace {
            display: grid;
            grid-template-columns: minmax(265px, .85fr) minmax(0,1.7fr);
            gap: 18px;
            align-items: start
        }

        .lms-navigation, .lms-reading-pane {
            background: white;
            border: 1px solid #dfe8f3;
            border-radius: 13px;
            min-width: 0;
            box-shadow: 0 4px 18px rgba(23,55,94,.035)
        }

        .lms-navigation {
            padding: 16px;
            max-height: calc(100vh - 130px);
            overflow-y: auto;
            position: sticky;
            top: 18px
        }

        .lms-navigation-title {
            font-size: 17px;
            font-weight: 800;
            color: #15375e;
            margin: 0 0 14px
        }

        .lms-module-heading {
            width: 100%;
            border: 0;
            border-radius: 8px;
            background: #edf4fc;
            padding: 12px 11px;
            text-align: left;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 8px;
            color: #15375e;
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
            margin: 10px 0 4px
        }

            .lms-module-heading span:first-child {
                overflow-wrap: anywhere
            }

            .lms-module-heading .lms-arrow {
                font-size: 15px;
                color: #3d6e9c
            }

        .lms-module-children {
            padding: 2px 0 5px 8px
        }

            .lms-module-children[hidden] {
                display: none
            }

        .lms-nav-item {
            display: flex;
            width: 100%;
            align-items: flex-start;
            gap: 10px;
            border: 0;
            background: transparent;
            border-radius: 8px;
            padding: 10px 11px;
            text-align: left;
            font: 600 12px Segoe UI,Arial,sans-serif;
            color: #425d7c;
            cursor: pointer;
            line-height: 1.5;
            overflow-wrap: anywhere
        }

            .lms-nav-item:hover {
                background: #f1f6fc
            }

            .lms-nav-item.active {
                background: #e3f0ff;
                color: #1263b5
            }

        .lms-nav-symbol {
            font-size: 15px;
            color: #2b76be;
            flex-shrink: 0
        }

        .lms-reading-pane {
            padding: 24px;
            min-height: 430px
        }

        .lms-selected-content > .student-lesson-item, .lms-selected-content > .student-assignment-card {
            margin: 0;
            border: 0;
            box-shadow: none;
            padding: 0
        }

        .lms-selected-content .student-lesson-header {
            padding: 0 0 20px
        }

        .lms-selected-content .student-lesson-body {
            padding: 20px 0 0
        }

        .lms-selected-content .student-assignment-card {
            padding: 0
        }

        .lms-selected-content .student-assignment-title {
            font-size: 25px;
            line-height: 1.3;
            margin-bottom: 14px
        }

        .lms-selected-content .student-assignment-desc {
            font-size: 14px;
            line-height: 1.8;
            margin: 22px 0
        }

        .lms-selected-content .student-assignment-meta {
            display: block;
            margin: 15px 0
        }

        .lms-selected-content .student-assignment-upload {
            display: flex;
            flex-direction: column;
            align-items: stretch;
            gap: 12px;
            padding: 20px;
            border: 1px dashed #a9c9eb;
            border-radius: 10px;
            background: #f8fbff
        }

            .lms-selected-content .student-assignment-upload input[type=file] {
                width: 100%;
                max-width: 100%
            }

            .lms-selected-content .student-assignment-upload .submit-btn {
                width: 100%;
                padding: 13px
            }

        .lms-empty-selection {
            padding: 60px 15px;
            text-align: center;
            color: #71869e;
            font-size: 13px
        }

        .lms-original-modules {
            display: none !important
        }

        .student-directory-panel {
            border: 0;
            background: transparent;
            overflow: visible
        }

        .student-directory-toolbar {
            background: white;
            border: 1px solid #e1e9f2;
            border-radius: 12px;
            margin-bottom: 14px
        }

        .lms-course-cards, .lms-course-cards tbody {
            display: block;
            min-width: 0;
            width: 100%
        }

            .lms-course-cards thead {
                display: none
            }

            .lms-course-cards tbody {
                display: grid;
                grid-template-columns: repeat(auto-fit,minmax(290px,1fr));
                gap: 14px
            }

                .lms-course-cards tbody tr {
                    display: flex;
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 9px;
                    padding: 20px;
                    background: white;
                    border: 1px solid #e1e9f2;
                    border-radius: 12px;
                    min-width: 0
                }

            .lms-course-cards td {
                display: block;
                border: 0;
                padding: 0;
                max-width: 100%;
                overflow-wrap: anywhere
            }

                .lms-course-cards td:nth-child(1) {
                    font-size: 11px;
                    color: #8091a4
                }

                .lms-course-cards td:nth-child(2) {
                    font-size: 16px
                }

                .lms-course-cards td:nth-child(5) {
                    margin-top: auto;
                    padding-top: 10px
                }

        @media(max-width:950px) {
            .lms-workspace {
                grid-template-columns: 1fr
            }

            .lms-navigation {
                position: static;
                max-height: none
            }

            .lms-reading-pane {
                min-height: 300px
            }
        }

        @media(max-width:600px) {
            .student-course-banner {
                padding: 24px 20px
            }

            .lms-reading-pane {
                padding: 16px
            }

            .lms-course-switcher-label, .lms-current-course {
                display: none
            }
        }
    </style>

    <script runat="server">
        protected string GetLessonDescription(object dataItem)
        {
            System.Data.DataRowView row =
                dataItem as System.Data.DataRowView;

            if (row == null ||
                !row.Row.Table.Columns.Contains("LessonDescription"))
            {
                return "No lesson description available yet.";
            }

            object value = row["LessonDescription"];

            if (value == null ||
                value == System.DBNull.Value ||
                string.IsNullOrWhiteSpace(Convert.ToString(value)))
            {
                return "No lesson description available yet.";
            }

            return Server.HtmlEncode(Convert.ToString(value));
        }
    </script>

</asp:Content>

<asp:Content ID="MainContent1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="student-course-details">

        <asp:Panel ID="pnlCourseDetailsView" runat="server" Visible="false">
            <div class="lms-course-switcher">
                <a class="lms-all-courses" href='<%= ResolveUrl("~/Student/CourseDetails.aspx") %>'>&#8592; All My Courses</a>
                <span class="lms-course-switcher-label">CURRENT COURSE</span>
                <span class="lms-current-course">
                    <asp:Label ID="lblSidebarCourseTitle" runat="server" Visible="false" />Course Workspace</span>
            </div>
            <a class="student-back-link"
                href='<%= ResolveUrl("~/Student/CourseDetails.aspx") %>'>&#8592; Back to My Courses
        </a>

            <asp:Panel ID="pnlCourse"
                runat="server"
                Visible="false">

                <!-- COURSE BANNER -->
                <div class="student-course-banner">
                    <div class="student-banner-content">

                        <span class="student-banner-eyebrow">Course Overview
                    </span>

                        <div class="student-banner-title">
                            <asp:Label ID="lblCourseTitle"
                                runat="server" />
                        </div>

                        <div class="student-banner-description">
                            <asp:Label ID="lblCourseDescription"
                                runat="server" />
                        </div>

                        <div class="student-course-meta">
                            Instructor:
                       
                            <asp:Label ID="lblInstructor"
                                runat="server" />
                        </div>

                    </div>
                </div>

                <!-- MODULES AND LESSONS -->
                <div class="student-section-header">
                    <span class="student-learning-eyebrow">YOUR COURSE CONTENT</span>
                    <h2>Learn by Module</h2>
                    <p>Open a module to find its lessons, downloadable PDFs, assignments, submission status, and instructor feedback—all in one place.</p>
                </div>

                <div class="lms-workspace">
                    <aside class="lms-navigation" aria-label="Course module navigation">
                        <div class="lms-navigation-title">Course Content</div>
                        <div id="lmsModuleNavigation" class="lms-navigation-items"></div>
                    </aside>
                    <section class="lms-reading-pane" aria-label="Selected lesson or assignment">
                        <div id="lmsSelectedContent" class="lms-selected-content">
                            <div class="lms-empty-selection">Select a lesson or assignment from the course content panel.</div>
                        </div>
                    </section>
                </div>
                <div id="lmsOriginalModules" class="lms-original-modules">
                    <asp:Repeater ID="rptModules"
                        runat="server"
                        OnItemDataBound="rptModules_ItemDataBound">

                        <ItemTemplate>

                            <details class="student-module student-module-workspace" data-module-id='<%# Eval("ModuleID") %>'>

                                <summary>
                                    <span class="student-module-icon"
                                        aria-hidden="true">&#9636;
                            </span>

                                    <span class="student-module-name">
                                        <small>LEARNING MODULE</small>
                                        <span><%#: Eval("ModuleTitle") %></span>
                                    </span>
                                    <span class="student-module-action">View content</span>
                                </summary>

                                <div class="student-lesson-list">
                                    <div class="student-module-content-heading">
                                        <span class="student-content-symbol">01</span>
                                        <div><strong>Lessons &amp; Reading Materials</strong><p>Read the lesson and download its resources.</p>
                                        </div>
                                    </div>

                                    <asp:Repeater ID="rptLessons"
                                        runat="server"
                                        OnItemDataBound="rptLessons_ItemDataBound">

                                        <ItemTemplate>

                                            <article class="student-lesson-item" data-lesson-id='<%# Eval("LessonID") %>'>

                                                <div class="student-lesson-header">

                                                    <div class="student-lesson-icon"
                                                        aria-hidden="true">
                                                        &#9636;
                                           
                                                    </div>

                                                    <div>
                                                        <div class="student-lesson-caption">
                                                            Course Lesson
                                               
                                                        </div>

                                                        <div class="student-lesson-title">
                                                            <%#: Eval("LessonTitle") %>
                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="student-lesson-body">

                                                    <section>

                                                        <div class="student-lesson-heading">
                                                            <span class="student-heading-accent"></span>
                                                            About this Lesson
                                               
                                                        </div>

                                                        <div class="student-lesson-description">
                                                            <%# GetLessonDescription(Container.DataItem) %>
                                                        </div>

                                                    </section>

                                                    <div class="student-lesson-divider"></div>

                                                    <section class="student-lesson-materials">

                                                        <div class="student-materials-heading">
                                                            Reading Materials
                                               
                                                        </div>

                                                        <div class="student-materials-description">
                                                            Download the attached PDF files
                                                    to read or review this lesson.
                                               
                                                        </div>

                                                        <asp:Repeater ID="rptMaterials"
                                                            runat="server">

                                                            <ItemTemplate>

                                                                <div class="student-material-row">

                                                                    <div class="student-material-file">

                                                                        <div class="student-pdf-icon">
                                                                            PDF
                                                               
                                                                        </div>

                                                                        <div>

                                                                            <div class="student-material-name">
                                                                                <%#: Eval("FileName") %>
                                                                            </div>

                                                                            <div class="student-material-type">
                                                                                PDF Document
                                                                   
                                                                            </div>

                                                                        </div>

                                                                    </div>

                                                                    <asp:HyperLink
                                                                        runat="server"
                                                                        CssClass="student-download-pdf"
                                                                        Text="&#8595; Download"
                                                                        ToolTip="Download PDF reading material"
                                                                        NavigateUrl='<%# ResolveUrl("~/Student/DownloadMaterial.aspx?MaterialID=" + Eval("MaterialID")) %>' />

                                                                </div>

                                                            </ItemTemplate>

                                                        </asp:Repeater>

                                                        <asp:Label ID="lblNoMaterials"
                                                            runat="server"
                                                            Visible="false"
                                                            CssClass="student-empty-text"
                                                            Text="No reading materials uploaded yet." />

                                                    </section>

                                                </div>

                                            </article>

                                        </ItemTemplate>

                                    </asp:Repeater>

                                    <asp:Label ID="lblNoLessons"
                                        runat="server"
                                        Visible="false"
                                        CssClass="student-empty-text"
                                        Text="No lessons available yet." />


                                    <!-- PHASE 3: ASSIGNMENTS FOR THIS MODULE -->
                                    <section class="student-assignment-section">
                                        <div class="student-module-content-heading">
                                            <span class="student-content-symbol">02</span>
                                            <div><strong>Assignments &amp; Grades</strong><p>Submit your work, check grading status, and read instructor feedback.</p>
                                            </div>
                                        </div>
                                        <asp:Repeater ID="rptAssignments" runat="server" OnItemDataBound="rptAssignments_ItemDataBound">
                                            <ItemTemplate>
                                                <div class="student-assignment-card" data-assignment-id='<%# Eval("AssignmentID") %>'>
                                                    <div class="student-assignment-title"><%#: Eval("AssignmentTitle") %></div>
                                                    <div class="student-assignment-desc"><%#: Eval("AssignmentDescription") %></div>
                                                    <div class="student-assignment-meta">
                                                        Due: <%#: Eval("DueDate", "{0:MMM dd, yyyy hh:mm tt}") %>
                                                &nbsp; | &nbsp; Max score: <%#: Eval("MaxScore", "{0:0.##}") %>
                                                    </div>
                                                    <asp:Label ID="lblSubmissionStatus" runat="server" CssClass="student-grade-status" />
                                                    <asp:Panel ID="pnlGradeDetails" runat="server" Visible="false" CssClass="student-grade-panel">
                                                        <div class="student-grade-heading">Instructor Evaluation</div>
                                                        <asp:Label ID="lblGradeScore" runat="server" CssClass="student-grade-score" />
                                                        <div class="student-grade-feedback">
                                                            <strong>Instructor feedback</strong>
                                                            <asp:Label ID="lblGradeFeedback" runat="server" />
                                                        </div>
                                                    </asp:Panel>
                                                    <div class="student-submission-heading">YOUR SUBMISSION</div>
                                                    <div class="student-assignment-upload">
                                                        <asp:FileUpload ID="fuAssignment" runat="server" accept=".pdf,.docx,.zip" />
                                                        <asp:Button ID="btnSubmitAssignment" runat="server" Text="Submit File" CssClass="submit-btn"
                                                            CausesValidation="false" CommandArgument='<%# Eval("AssignmentID") %>' OnClick="btnSubmitAssignment_Click" />
                                                    </div>
                                                    <div class="student-assignment-note">PDF, DOCX or ZIP · Maximum 10 MB.</div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                        <asp:Label ID="lblNoAssignments" runat="server" Visible="false" CssClass="student-empty-text" Text="No assignments for this module yet." />
                                    </section>
                                </div>

                            </details>

                        </ItemTemplate>

                    </asp:Repeater>
                </div>

                <script type="text/javascript">
                    (function () {
                        var modules = document.querySelectorAll('.student-module-workspace[data-module-id]');
                        if (!modules.length) return;
                        var key = 'MiniLMS_student_open_modules_' + (new URLSearchParams(window.location.search).get('CourseID') || 'course');
                        var saved = [];
                        try { saved = JSON.parse(sessionStorage.getItem(key) || '[]'); } catch (ignore) { saved = []; }
                        Array.prototype.forEach.call(modules, function (module) {
                            var id = module.getAttribute('data-module-id');
                            if (saved.indexOf(id) >= 0) module.open = true;
                            module.addEventListener('toggle', function () {
                                var open = Array.prototype.filter.call(modules, function (item) { return item.open; })
                                    .map(function (item) { return item.getAttribute('data-module-id'); });
                                try { sessionStorage.setItem(key, JSON.stringify(open)); } catch (ignore) { }
                            });
                        });
                    }());
        </script>
                <asp:Panel ID="pnlNoModules"
                    runat="server"
                    Visible="false"
                    CssClass="student-empty-modules">

                    <h3>No Modules Yet</h3>

                    <p>
                        This course has no available modules.
               
                    </p>

                </asp:Panel>

            </asp:Panel>

        </asp:Panel>


        <!-- COURSE DIRECTORY: shown when no CourseID is supplied -->
        <asp:Panel ID="pnlCourseDirectory" runat="server" Visible="false">
            <header class="student-directory-header">
                <div>
                    <span class="student-directory-eyebrow">Student Workspace</span>
                    <h1>My Courses</h1>
                    <p>All published courses assigned to you by your administrator.</p>
                </div>
                <span class="student-directory-tag">Assigned Courses</span>
            </header>
            <section class="student-directory-panel">
                <div class="student-directory-toolbar">
                    <h2>Course List</h2>
                    <input type="search" id="studentCourseSearch" class="student-course-search"
                        placeholder="Search courses or instructors..." aria-label="Search assigned courses" />
                </div>
                <div class="student-directory-scroll">
                    <table class="student-directory-table lms-course-cards" id="studentCoursesTable">
                        <thead>
                            <tr>
                                <th>Course ID</th>
                                <th>Course Title</th>
                                <th>Instructor</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptAssignedCourses" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>#<%#: Eval("CourseID") %></td>
                                        <td><span class="student-directory-title"><%#: Eval("CourseTitle") %></span></td>
                                        <td><%#: Eval("InstructorName") %></td>
                                        <td><span class="student-directory-status">Published</span></td>
                                        <td><a class="student-directory-action" href='<%# ResolveUrl("~/Student/CourseDetails.aspx?CourseID=" + Eval("CourseID")) %>'>View Course &#8594;</a></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
                <asp:Panel ID="pnlNoAssignedCourses" runat="server" Visible="false" CssClass="student-directory-empty">
                    No published courses have been assigned to you yet.
               
                </asp:Panel>
                <p id="studentSearchEmpty" class="student-directory-empty" style="display: none">No courses match your search.</p>
            </section>
            <script type="text/javascript">
                (function () {
                    var input = document.getElementById('studentCourseSearch');
                    var table = document.getElementById('studentCoursesTable');
                    var empty = document.getElementById('studentSearchEmpty');
                    if (!input || !table) return;
                    input.addEventListener('input', function () {
                        var term = input.value.toLocaleLowerCase().trim();
                        var rows = table.querySelectorAll('tbody tr');
                        var shown = 0;
                        Array.prototype.forEach.call(rows, function (row) {
                            var matches = row.textContent.toLocaleLowerCase().indexOf(term) !== -1;
                            row.style.display = matches ? '' : 'none';
                            if (matches) shown++;
                        });
                        if (empty) empty.style.display = rows.length && !shown ? 'block' : 'none';
                    });
                }());
            </script>
        </asp:Panel>

        <asp:Label ID="lblMessage"
            runat="server"
            CssClass="student-details-message"
            Visible="false" />

    </div>


    <script type="text/javascript">
        // Client-side workspace: reorganize already rendered content without changing ASP.NET IDs or events.
        (function () {
            var source = document.getElementById('lmsOriginalModules');
            var navigation = document.getElementById('lmsModuleNavigation');
            var reading = document.getElementById('lmsSelectedContent');
            if (!source || !navigation || !reading) return;
            var modules = source.querySelectorAll('.student-module-workspace');
            var entries = [];
            var courseKey = new URLSearchParams(window.location.search).get('CourseID') || 'course';
            var storageKey = 'MiniLMS_workspace_selected_' + courseKey;
            var selectedKey = '';
            try { selectedKey = sessionStorage.getItem(storageKey) || ''; } catch (e) { }
            var activeButton = null;
            var currentNode = null;
            var currentHome = null;
            function show(entry, button) {
                if (currentNode && currentHome) currentHome.appendChild(currentNode);
                reading.innerHTML = '';
                currentNode = entry.node;
                currentHome = entry.home;
                reading.appendChild(entry.node);
                if (activeButton) activeButton.classList.remove('active');
                activeButton = button;
                button.classList.add('active');
                try { sessionStorage.setItem(storageKey, entry.key); } catch (e) { }
            }
            Array.prototype.forEach.call(modules, function (module, mi) {
                var moduleId = module.getAttribute('data-module-id') || String(mi);
                var title = module.querySelector('.student-module-name > span');
                var heading = document.createElement('button');
                heading.type = 'button';
                heading.className = 'lms-module-heading';
                var headingName = document.createElement('span');
                headingName.textContent = 'Module ' + (mi + 1) + ': ' + (title ? title.textContent.trim() : 'Course Content');
                var arrow = document.createElement('span');
                arrow.className = 'lms-arrow';
                arrow.textContent = '⌄';
                heading.appendChild(headingName);
                heading.appendChild(arrow);
                var children = document.createElement('div');
                children.className = 'lms-module-children';
                heading.addEventListener('click', function () { children.hidden = !children.hidden; arrow.textContent = children.hidden ? '›' : '⌄'; });
                navigation.appendChild(heading);
                navigation.appendChild(children);
                function addItems(selector, kind, labelSelector, symbol) {
                    Array.prototype.forEach.call(module.querySelectorAll(selector), function (node, index) {
                        var key = kind + '-' + moduleId + '-' + (node.getAttribute('data-' + kind + '-id') || index);
                        var label = node.querySelector(labelSelector);
                        var button = document.createElement('button');
                        button.type = 'button';
                        button.className = 'lms-nav-item';
                        var mark = document.createElement('span');
                        mark.className = 'lms-nav-symbol';
                        mark.textContent = symbol;
                        var name = document.createElement('span');
                        name.textContent = (kind === 'lesson' ? 'Lesson ' : 'Assignment ') + (index + 1) + ': ' + (label ? label.textContent.trim() : 'Untitled');
                        button.appendChild(mark);
                        button.appendChild(name);
                        children.appendChild(button);
                        var entry = { key: key, node: node, home: node.parentNode, button: button, children: children };
                        entries.push(entry);
                        button.addEventListener('click', function () { show(entry, button); });
                    });
                }
                addItems('.student-lesson-item', 'lesson', '.student-lesson-title', '▹');
                addItems('.student-assignment-card', 'assignment', '.student-assignment-title', '▤');
            });
            var first = entries.filter(function (x) { return x.key === selectedKey; })[0] || entries[0];
            if (first) { first.children.hidden = false; show(first, first.button); }
            else { reading.innerHTML = '<div class="lms-empty-selection">No lessons or assignments are available yet.</div>'; }
        }());
    </script>
</asp:Content>
