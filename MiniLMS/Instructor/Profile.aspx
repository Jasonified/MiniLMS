
<%@ Page Title="Instructor Profile"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Profile.aspx.cs"
    Inherits="MiniLMS.InstructorProfile" %>

<asp:Content ID="ProfileHead"
    ContentPlaceHolderID="HeadContent"
    runat="server">

<style>
    .profile-shell {
        width: 100%;
        max-width: 1200px;
        margin: 0 auto;
    }

    .page-heading {
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
        margin: 0;
        color: #1e3047;
        font-size: 27px;
    }

    .page-heading p {
        margin: 7px 0 0;
        color: #72849a;
        font-size: 13px;
    }

    .profile-header {
        display: flex;
        align-items: center;
        min-height: 160px;
        padding: 30px 34px;
        margin-bottom: 28px;
        background: white;
        border: 1px solid #e1e9f2;
        border-radius: 12px;
    }

    .banner-title {
        margin-bottom: 13px;
        color: #2369b5;
        font-size: 11px;
        font-weight: 750;
        letter-spacing: 1px;
        text-transform: uppercase;
    }

    .banner-welcome {
        margin-bottom: 12px;
        color: #15365b;
        font-size: 27px;
        font-weight: 750;
    }

    .banner-description {
        margin: 0;
        color: #708399;
        font-size: 13px;
        line-height: 1.8;
    }

    .profile-card {
        background: white;
        border: 1px solid #e1e9f2;
        border-radius: 12px;
        padding: 30px;
    }

    .profile-card h2 {
        margin: 0 0 8px;
        font-size: 19px;
        color: #17375e;
    }

    .profile-subtitle {
        margin: 0 0 25px;
        color: #72849a;
        font-size: 13px;
        line-height: 1.7;
    }

    .photo-section {
        display: flex;
        align-items: center;
        gap: 25px;
        padding-bottom: 28px;
        margin-bottom: 28px;
        border-bottom: 1px solid #e7edf4;
    }

    .profile-avatar {
        width: 115px;
        height: 115px;
        flex-shrink: 0;
        border-radius: 50%;
        overflow: hidden;
        border: 4px solid #eaf2fb;
        background: #dceafa;
    }

    .profile-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .profile-photo-placeholder {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #2369b5;
        font-size: 43px;
        font-weight: 800;
    }

    .photo-actions {
        flex: 1;
        min-width: 0;
    }

    .photo-actions h3 {
        margin: 0 0 7px;
        color: #17375e;
        font-size: 16px;
    }

    .photo-actions p {
        margin: 0 0 13px;
        color: #72849a;
        font-size: 12px;
    }

    .profile-file {
        display: block;
        max-width: 100%;
        margin-bottom: 13px;
        font-size: 12px;
    }

    .profile-photo-save {
        padding: 11px 19px;
        border: none;
        border-radius: 7px;
        background: #2563a6;
        color: white;
        font: 650 13px 'Segoe UI', Arial, sans-serif;
        cursor: pointer;
    }

    .profile-photo-save:hover {
        background: #195692;
    }

    .profile-photo-save:disabled {
        opacity: .55;
        cursor: not-allowed;
    }

    .profile-message {
        display: block;
        margin-bottom: 15px;
        color: #205487;
        font-size: 13px;
    }

    .profile-message:empty {
        display: none;
    }

    .section-title {
        margin: 0 0 19px;
        color: #17375e;
        font-size: 17px;
    }

    .profile-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 18px;
    }

    .profile-row {
        padding: 18px;
        border: 1px solid #e5ebf3;
        border-radius: 9px;
        background: #fafbfd;
    }

    .profile-row label {
        display: block;
        margin-bottom: 9px;
        color: #8190a2;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: .3px;
        text-transform: uppercase;
    }

    .readonly {
        display: block;
        color: #20364f;
        font-size: 14px;
        font-weight: 650;
        overflow-wrap: anywhere;
    }

    .profile-note {
        margin-top: 22px;
        color: #8190a2;
        font-size: 12px;
        line-height: 1.7;
    }

    @media(max-width:650px) {
        .profile-header {
            min-height: 0;
            padding: 25px;
        }

        .banner-welcome {
            font-size: 24px;
        }

        .profile-card {
            padding: 22px;
        }

        .photo-section {
            align-items: flex-start;
            flex-direction: column;
        }

        .profile-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

</asp:Content>

<asp:Content ID="ProfileContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="profile-shell">

        <div class="page-heading">
            <span class="page-eyebrow">
                Instructor Portal
            </span>

            <h1>My Profile</h1>

            <p>
                View your account information and manage
                your profile photo.
            </p>
        </div>

        <section class="profile-header">
            <div>
                <div class="banner-title">
                    Instructor Profile
                </div>

                <div class="banner-welcome">
                    Welcome,
                    <asp:Label ID="lblInstructorName"
                        runat="server" />!
                </div>

                <p class="banner-description">
                    Manage your profile picture and view
                    your account information.
                </p>
            </div>
        </section>

        <asp:Label ID="lblMessage"
            runat="server"
            CssClass="profile-message"
            EnableViewState="false" />

        <section class="profile-card">

            <h2>Profile Information</h2>

            <p class="profile-subtitle">
                Your personal details and account information.
            </p>

            <div class="photo-section">

                <div class="profile-avatar">

                    <asp:Image ID="imgProfilePhoto"
                        runat="server"
                        AlternateText="Instructor profile photo"
                        Visible="false" />

                    <asp:Panel ID="pnlPhotoPlaceholder"
                        runat="server"
                        CssClass="profile-photo-placeholder">
                        I
                    </asp:Panel>

                </div>

                <div class="photo-actions">

                    <h3>Profile Photo</h3>

                    <p>
                        Upload a JPG or PNG image,
                        maximum 2 MB.
                    </p>

                    <asp:FileUpload ID="fuProfilePhoto"
                        runat="server"
                        CssClass="profile-file"
                        accept=".jpg,.jpeg,.png,image/jpeg,image/png" />

                    <asp:Button ID="btnUploadPhoto"
                        runat="server"
                        Text="Save Photo"
                        CssClass="profile-photo-save"
                        CausesValidation="false"
                        OnClick="btnUploadPhoto_Click" />

                </div>

            </div>

            <h3 class="section-title">
                Account Details
            </h3>

            <div class="profile-grid">

                <div class="profile-row">
                    <label>Full Name</label>
                    <asp:Label ID="lblFullName"
                        runat="server"
                        CssClass="readonly" />
                </div>

                <div class="profile-row">
                    <label>Email Address</label>
                    <asp:Label ID="lblEmail"
                        runat="server"
                        CssClass="readonly" />
                </div>

                <div class="profile-row">
                    <label>Account Role</label>
                    <asp:Label ID="lblRole"
                        runat="server"
                        CssClass="readonly" />
                </div>

                <div class="profile-row">
                    <label>Account Created</label>
                    <asp:Label ID="lblCreatedAt"
                        runat="server"
                        CssClass="readonly" />
                </div>

            </div>

            <p class="profile-note">
                Your account information is read-only.
                Contact your administrator if any
                details need to be updated.
            </p>

        </section>

    </div>

</asp:Content>
