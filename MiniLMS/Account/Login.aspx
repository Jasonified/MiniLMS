<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MiniLMS.Account.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>MiniLMS | Sign In</title>
    <style>
        :root {
            --navy: #102b4c;
            --blue: #174c83;
            --soft: #eef3f9;
            --line: #dbe4ee;
            --muted: #6c7b8e
        }

        * {
            box-sizing: border-box
        }

        html {
            min-height: 100%;
            scroll-behavior: smooth
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: 'Segoe UI',Arial,sans-serif;
            color: var(--navy);
            background: #f4f6f9
        }

        a {
            color: var(--blue);
            text-decoration: none
        }

            a:hover {
                text-decoration: underline
            }

            a:focus-visible, input:focus-visible, select:focus-visible, button:focus-visible {
                outline: 3px solid #8ab7e7;
                outline-offset: 2px
            }

        .page {
            min-height: 100vh;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column
        }

        .topbar {
            width: min(1180px,calc(100% - 40px));
            margin: 0 auto;
            padding: 26px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            position: relative;
            z-index: 2
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 11px;
            color: var(--navy);
            font-size: 23px;
            font-weight: 800;
            letter-spacing: -.6px
        }

        .brand-mark {
            display: grid;
            place-items: center;
            width: 40px;
            height: 40px;
            border-radius: 11px;
            background: var(--navy);
            color: #fff;
            font-size: 23px
        }

        .toplinks {
            display: flex;
            align-items: center;
            gap: 18px;
            font-size: 13px;
            font-weight: 600
        }

            .toplinks .outline {
                padding: 10px 17px;
                border: 1px solid #c3d3e5;
                border-radius: 9px
            }

        .content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 20px 48px;
            position: relative;
            z-index: 1
        }

        .auth-card {
            width: 100%;
            max-width: 440px;
            padding: 37px 39px 30px;
            background: #fff;
            border: 1px solid #e4eaf2;
            border-radius: 25px;
            box-shadow: 0 20px 70px #15365514;
            position: relative;
            z-index: 2
        }

            .auth-card.register {
                max-width: 550px;
                padding: 32px 40px
            }

        .heading {
            text-align: center;
            margin-bottom: 25px
        }

        .eyebrow {
            display: block;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 2px;
            color: #4277aa;
            margin-bottom: 9px
        }

        .heading h1 {
            font-size: 28px;
            letter-spacing: -.9px;
            margin: 0 0 10px
        }

        .heading p {
            font-size: 13px;
            color: var(--muted);
            line-height: 1.6;
            margin: 0
        }

        .field {
            margin-bottom: 17px
        }

            .field label {
                display: block;
                font-size: 12px;
                font-weight: 700;
                margin-bottom: 8px;
                color: #3c526b
            }

        .input-box {
            width: 100%;
            height: 47px;
            padding: 0 14px;
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 9px;
            color: var(--navy);
            font: 14px 'Segoe UI',Arial,sans-serif;
            outline: none;
            transition: border-color .2s,box-shadow .2s
        }

            .input-box:focus {
                border-color: #376eaa;
                box-shadow: 0 0 0 3px #dbeafa
            }

            .input-box::placeholder {
                color: #9aa7b6
            }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px
        }

        .submit-btn {
            display: block;
            width: 100%;
            height: 47px;
            border: 0;
            border-radius: 9px;
            background: var(--navy);
            color: white;
            font: 700 14px 'Segoe UI',Arial,sans-serif;
            cursor: pointer;
            margin-top: 13px;
            transition: background .2s
        }

            .submit-btn:hover {
                background: #23588d
            }

        .message {
            display: block;
            color: #a02020;
            background: #fff1f1;
            border: 1px solid #efcccc;
            border-radius: 9px;
            padding: 11px;
            font-size: 12px;
            margin-bottom: 15px
        }

            .message:empty {
                display: none
            }

        .note {
            font-size: 12px;
            color: #526b85;
            background: #eff5fc;
            border: 1px solid #dce8f5;
            border-radius: 9px;
            padding: 11px 13px;
            line-height: 1.5;
            margin-bottom: 19px
        }

        .helper {
            font-size: 12px;
            color: var(--muted);
            margin: 0 0 16px
        }

        .switch {
            text-align: center;
            font-size: 12px;
            color: var(--muted);
            margin: 22px 0 0
        }

            .switch a {
                font-weight: 700
            }

        .foot {
            text-align: center;
            color: #8492a3;
            font-size: 11px;
            padding: 0 20px 25px;
            position: relative;
            z-index: 2
        }

        .decor {
            position: absolute;
            pointer-events: none;
            color: #b4c6d8;
            opacity: .9
        }

            .decor.left {
                left: max(1%,calc(50% - 590px));
                top: 40%
            }

            .decor.right {
                right: max(1%,calc(50% - 600px));
                bottom: 10%
            }

            .decor svg {
                width: 270px;
                height: 280px
            }

        .circle {
            position: absolute;
            border: 1px solid #cfdae7;
            border-radius: 50%;
            pointer-events: none
        }

            .circle.one {
                width: 12px;
                height: 12px;
                top: 31%;
                left: 18%
            }

            .circle.two {
                width: 8px;
                height: 8px;
                right: 16%;
                top: 40%
            }

        .dots {
            position: absolute;
            width: 76px;
            height: 110px;
            background-image: radial-gradient(#b3c8dd 2px,transparent 2.5px);
            background-size: 16px 16px;
            opacity: .45;
            bottom: 8%;
            left: 8%
        }

        .dash {
            position: absolute;
            right: 8%;
            top: 24%;
            height: 1px;
            width: 90px;
            background: #cad8e6;
            transform: rotate(-22deg)
        }

        @media(max-width:1050px) {
            .decor {
                opacity: .35
            }

                .decor.left {
                    left: -90px
                }

                .decor.right {
                    right: -90px
                }
        }

        @media(max-width:680px) {
            .topbar {
                padding: 17px 0
            }

            .toplinks {
                gap: 9px
            }

                .toplinks .outline {
                    padding: 8px 10px
                }

            .brand {
                font-size: 19px
            }

            .brand-mark {
                width: 34px;
                height: 34px
            }

            .content {
                padding: 20px 15px 36px;
                align-items: flex-start
            }

            .auth-card, .auth-card.register {
                padding: 28px 22px;
                border-radius: 18px
            }

            .decor {
                display: none
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 0
            }

            .heading h1 {
                font-size: 25px
            }
        }

        @media(prefers-reduced-motion:reduce) {
            * {
                transition: none !important
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" defaultbutton="btnLogin">
        <div class="page">
            <header class="topbar"><a href="../Default.aspx" class="brand"><span class="brand-mark">M</span>MiniLMS</a><nav class="toplinks"><a href="../Default.aspx">Home</a><a class="outline" href="Register.aspx">Sign Up</a></nav>
            </header>
            <div class="decor left" aria-hidden="true">
                <svg viewBox="0 0 270 280" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M10 72q20-32 40 0t40 0t40 0t40 0" stroke="#a4b9cd" stroke-width="2" />
                    <rect x="30" y="125" width="110" height="75" rx="6" stroke="#96afc7" stroke-width="2" />
                    <path d="M46 147h72M46 165h54" stroke="#a4b9cd" stroke-width="2" />
                    <path d="M82 201l-16 20 30-20" stroke="#96afc7" stroke-width="2" />
                    <circle cx="210" cy="120" r="5" stroke="#96afc7" stroke-width="2" />
                    <path d="M170 220h75v45h-75z" fill="#e4edf7" />
                    <path d="M183 233h48m-48 12h31" stroke="#9db3c9" stroke-width="2" />
                </svg></div>
            <div class="decor right" aria-hidden="true">
                <svg viewBox="0 0 270 280" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M20 55q20-35 40 0t40 0t40 0" stroke="#a4b9cd" stroke-width="2" />
                    <rect x="115" y="90" width="100" height="70" rx="6" stroke="#96afc7" stroke-width="2" />
                    <path d="M133 112h62m-62 16h45" stroke="#a4b9cd" stroke-width="2" />
                    <path d="M148 161l-15 17 27-17" stroke="#96afc7" stroke-width="2" />
                    <rect x="24" y="193" width="105" height="64" rx="6" fill="#dbe7f4" />
                    <path d="M44 212h63m-63 15h42" stroke="#91acc6" stroke-width="2" />
                    <circle cx="224" cy="218" r="6" stroke="#96afc7" stroke-width="2" />
                </svg></div>
            <div class="circle one"></div>
            <div class="circle two"></div>
            <div class="dots"></div>
            <div class="dash"></div>
            <main class="content">
                <section class="auth-card" aria-labelledby="page-heading">
                    <div class="heading"><span class="eyebrow">MINILMS ACCOUNT ACCESS</span><h1 id="page-heading">Welcome back</h1>
                        <p>Enter your details to access your MiniLMS account.</p>
                    </div>
                    <asp:Label ID="lblMessage" runat="server" CssClass="message" /><div class="field">
                        <label for="txtUsername">Email address</label><asp:TextBox ID="txtUsername" runat="server" ClientIDMode="Static" CssClass="input-box" TextMode="Email" placeholder="Enter your email address" /></div>
                    <div class="field">
                        <label for="txtPassword">Password</label><asp:TextBox ID="txtPassword" runat="server" ClientIDMode="Static" CssClass="input-box" TextMode="Password" placeholder="Enter your password" /></div>
                    <p class="helper">Forgot your password? Please contact your administrator.</p>
                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="submit-btn" OnClick="btnLogin_Click" /><p class="switch">New to MiniLMS? <a href="Register.aspx">Create an account</a></p>
                </section>
            </main>
            <footer class="foot">© <%= DateTime.Now.Year %> MiniLMS · Learning Management System</footer>
        </div>
    </form>
</body>
</html>
