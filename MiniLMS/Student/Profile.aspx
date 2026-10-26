<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="MiniLMS.Student.Profile" %>

<asp:Content ID="ProfileHead" ContentPlaceHolderID="HeadContent" runat="server">
<style type="text/css">
.student-profile-page{max-width:1100px;margin:0 auto;color:#183451;font-family:'Segoe UI',Arial,sans-serif}
.student-profile-heading{margin-bottom:26px}.student-profile-eyebrow{display:block;color:#8a9ab0;font-size:11px;font-weight:700;letter-spacing:1.2px;text-transform:uppercase;margin-bottom:7px}
.student-profile-heading h1{margin:0;color:#17375e;font-size:25px;font-weight:700}.student-profile-subtitle{color:#72849a;font-size:13px;margin:8px 0 0}
.student-profile-banner{background:#123d70;min-height:155px;border-radius:14px 14px 0 0;padding:30px 34px;color:white;box-sizing:border-box}
.student-profile-banner h2{font-size:21px;margin:0 0 9px}.student-profile-banner p{color:#dbe8f5;font-size:13px;line-height:1.7;margin:0}
.student-profile-card{background:#fff;border:1px solid #e1e9f2;border-top:0;border-radius:0 0 14px 14px;padding:0 34px 34px;margin-bottom:24px}
.student-profile-identity{display:flex;align-items:flex-end;gap:20px;position:relative;margin-top:-43px;margin-bottom:30px}
.student-profile-avatar{width:100px;height:100px;flex-shrink:0;border:5px solid white;border-radius:50%;background:#e8f1fc;display:flex;align-items:center;justify-content:center;overflow:hidden;color:#2369b5;font-size:34px;font-weight:700;box-shadow:0 3px 12px rgba(23,55,94,.12);box-sizing:border-box}
.student-profile-avatar img{width:100%;height:100%;object-fit:cover;display:block}
.student-profile-identity-text{padding-bottom:7px;min-width:0}.student-profile-name{display:block;font-size:21px;font-weight:700;color:#17375e;overflow-wrap:anywhere}
.student-profile-role{display:inline-block;margin-top:7px;padding:5px 11px;background:#eaf2fc;color:#2369b5;border-radius:6px;font-size:11px;font-weight:700}
.student-profile-section-heading{margin-bottom:19px;padding-bottom:14px;border-bottom:1px solid #e8eef5}.student-profile-section-heading h2{margin:0 0 6px;font-size:17px;color:#17375e}.student-profile-section-heading p{margin:0;color:#72849a;font-size:12px}
.student-profile-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:22px}.student-profile-field{min-width:0}
.student-profile-field-label{display:block;margin-bottom:9px;color:#72849a;font-size:12px;font-weight:600}.student-profile-field-value{display:block;padding:13px 15px;min-height:45px;box-sizing:border-box;background:#f7f9fc;border:1px solid #e5ecf4;border-radius:8px;color:#183b61;font-size:13px;font-weight:600;overflow-wrap:anywhere}
.student-profile-photo-tools{margin:0 0 26px;padding:17px 19px;border:1px solid #e5ecf4;border-radius:10px;background:#f8fafd}.student-profile-photo-tools h3{font-size:14px;margin:0 0 7px}.student-profile-photo-tools p{font-size:12px;color:#72849a;margin:0 0 13px}
.student-profile-photo-input{max-width:100%;font-size:12px}.student-profile-save{display:inline-block;margin:12px 0 0;background:#2369b5;color:#fff;border:0;border-radius:7px;padding:10px 17px;font-size:12px;font-weight:700;cursor:pointer}.student-profile-save:hover{background:#174d88}
.student-profile-note{margin-top:26px;padding:14px 17px;background:#f0f6fd;border:1px solid #dce8f5;border-radius:9px;color:#526b85;font-size:12px;line-height:1.7}
.student-profile-message{display:block;padding:13px 15px;border-radius:8px;margin:0 0 20px;font-size:13px}.student-profile-message.error{background:#fff0f0;color:#a33b3b;border:1px solid #f1caca}.student-profile-message.success{background:#eef8f1;color:#247344;border:1px solid #cae8d4}
@media(max-width:600px){.student-profile-banner{padding:25px 20px}.student-profile-card{padding:0 20px 25px}.student-profile-grid{grid-template-columns:1fr;gap:17px}.student-profile-identity{gap:13px}.student-profile-avatar{width:82px;height:82px;font-size:28px}.student-profile-name{font-size:17px}}
</style>
</asp:Content>

<asp:Content ID="ProfileMain" ContentPlaceHolderID="MainContent" runat="server">
<div class="student-profile-page">
    <header class="student-profile-heading">
        <span class="student-profile-eyebrow">Student Portal</span>
        <h1>My Profile</h1>
        <p class="student-profile-subtitle">View your account information and manage your profile picture.</p>
    </header>

    <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="student-profile-message" />

    <asp:Panel ID="pnlProfile" runat="server" Visible="false">
        <div class="student-profile-banner">
            <h2>Student Profile</h2>
            <p>Your personal learning account information in MiniLMS.</p>
        </div>
        <div class="student-profile-card">
            <div class="student-profile-identity">
                <div class="student-profile-avatar">
                    <asp:Image ID="imgProfile" runat="server" Visible="false" AlternateText="Student profile picture" />
                    <asp:Label ID="lblAvatarInitial" runat="server" Text="S" />
                </div>
                <div class="student-profile-identity-text">
                    <asp:Label ID="lblFullName" runat="server" CssClass="student-profile-name" />
                    <span class="student-profile-role">Student</span>
                </div>
            </div>

            <div class="student-profile-photo-tools">
                <h3>Profile Picture</h3>
                <p>Only your profile picture can be changed. Choose a JPG or PNG image (maximum 2 MB).</p>
                <asp:FileUpload ID="fuProfilePhoto" runat="server" CssClass="student-profile-photo-input" accept=".jpg,.jpeg,.png,image/jpeg,image/png" />
                <div><asp:Button ID="btnUploadPhoto" runat="server" Text="Save Profile Picture" CssClass="student-profile-save" OnClick="btnUploadPhoto_Click" CausesValidation="false" /></div>
            </div>

            <div class="student-profile-section-heading">
                <h2>Personal Information</h2>
                <p>These details are read-only and cannot be changed here.</p>
            </div>
            <div class="student-profile-grid">
                <div class="student-profile-field"><span class="student-profile-field-label">First Name</span><asp:Label ID="lblFirstName" runat="server" CssClass="student-profile-field-value" /></div>
                <div class="student-profile-field"><span class="student-profile-field-label">Last Name</span><asp:Label ID="lblLastName" runat="server" CssClass="student-profile-field-value" /></div>
                <div class="student-profile-field"><span class="student-profile-field-label">Email Address</span><asp:Label ID="lblEmail" runat="server" CssClass="student-profile-field-value" /></div>
                <div class="student-profile-field"><span class="student-profile-field-label">Account Role</span><asp:Label ID="lblRole" runat="server" CssClass="student-profile-field-value" /></div>
                <div class="student-profile-field"><span class="student-profile-field-label">Account Created</span><asp:Label ID="lblCreatedAt" runat="server" CssClass="student-profile-field-value" /></div>
            </div>
            <div class="student-profile-note">Contact your administrator if any of your account details need correction.</div>
        </div>
    </asp:Panel>
</div>
</asp:Content>
